import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/util/responsive.dart';
import 'package:proyecto_ia_front/widgets/custom_header.dart';
import 'package:proyecto_ia_front/widgets/custom_nav_rail.dart';
import 'package:proyecto_ia_front/screens/car_appraisal_form.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreen = 0;

  void _updateScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);
    return Scaffold(
        drawer: (isMobile || isTablet)
            ? SizedBox(
                width: 250,
                child: CustomNavRail(
                    selectedScreen: _selectedScreen,
                    onDestinationSelected: _updateScreen),
              )
            : null,
        body: SafeArea(
          child: Row(
            children: [
              if (isDesktop)
                Expanded(
                    flex: 1,
                    child: CustomNavRail(
                        selectedScreen: _selectedScreen,
                        onDestinationSelected: _updateScreen)),
              Expanded(flex: 11, child: _buildScreen())
            ],
          ),
        ));
  }

  Widget _buildScreen() {
    switch (_selectedScreen) {
      case 0:
        return const Column(
          children: [
            CustomHeader(headerTitle: 'Formulario de Avalúo'),
            Expanded(flex: 11, child: CarAppraisalForm()),
          ],
        );
      case 1:
        return const Column(
          children: [
            CustomHeader(headerTitle: 'Historial'),
            //CarAppraisalHistory(),
          ],
        );
      default:
        return const Column(
          children: [
            CustomHeader(headerTitle: 'Formulario de Avalúo'),
            Expanded(flex: 11, child: CarAppraisalForm()),
          ],
        );
    }
  }
}
