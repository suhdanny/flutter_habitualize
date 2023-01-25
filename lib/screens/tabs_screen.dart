import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import './home_screen.dart';
import './calendar_screen.dart';
import './settings_screen.dart';
import './add_habit_screen.dart';

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
      Container(),
      SettingsScreen(),
    ];
    super.initState();
  }

  void _onItemTapped(index) {
    if (index == 2) {
      showMaterialModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          expand: false,
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) {
            return AddHabitScreen();
          });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _widgetOptions![_selectedIndex],
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(
        // marginR: const EdgeInsets.symmetric(vertical: 20),
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        dotIndicatorColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: [
          DotNavigationBarItem(
              icon: const Icon(Icons.home), selectedColor: Colors.black),
          DotNavigationBarItem(
              icon: const Icon(Icons.calendar_month),
              selectedColor: Colors.black),
          DotNavigationBarItem(
              icon: const Icon(Icons.add), selectedColor: Colors.black),
          DotNavigationBarItem(
              icon: const Icon(Icons.manage_accounts),
              selectedColor: Colors.black),
        ],
      ),
    );
  }
}
