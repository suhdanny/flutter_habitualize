import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import './home_screen.dart';
import './calendar_screen.dart';
import './settings_screen.dart';
import './add_habit_screen.dart';
import './stats_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  @override
  void initState() {
    _widgetOptions = [
      HomeScreen(),
      CalendarScreen(),
      AddHabitScreen(),
      StatsScreen(),
      SettingsScreen(),
    ];
    super.initState();
  }

  void _onItemTapped(index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/add-habit');
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions![_selectedIndex],
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        dotIndicatorColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: [
          DotNavigationBarItem(
              icon: Icon(Icons.home), selectedColor: Colors.black),
          DotNavigationBarItem(
              icon: Icon(Icons.calendar_month), selectedColor: Colors.black),
          DotNavigationBarItem(
              icon: Icon(Icons.add), selectedColor: Colors.black),
          DotNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart), selectedColor: Colors.black),
          DotNavigationBarItem(
              icon: Icon(Icons.settings), selectedColor: Colors.black),
        ],
      ),
    );
  }
}
