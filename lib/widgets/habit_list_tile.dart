import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitListTile extends StatelessWidget {
  const HabitListTile({
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Habit"),
                    content: Text(
                      "Are you sure you want to delete '$title'? This action cannot be undone.",
                      textAlign: TextAlign.left,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          String userUid =
                              FirebaseAuth.instance.currentUser!.uid;
                          FirebaseFirestore.instance
                              .doc('users/$userUid/habits/$docId')
                              .delete();
                          Navigator.pop(context, 'Delete');
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (ctx) {
                Navigator.pushNamed(
                  context,
                  '/add-habit',
                  arguments: {
                    "appBarTitle": "Edit Habit",
                    "docId": docId,
                    "icon": icon,
                    "iconColor": iconColor,
                    "title": title,
                    "count": count,
                    "countUnit": countUnit,
                    "duration": duration,
                  },
                );
              },
              icon: Icons.edit,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {},
              icon: Icons.more_time,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              label: "Count",
            ),
            SlidableAction(
              onPressed: (_) {},
              icon: Icons.create,
              backgroundColor: Colors.yellow[700] as Color,
              foregroundColor: Colors.white,
              label: "Notes",
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () => Navigator.pushNamed(
              context,
              '/habit-details',
              arguments: {
                "title": title,
              },
            ),
            leading: Icon(
              icon,
              color: iconColor,
              size: 55,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "$count $countUnit / $duration",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "TODAY: $dayCount / $count $countUnit",
                  style: TextStyle(
                    color: dayCount >= count ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$streaks 🔥",
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String userUid = FirebaseAuth.instance.currentUser!.uid;
                    await FirebaseFirestore.instance
                        .doc('/users/$userUid/habits/$docId')
                        .update({
                      "completed": !completed,
                      "streaks": completed
                          ? FieldValue.increment(-1)
                          : FieldValue.increment(1),
                      "dayCount": !completed ? count : 0,
                    });
                  },
                  icon: Icon(
                    Icons.task_alt,
                    size: 37,
                    color: completed ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
