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
    required this.idx,
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
    required this.dailyTracks,
    required this.weeklyTrack,
    required this.totalCount,
    super.key,
  });

  final String docId;
  final int idx;
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
  final Map<String, bool>? dailyTracks;
  final String? weeklyTrack;
  final int totalCount;

  List<Color> colorsList = [
    Color.fromRGBO(203, 228, 249, 1),
    Color.fromRGBO(239, 249, 218, 1),
    // Color.fromRGBO(255, 88, 68, 1),
    Color.fromRGBO(247, 215, 140, 1),
    Color.fromRGBO(249, 235, 223, 1),
    Color.fromRGBO(166, 211, 242, 1),
    Color.fromRGBO(249, 216, 214, 1),
    Color.fromRGBO(214, 205, 234, 1),
    Color.fromRGBO(175, 195, 168, 1),
  ];

  List<Color> colorsList2 = [
    Color.fromRGBO(253, 21, 27, 0.8),
    Color.fromRGBO(255, 179, 15, 0.8),
    Color.fromRGBO(132, 147, 36, 0.8),
    Color.fromRGBO(67, 127, 151, 0.8),
    Color.fromRGBO(1, 41, 95, 0.8),
  ];

  List<Color> colorsList3 = [
    Color.fromRGBO(255, 88, 68, 1),
    Color.fromRGBO(166, 211, 242, 1),
    Color.fromRGBO(247, 215, 140, 1),
    Color.fromRGBO(175, 195, 168, 1),
  ];

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
            'count': count,
            'countUnit': countUnit,
            'duration': duration,
            'dailyTracks': dailyTracks,
            'weeklyTrack': weeklyTrack,
            'selectedDateTime': selectedDateTime,
            'totalCount': totalCount,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(3, 5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: colorsList[idx % (colorsList.length - 1)],
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
                  style: TextStyle(
                    fontSize: 43,
                  ),
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
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
                color: Color.fromARGB(255, 68, 67, 67),
              ),
            )
          ],
        ),
      ),
    );
  }
}
