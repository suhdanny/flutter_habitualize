import 'package:flutter/material.dart';

class IntroHome extends StatefulWidget {
  const IntroHome({super.key});

  @override
  State<IntroHome> createState() => _IntroHomeState();
}

class _IntroHomeState extends State<IntroHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30, 90, 30, 0),
              child: Text(
                "Stay on Track with Your Habits in One Place",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40),
              ),
            ),
            Container(
              child: Image.asset('assets/images/WalkthroughHome.png'),
            )
          ],
        ));
  }
}
