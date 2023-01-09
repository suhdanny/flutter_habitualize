import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';

class HabitEmojiPicker extends StatefulWidget {
  HabitEmojiPicker({
    required this.selectedEmoji,
    required this.updateSelectedEmoji,
    super.key,
  });

  String? selectedEmoji;
  Function updateSelectedEmoji;

  @override
  State<HabitEmojiPicker> createState() => _HabitEmojiPickerState();
}

class _HabitEmojiPickerState extends State<HabitEmojiPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // pickIcon();
              showDialog(
                context: context,
                builder: (context) {
                  String? tempEmoji = widget.selectedEmoji ?? null;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text(
                            "Choose Your Icon  ${tempEmoji != null ? tempEmoji! : ''}"),
                        backgroundColor: const Color(0xFFF2F2F2),
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  // fontSize: 20,
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.updateSelectedEmoji(tempEmoji);
                              Navigator.pop(context, 'Confirm');
                            },
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                  // fontSize: 20,
                                  ),
                            ),
                          ),
                        ],
                        content: SizedBox(
                          height: 200,
                          width: 350,
                          child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              setState(() {
                                tempEmoji = emoji.emoji;
                              });
                            },
                            config: const Config(
                              columns: 7,
                              bgColor: Color(0xFFF2F2F2),
                              indicatorColor: Color.fromRGBO(125, 157, 156, 1),
                              iconColorSelected:
                                  Color.fromRGBO(125, 157, 156, 1),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
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
                Text(
                  widget.selectedEmoji == null
                      ? "Choose Icon"
                      : widget.selectedEmoji!,
                  style: TextStyle(
                    fontSize: widget.selectedEmoji == null ? 15 : 30,
                    color: Color.fromARGB(255, 87, 85, 85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
