import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/models/car.dart';

class CarAppraisalHistory extends StatelessWidget {
  final List<Car> history;
  final Function(int) onDelete;

  const CarAppraisalHistory({
    super.key,
    required this.history,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final car = history[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(
              "${car.brand} ${car.model} (${car.year}) - Avalúo: \$${car.avaluo}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cilindraje: ${car.cilindraje}, Combustible: ${car.gasType}, Color: ${car.color},  Fecha de Compra: ${car.fechaCompra}",
                ),
                Text(
                  "Cantón: ${car.canton}, País: ${car.country}",
                ),
                Text(
                  "Tipo: ${car.tipo}, Tipo Clase: ${car.cilindraje}, Tipo Persona: ${car.classType}, Tipo Servicio: ${car.tipoServicio}, Tipo Transacción: ${car.tipoTransaccion}",
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () => onDelete(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
