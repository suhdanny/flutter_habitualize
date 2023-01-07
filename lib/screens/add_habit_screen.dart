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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 25),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
              Text(
                "Add Habit",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
