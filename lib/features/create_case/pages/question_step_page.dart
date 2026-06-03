import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class QuestionStepPage extends StatelessWidget {
  const QuestionStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Create: Question',
        description:
            'Final question step route is ready for UI implementation.',
      ),
    );
  }
}
