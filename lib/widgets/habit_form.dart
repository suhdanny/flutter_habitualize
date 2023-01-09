import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import '../widgets/habit_emoji_picker.dart';
import '../widgets/duration_picker.dart';

class HabitForm extends StatefulWidget {
  const HabitForm({required this.addHabit, super.key});

  final Function addHabit;

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _countController = TextEditingController();
  // bool _isInit = true;
  String? _docId;

  bool _dailySelected = true;
  bool _weeklySelected = false;
  Emoji? _selectedEmoji;
  Map<String, bool> _dailyTracks = {
    'Mon': true,
    'Tue': true,
    'Wed': true,
    'Thu': true,
    'Fri': true,
    'Sat': true,
    'Sun': true,
  };
  String? _title;
  String? _count;
  String? _countUnit;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final args = ModalRoute.of(context)!.settings.arguments as Map;
  //
  //     // docId is only present for the habit that has already been created
  //     if (args['docId'] != null) {
  //       _docId = args['docId'];
  //       _dailySelected = args['duration'] == 'day' ? true : false;
  //       _weeklySelected = args['duration'] == 'week' ? true : false;
  //       _title = args['title'];
  //       _iconData = args['icon'];
  //       _mainColor = args['iconColor'];
  //       _count = args['count'].toString();
  //       _countUnit = args['countUnit'];
  //       _countController.text = args['count'].toString();
  //     }
  //     _isInit = false;
  //   }
  //   super.didChangeDependencies();
  // }

  void _updateDayTrack(String day) {
    setState(() {
      _dailyTracks.update(day, (value) => !value);
    });
  }

  void _updateSelectedEmoji(Emoji emoji) {
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
    _formKey.currentState!.save();

    // place validation logic

    print(_title);
    print(_selectedEmoji);
    print(_count);
    print(_dailySelected);
    print(_weeklySelected);
    print(_dailyTracks);

    widget.addHabit(
      _title,
      _selectedEmoji,
      int.parse(_count!),
      _countUnit,
      _dailySelected,
      _weeklySelected,
      _dailyTracks,
    );
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
                              onSaved: (value) => _count = value,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton(
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
                      updateDayTrack: _updateDayTrack,
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
                child: const Text("Add Habit 😆"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
