import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/habit_grid_tile.dart';
import '../widgets/home_calendar.dart';
import '../widgets/streak_heat_map.dart';

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
        padding: const EdgeInsets.only(top: 40.0, left: 8, right: 8, bottom: 8),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
                selectionColor: Colors.black,
              ),
              subtitle: Text(
                '${FirebaseAuth.instance.currentUser!.displayName!}',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
                selectionColor: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
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
                  fontWeight: FontWeight.w400,
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
                return Padding(
                  padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (ctx, idx) {
                      Map<String, dynamic> data =
                          snapshot.data!.docs[idx].data();
                      String selectedDate =
                          DateFormat('yyyy-MM-dd').format(_selectedDateTime);
                      Map<String, dynamic>? timelineData =
                          data['timeline'][selectedDate];
                      int dayCount =
                          timelineData == null ? 0 : timelineData['dayCount'];
                      bool completed = timelineData == null
                          ? false
                          : timelineData['completed'];

                      return HabitGridTile(
                        docId: snapshot.data!.docs[idx].id,
                        icon: data['icon'],
                        title: data['title'],
                        count: data['count'],
                        countUnit: data['countUnit'],
                        dayCount: dayCount,
                        duration: data['duration'],
                        streaks: data['streaks'],
                        completed: completed,
                        selectedDateTime: _selectedDateTime,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
              stream: FirebaseFirestore.instance
                  .collection('/users/$userUid/habits')
                  .snapshots(),
            ),
            StreakHeatMap(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
