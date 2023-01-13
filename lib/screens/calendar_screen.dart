import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/habit_list_tile.dart';
import '../widgets/calendar_list.dart';
import '../utils/create_new_timeline.dart';
import '../utils/is_after_today.dart';
import '../utils/get_weekday_string.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: ListTile(
              title: const Text(
                "Today is",
                style: TextStyle(
                  color: Color.fromRGBO(87, 111, 114, 1),
                  fontSize: 23,
                  fontWeight: FontWeight.w300,
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 5),
                child: Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: const TextStyle(
                    color: Color.fromRGBO(87, 111, 114, 1),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(228, 220, 207, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: TableCalendar(
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    onDaySelected: ((selectDay, focusDay) async {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                        createNewTimeline(selectDay);
                      });
                    }),
                    onFormatChanged: (CalendarFormat calendarFormat) {
                      setState(() {
                        format = calendarFormat;
                      });
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDay, day);
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,
                    calendarStyle: const CalendarStyle(
                      isTodayHighlighted: false,
                      selectedDecoration: BoxDecoration(
                        color: Color.fromRGBO(87, 111, 114, 1),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      // todayDecoration: BoxDecoration(
                      //     // color: Color.fromRGBO(87, 111, 114, 1),
                      //     shape: BoxShape.circle),
                    ),
                    headerVisible: true,
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      headerMargin: const EdgeInsets.only(bottom: 10),
                      formatButtonVisible: false,
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(125, 157, 156, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                          child: const Text(
                            "All Habits",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users/$userUid/habits')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final docs = snapshot.data!.docs;

                            final children = <Widget>[];

                            String selectedDateString =
                                DateFormat('yyyy-MM-dd').format(selectedDay);
                            bool isAfterToday = isDateAfterToday(selectedDay);

                            docs.forEach((doc) {
                              final data = doc.data();
                              bool display = false;
                              bool completed =
                                  data['timeline'][selectedDateString] == null
                                      ? false
                                      : data['timeline'][selectedDateString]
                                          ['completed'];

                              Map<String, bool>? dailyTracks;
                              String? weeklyTrack;

                              if (data['dailyTracks'] != null) {
                                dailyTracks =
                                    Map<String, bool>.from(data['dailyTracks']);
                              }
                              if (data['weeklyTrack'] != null) {
                                weeklyTrack = data['weeklyTrack'];
                              }

                              if (data['duration'] == 'day') {
                                final dailyTracks =
                                    Map<String, bool>.from(data['dailyTracks']);
                                if (dailyTracks[
                                        getWeekdayString(selectedDay)] ==
                                    true) {
                                  display = true;
                                }
                              } else {
                                final weeklyTrack = data['weeklyTrack'];
                                if (weeklyTrack ==
                                    getWeekdayString(selectedDay)) {
                                  display = true;
                                }
                              }

                              if (display) {
                                children.add(CalendarList(
                                  docId: doc.id,
                                  emoji: data['icon'],
                                  title: data['title'],
                                  count: data['count'],
                                  countUnit: data['countUnit'],
                                  duration: data['duration'],
                                  dailyTracks: dailyTracks,
                                  weeklyTrack: weeklyTrack,
                                  streaks: data['streaks'],
                                  completed:
                                      completed ? 'completed!' : 'uncompleted',
                                  selectedDateString: selectedDateString,
                                  isAfterToday: isAfterToday,
                                ));
                              }
                            });

                            return Expanded(
                              child: children.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.only(bottom: 80),
                                      child: Center(
                                        child: Text(
                                          "You have no challenges! 😄",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 120),
                                      children: children,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
