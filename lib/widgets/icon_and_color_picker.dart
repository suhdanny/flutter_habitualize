import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';

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
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                          IconData(
                            0xf48a,
                            fontFamily: iconFont,
                            fontPackage: iconFontPackage,
                          ),
                          color: Colors.black)),
                  SizedBox(width: 7),
                  const Text(
                    "Choose Icon",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 87, 85, 85),
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
