import 'package:flutter/material.dart';

class IntroAddHabit extends StatefulWidget {
  const IntroAddHabit({super.key});

  @override
  State<IntroAddHabit> createState() => _IntroAddHabitState();
}

class _IntroAddHabitState extends State<IntroAddHabit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Add Habit"),
    );
  }
}
