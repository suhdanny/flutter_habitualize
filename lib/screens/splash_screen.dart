import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './walkthrough_screen.dart';
import './tabs_screen.dart';
import './login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pushScreen(prefs.getInt("onBoard"));
  }

  void pushScreen(int? isViewed) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: ((context) {
          if (isViewed == null || isViewed == 0) {
            return const WalkthroughScreen();
          } else {
            if (FirebaseAuth.instance.currentUser != null) {
              return const TabsScreen();
            } else {
              return const LogInScreen();
            }
            // return StreamBuilder(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) return const TabsScreen();
            //     return const LogInScreen();
            //   },
            // );
          }
        }),
      ),
    );
  }

  startTimer() async {
    return Timer(const Duration(seconds: 3), navigateUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 120,
          height: 120,
          child: Lottie.asset('assets/json/lottie.json'),
        ), // child: Text("Splash Screen"),
      ),
    );
  }
}
