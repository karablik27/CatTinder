import 'package:flutter/material.dart';

class AppColors {
  static const backgroundTop = Color(0xFFF56F46);
  static const backgroundBottom = Color(0xFFE24C20);

  static const cardTop = Color(0xFF7CDF65);
  static const cardBottom = Color(0xFF58B44A);

  static const white = Colors.white;

  static LinearGradient backgroundGradient = const LinearGradient(
    colors: [backgroundTop, backgroundBottom],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient cardGradient = const LinearGradient(
    colors: [cardTop, cardBottom],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
