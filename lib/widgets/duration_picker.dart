import 'dart:ui';

import 'package:flutter/material.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({
    required this.handleDailySelect,
    required this.handleWeeklySelect,
    required this.dailySelected,
    required this.weeklySelected,
    super.key,
  });

  final VoidCallback handleDailySelect;
  final VoidCallback handleWeeklySelect;
  final bool dailySelected;
  final bool weeklySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: ElevatedButton(
            onPressed: handleDailySelect,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              textStyle: TextStyle(
                  fontSize: 14,
                  color: !dailySelected
                      ? Colors.white
                      : Color.fromRGBO(87, 111, 114, 1)),
              backgroundColor: dailySelected
                  ? Color.fromRGBO(87, 111, 114, 1)
                  : Color.fromRGBO(228, 220, 207, 1),
            ),
            child: const Text(
              "Daily",
              style: TextStyle(),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: ElevatedButton(
            onPressed: handleWeeklySelect,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              textStyle: TextStyle(
                  fontSize: 14,
                  color: !weeklySelected
                      ? Color.fromRGBO(87, 111, 114, 1)
                      : Colors.white),
              backgroundColor: weeklySelected
                  ? Color.fromRGBO(87, 111, 114, 1)
                  : Color.fromRGBO(228, 220, 207, 1),
            ),
            child: const Text("Weekly"),
          ),
        ),
      ],
    );
  }
}
