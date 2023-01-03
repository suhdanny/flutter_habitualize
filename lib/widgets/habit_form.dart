import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../widgets/input_title_text.dart';
import '../widgets/icon_and_color_picker.dart';
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
  bool _isInit = true;
  String? _docId;

  bool _dailySelected = true;
  bool _weeklySelected = false;
  String? _title;
  IconData? _iconData;
  Color? _tempMainColor;
  Color? _mainColor;
  String? _count;
  String? _countUnit;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      if (args['docId'] != null) {
        _docId = args['docId'];
        _dailySelected = args['duration'] == 'day' ? true : false;
        _weeklySelected = args['duration'] == 'week' ? true : false;
        _title = args['title'];
        _iconData = args['icon'];
        _mainColor = args['iconColor'];
        _count = args['count'].toString();
        _countUnit = args['countUnit'];
        _countController.text = args['count'].toString();
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context);

    setState(() {
      _iconData = icon;
    });
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _mainColor = _tempMainColor;
                });
              },
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Choose Your Icon Color",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
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
    bool isValid = _formKey.currentState!.validate();
    if (!isValid || _iconData == null || _countUnit == null) return;
    _formKey.currentState!.save();

    try {
      widget.addHabit(
        _docId,
        false,
        int.parse(_count!),
        _countUnit,
        _dailySelected ? 'day' : 'week',
        _iconData.toString(),
        _mainColor!.value.toRadixString(16),
        _title,
      );
      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const InputTitleText(title: "Title"),
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: const Text(
                    "Enter Title",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the title of the habit.";
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              const SizedBox(height: 20),
              const InputTitleText(title: "Icon and Color"),
              IconAndColorPicker(
                pickIcon: _pickIcon,
                openMainColorPicker: _openMainColorPicker,
                iconData: _iconData,
                mainColor: _mainColor,
              ),
              const SizedBox(height: 20),
              const InputTitleText(title: "Duration"),
              DurationPicker(
                handleDailySelect: _handleDailySelect,
                handleWeeklySelect: _handleWeeklySelect,
                dailySelected: _dailySelected,
                weeklySelected: _weeklySelected,
              ),
              const SizedBox(height: 20),
              const InputTitleText(title: "Count"),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _countController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: const Text(
                          "Enter Count",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.parse(value) < 0) {
                          return "Please enter valid count.";
                        }
                        return null;
                      },
                      onSaved: (value) => _count = value,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      value: _countUnit,
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
              const SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    textStyle: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  onPressed: _handleSubmit,
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
