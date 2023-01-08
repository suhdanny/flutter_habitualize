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
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 25),
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 40,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: Colors.black,
                ),
              ),
              HabitForm(addHabit: addHabit),
            ],
          ),
        ),
      ),
    );
  }
}
