import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:delayed_widget/delayed_widget.dart';
import '../login_screen.dart';
import '../tabs_screen.dart';
import 'package:lottie/lottie.dart';

class IntroGetStarted extends StatefulWidget {
  const IntroGetStarted({super.key});

  @override
  State<IntroGetStarted> createState() => _IntroGetStartedState();
}

class _IntroGetStartedState extends State<IntroGetStarted> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
        child: Column(
          children: [
            Container(
                width: 100,
                height: 100,
                child: Lottie.asset('assets/json/lottie.json')),
            SizedBox(
              height: 80,
            ),
            DelayedWidget(
              animationDuration: Duration(milliseconds: 1000),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Unleash Your Potential,",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Haveit.",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 270,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return const TabsScreen();
                        }
                        return const LogInScreen();
                      }));
                })));
              },
              child: Container(
                width: 230,
                height: 50,
                child: Center(
                    child: Text(
                  "Get Started 👋🏻",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(223, 223, 223, 1)),
              ),
            ),
          ],
        ));
  }
}
