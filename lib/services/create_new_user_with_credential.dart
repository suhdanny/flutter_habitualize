import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/format_date_to_string.dart';

createNewUserWithCredential(UserCredential userCredential) async {
  final user = await FirebaseFirestore.instance
      .doc('users/${userCredential.user!.uid}')
      .get();

  if (user.data() == null) {
    await FirebaseFirestore.instance
        .doc('users/${userCredential.user!.uid}')
        .set({
      "startDate": formatDateToString(DateTime.now()),
      "userName": userCredential.user!.displayName ??
          userCredential.user!.email?.split('@')[0],
    });

    await FirebaseFirestore.instance
        .collection('users/${userCredential.user!.uid}/habits')
        .add({
      "title": "Run Daily",
      "count": 1,
      "countUnit": "times",
      "duration": 'day',
      "dailyTracks": {
        'Mon': true,
        'Tue': true,
        'Wed': true,
        'Thu': true,
        'Fri': true,
        'Sat': true,
        'Sun': true,
      },
      "icon": '🏃',
      "streaks": 0,
      "timeline": {
        formatDateToString(DateTime.now()): {
          "completed": false,
          "dayCount": 0,
        }
      },
      "bestStreak": 0,
      "totalCount": 0,
    });
  }
}
