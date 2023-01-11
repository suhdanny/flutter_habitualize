import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/create_new_timeline.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({
    required this.updatedSelectedDateTime,
    super.key,
  });

  final Function updatedSelectedDateTime;

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  final _controller = DatePickerController();
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  bool _isInit = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.doc('users/$userUid').get(),
        builder: (ctx, snapshot) {
          if (snapshot.data == null) return const CircularProgressIndicator();

          final startDate = snapshot.data!['startDate'];
          DateTime calendarStartDate =
              DateFormat("yyyy-MM-dd").parse(startDate);
          int difference = DateTime.now().difference(calendarStartDate).inDays;

          if (difference > 14) {
            calendarStartDate =
                DateTime.now().subtract(const Duration(days: 14));
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_isInit) {
              _controller.animateToDate(
                DateTime.now(),
                duration: const Duration(milliseconds: 250),
              );
              _isInit = false;
            }
          });

          return Padding(
            padding: const EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
            child: DatePicker(
              calendarStartDate,
              controller: _controller,
              height: 90,
              width: 60,
              initialSelectedDate: DateTime.now(),
              selectionColor: Color.fromRGBO(125, 157, 156, 1),
              selectedTextColor: Colors.white,
              daysCount: 30,
              monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              dateTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onDateChange: (date) {
                createNewTimeline(date);
                widget.updatedSelectedDateTime(date);
              },
            ),
          );
        });
  }
}
