import 'dart:ui';

import 'package:flutter/material.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                onPressed: () {
                  pickIcon();
                },
                child: const Text("Choose Your Icon"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                onPressed: iconData != null ? openMainColorPicker : null,
                child: const Text("Choose Icon Color"),
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 130,
            child: FittedBox(
              child: Icon(
                iconData,
                color: mainColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
