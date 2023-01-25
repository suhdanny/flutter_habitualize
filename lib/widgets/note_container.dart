import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteContainer extends StatelessWidget {
  NoteContainer({
    required this.day,
    required this.month,
    required this.note,
    super.key,
  });

  final String day;
  final String month;
  final String note;

  List<Color> colorsList = [
    Color.fromRGBO(203, 228, 249, 1),
    Color.fromRGBO(239, 249, 218, 1),
    // Color.fromRGBO(255, 88, 68, 1),
    Color.fromRGBO(247, 215, 140, 1),
    Color.fromRGBO(249, 235, 223, 1),
    Color.fromRGBO(166, 211, 242, 1),
    Color.fromRGBO(249, 216, 214, 1),
    Color.fromRGBO(214, 205, 234, 1),
    Color.fromRGBO(175, 195, 168, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorsList[Random().nextInt(7)],
            ),
            child: Text(
              '$day \n $month',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            constraints: BoxConstraints(minHeight: 50),
            width: 250,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    note,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
