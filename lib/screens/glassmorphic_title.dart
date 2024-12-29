import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GlassmorphicTitle extends StatelessWidget {
  final String title;

  const GlassmorphicTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 3.0,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}