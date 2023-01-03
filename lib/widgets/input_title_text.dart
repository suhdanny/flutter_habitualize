import 'package:flutter/material.dart';

class InputTitleText extends StatelessWidget {
  const InputTitleText({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
