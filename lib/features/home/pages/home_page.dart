import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Home Feed',
        description:
            'Feed screens are intentionally not implemented yet. Pagination, voting, analytics, ad triggers, and repository contracts are already wired.',
      ),
    );
  }
}
