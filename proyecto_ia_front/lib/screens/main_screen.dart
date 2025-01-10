import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';
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
  final List<Car> _carList = [];
  //String _avaluoEstimado = '';
  //Car? _car;

  void _updateScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  void _updateAvaluo(String nuevoAvaluo, Car nuevoCar) {
    setState(() {
      _carList.add(nuevoCar);
      //_avaluoEstimado = nuevoAvaluo;
      //_car = nuevoCar;
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
                  flex: 2,
                  child: CustomNavRail(
                      selectedScreen: _selectedScreen,
                      onDestinationSelected: _updateScreen)),
            Expanded(flex: 10, child: _buildScreen()),
            // Expanded(
            //   flex: 3,
            //   child: CarAppraisalResults(
            //     avaluoEstimado: _avaluoEstimado,
            //     //car: _car,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_selectedScreen) {
      case 0:
        return Column(
          children: [
            const CustomHeader(headerTitle: 'Formulario de Avalúo'),
            Expanded(
              flex: 11,
              child: CarAppraisalForm(
                onAvaluoCalculated: _updateAvaluo,
              ),
            ),
          ],
        );
      case 1:
        return const Column(
          children: [
            CustomHeader(headerTitle: 'Historial'),
          ],
        );
      default:
        return Column(
          children: [
            const CustomHeader(headerTitle: 'Formulario de Avalúo'),
            Expanded(
              flex: 11,
              child: CarAppraisalForm(
                onAvaluoCalculated: _updateAvaluo,
              ),
            ),
          ],
        );
    }
  }
}
