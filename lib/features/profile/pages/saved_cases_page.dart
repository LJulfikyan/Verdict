import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class SavedCasesPage extends StatelessWidget {
  const SavedCasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Saved Cases',
        description:
            'Saved-cases routing is present and ready for repository-backed UI.',
      ),
    );
  }
}
