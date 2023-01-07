import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(29.0),
            child: ListTile(
              title: Text(
                "Today is",
                style: TextStyle(
                  color: Color.fromRGBO(87, 111, 114, 1),
                  fontSize: 23,
                  fontWeight: FontWeight.w300,
                ),
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: TextStyle(
                  color: Color.fromRGBO(87, 111, 114, 1),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
                onDateChanged: (date) {
                  selectedDate = date;
                }),
          )
        ],
      ),
    );
  }
}
