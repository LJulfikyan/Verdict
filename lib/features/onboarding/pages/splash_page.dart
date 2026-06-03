import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Splash',
        description:
            'Initialization runs before the app shell renders. This route remains available for startup animation and boot diagnostics.',
      ),
    );
  }
}
