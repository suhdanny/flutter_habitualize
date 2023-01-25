import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void deleteHabit(
  BuildContext context,
  String userUid,
  String docId,
  String title,
  bool popOnDelete,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      title: const Text(
        "Delete Habit",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      content: Text(
        "Are you sure you want to delete '$title'? This action cannot be undone.",
        textAlign: TextAlign.left,
        style: const TextStyle(
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
              fontSize: 15,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .doc('users/$userUid/habits/$docId')
                .delete();
            Navigator.pop(context, 'Delete');
          },
          child: const Text(
            "Delete",
            style: TextStyle(
              color: Color.fromRGBO(204, 54, 54, 1),
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  ).then((action) {
    if (action == 'Delete' && popOnDelete) {
      Navigator.pop(context);
    }
  });
}
