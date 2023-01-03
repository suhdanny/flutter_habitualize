import 'package:flutter/material.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({
    required this.handleDailySelect,
    required this.handleWeeklySelect,
    required this.dailySelected,
    required this.weeklySelected,
    super.key,
  });

  final VoidCallback handleDailySelect;
  final VoidCallback handleWeeklySelect;
  final bool dailySelected;
  final bool weeklySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: handleDailySelect,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              textStyle: const TextStyle(
                fontSize: 15,
              ),
              backgroundColor: dailySelected
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Daily"),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: handleWeeklySelect,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              textStyle: const TextStyle(
                fontSize: 15,
              ),
              backgroundColor: weeklySelected
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Weekly"),
          ),
        ),
      ],
    );
  }
}
