import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';

class CarDataSource extends DataTableSource {
  final List<Car> carsData;

  CarDataSource(this.carsData);

  @override
  DataRow getRow(int index) {
    final car = carsData[index];
    return DataRow(cells: [
      DataCell(Text(car.avaluo?.toStringAsFixed(1) ?? '-')),
      DataCell(Text(car.brand)),
      DataCell(Text(car.model)),
      DataCell(Text(car.year)),
      DataCell(Text(car.country)),
      DataCell(Text(car.cilindraje.toString())),
      DataCell(Text(car.gasType)),
      DataCell(Text(car.classType)),
      DataCell(Text(car.canton)),
      DataCell(Text(car.color)),
      DataCell(Text(car.persona)),
      DataCell(Text(car.tipo)),
      DataCell(Text(car.tipoServicio)),
      DataCell(Text(car.tipoTransaccion)),
      DataCell(Text(car.fechaCompra.toLocal().toString().split(' ')[0])),
    ]);
  }

  @override
  int get rowCount => carsData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
