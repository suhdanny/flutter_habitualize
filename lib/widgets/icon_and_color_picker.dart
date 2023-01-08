import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class IconAndColorPicker extends StatelessWidget {
  const IconAndColorPicker({
    required this.pickIcon,
    required this.openMainColorPicker,
    required this.iconData,
    required this.mainColor,
    super.key,
  });

  final Function pickIcon;
  final VoidCallback openMainColorPicker;
  final IconData? iconData;
  final Color? mainColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              pickIcon();
            },
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.directions_run)),
                  SizedBox(width: 10),
                  const Text(
                    "Icon",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.red),
                  SizedBox(width: 10),
                  const Text(
                    "Color",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
