import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StreakHeatMap extends StatelessWidget {
  StreakHeatMap({super.key});

  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Color.fromRGBO(249, 235, 227, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 17.0),
            child: Text(
              "Statistics",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users/$userUid/habits')
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data!.docs;

              // completedCount has date string (ex. '2021-01-01') as key and
              // count value calculated as # of habits completed / total # of habits
              Map<String, int> completedCount = {};

              docs.forEach((doc) {
                final timelineData =
                    doc.data()['timeline'] as Map<String, dynamic>;
                timelineData.forEach((date, data) {
                  if (completedCount.containsKey(date)) {
                    completedCount.update(date, (value) {
                      return data['completed'] ? value + 1 : value;
                    });
                  } else {
                    completedCount[date] = data['completed'] ? 1 : 0;
                  }
                });
              });

              Map<DateTime, int> dataset = {};

              // populate dataset map as DateTime object as key and the corresponding shade
              // values based on percentage
              completedCount.forEach((date, count) {
                double percentage = count / docs.length;
                int shade;

                if (percentage >= 0.0 && percentage < 0.2) {
                  shade = 1;
                } else if (percentage >= 0.2 && percentage < 0.4) {
                  shade = 2;
                } else if (percentage >= 0.4 && percentage < 0.6) {
                  shade = 3;
                } else if (percentage >= 0.6 && percentage < 0.8) {
                  shade = 4;
                } else {
                  shade = 5;
                }

                DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                DateTime dateTime = dateFormat.parse(date);

                dataset[dateTime] = shade;
              });

              return FutureBuilder(
                future: FirebaseFirestore.instance.doc('users/$userUid').get(),
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  String startDate = snapshot.data!.data()!['startDate'];

                  DateTime startDateTime =
                      DateFormat('yyy-MM-dd').parse(startDate);
                  int difference =
                      DateTime.now().difference(startDateTime).inDays;
                  DateTime endDateTime =
                      DateTime.now().add(Duration(days: 79 - difference));

                  if (difference > 36) {
                    startDateTime = DateTime.now().subtract(Duration(days: 39));
                    endDateTime = DateTime.now().add(Duration(days: 41));
                  }

                  return HeatMap(
                    startDate: startDateTime,
                    endDate: endDateTime,
                    datasets: dataset,
                    size: 18,
                    colorMode: ColorMode.color,
                    scrollable: true,
                    showText: false,
                    colorsets: const {
                      1: Colors.white,
                      2: Color.fromARGB(50, 204, 54, 54),
                      3: Color.fromARGB(100, 204, 54, 54),
                      4: Color.fromARGB(150, 204, 54, 54),
                      5: Color.fromARGB(225, 204, 54, 54),
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
