import 'dart:convert'; // Para manejar JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class FeatureImportancesScreen extends StatefulWidget {
  const FeatureImportancesScreen({super.key});

  @override
  State<FeatureImportancesScreen> createState() =>
      _FeatureImportancesScreenState();
}

class _FeatureImportancesScreenState extends State<FeatureImportancesScreen> {
  Map<String, double> featureImportances = {};

  @override
  void initState() {
    super.initState();
    fetchFeatureImportances();
  }

  Future<void> fetchFeatureImportances() async {
    const String url = 'http://127.0.0.1:5000/feature_importances';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Convertir valores a Map<String, double>
        setState(() {
          featureImportances = Map.fromEntries(
            data.entries.map((e) => MapEntry(e.key, e.value.toDouble())),
          );
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ordenar las características por importancia
    final sortedFeatures = featureImportances.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Importances'),
      ),
      body: featureImportances.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.center,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipPadding: const EdgeInsets.all(8.0),
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  rod.toY.toStringAsFixed(4),
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),
                            touchCallback: (FlTouchEvent event,
                                BarTouchResponse? touchResponse) {},
                            handleBuiltInTouches: true,
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  // Mapea el valor del eje al índice correcto
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < sortedFeatures.length) {
                                    return RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        sortedFeatures[index].key,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Text('');
                                  }
                                },
                                reservedSize: 235,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups:
                              sortedFeatures.asMap().entries.map((entry) {
                            final index = entry.key;
                            final feature = entry.value;
                            return BarChartGroupData(
                              x: index, // El índice se usa para mapear al eje X
                              barRods: [
                                BarChartRodData(
                                  toY: feature.value,
                                  width: 20,
                                  color: Colors.blue,
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
