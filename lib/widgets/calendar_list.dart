import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';

class CalendarList extends StatelessWidget {
  const CalendarList({
    required this.icon,
    required this.title,
    required this.streaks,
    required this.completed,
    super.key,
  });

  final IconData icon;
  final String title;
  final int streaks;
  final String completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Container(
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Text('${streaks} 🔥'),
                Text(
                  completed,
                  style: TextStyle(
                      fontSize: 12,
                      color: completed == 'completed!'
                          ? Color.fromRGBO(54, 126, 24, 1)
                          : Color.fromRGBO(204, 54, 54, 1)),
                )
              ],
            ),
          )),
    );
  }
}
