import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/components/bottom_nav_bar.dart';
import 'package:proyecto_ia_front/components/nav_rail.dart';
import 'package:proyecto_ia_front/screens/car_appraisal_form.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> screens = [
    const CarAppraisalForm(),
    Container(
      color: Colors.purple.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Feed',
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Favorites',
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    ),
  ];

  int selectedScreen = 0;

  void updateScreen(int index) {
    setState(() {
      selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Avalúo de Vehículos',
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavBar(
              selectedScreen: selectedScreen,
              onTap: updateScreen,
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            NavRail(
              selectedScreen: selectedScreen,
              onDestinationSelected: updateScreen,
            ),
          Expanded(
            child: screens[selectedScreen],
          ),
        ],
      ),
    );
  }
}
