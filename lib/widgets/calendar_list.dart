import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/add_habit_screen.dart';

class CalendarList extends StatefulWidget {
  const CalendarList({
    required this.docId,
    required this.emoji,
    required this.title,
    required this.count,
    required this.countUnit,
    required this.duration,
    required this.dayTracks,
    required this.streaks,
    required this.completed,
    required this.selectedDateString,
    required this.isAfterToday,
    super.key,
  });

  final String docId;
  final String emoji;
  final String title;
  final int count;
  final String countUnit;
  final String duration;
  final Map<String, bool> dayTracks;
  final int streaks;
  final String completed;
  final String selectedDateString;
  final bool isAfterToday;

  @override
  State<CalendarList> createState() => _CalendarListState();
}

class _CalendarListState extends State<CalendarList> {
  String? _countInput;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const DrawerMotion(),
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        title: const Text(
                          "Delete Habit",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                          "Are you sure you want to delete '${widget.title}'? This action cannot be undone.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
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
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Color.fromRGBO(204, 54, 54, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                      alignment: Alignment.center,
                      width: 24 * 4, // space for actionPan
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        color: Color.fromRGBO(204, 54, 54, 1),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            SlidableAction(
              onPressed: (ctx) {
                showMaterialModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  expand: false,
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return AddHabitScreen(
                      docId: widget.docId,
                      title: widget.title,
                      emoji: widget.emoji,
                      count: widget.count,
                      countUnit: widget.countUnit,
                      duration: widget.duration,
                      dayTracks: widget.dayTracks,
                    );
                  },
                );
              },
              icon: Icons.edit,
              backgroundColor: Color.fromRGBO(54, 126, 24, 1),
              foregroundColor: Colors.white,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: (ctx) {
                if (widget.isAfterToday) return;
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
                            print(widget.selectedDateString);

                            final db = FirebaseFirestore.instance;
                            String userUid =
                                FirebaseAuth.instance.currentUser!.uid;

                            db
                                .doc('users/$userUid/habits/${widget.docId}')
                                .get()
                                .then((DocumentSnapshot doc) {
                              final docData =
                                  doc.data() as Map<String, dynamic>;

                              final currentCompleted = docData['timeline']
                                  [widget.selectedDateString]['completed'];
                              final currentDayCount = docData['timeline']
                                  [widget.selectedDateString]['dayCount'];
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
                                "timeline.${widget.selectedDateString}.completed":
                                    updatedCompleted,
                                "timeline.${widget.selectedDateString}.dayCount":
                                    FieldValue.increment(
                                        int.parse(_countInput!)),
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
              backgroundColor: const Color.fromRGBO(245, 115, 40, 1),
              foregroundColor: Colors.white,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                      alignment: Alignment.center,
                      width: 24 * 4, // space for actionPan
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Color.fromRGBO(255, 233, 160, 1),
                      ),
                      child: const Icon(
                        Icons.create,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            // SlidableAction(
            //   onPressed: (_) {},
            //   icon: Icons.create,
            //   backgroundColor: Color.fromRGBO(255, 233, 160, 1),
            //   foregroundColor: Colors.white,
            // ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          child: ListTile(
              leading: Text(widget.emoji, style: TextStyle(fontSize: 40)),
              title: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              trailing: Container(
                width: 80,
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(
                      '${widget.streaks} 🔥',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.completed,
                      style: TextStyle(
                          fontSize: 15,
                          color: widget.completed == 'completed!'
                              ? Color.fromRGBO(54, 126, 24, 1)
                              : Colors.grey[600]),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
