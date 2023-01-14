import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteContainer extends StatelessWidget {
  const NoteContainer({
    required this.day,
    required this.month,
    required this.note,
    super.key,
  });

  final String day;
  final String month;
  final String note;

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
              color: const Color.fromRGBO(223, 223, 223, 1),
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
