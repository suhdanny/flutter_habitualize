import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/format_date_to_string.dart';

void createNewUser(String email, String username, String password) async {
  // create a new user with email and password
  final userCredential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  final user = userCredential.user;

  // add user document with id of user uid
  final userUid = user!.uid;
  await FirebaseFirestore.instance.doc('users/$userUid').set({
    "startDate": formatDateToString(DateTime.now()),
    "userName": username,
  });

  // add dummy habit
  await FirebaseFirestore.instance.collection('users/$userUid/habits').add({
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
