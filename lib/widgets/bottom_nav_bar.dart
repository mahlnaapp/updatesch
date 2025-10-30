import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "الحضور",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.grade), label: "الدرجات"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "الإعدادات"),
      ],
    );
  }
}
