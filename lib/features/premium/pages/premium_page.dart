import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Premium',
        description:
            'RevenueCat initialization, offerings, purchase, and restore flows are scaffolded. Paywall UI remains intentionally unimplemented.',
      ),
    );
  }
}
