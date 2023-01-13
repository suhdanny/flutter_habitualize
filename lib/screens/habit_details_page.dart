import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../utils/is_after_today.dart';

class HabitDetailsPage extends StatefulWidget {
  const HabitDetailsPage({super.key});

  @override
  State<HabitDetailsPage> createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  CalendarFormat format = CalendarFormat.month;
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // back-arrow Icon
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            margin: const EdgeInsets.only(top: 30),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                IconData(
                  0xf4fd,
                  fontFamily: iconFont,
                  fontPackage: iconFontPackage,
                ),
              ),
            ),
          ),
          Center(
              child: Column(
            children: [
              Text(
                args['icon'],
                style: TextStyle(
                  fontSize: 84,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                args['title'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Current Streaks",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        args['streaks'].toString(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Best Streaks",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        args['bestStreaks'].toString(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            ],
          )),
          Container(
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(20)),
            //     color: Color.fromRGBO(240, 235, 227, 1)),
            padding: const EdgeInsets.all(30),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users/$userUid/habits')
                    .doc(args['docId'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final data = snapshot.data!.data();
                  final timeline = data!['timeline'];

                  return TableCalendar(
                    focusedDay: today,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat calendarFormat) {
                      setState(() {
                        format = calendarFormat;
                      });
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(day, today);
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        final dayString = DateFormat('yyyy-MM-dd').format(day);

                        if (timeline.containsKey(dayString) &&
                            !isDateAfterToday(day)) {
                          final completed = timeline[dayString]['completed'];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: completed ? Colors.green : Colors.red,
                            ),
                            width: 7,
                            height: 7,
                          );
                        }
                      },
                    ),
                    calendarStyle: const CalendarStyle(
                      // markerDecoration: BoxDecoration(shape: BoxShape.circle),
                      isTodayHighlighted: false,
                      selectedDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      // todayDecoration: BoxDecoration(
                      //     // color: Color.fromRGBO(87, 111, 114, 1),
                      //     shape: BoxShape.circle),
                    ),
                    headerStyle: const HeaderStyle(
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      formatButtonVisible: false,
                      headerPadding: EdgeInsets.all(15),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
