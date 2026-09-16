import 'dart:async';

import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/routing/app_routes.dart';

class WhereToFormWidget extends StatefulWidget {
  const WhereToFormWidget({super.key});

  @override
  State<WhereToFormWidget> createState() =>
      _WhereToFormWidgetState();
}

class _WhereToFormWidgetState
    extends State<WhereToFormWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _fromController =
  TextEditingController(
    text: 'Assiut University',
  );

  final TextEditingController _toController =
  TextEditingController();

  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();

  Timer? _debounce;

  List<csc.Country> _countries = [];
  List<csc.City> _cities = [];

  final Map<String, String> _countryNames = {};

  List<_LocationSuggestion> _suggestions = [];

  _LocationSuggestion? _selectedFrom;
  _LocationSuggestion? _selectedTo;

  _ActiveField? _activeField;

  bool _isLoadingLocations = true;
  bool _isSearching = false;

  late final AnimationController _animationController;

  late final Animation<double> _fadeAnimation;

  late final Animation<Offset> _slideAnimation;

  bool get _canConfirm =>
      _selectedFrom != null &&
          _selectedTo != null;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _selectedFrom =
    const _LocationSuggestion(
      name: 'Assiut University',
      countryName: 'Egypt',
      type: _LocationType.city,
    );

    _setupAnimation();
    _setupFocusListeners();
    _loadLocations();
  }

  // ===========================================================================
  // ANIMATION
  // ===========================================================================

  void _setupAnimation() {
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 400,
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(
            0,
            0.025,
          ),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  // ===========================================================================
  // FOCUS
  // ===========================================================================

  void _setupFocusListeners() {
    _fromFocusNode.addListener(() {
      if (!_fromFocusNode.hasFocus) {
        return;
      }

      setState(() {
        _activeField =
            _ActiveField.from;

        _suggestions = [];
      });
    });

    _toFocusNode.addListener(() {
      if (!_toFocusNode.hasFocus) {
        return;
      }

      setState(() {
        _activeField =
            _ActiveField.to;

        _suggestions = [];
      });
    });
  }

  // ===========================================================================
  // LOAD DATA
  // ===========================================================================

  Future<void> _loadLocations() async {
    try {
      final countries =
      await csc.getAllCountries();

      final cities =
      await csc.getAllCities();

      if (!mounted) return;

      for (final country
      in countries) {
        _countryNames[
        country.isoCode] =
            country.name;
      }

      setState(() {
        _countries = countries;
        _cities = cities;

        _isLoadingLocations =
        false;
      });
    } catch (error) {
      debugPrint(
        'Error loading locations: $error',
      );

      if (!mounted) return;

      setState(() {
        _isLoadingLocations =
        false;
      });
    }
  }

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  void _searchLocation({
    required String value,
    required _ActiveField field,
  }) {
    _debounce?.cancel();

    if (field ==
        _ActiveField.from) {
      _selectedFrom = null;
    } else {
      _selectedTo = null;
    }

    final query =
    value.trim();

    if (query.isEmpty) {
      setState(() {
        _activeField = field;

        _suggestions = [];

        _isSearching = false;
      });

      return;
    }

    setState(() {
      _activeField = field;

      _isSearching = true;
    });

    _debounce = Timer(
      const Duration(
        milliseconds: 250,
      ),
          () {
        final normalizedQuery =
        query.toLowerCase();

        // ───────────────── Countries ─────────────────

        final countryResults =
        _countries
            .where(
              (country) =>
              country.name
                  .toLowerCase()
                  .startsWith(
                normalizedQuery,
              ),
        )
            .map(
              (country) =>
              _LocationSuggestion(
                name:
                country.name,
                countryName:
                country.name,
                type:
                _LocationType
                    .country,
              ),
        );

        // ───────────────── Cities ─────────────────

        final cityResults =
        _cities
            .where(
              (city) => city.name
              .toLowerCase()
              .startsWith(
            normalizedQuery,
          ),
        )
            .map(
              (city) =>
              _LocationSuggestion(
                name: city.name,
                countryName:
                _countryNames[
                city.countryCode] ??
                    city.countryCode,
                type:
                _LocationType
                    .city,
              ),
        );

        final results = [
          ...countryResults,
          ...cityResults,
        ];

        results.sort(
              (a, b) {
            if (a.type !=
                b.type) {
              return a.type ==
                  _LocationType
                      .country
                  ? -1
                  : 1;
            }

            return a.name
                .toLowerCase()
                .compareTo(
              b.name
                  .toLowerCase(),
            );
          },
        );

        if (!mounted) return;

        setState(() {
          _suggestions =
              results;

          _isSearching = false;
        });
      },
    );
  }

  // ===========================================================================
  // SELECT LOCATION
  // ===========================================================================

  void _selectLocation(
      _LocationSuggestion location,
      ) {
    if (_activeField ==
        _ActiveField.from) {
      _selectedFrom =
          location;

      _fromController.text =
          _displayName(location);

      _fromController.selection =
          TextSelection.collapsed(
            offset:
            _fromController
                .text.length,
          );

      _fromFocusNode.unfocus();
    } else if (_activeField ==
        _ActiveField.to) {
      _selectedTo =
          location;

      _toController.text =
          _displayName(location);

      _toController.selection =
          TextSelection.collapsed(
            offset:
            _toController
                .text.length,
          );

      _toFocusNode.unfocus();
    }

    setState(() {
      _suggestions = [];
      _activeField = null;
    });
  }

  String _displayName(
      _LocationSuggestion location,
      ) {
    if (location.type ==
        _LocationType.country) {
      return location.name;
    }

    return '${location.name}, ${location.countryName}';
  }

  // ===========================================================================
  // CLEAR
  // ===========================================================================

  void _clearFrom() {
    _fromController.clear();

    setState(() {
      _selectedFrom = null;
      _suggestions = [];

      _activeField =
          _ActiveField.from;
    });

    _fromFocusNode.requestFocus();
  }

  void _clearTo() {
    _toController.clear();

    setState(() {
      _selectedTo = null;
      _suggestions = [];

      _activeField =
          _ActiveField.to;
    });

    _toFocusNode.requestFocus();
  }

  // ===========================================================================
  // CONFIRM
  // ===========================================================================

  void _confirmDestination() {
    FocusScope.of(context).unfocus();

    final isValid =
        _formKey.currentState?.validate() ?? false;

    if (!isValid || !_canConfirm) {
      return;
    }

    context.push(
      AppRoutes.whento,
      extra: {
        'fromTitle': _displayName(_selectedFrom!),
        'toTitle': _displayName(_selectedTo!),
      },
    );
  }

  // ===========================================================================
  // CURRENT QUERY
  // ===========================================================================

  String get _currentQuery {
    switch (_activeField) {
      case _ActiveField.from:
        return _fromController.text.trim();

      case _ActiveField.to:
        return _toController.text.trim();

      case null:
        return '';
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _debounce?.cancel();

    _fromController.dispose();
    _toController.dispose();

    _fromFocusNode.dispose();
    _toFocusNode.dispose();

    _animationController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // UI
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior:
      HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context)
            .unfocus();

        setState(() {
          _suggestions = [];
          _activeField = null;
        });
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ───────────────── FROM ─────────────────

                _LocationField(
                  controller:
                  _fromController,
                  focusNode:
                  _fromFocusNode,
                  label: 'From',
                  hintText:
                  'Choose city or country',
                  icon: Icons
                      .location_on_outlined,
                  onTap: () {
                    setState(() {
                      _activeField =
                          _ActiveField
                              .from;

                      _suggestions =
                      [];
                    });
                  },
                  onChanged: (value) {
                    _searchLocation(
                      value: value,
                      field:
                      _ActiveField
                          .from,
                    );
                  },
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please select starting location';
                    }

                    if (_selectedFrom ==
                        null) {
                      return 'Choose a city or country from the list';
                    }

                    return null;
                  },
                  onClear:
                  _clearFrom,
                ),

                SizedBox(
                  height:
                  AppSpacing.md,
                ),

                // ───────────────── TO ─────────────────

                _LocationField(
                  controller:
                  _toController,
                  focusNode:
                  _toFocusNode,
                  label: 'To',
                  hintText:
                  'Choose city or country',
                  icon: Icons
                      .search_rounded,
                  onTap: () {
                    setState(() {
                      _activeField =
                          _ActiveField
                              .to;

                      _suggestions =
                      [];
                    });
                  },
                  onChanged: (value) {
                    _searchLocation(
                      value: value,
                      field:
                      _ActiveField.to,
                    );
                  },
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please select destination';
                    }

                    if (_selectedTo ==
                        null) {
                      return 'Choose a city or country from the list';
                    }

                    return null;
                  },
                  onClear: _clearTo,
                ),

                SizedBox(
                  height:
                  AppSpacing.sm,
                ),

                // ───────────────── SEARCH RESULTS ─────────────────

                Expanded(
                  child: _SearchResults(
                    isLoadingLocations:
                    _isLoadingLocations,
                    isSearching:
                    _isSearching,
                    hasQuery:
                    _currentQuery
                        .isNotEmpty,
                    suggestions:
                    _suggestions,
                    onSelected:
                    _selectLocation,
                  ),
                ),

                // ───────────────── CONFIRM ─────────────────

                AppButton(
                  label:
                  'Confirm Destination',
                  type:
                  AppButtonType
                      .primary,
                  onPressed:
                  _canConfirm
                      ? _confirmDestination
                      : null,
                ),

                SizedBox(
                  height:
                  AppSpacing.lg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// LOCATION FIELD
// =============================================================================

class _LocationField
    extends StatefulWidget {
  const _LocationField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.validator,
    required this.onClear,
    required this.onTap,
  });

  final TextEditingController
  controller;

  final FocusNode focusNode;

  final String label;
  final String hintText;

  final IconData icon;

  final ValueChanged<String>
  onChanged;

  final String? Function(String?)
  validator;

  final VoidCallback onClear;
  final VoidCallback onTap;

  @override
  State<_LocationField>
  createState() =>
      _LocationFieldState();
}

class _LocationFieldState
    extends State<_LocationField> {
  @override
  void initState() {
    super.initState();

    widget.controller
        .addListener(_update);
  }

  @override
  void didUpdateWidget(
      covariant _LocationField oldWidget,
      ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (oldWidget.controller !=
        widget.controller) {
      oldWidget.controller
          .removeListener(_update);

      widget.controller
          .addListener(_update);
    }
  }

  void _update() {
    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    widget.controller
        .removeListener(_update);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText =
        widget.controller.text
            .isNotEmpty;

    return TextFormField(
      controller:
      widget.controller,
      focusNode:
      widget.focusNode,
      onTap: widget.onTap,
      onChanged:
      widget.onChanged,
      validator:
      widget.validator,
      cursorColor:
      AppColors.primaryColor,
      textInputAction:
      TextInputAction.search,
      autovalidateMode:
      AutovalidateMode
          .onUserInteraction,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(
        fontSize: 14,
        fontWeight:
        FontWeight.w400,
        letterSpacing: 0,
        color: AppColors
            .secondaryColor,
      ),
      decoration:
      InputDecoration(
        filled: true,
        fillColor:
        AppColors.bgColor,

        // Icon
        prefixIcon: Padding(
          padding:
          EdgeInsets.only(
            left:
            AppSpacing.ms,
            right:
            AppSpacing.sm,
          ),
          child: Icon(
            widget.icon,
            size: 24,
            color: const Color(
              0xFF557694,
            ),
          ),
        ),

        prefixIconConstraints:
        const BoxConstraints(
          minWidth: 48,
        ),

        // Clear
        suffixIcon:
        AnimatedSwitcher(
          duration:
          const Duration(
            milliseconds: 180,
          ),
          child: hasText
              ? IconButton(
            key:
            const ValueKey(
              'clear',
            ),
            onPressed:
            widget.onClear,
            icon: Icon(
              Icons
                  .close_rounded,
              size: 20,
              color: AppColors
                  .textGreyAndWhite,
            ),
          )
              : const SizedBox
              .shrink(
            key:
            ValueKey(
              'empty',
            ),
          ),
        ),

        hintText:
        '${widget.label}: ${widget.hintText}',

        hintStyle:
        Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          fontSize: 14,
          fontWeight:
          FontWeight
              .w400,
          letterSpacing: 0,
          color:
          const Color(
            0xFF557694,
          ),
        ),

        contentPadding:
        EdgeInsets.symmetric(
          vertical:
          AppSpacing.ml,
          horizontal:
          AppSpacing.md,
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppSpacing.md,
          ),
          borderSide:
          BorderSide(
            color: AppColors
                .inputBorderGrey,
            width: 1,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppSpacing.md,
          ),
          borderSide:
          BorderSide(
            color: AppColors
                .primaryColor,
            width: 1.4,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppSpacing.md,
          ),
          borderSide:
          const BorderSide(
            color: AppColors
                .dangerRed,
            width: 1,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppSpacing.md,
          ),
          borderSide:
          const BorderSide(
            color: AppColors
                .dangerRed,
            width: 1.4,
          ),
        ),

        errorStyle:
        Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(
          fontSize: 11,
          color: AppColors
              .dangerRed,
        ),
      ),
    );
  }
}

// =============================================================================
// SEARCH RESULTS
// =============================================================================

class _SearchResults
    extends StatelessWidget {
  const _SearchResults({
    required this.isLoadingLocations,
    required this.isSearching,
    required this.hasQuery,
    required this.suggestions,
    required this.onSelected,
  });

  final bool isLoadingLocations;
  final bool isSearching;
  final bool hasQuery;

  final List<_LocationSuggestion>
  suggestions;

  final ValueChanged<
      _LocationSuggestion>
  onSelected;

  @override
  Widget build(BuildContext context) {
    // الصفحة تفضل فاضية
    // لحد ما المستخدم يبدأ يكتب.
    if (!hasQuery) {
      return const SizedBox.expand();
    }

    if (isLoadingLocations ||
        isSearching) {
      return Center(
        child: SizedBox(
          width: AppSpacing.lg,
          height: AppSpacing.lg,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors
                .primaryColor,
          ),
        ),
      );
    }

    if (suggestions.isEmpty) {
      return Align(
        alignment:
        Alignment.topCenter,
        child: Padding(
          padding:
          EdgeInsets.only(
            top: AppSpacing.xl,
          ),
          child: Text(
            'No cities or countries found',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: AppColors
                  .textGreyAndWhite,
            ),
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration:
      const Duration(
        milliseconds: 220,
      ),
      child: ListView.separated(
        key: ValueKey(
          suggestions.length,
        ),
        padding:
        EdgeInsets.only(
          top: AppSpacing.sm,
          bottom:
          AppSpacing.md,
        ),
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior
            .onDrag,
        itemCount:
        suggestions.length,
        separatorBuilder:
            (_, __) {
          return Divider(
            height: 1,
            color: AppColors
                .dividerAuthColor,
          );
        },
        itemBuilder:
            (context, index) {
          final location =
          suggestions[index];

          return _SuggestionTile(
            location:
            location,
            onTap: () {
              onSelected(
                location,
              );
            },
          );
        },
      ),
    );
  }
}

// =============================================================================
// SUGGESTION TILE
// =============================================================================

class _SuggestionTile
    extends StatelessWidget {
  const _SuggestionTile({
    required this.location,
    required this.onTap,
  });

  final _LocationSuggestion
  location;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCountry =
        location.type ==
            _LocationType.country;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(
          AppSpacing.ms,
        ),
        child: Padding(
          padding:
          EdgeInsets.symmetric(
            vertical:
            AppSpacing.ms,
          ),
          child: Row(
            children: [
              Container(
                width:
                AppSpacing.xxl,
                height:
                AppSpacing.xxl,
                decoration:
                const BoxDecoration(
                  color: Color(
                    0xFFEEF8F6,
                  ),
                  shape:
                  BoxShape.circle,
                ),
                alignment:
                Alignment.center,
                child: Icon(
                  isCountry
                      ? Icons
                      .public_rounded
                      : Icons
                      .location_on_outlined,
                  size: 21,
                  color: AppColors
                      .primaryColor,
                ),
              ),

              SizedBox(
                width:
                AppSpacing.ms,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      location.name,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontSize:
                        14,
                        fontWeight:
                        FontWeight
                            .w500,
                        color:
                        AppColors
                            .secondaryColor,
                      ),
                    ),

                    SizedBox(
                      height:
                      AppSpacing
                          .xs,
                    ),

                    Text(
                      isCountry
                          ? 'Country'
                          : location
                          .countryName,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        fontSize:
                        11,
                        color:
                        AppColors
                            .textGreyAndWhite,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width:
                AppSpacing.sm,
              ),

              Icon(
                Icons
                    .north_west_rounded,
                size: 17,
                color: AppColors
                    .textGreyAndWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE TYPES
// =============================================================================

enum _ActiveField {
  from,
  to,
}

enum _LocationType {
  city,
  country,
}

class _LocationSuggestion {
  const _LocationSuggestion({
    required this.name,
    required this.countryName,
    required this.type,
  });

  final String name;
  final String countryName;

  final _LocationType type;
}