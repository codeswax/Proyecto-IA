import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_ia_front/models/car.dart';

class PDFGeneratorScreen extends StatefulWidget {
  final List<Car> vehicles;

  const PDFGeneratorScreen({super.key, required this.vehicles});

  @override
  State<PDFGeneratorScreen> createState() => _PDFGeneratorScreenState();
}

class _PDFGeneratorScreenState extends State<PDFGeneratorScreen> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    generatePDF();
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    // Agregar una página por vehículo
    for (var vehicle in widget.vehicles) {
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Detalles del Vehículo",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("Marca: ${vehicle.brand}"),
              pw.Text("Modelo: ${vehicle.model}"),
              pw.Text("Año: ${vehicle.year}"),
              pw.Text("Cilindraje: ${vehicle.cilindraje}"),
              pw.Text("Combustible: ${vehicle.gasType}"),
              pw.Text("Clase: ${vehicle.classType}"),
              pw.Text("Color: ${vehicle.color}"),
              pw.Text("País: ${vehicle.country}"),
              pw.Text("Cantón: ${vehicle.canton}"),
              pw.Text("Persona: ${vehicle.persona}"),
              pw.Text("Tipo: ${vehicle.tipo}"),
              pw.Text("Tipo de Servicio: ${vehicle.tipoServicio}"),
              pw.Text("Tipo de Transacción: ${vehicle.tipoTransaccion}"),
              pw.Text("Fecha de Compra: ${vehicle.fechaCompra.toString()}"),
              //pw.Text("Avalúo Estimado: ${vehicle.avaluoEstimado}"),
            ],
          ),
        ),
      );
    }

    // Guardar el archivo PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/vehiculos_avaluados.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Generado"),
      ),
      body: pdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: pdfPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onRender: (pages) {
                debugPrint('Document renderizado con $pages páginas.');
              },
              onError: (error) {
                debugPrint('Error al cargar el PDF: $error');
              },
              onPageError: (page, error) {
                debugPrint('Error en la página $page: $error');
              },
            ),
    );
  }
}
