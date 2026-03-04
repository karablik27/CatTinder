import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int value;
  final int max;

  const RatingStars({super.key, required this.value, this.max = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        max,
        (i) => Icon(
          i < value ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 20,
        ),
      ),
    );
  }
}
