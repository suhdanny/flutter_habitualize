import 'dart:ui';

import 'package:flutter/material.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({
    required this.dailyTracks,
    required this.weeklyTrack,
    required this.updateDayTrack,
    required this.updateWeekTrack,
    required this.handleDailySelect,
    required this.handleWeeklySelect,
    required this.dailySelected,
    required this.weeklySelected,
    super.key,
  });

  final Map<String, bool> dailyTracks;
  final String weeklyTrack;
  final Function updateDayTrack;
  final Function updateWeekTrack;
  final VoidCallback handleDailySelect;
  final VoidCallback handleWeeklySelect;
  final bool dailySelected;
  final bool weeklySelected;

  Widget dayContainer(String day, String dayText) {
    return GestureDetector(
      onTap: () {
        updateDayTrack(day);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: dailyTracks[day] == true
              ? Color.fromRGBO(244, 199, 171, 1)
              : Color.fromRGBO(223, 223, 223, 1),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            dayText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget weekContainer(String day, String dayText) {
    return GestureDetector(
      onTap: () {
        updateWeekTrack(day);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: weeklyTrack == day
              ? Color.fromRGBO(244, 199, 171, 1)
              : Color.fromRGBO(223, 223, 223, 1),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            dayText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                      ? Color.fromRGBO(244, 199, 171, 1)
                      : Color.fromRGBO(223, 223, 223, 1),
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
                      ? Color.fromRGBO(244, 199, 171, 1)
                      : Color.fromRGBO(223, 223, 223, 1),
                ),
                child: const Text("Weekly"),
              ),
            ),
          ],
        ),
        if (dailySelected)
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dayContainer('Mon', 'M'),
                const SizedBox(width: 5),
                dayContainer('Tue', 'T'),
                const SizedBox(width: 5),
                dayContainer('Wed', 'W'),
                const SizedBox(width: 5),
                dayContainer('Thu', 'T'),
                const SizedBox(width: 5),
                dayContainer('Fri', 'F'),
                const SizedBox(width: 5),
                dayContainer('Sat', 'S'),
                const SizedBox(width: 5),
                dayContainer('Sun', 'S'),
              ],
            ),
          ),
        if (weeklySelected)
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                weekContainer('Mon', 'M'),
                const SizedBox(width: 5),
                weekContainer('Tue', 'T'),
                const SizedBox(width: 5),
                weekContainer('Wed', 'W'),
                const SizedBox(width: 5),
                weekContainer('Thu', 'T'),
                const SizedBox(width: 5),
                weekContainer('Fri', 'F'),
                const SizedBox(width: 5),
                weekContainer('Sat', 'S'),
                const SizedBox(width: 5),
                weekContainer('Sun', 'S'),
              ],
            ),
          ),
      ],
    );
  }
}
