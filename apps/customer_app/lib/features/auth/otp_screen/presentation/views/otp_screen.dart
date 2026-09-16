import 'dart:async';

import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/src/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers =
  List.generate(4, (_) => TextEditingController());

  final _focusNodes =
  List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _seconds = 10;

  @override
  void initState() {
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _focusNodes.first.requestFocus(),
    );
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (_seconds == 0) {
          timer.cancel();
          return;
        }

        setState(() => _seconds--);
      },
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _resendOtp() {
    if (_seconds != 0) return;

    for (final controller in _controllers) {
      controller.clear();
    }

    setState(() => _seconds = 10);

    _focusNodes.first.requestFocus();
    _startTimer();
  }

  Widget _otpField(int index) {
    return SizedBox(
      width: 66.w,
      height: 76.h,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        cursorColor: AppColors.primaryColor,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) => _onOtpChanged(value, index),
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryColor,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: _otpBorder(
            const Color(0xFFC6D1DB),
          ),
          focusedBorder: _otpBorder(
            AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _otpBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        color: color,
        width: 1.2,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppSpacing.sm,
                      ),

                      /// Back
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: context.pop,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: Icon(
                            Icons.arrow_back,
                            size: 24.r,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: AppSpacing.ml,
                      ),

                      /// Logo
                      Image.asset(
                        ImageAssets.logo2,
                        width: 160.w,
                        height: 158.h,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(
                        height: AppSpacing.ml,
                      ),

                      /// Title
                      Text(
                        'Welcome Back to Meshwar',
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryColor,
                        ),
                      ),

                      SizedBox(
                        height: AppSpacing.ms,
                      ),

                      /// Verification text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'We sent a 4-digit verification code to +20 10 ••••••••',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 13.sp,
                                color: const Color(0xFF6E6E6E),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: AppSpacing.sm,
                          ),

                          InkWell(
                            onTap: context.pop,
                            child: Icon(
                              Icons.edit_outlined,
                              size: 26.r,
                              color: const Color(0xFF747474),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: AppSpacing.lg,
                      ),

                      /// OTP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                              (index) => Padding(
                            padding: EdgeInsets.only(
                              right: index == 3
                                  ? 0
                                  : AppSpacing.ms,
                            ),
                            child: _otpField(index),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: AppSpacing.ml,
                      ),

                      /// Resend
                      GestureDetector(
                        onTap: _seconds == 0
                            ? _resendOtp
                            : null,
                        child: Text(
                          _seconds > 0
                              ? 'Resend in $_seconds secs'
                              : 'Resend code',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Button
              AppButton(
                label: 'Get Started',
                onPressed: () {
                  context.push(
                    AppRoutes.completeprofile,
                  );
                },
              ),

              SizedBox(
                height: AppSpacing.ml,
              ),
            ],
          ),
        ),
      ),
    );
  }
}