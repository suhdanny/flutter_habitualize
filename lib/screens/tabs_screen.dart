import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './home_screen.dart';
import './settings_screen.dart';

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
      SettingsScreen(),
    ];
    super.initState();
  }

  void _updateIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // String get currentDate {
  //   return DateFormat("EEE MMM d").format(DateTime.now());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions![_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/add-habit',
                  arguments: {"appBarTitle": "Add Habit"},
                );
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _updateIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
