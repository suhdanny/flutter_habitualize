import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarList extends StatelessWidget {
  const CalendarList({
    required this.docId,
    required this.icon,
    required this.title,
    required this.streaks,
    required this.completed,
    super.key,
  });

  final String docId;
  final String icon;
  final String title;
  final int streaks;
  final String completed;

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
                          "Are you sure you want to delete '${title}'? This action cannot be undone.",
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
                                  .doc('users/$userUid/habits/$docId')
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
                // Navigator.pushNamed(
                //   context,
                //   '/add-habit',
                //   arguments: {
                //     "docId": docId,
                //     "icon":icon,
                //     "iconColor":iconColor,
                //     "title":title,
                //     "count":count,
                //     "countUnit":countUnit,
                //     "duration":duration,
                //   },
                // );
              },
              icon: Icons.edit,
              backgroundColor: Color.fromRGBO(54, 126, 24, 1),
              foregroundColor: Colors.white,
            ),
          ],
        ),
        child: ListTile(
            leading: Text(icon, style: TextStyle(fontSize: 35)),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text('${streaks} 🔥'),
                  Text(
                    completed,
                    style: TextStyle(
                        fontSize: 12,
                        color: completed == 'completed!'
                            ? Color.fromRGBO(54, 126, 24, 1)
                            : Colors.grey[600]),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
