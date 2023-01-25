import 'package:flutter/material.dart';
import 'package:delayed_widget/delayed_widget.dart';

class IntroDetails extends StatefulWidget {
  const IntroDetails({super.key});

  @override
  State<IntroDetails> createState() => _IntroDetailsState();
}

class _IntroDetailsState extends State<IntroDetails> {
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
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
              child: Text(
                "Take Control of Your Habits with Flexibility",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              child: Image.asset('assets/images/TutorialDetails.png'),
            )
          ],
        ),
      ),
    );
  }
}
