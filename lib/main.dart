import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/grades_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام الطالب',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Cairo'),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    AttendanceScreen(),
    GradesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
