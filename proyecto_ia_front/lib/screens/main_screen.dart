import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';
import 'package:proyecto_ia_front/screens/car_appraisal_files.dart';
import 'package:proyecto_ia_front/screens/car_appraisal_history.dart';
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
    });
  }

  void _onDelete(int index) {
    setState(() {
      _carList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: CustomNavRail(
                    selectedScreen: _selectedScreen,
                    onDestinationSelected: _updateScreen)),
            Expanded(flex: 10, child: _buildScreen()),
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
        return Column(
          children: [
            const CustomHeader(headerTitle: 'Historial'),
            Expanded(
                flex: 11,
                child:
                    CarAppraisalHistory(history: _carList, onDelete: _onDelete))
          ],
        );
      case 2:
        return const Column(
          children: [
            CustomHeader(headerTitle: 'Subir Catálogo'),
            Expanded(
              flex: 11,
              child: CarAppraisalFiles(),
            ),
          ],
        );

      default:
        return Column(
          children: [
            const CustomHeader(headerTitle: 'Formulario de Avalúo'),
            Expanded(
              flex: 10,
              child: CarAppraisalForm(
                onAvaluoCalculated: _updateAvaluo,
              ),
            ),
          ],
        );
    }
  }
}
