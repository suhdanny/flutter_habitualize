import 'package:flutter/material.dart';

class HabitDetailsPage extends StatelessWidget {
  const HabitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Habit Details Page for ${args['title']}'),
      ),
    );
  }
}
