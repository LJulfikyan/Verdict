import 'package:flutter/material.dart';

import '../../../core/widgets/page_placeholder.dart';

class CaseDetailPage extends StatelessWidget {
  const CaseDetailPage({required this.caseId, super.key});

  final String caseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagePlaceholder(
        title: 'Case Detail',
        description: 'Shared case route prepared for case `$caseId`.',
      ),
    );
  }
}
