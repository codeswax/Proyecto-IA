import 'dart:convert';
import 'dart:typed_data';
import 'package:proyecto_ia_front/models/car.dart';

class CSVReader {
  final List<String> requiredColumns = [
    'TIPO TRANSACCIÓN',
    'MARCA',
    'MODELO',
    'PAÍS',
    'AÑO MODELO',
    'CLASE',
    'TIPO',
    'TIPO SERVICIO',
    'CILINDRAJE',
    'TIPO COMBUSTIBLE',
    'FECHA COMPRA (MM/DD/AA)',
    'PERSONA NATURAL - JURÍDICA',
    'COLOR 1',
    'CANTÓN'
  ];

  List<Car> parseCSV(Uint8List fileContent) {
    final csvContent = utf8.decode(fileContent);
    final lines = csvContent.split('\n');
    if (lines.isEmpty) {
      throw Exception('El archivo no contiene información.');
    }

    final headers =
        lines.first.split(',').map((h) => h.trim().toUpperCase()).toList();

    if (!requiredColumns.every((col) => headers.contains(col))) {
      throw Exception('Falta información necesaria.');
    }

    List<Car> carsData = [];
    for (var i = 1; i < lines.length; i++) {
      final values = lines[i].split(',');
      if (values.length != headers.length) continue;
      final row = Map<String, String>.fromIterables(headers, values);

      try {
        final car = Car(
          cilindraje: int.tryParse(row['CILINDRAJE'] ?? '0') ?? 0,
          brand: row['MARCA'] ?? '',
          model: row['MODELO'] ?? '',
          year: row['AÑO MODELO'] ?? '0',
          gasType: row['TIPO COMBUSTIBLE'] ?? '',
          classType: row['CLASE'] ?? '',
          canton: row['CANTÓN'] ?? '',
          country: row['PAÍS'] ?? '',
          color: row['COLOR 1'] ?? '',
          persona: row['PERSONA NATURAL - JURÍDICA'] ?? '',
          tipo: row['TIPO'] ?? '',
          tipoServicio: row['TIPO SERVICIO'] ?? '',
          tipoTransaccion: row['TIPO TRANSACCIÓN'] ?? '',
          fechaCompra:
              DateTime.tryParse(row['FECHA COMPRA (MM/DD/AA)'] ?? '') ??
                  DateTime(1970, 1, 1),
        );
        carsData.add(car);
      } catch (e) {
        continue;
      }
    }
    return carsData;
  }
}
