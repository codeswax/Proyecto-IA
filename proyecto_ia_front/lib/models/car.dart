class Car {
  final int cilindraje;
  final String brand;
  final String model;
  final String year;
  final String gasType;
  final String classType;
  final String canton;
  final String country;
  final String color;
  final String persona;
  final String tipo;
  final String tipoServicio;
  final String tipoTransaccion;
  final DateTime fechaCompra;

  Car({
    required this.cilindraje,
    required this.brand,
    required this.model,
    required this.year,
    required this.gasType,
    required this.classType,
    required this.canton,
    required this.country,
    required this.color,
    required this.persona,
    required this.tipo,
    required this.tipoServicio,
    required this.tipoTransaccion,
    required this.fechaCompra,
  });

  Map<String, dynamic> toMap() {
    return {
      'Cilindraje': cilindraje,
      'Marca': brand,
      'Modelo': model,
      'Año': year,
      'Tipo de Gasolina': gasType,
      'Clase': classType,
      'Cantón': canton,
      'País': country,
      'Color': color,
      'Persona': persona,
      'Tipo': tipo,
      'Tipo de Servicio': tipoServicio,
      'Tipo de Transacción': tipoTransaccion,
      'Fecha de Compra': fechaCompra.toIso8601String(),
    };
  }
}
