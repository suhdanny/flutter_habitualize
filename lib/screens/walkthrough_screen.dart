import 'package:flutter/material.dart';
import 'package:flutter_habitualize/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './auth_screen.dart';
import './walkthrough/intro_addinghabit.dart';
import './walkthrough/intro_calendar.dart';
import './walkthrough/intro_details.dart';
import './walkthrough/intro_getstarted.dart';
import './walkthrough/intro_home.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  PageController _controller = PageController();

  bool onLastPage = false;

  _storeOnBoardInfo() async {
    int isViewed = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("onBoard", isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 4);
            });
          },
          children: const [
            IntroHome(),
            IntroDetails(),
            IntroCalendar(),
            IntroAddHabit(),
            IntroGetStarted(),
          ],
        ),
        Container(
            alignment: Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(5);
                    },
                    child: Text("skip")),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 5,
                  effect: SlideEffect(
                      activeDotColor: Colors.black,
                      dotColor: Color.fromRGBO(223, 223, 223, 0.5),
                      dotHeight: 13,
                      dotWidth: 13),
                ),
                !onLastPage
                    ? GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text("next"))
                    : GestureDetector(
                        onTap: () {
                          _storeOnBoardInfo();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return StreamBuilder(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) return const TabsScreen();
                                return const AuthScreen();
                              },
                            );
                          }));
                        },
                        child: Text("done"),
                      )
              ],
            ))
      ]),
    );
  }
}
