import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../screens/add_habit_screen.dart';

void editHabit(
  BuildContext context,
  String docId,
  String title,
  String emoji,
  int count,
  String countUnit,
  String duration,
  Map<String, bool>? dailyTracks,
  String? weeklyTrack,
  bool popOnEdit,
) {
  showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    ),
    expand: false,
    isDismissible: false,
    enableDrag: false,
    context: context,
    builder: (context) {
      return AddHabitScreen(
        docId: docId,
        title: title,
        emoji: emoji,
        count: count,
        countUnit: countUnit,
        duration: duration,
        dailyTracks: dailyTracks,
        weeklyTrack: weeklyTrack,
      );
    },
  ).then((result) {
    if (result && popOnEdit) {
      Navigator.pop(context);
    }
  });
}
