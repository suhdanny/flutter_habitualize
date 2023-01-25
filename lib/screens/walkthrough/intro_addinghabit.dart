import 'package:flutter/material.dart';
import 'package:delayed_widget/delayed_widget.dart';

class IntroAddHabit extends StatefulWidget {
  const IntroAddHabit({super.key});

  @override
  State<IntroAddHabit> createState() => _IntroAddHabitState();
}

class _IntroAddHabitState extends State<IntroAddHabit> {
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
                "Customize and Add Habits with Ease",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              child: Image.asset('assets/images/TutorialAddHabit.png'),
            )
          ],
        ),
      ),
    );
  }
}
