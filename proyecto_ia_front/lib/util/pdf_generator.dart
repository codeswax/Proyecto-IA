import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:proyecto_ia_front/models/car.dart';

Future<void> pdfGenerator(List<Car> carsData) async {
  final pdf = pw.Document();

  for (final car in carsData) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("Vehículo: ${carsData.indexOf(car) + 1}"),
                    ],
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                  ),
                ],
              ),
              pw.Divider(
                height: 50,
                borderStyle: pw.BorderStyle.dashed,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        child: pw.Text(
                          'Especificaciones',
                          textAlign: pw.TextAlign.center,
                        ),
                        padding: const pw.EdgeInsets.all(20),
                      ),
                    ],
                  ),
                  ...car.toJson().entries.map((entry) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          child: pw.Text(
                            entry.key, // Clave
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                          padding: const pw.EdgeInsets.all(10),
                        ),
                        pw.Padding(
                          child: pw.Text(
                            entry.value.toString(), // Valor
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                          padding: const pw.EdgeInsets.all(10),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
