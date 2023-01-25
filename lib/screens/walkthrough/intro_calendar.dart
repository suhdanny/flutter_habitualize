import 'package:flutter/material.dart';
import 'package:delayed_widget/delayed_widget.dart';

class IntroCalendar extends StatefulWidget {
  const IntroCalendar({super.key});

  @override
  State<IntroCalendar> createState() => _IntroCalendarState();
}

class _IntroCalendarState extends State<IntroCalendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      child: DelayedWidget(
        animationDuration: Duration(milliseconds: 1000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
              child: Text(
                "Track Your Habits and Streaks in Style",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              child: Image.asset('assets/images/TutorialCalendar.png'),
            )
          ],
        ),
      ),
    );
  }
}
