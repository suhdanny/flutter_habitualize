import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({super.key});

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      height: 100,
      width: 80,
      initialSelectedDate: DateTime.now(),
      selectionColor: Color.fromRGBO(54, 174, 124, 1),
      selectedTextColor: Colors.white,
      monthTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      dateTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      dayTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onDateChange: (date) {
        print(date);
      },
    );
  }
}
