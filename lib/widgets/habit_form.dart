import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import '../widgets/habit_emoji_picker.dart';
import '../widgets/duration_picker.dart';
import '../utils/get_weekday_string.dart';

class HabitForm extends StatefulWidget {
  const HabitForm({
    required this.addHabit,
    required this.updateHabit,
    this.docId,
    this.emoji,
    this.title,
    this.count,
    this.countUnit,
    this.duration,
    this.dailyTracks,
    this.weeklyTrack,
    super.key,
  });

  final Function addHabit;
  final Function updateHabit;
  final String? docId;
  final String? emoji;
  final String? title;
  final int? count;
  final String? countUnit;
  final String? duration;
  final Map<String, bool>? dailyTracks;
  final String? weeklyTrack;

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _countController = TextEditingController();

  String? _docId;
  bool _dailySelected = true;
  bool _weeklySelected = false;
  String? _selectedEmoji;
  Map<String, bool> _dailyTracks = {
    'Mon': true,
    'Tue': true,
    'Wed': true,
    'Thu': true,
    'Fri': true,
    'Sat': true,
    'Sun': true,
  };
  String _weeklyTrack = getWeekdayString(DateTime.now());
  String? _title;
  String? _count;
  String? _countUnit;
  String? _validationMessage;

  @override
  void initState() {
    if (widget.docId != null) {
      _docId = widget.docId;
      _dailySelected = widget.duration == 'day' ? true : false;
      _weeklySelected = widget.duration == 'week' ? true : false;
      _selectedEmoji = widget.emoji;
      _title = widget.title;
      _count = widget.count.toString();
      _countUnit = widget.countUnit;

      if (_dailySelected) {
        _dailyTracks = widget.dailyTracks!;
      }
      if (_weeklySelected) {
        _weeklyTrack = widget.weeklyTrack!;
      }

      _countController.text = _count!;
      super.initState();
    }
  }

  void _updateDayTrack(String day) {
    setState(() {
      _dailyTracks.update(day, (value) => !value);
    });
  }

  void _updateWeekTrack(String day) {
    setState(() {
      _weeklyTrack = day;
    });
  }

  void _updateSelectedEmoji(String emoji) {
    setState(() {
      _selectedEmoji = emoji;
    });
  }

  void _handleDailySelect() {
    setState(() {
      _dailySelected = true;
      _weeklySelected = false;
    });
  }

  void _handleWeeklySelect() {
    setState(() {
      _weeklySelected = true;
      _dailySelected = false;
    });
  }

  void _handleSubmit() async {
    // validation logic
    if (_title == null || _title!.isEmpty) {
      setState(() {
        _validationMessage = "Please enter a valid habit title.";
      });
      return;
    } else if (_selectedEmoji == null || _selectedEmoji!.isEmpty) {
      setState(() {
        _validationMessage = "Please select an emoji.";
      });
      return;
    } else if (_count == null || _count!.isEmpty) {
      setState(() {
        _validationMessage = "Please enter a valid count number.";
      });
      return;
    } else if (_countUnit == null || _countUnit!.isEmpty) {
      setState(() {
        _validationMessage = "Please select a count unit.";
      });
      return;
    } else {
      setState(() {
        _validationMessage = null;
      });
    }

    if (_docId == null) {
      widget.addHabit(
        _title,
        _selectedEmoji,
        int.parse(_count!),
        _countUnit,
        _dailySelected,
        _weeklySelected,
        _dailyTracks,
        _weeklyTrack,
      );
    } else {
      widget.updateHabit(
        _docId,
        _title,
        _selectedEmoji,
        int.parse(_count!),
        _countUnit,
        _dailySelected,
        _weeklySelected,
        _dailyTracks,
        _weeklyTrack,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Add new habit",
                      hintStyle: TextStyle(
                        fontSize: 28,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 3),
                    ),
                    onChanged: (value) => _title = value,
                    onSaved: (value) => _title = value,
                  ),
                  const SizedBox(height: 20),
                  // const InputTitleText(title: "Icon and Color"),
                  HabitEmojiPicker(
                    selectedEmoji: _selectedEmoji,
                    updateSelectedEmoji: _updateSelectedEmoji,
                  ),
                  const SizedBox(height: 10),
                  // const InputTitleText(title: "Duration"),
                  Column(children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            IconData(0xf44c,
                                fontFamily: iconFont,
                                fontPackage: iconFontPackage),
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Column(
                          children: const [
                            Text(
                              "I want to set the habit to be",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 87, 85, 85),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 20.0, 0),
                      child: Row(
                        children: [
                          Expanded(
                            // margin: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                            child: TextFormField(
                              controller: _countController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                label: Text(
                                  "Enter Count",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(15),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _count = value,
                              onSaved: (value) => _count = value,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              value: _countUnit,
                              iconSize: 24,
                              underline: Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFFBDBDBD),
                                            width: 0.0))),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              items: const [
                                DropdownMenuItem(
                                  value: 'min',
                                  child: Text("min"),
                                ),
                                DropdownMenuItem(
                                  value: 'hr',
                                  child: Text("hr"),
                                ),
                                DropdownMenuItem(
                                  value: 'times',
                                  child: Text('times'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _countUnit = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    DurationPicker(
                      dailyTracks: _dailyTracks,
                      weeklyTrack: _weeklyTrack,
                      updateDayTrack: _updateDayTrack,
                      updateWeekTrack: _updateWeekTrack,
                      handleDailySelect: _handleDailySelect,
                      handleWeeklySelect: _handleWeeklySelect,
                      dailySelected: _dailySelected,
                      weeklySelected: _weeklySelected,
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            if (_validationMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _validationMessage!,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(87, 111, 114, 1),
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                onPressed: _handleSubmit,
                child: Text(_docId == null ? "Add Habit 😆" : "Confirm Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
