import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/services/debug_logger.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../onboarding/widgets/app_logo_mark.dart';
import '../controllers/auth_controller.dart';
import '../widgets/social_auth_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AuthController>();
  }

  Future<void> _runAuth(Future<void> Function() action) async {
    try {
      await action();
      if (!mounted) {
        return;
      }
      DebugLogger.logNavigation(
        module: 'Router',
        className: '_LoginPageState',
        method: '_runAuth',
        currentRoute: RouteNames.login,
        targetRoute: RouteNames.home,
      );
      context.go(RouteNames.home);
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Auth',
        className: '_LoginPageState',
        method: '_runAuth',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) {
        return;
      }
      final message = _controller.errorMessage.value;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.isEmpty ? 'Unable to sign in.' : message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canUseApple = !kIsWeb && (Platform.isIOS || Platform.isMacOS);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Center(child: AppLogoMark(size: 84)),
              const SizedBox(height: AppDimensions.space48),
              Text(
                'Let the internet decide who was right.',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),
              Text(
                'Vote first, unlock results, and keep your identity private.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.space32),
              Obx(
                () => Column(
                  children: [
                    if (canUseApple) ...[
                      SocialAuthButton(
                        label: 'Continue with Apple',
                        icon: const Icon(Icons.apple_rounded, size: 22),
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        borderColor: AppColors.secondary,
                        isLoading: _controller.isLoading.value,
                        onPressed: () => _runAuth(_controller.loginApple),
                      ),
                      const SizedBox(height: AppDimensions.space12),
                    ],
                    SocialAuthButton(
                      label: 'Continue with Google',
                      icon: const _GoogleIcon(),
                      isLoading: _controller.isLoading.value,
                      onPressed: () => _runAuth(_controller.loginGoogle),
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Continue as Guest',
                        variant: AppButtonVariant.outlined,
                        isLoading: _controller.isLoading.value,
                        onPressed: () => _runAuth(_controller.continueAsGuest),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space24),
              Center(
                child: Text(
                  'By continuing, you agree to stay anonymous and keep cases respectful.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Color(0xFF4285F4),
            Color(0xFF34A853),
            Color(0xFFFBBC05),
            Color(0xFFEA4335),
            Color(0xFF4285F4),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
