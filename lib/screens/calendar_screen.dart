import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          margin: const EdgeInsets.only(top: 35),
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: ListTile(
              title: const Text(
                "Today is",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 5),
                child: Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 15),
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
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: false,
                    todayTextStyle:
                        TextStyle(color: Color.fromRGBO(253, 21, 27, 1)),
                    selectedDecoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                      // color: Color.fromRGBO(147, 181, 198, 1),
                      color: Color.fromRGBO(223, 223, 223, 1),
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(7.0),
                      // borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    selectedTextStyle:
                        TextStyle(color: Colors.black.withOpacity(0.5)),
                    // todayDecoration: BoxDecoration(
                    //   // color: Color.fromRGBO(87, 111, 114, 1),
                    //   shape: BoxShape.rectangle,
                    //   borderRadius: BorderRadius.circular(7.0),
                    // ),
                  ),
                  headerVisible: true,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    headerMargin: EdgeInsets.only(bottom: 10),
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(147, 181, 198, 1),
                    color: Color.fromRGBO(223, 223, 223, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 20, 0, 6),
                        child: const Text(
                          "All Habits",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
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
                              if (dailyTracks[getWeekdayString(selectedDay)] ==
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
                                bestStreak: data['bestStreak'],
                                completed:
                                    completed ? 'completed!' : 'uncompleted',
                                selectedDateString: selectedDateString,
                                selectedDateTime: selectedDay,
                                isAfterToday: isAfterToday,
                                totalCount: data['totalCount'],
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
      ],
    );
  }
}
