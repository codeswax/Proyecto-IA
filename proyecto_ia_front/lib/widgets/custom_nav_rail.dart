import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/util/constants.dart';

class CustomNavRail extends StatelessWidget {
  final int selectedScreen;
  final Function(int) onDestinationSelected;

  const CustomNavRail({
    super.key,
    required this.selectedScreen,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: cardColor,
      indicatorColor: primaryColor,
      selectedIndex: selectedScreen,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(
            Icons.car_rental,
            size: 30,
          ),
          label: Text('Valuar'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.history,
            size: 30,
          ),
          label: Text('Historial'),
        ),
      ],
      labelType: NavigationRailLabelType.all,
      selectedLabelTextStyle: const TextStyle(
        color: Colors.white,
      ),
      selectedIconTheme: const IconThemeData(
        color: cardColor,
      ),
      leading: const Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Icon(
            Icons.calculate_sharp,
            size: 100,
            color: primaryColor,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
