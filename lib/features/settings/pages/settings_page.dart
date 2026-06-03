import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Settings',
        description:
            'Settings route is ready for notification preferences and account controls.',
      ),
    );
  }
}
