import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/features/home/presentation/widgets/whereto/where_to_form_widget.dart';
import 'package:flutter/material.dart';

class WheretoScreen extends StatefulWidget {
  const WheretoScreen({super.key});

  @override
  State<WheretoScreen> createState() => _WheretoScreenState();
}

class _WheretoScreenState extends State<WheretoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.lg),

              // ───────────────── Header ─────────────────
              const _Header(),

              SizedBox(height: AppSpacing.xl),

              // ───────────────── Form ─────────────────
              const Expanded(
                child: WhereToFormWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.xxl,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.xxl,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.all(
                      AppSpacing.sm,
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 24,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Text(
              'Where To',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: AppColors.primaryColor,
              ),
            ),
          ),

          SizedBox(
            width: AppSpacing.xxl,
          ),
        ],
      ),
    );
  }
}