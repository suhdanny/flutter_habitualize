import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:intl/intl.dart';
import '../utils/is_after_today.dart';

class HabitGridTile extends StatelessWidget {
  HabitGridTile({
    required this.docId,
    required this.icon,
    required this.title,
    required this.count,
    required this.countUnit,
    required this.dayCount,
    required this.duration,
    required this.streaks,
    required this.completed,
    required this.selectedDateTime,
    required this.bestStreaks,
    super.key,
  });

  final String docId;
  final String icon;
  final String title;
  final int count;
  final int dayCount;
  final String countUnit;
  final String duration;
  final int streaks;
  final bool completed;
  final DateTime selectedDateTime;
  final int bestStreaks;

  List<String> colors = [
    'Color.fromRGBO(235, 83, 83, 0.5)',
    'Color.fromRGBO(249, 217, 35, 0.5)',
    'Color.fromRGBO(54, 174, 124, 0.5)',
    'Color.fromRGBO(24, 116, 152, 0.5)',
  ];

  int index = Random().nextInt(4);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/habit-details',
          arguments: {
            'docId': docId,
            'title': title,
            'icon': icon,
            'streaks': streaks,
            'bestStreaks': bestStreaks,
            'completed': completed,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  icon,
                  style: TextStyle(fontSize: 45),
                ),
                IconButton(
                  onPressed: () async {
                    // if the selected date is in the future, do not allow users to complete the habit
                    if (isDateAfterToday(selectedDateTime)) return;

                    String userUid = FirebaseAuth.instance.currentUser!.uid;
                    String selectedDate =
                        DateFormat('yyyy-MM-dd').format(selectedDateTime);

                    // update the completed status and if the habit wasn't completed before, then add streak count by 1
                    await FirebaseFirestore.instance
                        .doc('/users/$userUid/habits/$docId')
                        .update({
                      "timeline.$selectedDate.completed": !completed,
                      "streaks": completed
                          ? FieldValue.increment(-1)
                          : FieldValue.increment(1),
                      "timeline.$selectedDate.dayCount": !completed ? count : 0,
                    });
                  },
                  icon: Icon(
                    IconData(0xf3fe,
                        fontFamily: iconFont, fontPackage: iconFontPackage),
                    size: 30,
                    color: completed ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 1),
            // Text(
            //   "$count $countUnit / $duration",
            //   style: const TextStyle(
            //     fontSize: 15,
            //     color: Colors.grey,
            //   ),
            // ),
            // const SizedBox(height: 5),
            Text(
              "TODAY: $dayCount / $count $countUnit",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
