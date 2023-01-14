import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addNote(
  BuildContext context,
  String userUid,
  String docId,
  String selectedDateString,
) async {
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchDocumentSnapshot() {
    return FirebaseFirestore.instance.doc('users/$userUid/habits/$docId').get();
  }

  final data = await fetchDocumentSnapshot();
  final docData = data.data();

  String? noteInput;
  final noteTextFieldController = TextEditingController();

  if (docData!['timeline'][selectedDateString].containsKey('note')) {
    noteInput = docData['timeline'][selectedDateString]['note'];
    noteTextFieldController.text = noteInput!;
  } else {
    noteTextFieldController.text = '';
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: const Text(
        "Add Note",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      content: TextField(
        controller: noteTextFieldController,
        minLines: 4,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: "Enter Note",
          hintStyle: const TextStyle(
            fontSize: 15,
          ),
        ),
        onChanged: (value) => noteInput = value,
      ),
      actions: [
        TextButton(
          onPressed: () {
            noteInput = null;
            Navigator.pop(context, 'Cancel');
          },
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
            if (noteInput == null || noteInput!.isEmpty) {
              return;
            }
            FirebaseFirestore.instance
                .doc('users/$userUid/habits/$docId')
                .update({
              'timeline.$selectedDateString.note': noteInput,
            });

            // noteInput = null;

            Navigator.pop(context, 'Save');
          },
          child: const Text(
            "Save",
            style: TextStyle(
              color: Color.fromRGBO(245, 115, 40, 1),
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
}
