import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import '../screens/add_habit_screen.dart';
import '../services/delete_habit.dart';
import '../services/edit_habit.dart';
import '../services/add_count.dart';
import '../services/add_note.dart';

class CalendarList extends StatefulWidget {
  const CalendarList({
    required this.docId,
    required this.emoji,
    required this.title,
    required this.count,
    required this.countUnit,
    required this.duration,
    required this.dailyTracks,
    required this.weeklyTrack,
    required this.streaks,
    required this.bestStreak,
    required this.completed,
    required this.selectedDateString,
    required this.selectedDateTime,
    required this.isAfterToday,
    required this.totalCount,
    super.key,
  });

  final String docId;
  final String emoji;
  final String title;
  final int count;
  final String countUnit;
  final String duration;
  final Map<String, bool>? dailyTracks;
  final String? weeklyTrack;
  final int streaks;
  final int bestStreak;
  final String completed;
  final String selectedDateString;
  final DateTime selectedDateTime;
  final bool isAfterToday;
  final int totalCount;

  @override
  State<CalendarList> createState() => _CalendarListState();
}

class _CalendarListState extends State<CalendarList> {
  String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/habit-details',
          arguments: {
            'docId': widget.docId,
            'title': widget.title,
            'icon': widget.emoji,
            'streaks': widget.streaks,
            'bestStreaks': widget.bestStreak,
            'completed': widget.completed,
            'selectedDateTime': widget.selectedDateTime,
            'totalCount': widget.totalCount,
            'count': widget.count,
            'countUnit': widget.countUnit,
            'dailyTracks': widget.dailyTracks,
            'weeklyTrack': widget.weeklyTrack,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        child: Slidable(
          key: const ValueKey(0),
          startActionPane: ActionPane(
            extentRatio: 0.4,
            motion: const DrawerMotion(),
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => deleteHabit(
                        context, userUid, widget.docId, widget.title),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                        alignment: Alignment.center,
                        width: 24 * 4, // space for actionPan
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          color: Color.fromRGBO(253, 21, 27, 1),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              SlidableAction(
                onPressed: (ctx) => editHabit(
                  context,
                  widget.docId,
                  widget.title,
                  widget.emoji,
                  widget.count,
                  widget.countUnit,
                  widget.duration,
                  widget.dailyTracks,
                  widget.weeklyTrack,
                ),
                icon: Icons.edit,
                backgroundColor: Color.fromRGBO(255, 179, 15, 1),
                foregroundColor: Colors.white,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.4,
            children: [
              SlidableAction(
                onPressed: (ctx) => addCount(
                  context,
                  userUid,
                  widget.docId,
                  widget.selectedDateString,
                  widget.isAfterToday,
                  widget.count,
                ),
                icon: Icons.more_time,
                backgroundColor: Color.fromRGBO(132, 147, 36, 1),
                foregroundColor: Colors.white,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      addNote(context, userUid, widget.docId,
                          widget.selectedDateString);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      alignment: Alignment.center,
                      width: 24 * 4, // space for actionPan
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Color.fromRGBO(67, 127, 151, 1),
                      ),
                      child: const Icon(
                        IconData(0xf417,
                            fontFamily: iconFont, fontPackage: iconFontPackage),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            child: ListTile(
              leading: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 40),
              ),
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              trailing: Container(
                width: 90,
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(
                      '${widget.streaks} 🔥',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.completed,
                      style: TextStyle(
                          fontSize: 15,
                          color: widget.completed == 'completed!'
                              ? Color.fromRGBO(54, 126, 24, 1)
                              : Colors.grey[600]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
