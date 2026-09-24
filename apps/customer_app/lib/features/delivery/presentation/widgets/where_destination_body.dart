import 'dart:async';
import 'dart:convert';

import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class WhereDestinationBody extends StatefulWidget {
  const WhereDestinationBody({super.key});

  @override
  State<WhereDestinationBody> createState() =>
      _WhereDestinationBodyState();
}

class _WhereDestinationBodyState
    extends State<WhereDestinationBody> {
  final TextEditingController _searchController =
  TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  Timer? _debounce;

  List<_PlaceResult> _results = [];

  _PlaceResult? _selectedPlace;

  bool _isLoading = false;

  String? _error;

  int _searchVersion = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // =========================================================
  // SEARCH
  // =========================================================

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (_selectedPlace != null &&
        query != _selectedPlace!.displayName) {
      setState(() {
        _selectedPlace = null;
      });
    }

    if (query.isEmpty) {
      _searchVersion++;

      setState(() {
        _results = [];
        _selectedPlace = null;
        _isLoading = false;
        _error = null;
      });

      return;
    }

    final version = ++_searchVersion;

    _debounce = Timer(
      const Duration(milliseconds: 450),
          () {
        _searchPlaces(
          query,
          version,
        );
      },
    );
  }

  Future<void> _searchPlaces(
      String query,
      int version,
      ) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/search',
        {
          'q': query,
          'format': 'jsonv2',
          'limit': '10',
          'addressdetails': '1',
        },
      );

      final response = await http.get(
        uri,
        headers: const {
          'User-Agent': 'customer_app/1.0',
          'Accept-Language': 'en',
        },
      );

      if (!mounted ||
          version != _searchVersion) {
        return;
      }

      if (response.statusCode != 200) {
        throw Exception(
          'Search failed: ${response.statusCode}',
        );
      }

      final List<dynamic> data =
      jsonDecode(response.body);

      final places = data
          .map(
            (json) => _PlaceResult.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .where(_isAllowedPlace)
          .toList();

      if (!mounted ||
          version != _searchVersion) {
        return;
      }

      setState(() {
        _results = places;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted ||
          version != _searchVersion) {
        return;
      }

      setState(() {
        _results = [];
        _isLoading = false;
        _error = 'Could not load destinations';
      });
    }
  }

  bool _isAllowedPlace(
      _PlaceResult place,
      ) {
    const allowedTypes = {
      'city',
      'town',
      'village',
      'municipality',
      'state',
      'province',
      'country',
      'administrative',
      'county',
      'region',
    };

    return allowedTypes.contains(
      place.type,
    ) ||
        allowedTypes.contains(
          place.addressType,
        );
  }

  // =========================================================
  // SELECT PLACE
  // =========================================================

  void _selectPlace(
      _PlaceResult place,
      ) {
    _debounce?.cancel();

    _searchVersion++;

    setState(() {
      _selectedPlace = place;

      _results = [];

      _isLoading = false;

      _error = null;

      _searchController.text =
          place.displayName;

      _searchController.selection =
          TextSelection.collapsed(
            offset: place.displayName.length,
          );
    });

    _searchFocusNode.unfocus();
  }

  // =========================================================
  // CLEAR
  // =========================================================

  void _clearSearch() {
    _debounce?.cancel();

    _searchVersion++;

    _searchController.clear();

    setState(() {
      _results = [];
      _selectedPlace = null;
      _isLoading = false;
      _error = null;
    });

    _searchFocusNode.requestFocus();
  }

  // =========================================================
  // CONFIRM
  // =========================================================

  void _confirmDestination() {
    if (_selectedPlace == null) {
      return;
    }

    FocusManager.instance.primaryFocus
        ?.unfocus();

    context.push(
      AppRoutes.package,
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final hasSearchText =
        _searchController.text
            .trim()
            .isNotEmpty;

    final hasSelectedPlace =
        _selectedPlace != null;

    return Container(
      color: AppColors.bgColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        child: Column(
          children: [
            SizedBox(
              height: AppSpacing.md,
            ),

            _buildHeader(),

            SizedBox(
              height: AppSpacing.lg,
            ),

            _buildSearchField(),

            SizedBox(
              height: AppSpacing.md,
            ),

            _buildChooseOnMap(),

            SizedBox(
              height: AppSpacing.ml,
            ),

            if (!hasSearchText)
              _buildTabs(),

            if (hasSearchText &&
                !hasSelectedPlace)
              Expanded(
                child:
                _buildSearchContent(),
              )
            else
              const Spacer(),

            AppButton(
              width: double.infinity,
              label:
              'Confirm Destination',
              onPressed:
              hasSelectedPlace
                  ? _confirmDestination
                  : null,
            ),

            SizedBox(
              height: AppSpacing.md,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment:
            Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                context.pop();
              },
              borderRadius:
              BorderRadius.circular(
                100.r,
              ),
              child: SizedBox(
                width: 40.r,
                height: 40.r,
                child: Icon(
                  Icons.arrow_back,
                  size: 21.r,
                  color: AppColors
                      .primaryColor,
                ),
              ),
            ),
          ),

          Text(
            'Where To',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
              fontSize: 18.sp,
              fontWeight:
              FontWeight.w500,
              color: AppColors
                  .primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SEARCH FIELD
  // =========================================================

  Widget _buildSearchField() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
        AppBorders.lg,
        border: Border.all(
          color: AppColors
              .inputBorderGrey,
          width: 1,
        ),
      ),
      child: TextField(
        controller:
        _searchController,
        focusNode:
        _searchFocusNode,

        textInputAction:
        TextInputAction.search,

        onChanged:
        _onSearchChanged,

        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          fontSize: 14.sp,
          color: AppColors
              .secondaryColor,
        ),

        decoration:
        InputDecoration(
          hintText:
          'Search Destination',

          hintStyle:
          Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize:
            14.sp,
            color:
            const Color(
              0xFF526B86,
            ),
          ),

          prefixIcon: Padding(
            padding:
            EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.sm,
            ),
            child: Icon(
              Icons.search,
              size: 23.r,
              color:
              const Color(
                0xFF365A7C,
              ),
            ),
          ),

          prefixIconConstraints:
          const BoxConstraints(),

          suffixIcon:
          _searchController
              .text
              .isNotEmpty
              ? IconButton(
            onPressed:
            _clearSearch,
            icon: Icon(
              Icons.close,
              size: 18.r,
              color:
              AppColors.grey,
            ),
          )
              : null,

          border:
          InputBorder.none,

          enabledBorder:
          InputBorder.none,

          focusedBorder:
          InputBorder.none,

          contentPadding:
          EdgeInsets.symmetric(
            vertical: 17.h,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CHOOSE ON MAP
  // =========================================================

  Widget _buildChooseOnMap() {
    return Align(
      alignment:
      Alignment.centerLeft,
      child: InkWell(
        onTap: () {},
        borderRadius:
        AppBorders.md,
        child: Padding(
          padding:
          EdgeInsets.symmetric(
            vertical:
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Icon(
                Icons
                    .location_on_outlined,
                size: 23.r,
                color: AppColors
                    .primaryColor,
              ),

              SizedBox(
                width:
                AppSpacing.sm,
              ),

              Text(
                'Chose on map',
                style:
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  fontSize:
                  14.sp,
                  color:
                  AppColors
                      .primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TABS
  // =========================================================

  Widget _buildTabs() {
    return Align(
      alignment:
      Alignment.centerLeft,
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            height: 48.h,
            padding:
            EdgeInsets.symmetric(
              horizontal:
              AppSpacing.md,
            ),
            alignment:
            Alignment.center,
            decoration:
            BoxDecoration(
              color: AppColors
                  .primaryColor
                  .withValues(
                alpha: 0.08,
              ),
              borderRadius:
              AppBorders.lg,
            ),
            child: Text(
              'Suggested',
              style:
              Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize:
                14.sp,
                fontWeight:
                FontWeight
                    .w500,
                color:
                AppColors
                    .primaryColor,
              ),
            ),
          ),

          SizedBox(
            width:
            AppSpacing.md,
          ),

          Container(
            height: 48.h,
            padding:
            EdgeInsets.symmetric(
              horizontal:
              AppSpacing.ml,
            ),
            alignment:
            Alignment.center,
            decoration:
            BoxDecoration(
              color:
              AppColors.white,
              borderRadius:
              AppBorders.lg,
              border: Border.all(
                color: AppColors
                    .lightBorder,
              ),
            ),
            child: Text(
              'Saved',
              style:
              Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize:
                14.sp,
                fontWeight:
                FontWeight
                    .w500,
                color:
                AppColors
                    .secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RESULTS
  // =========================================================

  Widget _buildSearchContent() {
    if (_isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(
          color:
          AppColors.primaryColor,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: TextStyle(
            fontSize: 13.sp,
            color:
            AppColors.textGrey,
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return const SizedBox();
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),

      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,

      itemCount:
      _results.length,

      separatorBuilder:
          (context, index) {
        return Divider(
          height: 1,
          color: AppColors
              .dividerAuthColor,
        );
      },

      itemBuilder:
          (context, index) {
        final place =
        _results[index];

        return InkWell(
          onTap: () {
            _selectPlace(place);
          },
          child: Padding(
            padding:
            EdgeInsets.symmetric(
              vertical:
              AppSpacing.ms,
            ),
            child: Row(
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration:
                  BoxDecoration(
                    color: AppColors
                        .primaryColor
                        .withValues(
                      alpha: 0.08,
                    ),
                    shape:
                    BoxShape.circle,
                  ),
                  child: Icon(
                    Icons
                        .location_on_outlined,
                    size: 20.r,
                    color: AppColors
                        .primaryColor,
                  ),
                ),

                SizedBox(
                  width:
                  AppSpacing.ms,
                ),

                Expanded(
                  child: Text(
                    place.displayName,
                    maxLines: 2,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style:
                    Theme.of(
                      context,
                    )
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontSize:
                      13.sp,
                      color:
                      AppColors
                          .secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =========================================================
// MODEL
// =========================================================

class _PlaceResult {
  const _PlaceResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.addressType,
  });

  final String displayName;
  final double latitude;
  final double longitude;
  final String type;
  final String addressType;

  factory _PlaceResult.fromJson(
      Map<String, dynamic> json,
      ) {
    return _PlaceResult(
      displayName:
      json['display_name']
          ?.toString() ??
          '',

      latitude:
      double.tryParse(
        json['lat']
            ?.toString() ??
            '',
      ) ??
          0,

      longitude:
      double.tryParse(
        json['lon']
            ?.toString() ??
            '',
      ) ??
          0,

      type:
      json['type']
          ?.toString() ??
          '',

      addressType:
      json['addresstype']
          ?.toString() ??
          '',
    );
  }
}