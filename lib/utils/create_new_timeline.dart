import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final userUid = FirebaseAuth.instance.currentUser!.uid;

void createNewTimeline(date) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users/$userUid/habits')
      .get();
  for (var doc in snapshot.docs) {
    final data = doc.data();
    String selectedDate = DateFormat('yyyy-MM-dd').format(date);
    Map<String, dynamic> timeline = data['timeline'];

    if (!timeline.containsKey(selectedDate)) {
      await doc.reference.update({
        "timeline.$selectedDate": {
          "completed": false,
          "dayCount": 0,
        }
      });
    }
  }
}
