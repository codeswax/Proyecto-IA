import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';
import 'package:proyecto_ia_front/util/constants.dart';
// import 'package:front_proyecto_ia/components/car_appraisal_details.dart';

class CarAppraisalForm extends StatefulWidget {
  const CarAppraisalForm({super.key});

  @override
  State<CarAppraisalForm> createState() => _CarAppraisalFormState();
}

class _CarAppraisalFormState extends State<CarAppraisalForm> {
  final _formKey = GlobalKey<FormState>();

  String marca = 'Marca 1';
  String modelo = 'Modelo 1';
  String anio = '2025';
  String combustible = 'Gasolina';
  String clase = 'Clase 1';
  String canton = 'Cantón 1';
  String pais = 'País 1';
  String color = 'Color 1';
  String persona = 'Tipo Persona 1';
  String tipo = 'Tipo 1';
  String tipoServicio = 'Tipo Servicio 1';
  String tipoTransaccion = 'Tipo Transacción 1';
  DateTime? fechaCompra;
  String? fechaCompraError;
  int cilindraje = 0;
  final TextEditingController cilindrajeController = TextEditingController();
  Car? car;

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

  void sendCarDetails() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        car = Car(
          brand: marca,
          model: modelo,
          year: anio,
          gasType: combustible,
          classType: clase,
          canton: canton,
          country: pais,
          color: color,
          persona: persona,
          tipo: tipo,
          tipoServicio: tipoServicio,
          tipoTransaccion: tipoTransaccion,
          fechaCompra: fechaCompra!,
          cilindraje: cilindraje,
        );
      });

      print('Cilindraje: ${car!.cilindraje}');
      print('Marca: ${car!.brand}');
      print('Modelo: ${car!.model}');
      print('Año: ${car!.year}');
      print('Tipo de Combustible: ${car!.gasType}');
      print('Clase: ${car!.classType}');
      print('Cantón: ${car!.canton}');
      print('País: ${car!.country}');
      print('Color: ${car!.color}');
      print('Tipo de Persona: ${car!.persona}');
      print('Tipo: ${car!.tipo}');
      print('Tipo de Servicio: ${car!.tipoServicio}');
      print('Tipo de Transacción: ${car!.tipoTransaccion}');
      print('Fecha de Compra: ${car!.fechaCompra}');
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
                  items: ['Marca 1', 'Marca 2', 'Marca 3']
                      .map((String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      marca = value!;
                    });
                  },
                  onSaved: (value) => marca = value!,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona una marca'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  value: modelo,
                  items: ['Modelo 1', 'Modelo 2', 'Modelo 3']
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona un modelo'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Año Modelo'),
                  value: anio,
                  items: ['2025', '2024', '2023']
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Clase'),
                  value: clase,
                  items: ['Clase 1', 'Clase 2', 'Clase 3']
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona una clase'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Combustible'),
                  value: combustible,
                  items: ['Gasolina', 'Diesel', 'Eléctrico']
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'País'),
                  value: pais,
                  items: ['País 1', 'País 2', 'País 3']
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona un país'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Cantón'),
                  value: canton,
                  items: ['Cantón 1', 'Cantón 2', 'Cantón 3']
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona un cantón'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Color'),
                  value: color,
                  items: ['Color 1', 'Colorn 2', 'Color 3']
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona un color'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Persona'),
                  value: persona,
                  items: ['Tipo Persona 1', 'Tipo Persona 2']
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
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  value: tipo,
                  items: ['Tipo 1', 'Tipo 2']
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona un tipo'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Tipo Servicio'),
                  value: tipoServicio,
                  items: ['Tipo Servicio 1', 'Tipo Servicio 2']
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
                  decoration:
                      const InputDecoration(labelText: 'Tipo Transacción'),
                  value: tipoTransaccion,
                  items: ['Tipo Transacción 1', 'Tipo Transacción 2']
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
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          fechaCompra != null
                              ? 'Fecha de Compra: ${DateFormat('dd/MM/yyyy').format(fechaCompra!)}'
                              : 'Fecha de Compra: No seleccionada',
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: primaryColor,
                          ),
                          child: const Text('Seleccionar Fecha'),
                        ),
                        if (fechaCompraError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              fechaCompraError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}
