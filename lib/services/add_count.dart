import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addCount(
  BuildContext context,
  String userUid,
  String docId,
  String selectedDateString,
  bool isAfterToday,
  int currentCount,
  Function handleExit,
) {
  String? count;

  if (isAfterToday) return;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: const Text(
        "Update Your Progress",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      content: TextField(
        decoration: const InputDecoration(
          hintText: "Enter Count",
          hintStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) => count = value,
      ),
      actions: [
        TextButton(
          onPressed: (() {
            count = null;
            Navigator.of(context).pop(false);
          }),
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
            if (count == null) return;
            try {
              final db = FirebaseFirestore.instance;

              db
                  .doc('users/$userUid/habits/$docId')
                  .get()
                  .then((DocumentSnapshot doc) {
                final docData = doc.data() as Map<String, dynamic>;

                final currentCompleted =
                    docData['timeline'][selectedDateString]['completed'];
                final currentDayCount =
                    docData['timeline'][selectedDateString]['dayCount'];
                final currentStreaks = docData['streaks'];

                // if the updated dayCount exceeds daily goal count, then completed must be true
                bool updatedCompleted =
                    currentDayCount + int.parse(count!) >= currentCount
                        ? true
                        : false;

                // if current completed is false and updatedCompleted is true, then update the streaks value by 1
                int updatedStreaks = updatedCompleted && !currentCompleted
                    ? currentStreaks + 1
                    : currentStreaks;

                doc.reference.update({
                  "timeline.$selectedDateString.completed": updatedCompleted,
                  "timeline.$selectedDateString.dayCount":
                      FieldValue.increment(int.parse(count!)),
                  "streaks": updatedStreaks,
                  "totalCount": FieldValue.increment(int.parse(count!)),
                });
              });
            } catch (error) {
              print(error);
            }
            Navigator.of(context).pop(true);
          },
          child: const Text(
            "Add",
            style: TextStyle(
              color: Color.fromRGBO(245, 115, 40, 1),
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  ).then((result) {
    if (result == true) {
      handleExit();
    }
  });
}
