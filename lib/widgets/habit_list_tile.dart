import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitListTile extends StatefulWidget {
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
  State<HabitListTile> createState() => _HabitListTileState();
}

class _HabitListTileState extends State<HabitListTile> {
  String? _countInput;

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
                      "Are you sure you want to delete '${widget.title}'? This action cannot be undone.",
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
                              .doc('users/$userUid/habits/${widget.docId}')
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
                    "docId": widget.docId,
                    "icon": widget.icon,
                    "iconColor": widget.iconColor,
                    "title": widget.title,
                    "count": widget.count,
                    "countUnit": widget.countUnit,
                    "duration": widget.duration,
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
              onPressed: (ctx) {
                showDialog(
                  context: ctx,
                  builder: (context) => AlertDialog(
                    title: const Text("Add Daily Count"),
                    content: TextField(
                      decoration: const InputDecoration(
                        label: Text("Enter Count"),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _countInput = value;
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _countInput = null;
                          });
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_countInput == null) return;
                          try {
                            final db = FirebaseFirestore.instance;
                            String userUid =
                                FirebaseAuth.instance.currentUser!.uid;

                            db
                                .doc('users/$userUid/habits/${widget.docId}')
                                .get()
                                .then((DocumentSnapshot doc) {
                              final docData =
                                  doc.data() as Map<String, dynamic>;
                              final currentCompleted = docData['completed'];
                              final currentDayCount = docData['dayCount'];
                              final currentStreaks = docData['streaks'];

                              // if the updated dayCount exceeds daily goal count, then completed must be true
                              bool updatedCompleted =
                                  currentDayCount + int.parse(_countInput!) >=
                                          widget.count
                                      ? true
                                      : false;

                              // if current completed is false and updatedCompleted is true, then update the streaks value by 1
                              int updatedStreaks =
                                  updatedCompleted && !currentCompleted
                                      ? currentStreaks + 1
                                      : currentStreaks;

                              doc.reference.update({
                                "dayCount": FieldValue.increment(
                                    int.parse(_countInput!)),
                                "completed": updatedCompleted,
                                "streaks": updatedStreaks,
                              });
                            });
                          } catch (error) {
                            print(error);
                          }
                          Navigator.pop(context, 'Add');
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                );
              },
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
                "title": widget.title,
              },
            ),
            leading: Icon(
              widget.icon,
              color: widget.iconColor,
              size: 55,
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "${widget.count} ${widget.countUnit} / ${widget.duration}",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "TODAY: ${widget.dayCount} / ${widget.count} ${widget.countUnit}",
                  style: TextStyle(
                    color: widget.dayCount >= widget.count
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.streaks} 🔥",
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String userUid = FirebaseAuth.instance.currentUser!.uid;
                    await FirebaseFirestore.instance
                        .doc('/users/$userUid/habits/${widget.docId}')
                        .update({
                      "completed": !widget.completed,
                      "streaks": widget.completed
                          ? FieldValue.increment(-1)
                          : FieldValue.increment(1),
                      "dayCount": !widget.completed ? widget.count : 0,
                    });
                  },
                  icon: Icon(
                    Icons.task_alt,
                    size: 37,
                    color: widget.completed ? Colors.red : Colors.grey,
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
