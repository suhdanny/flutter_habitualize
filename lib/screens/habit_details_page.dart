import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../widgets/note_container.dart';
import '../services/delete_habit.dart';
import '../services/edit_habit.dart';
import '../services/add_count.dart';
import '../services/add_note.dart';
import '../utils/is_after_today.dart';
import '../utils/sort_timeline_by_date.dart';

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
    DateTime selectedDateTime = args['selectedDateTime'];
    String selectedDateString =
        DateFormat('yyyy-MM-dd').format(selectedDateTime);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                  margin: const EdgeInsets.only(top: 30),
                  child: PopupMenuButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    )),
                    position: PopupMenuPosition.under,
                    onSelected: (result) {
                      if (result == 0) {
                        editHabit(
                          context,
                          args['docId'],
                          args['title'],
                          args['icon'],
                          args['count'],
                          args['countUnit'],
                          args['duration'],
                          args['dailyTracks'],
                          args['weeklyTrack'],
                        );
                      }
                      if (result == 1) {
                        bool isAfterToday = isDateAfterToday(selectedDateTime);
                        addCount(
                          context,
                          userUid,
                          args['docId'],
                          selectedDateString,
                          isAfterToday,
                          args['count'],
                          () => Navigator.of(context).pop(),
                        );
                      }
                      if (result == 2) {
                        addNote(
                          context,
                          userUid,
                          args['docId'],
                          selectedDateString,
                        );
                      }
                      if (result == 3) {
                        deleteHabit(
                          context,
                          userUid,
                          args['docId'],
                          args['title'],
                        );
                      }
                    },
                    itemBuilder: ((_) => [
                          const PopupMenuItem(
                            value: 0,
                            child: Text(
                              "✍🏻 Edit",
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 1,
                            child: Text(
                              "🔄 Update Progress",
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Text(
                              "📝 Take Notes",
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 3,
                            child: Text(
                              "🗑 Delete",
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  args['icon'],
                  style: const TextStyle(
                    fontSize: 84,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  args['title'],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 40),
                // const SizedBox(height: 20),
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(223, 223, 223, 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Current Streaks",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            args['streaks'].toString(),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Best Streaks",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            args['bestStreaks'].toString(),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Total Count",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                args['totalCount'].toString(),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                args['countUnit'],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                          final dayString =
                              DateFormat('yyyy-MM-dd').format(day);

                          if (timeline.containsKey(dayString) &&
                              !isDateAfterToday(day)) {
                            final completed = timeline[dayString]['completed'];
                            if (completed) {
                              // return Container(
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(50),
                              //     color: Colors.green,
                              //   ),
                              //   width: 5,
                              //   height: 5,
                              // );
                              return const Icon(
                                Icons.done,
                                color: Colors.green,
                                size: 10,
                              );
                            } else {
                              return const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 10,
                              );
                            }
                          }
                        },
                      ),
                      calendarStyle: const CalendarStyle(
                        // markerDecoration: BoxDecoration(shape: BoxShape.circle),
                        isTodayHighlighted: false,
                        selectedDecoration: BoxDecoration(
                          color: Color.fromRGBO(223, 223, 223, 1),
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
                        titleTextStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    );
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15, left: 5),
                    child: const Text(
                      "Notes",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .doc('users/$userUid/habits/${args['docId']}')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final data = snapshot.data!.data();
                      final sortedTimeline =
                          sortTimelineByDate(data!['timeline']);

                      final children = <Widget>[];
                      sortedTimeline.forEach((date, value) {
                        if (value.containsKey('note')) {
                          final parsedDate =
                              DateFormat('yyyy-MM-dd').parse(date);

                          children.add(GestureDetector(
                            onTap: () => addNote(
                              context,
                              userUid,
                              args['docId'],
                              date,
                            ),
                            child: NoteContainer(
                              day: parsedDate.day.toString(),
                              month: DateFormat.MMM().format(parsedDate),
                              note: value['note'],
                            ),
                          ));
                        }
                      });

                      return children.isEmpty
                          ? Container(
                              child: Text("You have no notes!"),
                            )
                          : Container(
                              height: 200,
                              child: ListView(
                                padding: const EdgeInsets.only(top: 5),
                                children: children,
                              ),
                            );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
