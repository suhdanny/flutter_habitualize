import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/habit_grid_tile.dart';
import '../widgets/home_calendar.dart';

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
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
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
            Expanded(
              child: StreamBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (ctx, idx) {
                        Map<String, dynamic> data =
                            snapshot.data!.docs[idx].data();
                        String selectedDate =
                            DateFormat('yyyy-MM-dd').format(_selectedDateTime);
                        int codePoint = int.parse(
                            data['icon'].split('U+')[1].split(')')[0],
                            radix: 16);
                        IconData icon =
                            IconData(codePoint, fontFamily: "MaterialIcons");
                        Color iconColor =
                            Color(int.parse(data['iconColor'], radix: 16));
                        Map<String, dynamic>? timelineData =
                            data['timeline'][selectedDate];
                        int dayCount =
                            timelineData == null ? 0 : timelineData['dayCount'];
                        bool completed = timelineData == null
                            ? false
                            : timelineData['completed'];

                        return HabitGridTile(
                          docId: snapshot.data!.docs[idx].id,
                          icon: icon,
                          iconColor: iconColor,
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
            ),
          ],
        ),
      ),
    );
  }
}
