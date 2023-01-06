import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/habit_details_page.dart';
import './screens/add_habit_screen.dart';
import './screens/tabs_screen.dart';
import './screens/auth_screen.dart';

Future<void> main() async {
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
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return const TabsScreen();
          return const AuthScreen();
        },
      ),
      routes: {
        '/add-habit': (ctx) => const AddHabitScreen(),
        '/habit-details': (ctx) => const HabitDetailsPage(),
      },
    );
  }
}
