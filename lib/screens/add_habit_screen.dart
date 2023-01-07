import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/habit_form.dart';

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});

  void addHabit(
    String? docId,
    bool completed,
    int count,
    String countUnit,
    String duration,
    String icon,
    String iconColor,
    String title,
  ) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    if (docId == null) {
      await FirebaseFirestore.instance.collection('users/$userUid/habits').add({
        "completed": completed,
        "count": count,
        "countUnit": countUnit,
        "duration": duration,
        "icon": icon,
        "iconColor": iconColor,
        "streaks": 0,
        "title": title,
        "dayCount": 0,
      });
    } else {
      await FirebaseFirestore.instance
          .doc('users/$userUid/habits/$docId')
          .update({
        "completed": completed,
        "count": count,
        "countUnit": countUnit,
        "duration": duration,
        "icon": icon,
        "iconColor": iconColor,
        "title": title,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Add Habit")),
    );
  }
}
