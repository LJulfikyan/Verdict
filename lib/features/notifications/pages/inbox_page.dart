import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PagePlaceholder(
        title: 'Inbox',
        description:
            'Notification data flow, unread tracking, and deep-link targets are scaffolded. Screen implementation is intentionally deferred.',
      ),
    );
  }
}
