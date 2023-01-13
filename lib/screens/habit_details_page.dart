import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitDetailsPage extends StatefulWidget {
  const HabitDetailsPage({super.key});

  @override
  State<HabitDetailsPage> createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    CalendarFormat format = CalendarFormat.month;
    DateTime today = DateTime.now();
    DateTime focusedDay = DateTime.now();

    void _onDaySelected(DateTime day, DateTime focusedDay) {
      setState(() {
        today = day;
      });
    }

    return Scaffold(
      body: Container(
        child: Column(
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
                icon: Icon(
                  IconData(0xf4fd,
                      fontFamily: iconFont, fontPackage: iconFontPackage),
                ),
              ),
            ),

            // Title Secion
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
              child: TableCalendar(
                focusedDay: today,
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                calendarFormat: format,
                calendarBuilders: CalendarBuilders(
                  singleMarkerBuilder: (context, date, event) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      width: 7,
                      height: 7,
                    );
                  },
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (CalendarFormat calendarFormat) {
                  setState(() {
                    format = calendarFormat;
                  });
                },
                selectedDayPredicate: (day) {
                  return isSameDay(day, today);
                },
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
                    headerPadding: const EdgeInsets.all(15)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Scaffold(
//       body: Container(
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.only(top: 80),
//               child: Text(
//                 "'habit title'",
//                 style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w300,
//                     color: Colors.black),
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Container(
//               padding: const EdgeInsets.all(15),
//               child: Text(
//                 "streak number",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               child: Text(
//                 "streaks",
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
