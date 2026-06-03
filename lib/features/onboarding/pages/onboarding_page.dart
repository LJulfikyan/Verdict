import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Onboarding',
        description:
            'The onboarding flow is reserved for the next implementation phase. Navigation, persistence, and controller state are already scaffolded.',
      ),
    );
  }
}
