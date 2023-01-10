import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../widgets/habit_form.dart';

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({
    this.docId,
    this.emoji,
    this.title,
    this.count,
    this.countUnit,
    this.duration,
    this.dailyTracks,
    this.weeklyTrack,
    super.key,
  });

  final String? docId;
  final String? emoji;
  final String? title;
  final int? count;
  final String? countUnit;
  final String? duration;
  final Map<String, bool>? dailyTracks;
  final String? weeklyTrack;

  void addHabit(
    String title,
    String emoji,
    int count,
    String countUnit,
    bool dailySelected,
    bool weeklySelected,
    Map<String, bool> dailyTracks,
    String weeklyTrack,
  ) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await FirebaseFirestore.instance.collection('users/$userUid/habits').add({
      "title": title,
      "count": count,
      "countUnit": countUnit,
      "duration": dailySelected ? 'day' : 'week',
      if (dailySelected) "dailyTracks": dailyTracks,
      if (weeklySelected) "weeklyTrack": weeklyTrack,
      "icon": emoji,
      "streaks": 0,
      "timeline": {
        today: {
          "completed": false,
          "dayCount": 0,
        },
      }
    });
  }

  void updateHabit(
    String docId,
    String title,
    String emoji,
    int count,
    String countUnit,
    bool dailySelected,
    bool weeklySelected,
    Map<String, bool> dailyTracks,
    String weeklyTrack,
  ) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .doc('users/$userUid/habits/$docId')
        .update({
      "title": title,
      "icon": emoji,
      "duration": dailySelected ? 'day' : 'week',
      if (dailySelected) "dailyTracks": dailyTracks,
      if (weeklySelected) "weeklyTrack": weeklyTrack,
      "count": count,
      "countUnit": countUnit,
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
              HabitForm(
                addHabit: addHabit,
                updateHabit: updateHabit,
                docId: docId,
                title: title,
                emoji: emoji,
                count: count,
                countUnit: countUnit,
                duration: duration,
                dailyTracks: dailyTracks,
                weeklyTrack: weeklyTrack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
