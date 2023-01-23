import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_habitualize/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/habit_details_page.dart';
import './screens/add_habit_screen.dart';
import './screens/tabs_screen.dart';
import './screens/auth_screen.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitualize',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        primaryColor: const Color.fromRGBO(235, 83, 83, 1),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color.fromRGBO(249, 217, 35, 1),
          cardColor: const Color.fromRGBO(54, 174, 124, 1),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/add-habit': (ctx) => const AddHabitScreen(),
        '/habit-details': (ctx) => const HabitDetailsPage(),
      },
    );
  }
}
