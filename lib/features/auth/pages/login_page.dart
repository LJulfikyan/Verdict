import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Login',
        description:
            'Authentication UI is intentionally deferred. The route, controller, and service wiring are ready for Google, Apple, and guest flows.',
      ),
    );
  }
}
