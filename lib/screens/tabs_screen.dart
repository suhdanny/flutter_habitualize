import 'package:flutter/material.dart';
import 'package:flutter_habitualize/screens/calendar_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './home_screen.dart';
import './settings_screen.dart';
import './calendar_screen.dart';
import './add_habit_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

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
      CalendarScreen(),
      SettingsScreen(),
      SettingsScreen(),
    ];
    super.initState();
  }

  void _updateIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions![_selectedIndex],
      // extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: DotNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            _updateIndex(index);
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
                icon: Icon(Icons.stacked_bar_chart),
                selectedColor: Colors.black),
            DotNavigationBarItem(
                icon: Icon(Icons.settings), selectedColor: Colors.black),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: _widgetOptions![_selectedIndex],
    //   floatingActionButton: _selectedIndex == 0
    //       ? FloatingActionButton(
    //           onPressed: () {
    //             Navigator.pushNamed(
    //               context,
    //               '/add-habit',
    //               arguments: {"appBarTitle": "Add Habit"},
    //             );
    //           },
    //           child: const Icon(
    //             Icons.add,
    //           ),
    //         )
    //       : Container(),
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: _selectedIndex,
    //     onTap: (index) {
    //       _updateIndex(index);
    //     },
    //     items: const [
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.home,
    //         ),
    //         label: "Home",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.settings,
    //         ),
    //         label: "Settings",
    //       ),
    //     ],
    //   ),
    // );
  }
}
