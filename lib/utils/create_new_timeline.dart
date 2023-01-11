import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../utils/get_weekday_string.dart';

void createNewTimeline(date) async {
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  final snapshot = await FirebaseFirestore.instance
      .collection('users/$userUid/habits')
      .get();
  for (var doc in snapshot.docs) {
    final data = doc.data();

    bool isTracked = false;
    if (data['duration'] == 'day') {
      final dailyTracks = Map<String, bool>.from(data['dailyTracks']);
      if (dailyTracks[getWeekdayString(date)] == true) {
        isTracked = true;
      }
    } else {
      final weekTracks = data['weekTrack'];
      if (weekTracks == getWeekdayString(date)) {
        isTracked = true;
      }
    }

    String selectedDate = DateFormat('yyyy-MM-dd').format(date);
    Map<String, dynamic> timeline = data['timeline'];

    if (!timeline.containsKey(selectedDate) && isTracked) {
      await doc.reference.update({
        "timeline.$selectedDate": {
          "completed": false,
          "dayCount": 0,
        }
      });
    }
  }
}
