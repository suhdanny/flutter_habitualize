import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import '../widgets/habit_grid_tile.dart';
import '../widgets/home_calendar.dart';
import '../widgets/streak_heat_map.dart';
import '../utils/get_weekday_string.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
  DateTime _selectedDateTime = DateTime.now();

  void _updateSelectedDateTime(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });
  }

  String get greetingText {
    int hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return 'Good morning 👋🏻';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon 😊';
    } else if (hour >= 18 && hour < 21) {
      return 'Good evening 🌅';
    }
    return 'Good Night 🥱';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 8, right: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser!.photoURL!,
                ),
              ),
              title: Text(
                '$greetingText, ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                selectionColor: Colors.black,
              ),
              subtitle: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .doc('/users/$userUid')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final data = snapshot.data!.data();
                    String userName =
                        FirebaseAuth.instance.currentUser!.displayName!;

                    if (data!.containsKey("userName")) {
                      userName = data["userName"];
                    }

                    return Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      selectionColor: Colors.black,
                    );
                  }),
            ),
            const SizedBox(height: 10),
            HomeCalendar(
              updatedSelectedDateTime: _updateSelectedDateTime,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 17.0),
              child: Text(
                "Today's Challenge",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final children = <Widget>[];

                snapshot.data!.docs.forEachIndexed((idx, doc) {
                  Map<String, dynamic> data = doc.data();
                  String selectedDate =
                      DateFormat('yyyy-MM-dd').format(_selectedDateTime);
                  Map<String, dynamic>? timelineData =
                      data['timeline'][selectedDate];
                  int dayCount =
                      timelineData == null ? 0 : timelineData['dayCount'];
                  bool completed =
                      timelineData == null ? false : timelineData['completed'];
                  Map<String, bool>? dailyTracks;
                  String? weeklyTrack;

                  if (data['dailyTracks'] != null) {
                    dailyTracks = Map<String, bool>.from(data['dailyTracks']);
                  }
                  if (data['weeklyTrack'] != null) {
                    weeklyTrack = data['weeklyTrack'];
                  }

                  bool display = false;

                  if (data['duration'] == 'day') {
                    if (dailyTracks![getWeekdayString(_selectedDateTime)] ==
                        true) {
                      display = true;
                    }
                  } else {
                    if (weeklyTrack == getWeekdayString(_selectedDateTime)) {
                      display = true;
                    }
                  }

                  if (display) {
                    children.add(HabitGridTile(
                      docId: doc.id,
                      idx: idx,
                      icon: data['icon'],
                      title: data['title'],
                      count: data['count'],
                      countUnit: data['countUnit'],
                      dayCount: dayCount,
                      duration: data['duration'],
                      streaks: data['streaks'],
                      completed: completed,
                      selectedDateTime: _selectedDateTime,
                      bestStreaks: data['bestStreak'],
                      dailyTracks: dailyTracks,
                      weeklyTrack: weeklyTrack,
                      totalCount: data['totalCount'],
                    ));
                  }
                });

                return Padding(
                  padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
                  child: children.isEmpty
                      ? const SizedBox(
                          height: 175,
                          child: Center(
                            child: Text(
                              "You have no challenges! 😄",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 1.0,
                          children: children,
                        ),
                );
              },
              stream: FirebaseFirestore.instance
                  .collection('/users/$userUid/habits')
                  .snapshots(),
            ),
            Container(
              // padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.fromLTRB(25, 18, 0, 5),
              child: const Text(
                "Analytics",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            StreakHeatMap(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
