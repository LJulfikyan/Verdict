import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Share case',
      icon: const Icon(Icons.ios_share_rounded),
    );
  }
}
