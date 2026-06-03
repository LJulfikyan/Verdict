import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class CategoryStepPage extends StatelessWidget {
  const CategoryStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Create: Category',
        description: 'Category selection screen is intentionally deferred.',
      ),
    );
  }
}
