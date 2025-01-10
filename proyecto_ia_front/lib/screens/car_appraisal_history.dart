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
            subtitle: Text(
              "Cilindraje: ${car.cilindraje}, Combustible: ${car.gasType}, Color: ${car.color}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Generar PDF'),
                          content: const Text(
                              'Esta funcionalidad está en desarrollo.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () => onDelete(index), // Callback para eliminar
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
