import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedScreen;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedScreen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      currentIndex: selectedScreen,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.white,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: 'Avaluar'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
      ],
    );
  }
}
