import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({required this.isSaved, this.onPressed, super.key});

  final bool isSaved;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: isSaved ? 'Remove save' : 'Save case',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          key: ValueKey<bool>(isSaved),
        ),
      ),
    );
  }
}
