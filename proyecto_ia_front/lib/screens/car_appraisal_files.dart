import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_ia_front/models/car.dart';
import 'package:proyecto_ia_front/util/constants.dart';
import 'package:proyecto_ia_front/util/csv_reader.dart';
import 'package:proyecto_ia_front/util/pdf_generator.dart';
import 'package:proyecto_ia_front/widgets/data_table/car_data_table.dart';
import 'package:proyecto_ia_front/widgets/custom_section_card.dart';
import 'package:proyecto_ia_front/widgets/dialog/dialog_implementation.dart';

class CarAppraisalFiles extends StatefulWidget {
  const CarAppraisalFiles({super.key});

  @override
  State<CarAppraisalFiles> createState() => _CarAppraisalFilesState();
}

class _CarAppraisalFilesState extends State<CarAppraisalFiles> {
  String? fileName;
  Uint8List? pickedFile;
  List<Car> carsData = [];
  final CSVReader csvReader = CSVReader();

  Future<List<double>> fetchPredictions(
      List<List<dynamic>> featuresList) async {
    final url = Uri.parse('http://127.0.0.1:5000/batch_predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'features': featuresList}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<double>.from(
          jsonResponse['predictions'].map((e) => e.toDouble()));
    } else {
      throw Exception('Error al obtener predicciones: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: pickedFile == null ? _buildUploadFileColumn() : _buildDataTable(),
    );
  }

  Widget _buildUploadFileColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: transparent,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: primaryColor)),
          child: Padding(
            padding: const EdgeInsets.all(standardPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.file_upload_rounded,
                  size: 120,
                  color: primaryColor,
                ),
                const Text(
                  'Analiza varios carros.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
                const Text(
                  'Formato compatible: .csv',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    pickFile(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Subir archivo',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDataTable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSectionCard(
              headerIcon: Icons.check_circle_rounded,
              headerTitle: 'Archivo subido',
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 200,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.file_present,
                          color: primaryColor,
                          size: 48,
                        ),
                        Text(
                          fileName!,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          pickedFile = null;
                          fileName = null;
                          carsData.clear();
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: backgroundColor,
              ),
              onPressed: () async {
                try {
                  final featuresList = carsData.map((car) {
                    return [
                      car.cilindraje,
                      car.brand,
                      car.model,
                      car.year,
                      car.gasType,
                      car.classType,
                      car.canton,
                      car.country,
                      car.color,
                      car.persona,
                      car.tipo,
                      car.tipoServicio,
                      car.tipoTransaccion,
                      car.fechaCompra.toString(),
                    ];
                  }).toList();
                  if (mounted) {
                    DialogImplementation()
                        .showLoadingDialog(context, "Calculando avalúo");
                  }
                  await Future.delayed(const Duration(seconds: 3));
                  final predictions = await fetchPredictions(featuresList);
                  setState(() {
                    for (int i = 0; i < carsData.length; i++) {
                      carsData[i].avaluo = predictions[i];
                    }
                  });
                } catch (e) {
                  if (mounted) {
                    DialogImplementation()
                        .showExceptionDialog(context, e.toString());
                  }
                } finally {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Calcular avalúo'),
            ),
            ElevatedButton(
              onPressed: carsData.any((car) => car.avaluo != null)
                  ? () => pdfGenerator(carsData)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: backgroundColor,
              ),
              child: const Text('Generar reporte PDF'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: CarDataTable(
              carsData: carsData,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> pickFile(BuildContext context) async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (res != null && res.files.isNotEmpty) {
      setState(() {
        pickedFile = res.files.single.bytes;
        fileName = res.files.single.name;
      });
      try {
        if (context.mounted) {
          DialogImplementation().showLoadingDialog(context, "Leyendo archivo");
        }
        await Future.delayed(const Duration(seconds: 3));
        final cars = csvReader.parseCSV(pickedFile!);
        setState(() {
          carsData = cars;
          Navigator.of(context).pop();
        });
      } catch (e) {
        setState(() {
          pickedFile = null;
          fileName = null;
          carsData.clear();
        });
        if (context.mounted) {
          String errorMessage = e.toString().replaceFirst('Exception: ', '');
          Navigator.of(context).pop();
          DialogImplementation().showExceptionDialog(context, errorMessage);
        }
      }
    }
  }
}
