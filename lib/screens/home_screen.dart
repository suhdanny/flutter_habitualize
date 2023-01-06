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
      return 'Good morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
                '$greetingText, \n${FirebaseAuth.instance.currentUser!.displayName!}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
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
                  fontWeight: FontWeight.bold,
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
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
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

                      return HabitGridTile(
                        docId: snapshot.data!.docs[idx].id,
                        icon: icon,
                        iconColor: iconColor,
                        title: data['title'],
                        count: data['count'],
                        countUnit: data['countUnit'],
                        dayCount: data['timeline'][selectedDate]['dayCount'],
                        duration: data['duration'],
                        streaks: data['streaks'],
                        completed: data['timeline'][selectedDate]['completed'],
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
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
