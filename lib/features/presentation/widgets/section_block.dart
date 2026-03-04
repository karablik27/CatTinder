import 'package:flutter/material.dart';
import 'title_text.dart';

class SectionBlock extends StatelessWidget {
  final String title;
  final String text;

  const SectionBlock({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title),
        Text(text, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 18),
      ],
    );
  }
}
