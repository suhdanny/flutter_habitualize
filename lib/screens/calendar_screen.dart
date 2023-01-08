import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/habit_list_tile.dart';
import '../widgets/calendar_list.dart';
import '../utils/create_new_timeline.dart';

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

  TextEditingController _eventController = TextEditingController();

  // @override
  // void initState() {
  //   selectedEvents = {};
  //   super.initState();
  // }

  // List<Event> _getEventsfromDay(DateTime date) {
  //   return selectedEvents[date] ?? [];
  // }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(25.0),
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
                  style: TextStyle(
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
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      headerMargin: const EdgeInsets.only(bottom: 10),
                      formatButtonVisible: false,
                      formatButtonTextStyle: const TextStyle(
                        color: Color.fromRGBO(87, 111, 114, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      formatButtonDecoration: BoxDecoration(
                        color: Color.fromRGBO(228, 220, 207, 1),
                        border: Border.all(
                            width: 0.0,
                            color: Color.fromRGBO(228, 220, 207, 1)),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
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
                          topRight: Radius.circular(40)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                          child: const Text(
                            "All Habits",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users/$userUid/habits')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
                            final docs = snapshot.data!.docs;
                            String selectedDateString =
                                DateFormat('yyyy-MM-dd').format(selectedDay);

                            return Expanded(
                              child: Container(
                                child: ListView.builder(
                                  itemBuilder: (ctx, idx) {
                                    final data = docs[idx].data();
                                    int codePoint = int.parse(
                                        data['icon']
                                            .split('U+')[1]
                                            .split(')')[0],
                                        radix: 16);
                                    IconData icon = IconData(codePoint,
                                        fontFamily: "MaterialIcons");
                                    bool completed = data['timeline']
                                                [selectedDateString] ==
                                            null
                                        ? false
                                        : data['timeline'][selectedDateString]
                                            ['completed'];

                                    return CalendarList(
                                      icon: icon,
                                      title: data['title'],
                                      streaks: data['streaks'],
                                      completed: completed
                                          ? 'completed!'
                                          : 'uncompleted!',
                                    );
                                  },
                                  itemCount: docs.length,
                                ),
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


//                 final snapshot = await FirebaseFirestore.instance
//                     .collection('users/$userUid/habits')
//                     .get();



