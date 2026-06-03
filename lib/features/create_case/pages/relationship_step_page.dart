import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class RelationshipStepPage extends StatelessWidget {
  const RelationshipStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Create: Relationship',
        description:
            'Step routing and controller state are prepared for the multi-step create flow.',
      ),
    );
  }
}
