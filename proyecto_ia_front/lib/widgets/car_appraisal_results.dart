// import 'package:flutter/material.dart';
// import 'package:proyecto_ia_front/models/car.dart';
// import 'package:proyecto_ia_front/util/constants.dart';
// import 'package:proyecto_ia_front/widgets/custom_section_card.dart';

// class CarAppraisalResults extends StatelessWidget {
//   final String avaluoEstimado;
//   //final Car? car;

//   const CarAppraisalResults({
//     super.key,
//     required this.avaluoEstimado,
//     //required this.car,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(color: cardColor),
//       child: avaluoEstimado.isEmpty
//           ? _buildEmptyContent()
//           : SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CustomSectionCard(
//                       headerIcon: Icons.analytics,
//                       headerTitle: 'Resultados',
//                       content: Column(
//                         children: [
//                           _buildPriceContent(),
//                           //_buildCarStats(car!),
//                         ],
//                       ),
//                       color: backgroundColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildPriceContent() {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Text(
//             'El avalúo del vehículo es:',
//             style: TextStyle(
//               fontSize: 18,
//             ),
//           ),
//           Text(
//             avaluoEstimado.isNotEmpty ? '\$$avaluoEstimado' : '-',
//             style: const TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//               color: primaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyContent() {
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(bottom: 10.0),
//           child: Icon(
//             Icons.pending_actions,
//             size: 60,
//             color: primaryColor,
//           ),
//         ),
//         Text(
//           'Aquí se mostrarán los resultados.',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCarStats(Car car) {
//     final Map<String, dynamic> carStuff = car.toMap();
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 4.0,
//         mainAxisSpacing: 4.0,
//         childAspectRatio: 2.5,
//       ),
//       itemCount: carStuff.entries.length,
//       itemBuilder: (context, index) {
//         final entry = carStuff.entries.elementAt(index);
//         return Card(
//           elevation: 2,
//           color: primaryColor,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   entry.key,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                       color: backgroundColor),
//                 ),
//                 Text(
//                   entry.value.toString(),
//                   style: const TextStyle(fontSize: 12, color: backgroundColor),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
