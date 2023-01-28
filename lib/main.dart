import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_habitualize/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/habit_details_page.dart';
import './screens/add_habit_screen.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
      routes: {
        '/': (ctx) => const SplashScreen(),
        '/sign-in': (ctx) => const LogInScreen(),
        '/sign-up': (ctx) => const SignUpScreen(),
        '/add-habit': (ctx) => const AddHabitScreen(),
        '/habit-details': (ctx) => const HabitDetailsPage(),
      },
    );
  }
}
