import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Profile',
        description:
            'Profile state and premium awareness are in place. The visual profile screens are intentionally deferred.',
      ),
    );
  }
}
