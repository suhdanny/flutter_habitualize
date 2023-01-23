import 'package:flutter/material.dart';

class IntroCalendar extends StatefulWidget {
  const IntroCalendar({super.key});

  @override
  State<IntroCalendar> createState() => _IntroCalendarState();
}

class _IntroCalendarState extends State<IntroCalendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("calendar"),
    );
  }
}
