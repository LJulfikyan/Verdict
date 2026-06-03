import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Create: Success',
        description:
            'Success state route is scaffolded for post-submission confirmation.',
      ),
    );
  }
}
