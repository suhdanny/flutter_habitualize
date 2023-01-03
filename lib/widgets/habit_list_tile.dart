import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HabitListTile extends StatelessWidget {
  const HabitListTile({
    required this.docId,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.count,
    required this.countUnit,
    required this.duration,
    required this.streaks,
    required this.completed,
    super.key,
  });

  final String docId;
  final IconData icon;
  final Color iconColor;
  final String title;
  final int count;
  final String countUnit;
  final String duration;
  final int streaks;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor,
            size: 40,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            "$count$countUnit / $duration",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$streaks 🔥",
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  String userUid = FirebaseAuth.instance.currentUser!.uid;
                  FirebaseFirestore.instance
                      .doc('/users/$userUid/habits/$docId')
                      .update({
                    "completed": !completed,
                    "streaks": completed
                        ? FieldValue.increment(-1)
                        : FieldValue.increment(1),
                  });
                },
                icon: Icon(
                  Icons.task_alt,
                  size: 35,
                  color: completed ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
