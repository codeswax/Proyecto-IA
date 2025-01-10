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
    double iconSize = 35.0;

    return NavigationRail(
      backgroundColor: cardColor,
      indicatorColor: primaryColor,
      selectedIndex: selectedScreen,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationRailDestination(
          icon: Icon(
            Icons.car_rental,
            size: iconSize,
          ),
          label: const Text('Valuar'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.history,
            size: iconSize,
          ),
          label: const Text('Historial'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.upload_file,
            size: iconSize,
          ),
          label: const Text('Subir'),
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Icon(
              Icons.commute,
              size: 120,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
