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
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
        margin: const EdgeInsets.all(13),
        decoration: const BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Color.fromRGBO(249, 216, 214, 1),
          //     spreadRadius: 5,
          //     blurRadius: 10,
          //     offset: Offset(4, 5), // changes position of shadow
          //   ),
          // ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // border: Border.all(color: Colors.grey.withOpacity(0.5))
          // color: Colors.grey.withOpacity(0.5),
          color: Color.fromRGBO(223, 223, 223, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(left: 17.0),
            //   child: Text(
            //     "Statistics",
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
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

                // habitTrackCount has date string as key and count value calulated as how
                // many habits are tracked in a certain date
                Map<String, int> habitTrackCount = {};

                docs.forEach((doc) {
                  final timelineData =
                      doc.data()['timeline'] as Map<String, dynamic>;
                  timelineData.forEach((date, data) {
                    if (completedCount.containsKey(date)) {
                      completedCount.update(date, (value) {
                        return data['completed'] ? value + 1 : value;
                      });
                      habitTrackCount.update(date, (value) => value + 1);
                    } else {
                      completedCount[date] = data['completed'] ? 1 : 0;
                      habitTrackCount[date] = 1;
                    }
                  });
                });

                Map<DateTime, int> dataset = {};

                // populate dataset map as DateTime object as key and the corresponding shade
                // values based on percentage
                completedCount.forEach((date, count) {
                  double percentage = count / habitTrackCount[date]!;
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
                  future:
                      FirebaseFirestore.instance.doc('users/$userUid').get(),
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
                        DateTime.now().add(Duration(days: 39 - difference));

                    if (difference > 36) {
                      startDateTime =
                          DateTime.now().subtract(Duration(days: 39));
                      endDateTime = DateTime.now().add(Duration(days: 30));
                    }

                    return HeatMap(
                      startDate: startDateTime.subtract(Duration(days: 20)),
                      endDate: endDateTime,
                      datasets: dataset,
                      size: 21,
                      colorMode: ColorMode.color,
                      showColorTip: false,
                      scrollable: true,
                      showText: false,
                      colorsets: const {
                        1: Colors.white,
                        2: Color.fromRGBO(255, 88, 68, 0.4),
                        3: Color.fromRGBO(255, 88, 68, 0.6),
                        4: Color.fromRGBO(255, 88, 68, 0.8),
                        5: Color.fromRGBO(255, 88, 68, 1),
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
