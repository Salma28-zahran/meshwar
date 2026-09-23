import 'dart:async';
import 'dart:convert';

import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

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

  // ─────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  // ─────────────────────────────────────────────
  // Search
  // ─────────────────────────────────────────────

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _results = [];
        _selectedPlace = null;
        _error = null;
        _isLoading = false;
      });

      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 450),
          () => _searchPlaces(query),
    );
  }

  Future<void> _searchPlaces(String query) async {
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

      if (!mounted) return;

      setState(() {
        _results = places;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _results = [];
        _isLoading = false;
        _error = 'Could not load destinations';
      });
    }
  }

  bool _isAllowedPlace(_PlaceResult place) {
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

    return allowedTypes.contains(place.type) ||
        allowedTypes.contains(place.addressType);
  }

  // ─────────────────────────────────────────────
  // Select place
  // ─────────────────────────────────────────────

  void _selectPlace(_PlaceResult place) {
    setState(() {
      _selectedPlace = place;

      _searchController.text =
          place.displayName;

      _results = [];
    });

    _searchFocusNode.unfocus();
  }

  void _clearSearch() {
    _debounce?.cancel();

    _searchController.clear();

    setState(() {
      _results = [];
      _selectedPlace = null;
      _error = null;
      _isLoading = false;
    });

    _searchFocusNode.requestFocus();
  }

  // ─────────────────────────────────────────────
  // Confirm
  // ─────────────────────────────────────────────

  void _confirmDestination() {
    final place = _selectedPlace;

    if (place == null) return;

    Navigator.of(context).pop({
      'name': place.displayName,
      'latitude': place.latitude,
      'longitude': place.longitude,
    });
  }

  // ─────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.md),

            _buildHeader(context),

            SizedBox(height: AppSpacing.lg),

            _buildSearchField(),

            SizedBox(height: AppSpacing.md),

            _buildChooseOnMap(),

            SizedBox(height: AppSpacing.ml),

            if (_searchController.text.isEmpty)
              _buildTabs(),

            if (_searchController.text.isNotEmpty)
              Expanded(
                child: _buildSearchContent(),
              )
            else
              const Spacer(),

            AppButton(
              width: double.infinity,
              label: 'Confirm Destination',
              onPressed: _selectedPlace == null
                  ? null
                  : _confirmDestination,
            ),

            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              borderRadius: BorderRadius.circular(
                100.r,
              ),
              child: SizedBox(
                width: 40.r,
                height: 40.r,
                child: Icon(
                  Icons.arrow_back,
                  size: 21.r,
                  color: AppColors.primaryColor,
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
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Search field
  // ─────────────────────────────────────────────

  Widget _buildSearchField() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorders.lg,
        border: Border.all(
          color: AppColors.inputBorderGrey,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,

        textInputAction: TextInputAction.search,

        onChanged: (value) {
          setState(() {});

          _onSearchChanged(value);
        },

        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          fontSize: 14.sp,
          color: AppColors.secondaryColor,
        ),

        decoration: InputDecoration(
          hintText: 'Search Destination',

          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 14.sp,
            color: const Color(
              0xFF526B86,
            ),
          ),

          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.sm,
            ),
            child: Icon(
              Icons.search,
              size: 23.r,
              color: const Color(
                0xFF365A7C,
              ),
            ),
          ),

          prefixIconConstraints:
          const BoxConstraints(),

          suffixIcon:
          _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: _clearSearch,
            icon: Icon(
              Icons.close,
              size: 18.r,
              color: AppColors.grey,
            ),
          )
              : null,

          border: InputBorder.none,

          enabledBorder: InputBorder.none,

          focusedBorder: InputBorder.none,

          contentPadding:
          EdgeInsets.symmetric(
            vertical: 17.h,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Choose on map
  // ─────────────────────────────────────────────

  Widget _buildChooseOnMap() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          // TODO:
          // navigate to choose location from map
        },
        borderRadius: AppBorders.md,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 23.r,
                color: AppColors.primaryColor,
              ),

              SizedBox(
                width: AppSpacing.sm,
              ),

              Text(
                'Chose on map',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  fontSize: 14.sp,
                  fontWeight:
                  FontWeight.w400,
                  color:
                  AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Suggested / Saved
  // ─────────────────────────────────────────────

  Widget _buildTabs() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor
                  .withValues(
                alpha: 0.08,
              ),
              borderRadius: AppBorders.lg,
            ),
            child: Text(
              'Suggested',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color:
                AppColors.primaryColor,
              ),
            ),
          ),

          SizedBox(
            width: AppSpacing.md,
          ),

          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.ml,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppBorders.lg,
              border: Border.all(
                color: AppColors.lightBorder,
              ),
            ),
            child: Text(
              'Saved',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors
                    .secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Search results
  // ─────────────────────────────────────────────

  Widget _buildSearchContent() {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          width: 24.r,
          height: 24.r,
          child:
          const CircularProgressIndicator(
            strokeWidth: 2,
            color:
            AppColors.primaryColor,
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 13.sp,
            color: AppColors.textGrey,
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No destinations found',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 13.sp,
            color: AppColors.textGrey,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),

      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,

      itemCount: _results.length,

      separatorBuilder: (
          context,
          index,
          ) {
        return Divider(
          height: 1,
          color:
          AppColors.dividerAuthColor,
        );
      },

      itemBuilder: (
          context,
          index,
          ) {
        final place = _results[index];

        return InkWell(
          onTap: () {
            _selectPlace(place);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.ms,
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
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
                  width: AppSpacing.ms,
                ),

                Expanded(
                  child: Text(
                    place.displayName,
                    maxLines: 2,
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
                      13.sp,
                      height: 1.35,
                      color: AppColors
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

// ─────────────────────────────────────────────
// Place model
// ─────────────────────────────────────────────

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
      json['type']?.toString() ??
          '',

      addressType:
      json['addresstype']
          ?.toString() ??
          '',
    );
  }
}