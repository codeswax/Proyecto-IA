import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';
import 'package:proyecto_ia_front/util/constants.dart';
import 'package:proyecto_ia_front/widgets/custom_section_card.dart';
// import 'package:front_proyecto_ia/components/car_appraisal_details.dart';

class CarAppraisalForm extends StatefulWidget {
  final Function(String, Car) onAvaluoCalculated;
  const CarAppraisalForm({super.key, required this.onAvaluoCalculated});

  @override
  State<CarAppraisalForm> createState() => _CarAppraisalFormState();
}

class _CarAppraisalFormState extends State<CarAppraisalForm> {
  final _formKey = GlobalKey<FormState>();

  List<String> marcas = [];
  List<String> modelos = [];
  List<String> anios = [];
  List<String> clases = [];
  List<String> combustibles = [];
  List<String> paises = [];
  List<String> cantones = [];
  List<String> colores = [];
  List<String> personas = [];
  List<String> tipos = [];
  List<String> tiposServicio = [];
  List<String> tiposTransaccion = [];

  Car? car;
  String? marca;
  String? modelo;
  String? anio;
  String? combustible;
  String? clase;
  String? canton;
  String? pais;
  String? color;
  String? persona;
  String? tipo;
  String? tipoServicio;
  String? tipoTransaccion;
  DateTime? fechaCompra;
  String? fechaCompraError;
  int? cilindraje;
  final TextEditingController cilindrajeController = TextEditingController();
  String avaluoEstimado = '-';

  @override
  void initState() {
    super.initState();
    loadFeatures(); // Cargar las listas de valores al inicio
  }

  Future<void> loadFeatures() async {
    final fetchedMarcas = await fetchFeatures('MARCA');
    final fetchedAnios = await fetchFeatures('AÑO MODELO');
    final fetchedClases = await fetchFeatures('CLASE');
    final fetchedCombustibles = await fetchFeatures('TIPO COMBUSTIBLE');
    final fetchedPaises = await fetchFeatures('PAÍS');
    final fetchedCantones = await fetchFeatures('CANTÓN');
    final fetchedColores = await fetchFeatures('COLOR 1');
    final fetchedPersonas = await fetchFeatures('PERSONA NATURAL - JURÍDICA');
    final fetchedTipos = await fetchFeatures('TIPO');
    final fetchedTiposServicio = await fetchFeatures('TIPO SERVICIO');
    final fetchedTiposTransaccion = await fetchFeatures('TIPO TRANSACCIÓN');

    setState(() {
      marcas = fetchedMarcas;
      if (marcas.isNotEmpty) marca = marcas.first;
      updateModels(marca!);

      anios = fetchedAnios;
      if (anios.isNotEmpty) anio = anios.first;

      clases = fetchedClases;
      if (clases.isNotEmpty) clase = clases.first;

      combustibles = fetchedCombustibles;
      if (combustibles.isNotEmpty) combustible = combustibles.first;

      paises = fetchedPaises;
      if (paises.isNotEmpty) pais = paises.first;

      cantones = fetchedCantones;
      if (cantones.isNotEmpty) canton = cantones.first;

      colores = fetchedColores;
      if (colores.isNotEmpty) color = colores.first;

      personas = fetchedPersonas;
      if (personas.isNotEmpty) persona = personas.first;

      tipos = fetchedTipos;
      if (tipos.isNotEmpty) tipo = tipos.first;

      tiposServicio = fetchedTiposServicio;
      if (tiposServicio.isNotEmpty) tipoServicio = tiposServicio.first;

      tiposTransaccion = fetchedTiposTransaccion;
      if (tiposTransaccion.isNotEmpty) tipoTransaccion = tiposTransaccion.first;
    });
  }

  Future<List<String>> fetchFeatures(String feature) async {
    try {
      final url = Uri.parse('http://127.0.0.1:5000/unique_values/$feature');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('unique_values')) {
          return (data['unique_values'] as List<dynamic>).cast<String>();
        } else {
          throw Exception('La respuesta no contiene la clave "unique_values"');
        }
      } else {
        throw Exception('Error al obtener los valores de $feature');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<String>> fetchModels(String brand) async {
    try {
      final url = Uri.parse('http://127.0.0.1:5000/models/$brand');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<String>(); // Convierte a una lista de cadenas
      } else {
        throw Exception('Error al obtener los modelos para la marca $brand');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> updateModels(String brand) async {
    final fetchedModelos = await fetchModels(brand);
    setState(() {
      modelos = fetchedModelos;
      if (modelos.isNotEmpty) modelo = modelos.first;
    });
  }

  String? _validateFechaCompra() {
    if (fechaCompra == null) {
      return 'Seleccione una fecha de compra';
    }
    return null;
  }

  String? _validateCilindraje(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa el cilindraje';
    }
    final int? intValue = int.tryParse(value);
    if (intValue == null || intValue <= 0) {
      return 'El cilindraje debe ser un entero mayor a 0';
    }
    return null;
  }

  Future<double> fetchPrediction(List<dynamic> features) async {
    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'features': features}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return double.parse(jsonResponse['prediction'][0].toStringAsFixed(2));
    } else {
      throw Exception('Error al obtener predicción');
    }
  }

  Future<void> sendCarDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        car = Car(
          cilindraje: cilindraje!,
          brand: marca!,
          model: modelo!,
          year: anio!,
          gasType: combustible!,
          classType: clase!,
          canton: canton!,
          country: pais!,
          color: color!,
          persona: persona!,
          tipo: tipo!,
          tipoServicio: tipoServicio!,
          tipoTransaccion: tipoTransaccion!,
          fechaCompra: fechaCompra!,
        );
      });

      final features = [
        car!.cilindraje,
        car!.brand,
        car!.model,
        car!.year,
        car!.gasType,
        car!.classType,
        car!.canton,
        car!.country,
        car!.color,
        car!.persona,
        car!.tipo,
        car!.tipoServicio,
        car!.tipoTransaccion,
        car!.fechaCompra.toString(),
      ];

      // print("Cilindraje: ${car!.cilindraje}");
      // print("Marca: ${car!.brand}");
      // print("Modelo: ${car!.model}");
      // print("Año: ${car!.year}");
      // print("Tipo de Combustible: ${car!.gasType}");
      // print("Clase: ${car!.classType}");
      // print("Cantón: ${car!.canton}");
      // print("País: ${car!.country}");
      // print("Color: ${car!.color}");
      // print("Tipo de Persona: ${car!.persona}");
      // print("Tipo: ${car!.tipo}");
      // print("Tipo de Servicio: ${car!.tipoServicio}");
      // print("Tipo de Transacción: ${car!.tipoTransaccion}");
      // print("Fecha de Compra: ${car!.fechaCompra}");

      try {
        final prediction = await fetchPrediction(features);
        print('Avalúo estimado: $prediction');
        setState(() {
          avaluoEstimado = prediction.toString();
        });

        widget.onAvaluoCalculated(prediction.toString(), car!);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaCompra ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != fechaCompra) {
      setState(() {
        fechaCompra = picked;
        fechaCompraError = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    cilindrajeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CustomSectionCard(
                            headerIcon: Icons.info,
                            headerTitle: 'Información Básica',
                            content: _buildInfoContent(),
                          ),
                          const SizedBox(height: 10),
                          CustomSectionCard(
                              headerIcon: Icons.car_rental,
                              headerTitle: 'Características',
                              content: _buildFeaturesContent())
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          CustomSectionCard(
                              headerIcon: Icons.location_on,
                              headerTitle: 'Ubicación',
                              content: _buidLocationContent()),
                          const SizedBox(height: 10),
                          CustomSectionCard(
                              headerIcon: Icons.person,
                              headerTitle: 'Propiedad y Uso',
                              content: _buildOwnershipContent()),
                          const SizedBox(height: 10),
                          _buildPriceContent()
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              fechaCompraError = _validateFechaCompra();
                            });
                            sendCarDetails();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: primaryColor,
                          ),
                          child: const Text('Valuar Vehículo'),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 16),
                    // const Text('Avalúo Estimado: \$'),
                    // Text(avaluoEstimado),
                  ],
                ),
              ],
            )
            // : Column(
            //     children: [
            //       CustomSectionCard(
            //         headerIcon: Icons.info,
            //         headerTitle: 'Información Básica',
            //         content: _buildInfoContent(),
            //       ),
            //       const SizedBox(height: 10),
            //       CustomSectionCard(
            //           headerIcon: Icons.car_rental,
            //           headerTitle: 'Características',
            //           content: _buildFeaturesContent()),
            //       const SizedBox(height: 10),
            //       CustomSectionCard(
            //           headerIcon: Icons.location_on,
            //           headerTitle: 'Ubicación',
            //           content: _buidLocationContet()),
            //       const SizedBox(height: 10),
            //       CustomSectionCard(
            //           headerIcon: Icons.person,
            //           headerTitle: 'Propiedad y Uso',
            //           content: _buildOwnershipContent()),
            //       const SizedBox(height: 10),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(bottom: 8.0),
            //             child: SizedBox(
            //               width: 200,
            //               child: ElevatedButton(
            //                 onPressed: () {
            //                   setState(() {
            //                     fechaCompraError = _validateFechaCompra();
            //                   });
            //                   sendCarDetails();
            //                 },
            //                 style: ElevatedButton.styleFrom(
            //                   foregroundColor: Colors.black,
            //                   backgroundColor: primaryColor,
            //                 ),
            //                 child: const Text('Valuar Vehículo'),
            //               ),
            //             ),
            //           ),
            //           const SizedBox(width: 16),
            //           const Text('Avalúo Estimado: \$'),
            //           Text(avaluoEstimado),
            //         ],
            //       ),
            //     ],
            //   )
            ),
      ),
    );
  }

  Widget _buildInfoContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: cilindrajeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cilindraje',
            ),
            validator: _validateCilindraje,
            onSaved: (value) => cilindraje = int.parse(value!),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Marca'),
            value: marca,
            items: marcas
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                marca = value!;
              });
              updateModels(value!);
            },
            onSaved: (value) => marca = value!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona una marca' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Modelo'),
            value: modelo,
            items: modelos
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                modelo = value!;
              });
            },
            onSaved: (value) => modelo = value!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona un modelo' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Año Modelo'),
            value: anio,
            items: anios
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                anio = value!;
              });
            },
            onSaved: (value) => anio = value!,
            validator: (value) => value == null || value.isEmpty
                ? 'Selecciona un año modelo'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buidLocationContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'País'),
            value: pais,
            items: paises
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                pais = value!;
              });
            },
            onSaved: (value) => pais = value!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona un país' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Cantón'),
            value: canton,
            items: cantones
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                canton = value!;
              });
            },
            onSaved: (value) => canton = value!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona un cantón' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Clase'),
            value: clase,
            items: clases
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                clase = value!;
              });
            },
            onSaved: (value) => clase = value!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona una clase' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Tipo'),
            value: tipo,
            items: tipos
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                tipo = value!;
              });
            },
            onSaved: (value) => tipo = value!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona un tipo' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Color'),
            value: color,
            items: colores
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                color = value!;
              });
            },
            onSaved: (value) => color = value!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecciona un color' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Tipo de Combustible'),
            value: combustible,
            items: combustibles
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                combustible = value!;
              });
            },
            onSaved: (value) => combustible = value!,
            validator: (value) => value == null || value.isEmpty
                ? 'Selecciona un tipo de combustible'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildOwnershipContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Tipo de Persona'),
            value: persona,
            items: personas
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                persona = value!;
              });
            },
            onSaved: (value) => persona = value!,
            validator: (value) => value == null || value.isEmpty
                ? 'Selecciona un tipo de persona'
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Tipo Servicio'),
            value: tipoServicio,
            items: tiposServicio
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                tipoServicio = value!;
              });
            },
            onSaved: (value) => tipoServicio = value!,
            validator: (value) => value == null || value.isEmpty
                ? 'Selecciona un tipo de servicio'
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Tipo Transacción'),
            value: tipoTransaccion,
            items: tiposTransaccion
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                tipoTransaccion = value!;
              });
            },
            onSaved: (value) => tipoTransaccion = value!,
            validator: (value) => value == null || value.isEmpty
                ? 'Selecciona un tipo de transacción'
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fechaCompra != null
                        ? 'Fecha de Compra: ${DateFormat('dd/MM/yyyy').format(fechaCompra!)}'
                        : 'Fecha de Compra: No seleccionada',
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: primaryColor,
                    ),
                    child: const Text(
                      'Seleccionar Fecha',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              if (fechaCompraError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    fechaCompraError!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceContent() {
    return CustomSectionCard(
      headerIcon: Icons.check_circle,
      headerTitle: 'Resultados',
      content: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'El avalúo del vehículo es:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                avaluoEstimado.isNotEmpty ? '\$$avaluoEstimado' : '-',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
