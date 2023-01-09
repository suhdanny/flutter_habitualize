import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../widgets/habit_form.dart';

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});

  void addHabit(
    String title,
    Emoji emoji,
    int count,
    String countUnit,
    bool dailySelected,
    bool weeklySelected,
    Map<String, bool> dailyTracks,
  ) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await FirebaseFirestore.instance.collection('users/$userUid/habits').add({
      "title": title,
      "count": count,
      "countUnit": countUnit,
      "duration": dailySelected ? 'day' : 'week',
      "dailyTracks": dailySelected ? dailyTracks : null,
      "icon": emoji.emoji,
      "streaks": 0,
      "timeline": {
        today: {
          "completed": false,
          "dayCount": 0,
        },
      }
    });
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
