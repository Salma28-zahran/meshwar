import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/cityto/data/location_option.dart';
import 'package:customer_app/features/cityto/presentation/widgets/where/location_autocomplete_field.dart';
import 'package:customer_app/features/cityto/presentation/widgets/where/location_service.dart';
import 'package:customer_app/features/cityto/presentation/widgets/where/where_city_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WhereCity extends StatefulWidget {
  const WhereCity({super.key});

  @override
  State<WhereCity> createState() =>
      _WhereCityState();
}

class _WhereCityState extends State<WhereCity> {
  final TextEditingController _fromController =
  TextEditingController(
    text: 'Assiut University',
  );

  final TextEditingController _toController =
  TextEditingController();

  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();

  List<LocationOption> _locations = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final locations =
    await LocationService.getLocations();

    if (!mounted) return;

    setState(() {
      _locations = locations;
      _isLoading = false;
    });
  }

  void _confirmDestination() {
    final from =
    _fromController.text.trim();

    final to =
    _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select both locations',
          ),
        ),
      );

      return;
    }

    FocusScope.of(context).unfocus();

    debugPrint('From: $from');
    debugPrint('To: $to');

    context.push(
      AppRoutes.whencity,
      extra: {
        'from': from,
        'to': to,
      },
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();

    _fromFocusNode.dispose();
    _toFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Column(
            children: [
              WhereCityHeader(
                onBack: context.pop,
              ),

              SizedBox(
                height: AppSpacing.lg,
              ),

              LocationAutocompleteField(
                label: 'From',
                controller: _fromController,
                focusNode: _fromFocusNode,
                locations: _locations,
                isLoading: _isLoading,
                icon:
                Icons.location_on_outlined,
                textInputAction:
                TextInputAction.next,
                onSubmitted: (_) {
                  _toFocusNode.requestFocus();
                },
              ),

              SizedBox(
                height: AppSpacing.lg,
              ),

              LocationAutocompleteField(
                label: 'To',
                controller: _toController,
                focusNode: _toFocusNode,
                locations: _locations,
                isLoading: _isLoading,
                icon: Icons.search_rounded,
                textInputAction:
                TextInputAction.done,
                onSubmitted: (_) {
                  _confirmDestination();
                },
              ),

              const Spacer(),

              AppButton(
                label: 'Confirm Destination',
                onPressed:
                _confirmDestination,
              ),

              SizedBox(
                height: AppSpacing.md,
              ),
            ],
          ),
        ),
      ),
    );
  }
}