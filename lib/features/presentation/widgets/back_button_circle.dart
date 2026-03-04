import 'package:flutter/material.dart';

class BackButtonCircle extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const BackButtonCircle({super.key, required this.onTap, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: Colors.black87, size: 26),
      ),
    );
  }
}
