import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/onboarding_controller.dart';
import '../models/onboarding_item.dart';
import '../widgets/onboarding_illustration.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  late final OnboardingController _controller;

  static const _items = [
    OnboardingItem(
      title: 'The Internet Decides',
      subtitle: 'Post relationship situations and get a verdict.',
      type: OnboardingIllustrationType.cards,
    ),
    OnboardingItem(
      title: 'Stay Anonymous',
      subtitle: 'No names. No photos. No drama.',
      type: OnboardingIllustrationType.anonymous,
    ),
    OnboardingItem(
      title: 'Vote First',
      subtitle: 'Results unlock only after voting.',
      type: OnboardingIllustrationType.chart,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<OnboardingController>();
    _controller.setPage(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handlePrimaryAction() async {
    if (_controller.isLastPage.value) {
      await _controller.completeOnboarding();
      if (!mounted) {
        return;
      }
      final authService = Get.find<AuthService>();
      context.go(
        authService.isAuthenticated ? RouteNames.home : RouteNames.login,
      );
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.space16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    await _controller.completeOnboarding();
                    if (!context.mounted) {
                      return;
                    }
                    context.go(RouteNames.login);
                  },
                  child: const Text('Skip'),
                ),
              ),
              const SizedBox(height: AppDimensions.space12),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: _controller.setPage,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OnboardingIllustration(type: item.type),
                        const SizedBox(height: AppDimensions.space48),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space16),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _items.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _controller.currentPage.value == index ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _controller.currentPage.value == index
                            ? AppColors.primary
                            : AppColors.outline,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space24),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: _controller.isLastPage.value ? 'Continue' : 'Next',
                    onPressed: _handlePrimaryAction,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space32),
            ],
          ),
        ),
      ),
    );
  }
}
