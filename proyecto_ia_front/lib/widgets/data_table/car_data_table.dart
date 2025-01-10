import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';

import 'package:proyecto_ia_front/widgets/data_table/car_data_sources.dart';

class CarDataTable extends StatelessWidget {
  final List<Car> carsData;
  const CarDataTable({super.key, required this.carsData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        dragStartBehavior: DragStartBehavior.start,
        rowsPerPage: 10,
        columns: const [
          DataColumn(label: Text('Avalúo (\$)')),
          DataColumn(label: Text('Marca')),
          DataColumn(label: Text('Modelo')),
          DataColumn(label: Text('Año')),
          DataColumn(label: Text('País')),
          DataColumn(label: Text('Cilindraje')),
          DataColumn(label: Text('Combustible')),
          DataColumn(label: Text('Clase')),
          DataColumn(label: Text('Cantón')),
          DataColumn(label: Text('Color')),
          DataColumn(label: Text('Persona')),
          DataColumn(label: Text('Tipo')),
          DataColumn(label: Text('Servicio')),
          DataColumn(label: Text('Transacción')),
          DataColumn(label: Text('Fecha Compra')),
        ],
        source: CarDataSource(carsData),
      ),
    );
  }
}
