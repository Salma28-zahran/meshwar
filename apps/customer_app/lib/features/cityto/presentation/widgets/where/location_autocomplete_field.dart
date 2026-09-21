import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/features/cityto/data/location_option.dart';
import 'package:customer_app/features/cityto/presentation/widgets/where/location_suggestion_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationAutocompleteField extends StatelessWidget {
  const LocationAutocompleteField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.locations,
    required this.icon,
    required this.isLoading,
    required this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<LocationOption> locations;
  final IconData icon;
  final bool isLoading;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<LocationOption>(
          textEditingController: controller,
          focusNode: focusNode,

          displayStringForOption: (option) {
            return option.displayName;
          },

          optionsBuilder: (value) {
            return _search(value.text);
          },

          fieldViewBuilder: (
              context,
              controller,
              focusNode,
              onFieldSubmitted,
              ) {
            return _LocationField(
              label: label,
              icon: icon,
              controller: controller,
              focusNode: focusNode,
              isLoading: isLoading,
              textInputAction: textInputAction,
              onSubmitted: (value) {
                onFieldSubmitted();
                onSubmitted?.call(value);
              },
            );
          },

          optionsViewBuilder: (
              context,
              onSelected,
              options,
              ) {
            return _SuggestionsView(
              width: constraints.maxWidth,
              options: options.toList(),
              onSelected: onSelected,
            );
          },
        );
      },
    );
  }

  Iterable<LocationOption> _search(String value) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty || isLoading) {
      return const Iterable<LocationOption>.empty();
    }

    final countries = locations
        .where(
          (item) =>
      item.isCountry &&
          item.name.toLowerCase().startsWith(query),
    )
        .take(4);

    final cities = locations
        .where(
          (item) =>
      !item.isCountry &&
          item.name.toLowerCase().startsWith(query),
    )
        .take(8);

    return [
      ...countries,
      ...cities,
    ];
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.textInputAction,
    required this.onSubmitted,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.ml,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: AppBorders.lg,
        border: Border.all(
          color: AppColors.inputBorderGrey,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25.sp,
            color: context.secondaryColor,
          ),

          SizedBox(width: AppSpacing.ms),

          Text(
            '$label:',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              fontSize: 14.sp,
              color: AppColors.textGreyAndWhite,
            ),
          ),

          SizedBox(width: AppSpacing.xs),

          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize: 14.sp,
                color: context.secondaryColor,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          if (isLoading)
            SizedBox(
              width: 18.r,
              height: 18.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView({
    required this.width,
    required this.options,
    required this.onSelected,
  });

  final double width;
  final List<LocationOption> options;
  final ValueChanged<LocationOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        borderRadius: AppBorders.md,
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Container(
          width: width,
          constraints: BoxConstraints(
            maxHeight: 280.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: AppBorders.md,
            border: Border.all(
              color: AppColors.inputBorderGrey,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
            ),
            itemCount: options.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: AppColors.dividerAuthColor,
            ),
            itemBuilder: (context, index) {
              final option = options[index];

              return LocationSuggestionItem(
                option: option,
                onTap: () {
                  onSelected(option);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}