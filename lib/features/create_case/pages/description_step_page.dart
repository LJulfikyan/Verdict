import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class DescriptionStepPage extends StatelessWidget {
  const DescriptionStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Create: Description',
        description:
            'Description entry step is deferred; validation and repository submission are already in place.',
      ),
    );
  }
}
