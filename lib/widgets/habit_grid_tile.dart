import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:intl/intl.dart';

class HabitGridTile extends StatelessWidget {
  const HabitGridTile({
    required this.docId,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.count,
    required this.countUnit,
    required this.dayCount,
    required this.duration,
    required this.streaks,
    required this.completed,
    required this.selectedDateTime,
    super.key,
  });

  final String docId;
  final IconData icon;
  final Color iconColor;
  final String title;
  final int count;
  final int dayCount;
  final String countUnit;
  final String duration;
  final int streaks;
  final bool completed;
  final DateTime selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
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
              Icon(
                icon,
                size: 60,
                color: iconColor,
              ),
              IconButton(
                onPressed: () async {
                  String userUid = FirebaseAuth.instance.currentUser!.uid;
                  String selectedDate =
                      DateFormat('yyyy-MM-dd').format(selectedDateTime);
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
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
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
            "TODAY: $dayCount $countUnit / $duration",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
