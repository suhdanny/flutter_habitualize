import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';

class CalendarList extends StatelessWidget {
  const CalendarList(
      {required this.icon,
      required this.title,
      required this.completed,
      super.key});

  final IconData icon;
  final String title;
  final bool completed;

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
        title: Text(title),
        trailing: Icon(
          IconData(0xf3fe, fontFamily: iconFont, fontPackage: iconFontPackage),
          size: 30,
          color: completed ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}
