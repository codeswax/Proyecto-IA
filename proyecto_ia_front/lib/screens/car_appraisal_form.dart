import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';
// import 'package:front_proyecto_ia/components/car_appraisal_details.dart';

class CarAppraisalForm extends StatefulWidget {
  const CarAppraisalForm({super.key});

  @override
  State<CarAppraisalForm> createState() => _CarAppraisalFormState();
}

class _CarAppraisalFormState extends State<CarAppraisalForm> {
  final _formKey = GlobalKey<FormState>();

  String brand = '';
  String model = '';
  String year = '';
  String gasType = 'Gasolina';
  String classType = '';
  String canton = '';
  Car? car;

  void sendCarDetails() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        car = Car(
          brand: brand,
          model: model,
          year: year,
          gasType: gasType,
          classType: classType,
          canton: canton,
        );
      });

      print('Marca: ${car!.brand}');
      print('Modelo: ${car!.model}');
      print('Año: ${car!.year}');
      print('Tipo de Combustible: ${car!.gasType}');
      print('Clase: ${car!.classType}');
      print('Cantón: ${car!.canton}');

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CarAppraisalDetails(car: car!),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Marca'),
              validator: (value) =>
                  value!.isEmpty ? 'Por favor, ingresa la marca' : null,
              onSaved: (value) => brand = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Modelo'),
              validator: (value) =>
                  value!.isEmpty ? 'Por favor, ingresa el modelo' : null,
              onSaved: (value) => model = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Año'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el año';
                }
                int? yearInt = int.tryParse(value);
                if (yearInt == null ||
                    yearInt < 1900 ||
                    yearInt > DateTime.now().year) {
                  return 'Ingresa un año válido';
                }
                return null;
              },
              onSaved: (value) => year = value!,
            ),
            DropdownButtonFormField(
              decoration:
                  const InputDecoration(labelText: 'Tipo de Combustible'),
              value: gasType,
              items: ['Gasolina', 'Diesel', 'Eléctrico']
                  .map((String value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  gasType = value!;
                });
              },
              onSaved: (value) => gasType = value!,
              validator: (value) => value == null || value.isEmpty
                  ? 'Selecciona un tipo de combustible'
                  : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Clase'),
              validator: (value) =>
                  value!.isEmpty ? 'Por favor, ingresa la clase' : null,
              onSaved: (value) => classType = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Cantón'),
              validator: (value) =>
                  value!.isEmpty ? 'Por favor, ingresa el cantón' : null,
              onSaved: (value) => canton = value!,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: sendCarDetails,
                child: const Text('Valuar Vehículo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
