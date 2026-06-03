import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Edit Profile',
        description:
            'Edit-profile routing and validation hooks are reserved for the next implementation phase.',
      ),
    );
  }
}
