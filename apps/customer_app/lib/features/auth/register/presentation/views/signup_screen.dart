import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/src/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 56),

                      Image.asset(
                        ImageAssets.logo2,
                        width: 150,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 30),

                      Text(
                        'Welcome to Meshwar',
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0A3155),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Enter your mobile number to get started',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF777777),
                        ),
                      ),

                      const SizedBox(height: 42),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your mobile number',
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF0A3155),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF0A3155),
                          ),
                          decoration: InputDecoration(
                            hintText: '+20 | 10XXXXXXXX',
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF8A9BAD),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFC2CFD9),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF00A887),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      const SizedBox(height: 30),

                      AppButton(
                        label: 'Get OTP',
                        onPressed: () {
                          context.push(AppRoutes.otp);
                        },
                      ),

                      const SizedBox(height: 18),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'By continuing, you agree to our Terms & Conditions and Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            height: 1.6,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}