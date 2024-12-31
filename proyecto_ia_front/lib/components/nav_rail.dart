import 'package:flutter/material.dart';

class NavRail extends StatelessWidget {
  final int selectedScreen;
  final Function(int) onDestinationSelected;

  const NavRail({
    super.key,
    required this.selectedScreen,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: Colors.blue,
      indicatorColor: Colors.white,
      selectedIndex: selectedScreen,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(
            Icons.car_rental,
            size: 30,
          ),
          label: Text('Avaluar'),
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
      leading: const Column(
        children: [
          SizedBox(
            height: 10,
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 35,
            child: Icon(
              Icons.calculate_sharp,
              size: 45,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
