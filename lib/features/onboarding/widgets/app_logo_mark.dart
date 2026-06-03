import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({this.size = 84, this.showWordmark = true, super.key});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          child: Center(
            child: Transform.rotate(
              angle: -0.14,
              child: Text(
                'V',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(height: 18),
          Text(
            'Verdict',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
        ],
      ],
    );
  }
}
