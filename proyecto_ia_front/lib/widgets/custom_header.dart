import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/util/constants.dart';

class CustomHeader extends StatelessWidget {
  final String headerTitle;
  const CustomHeader({super.key, required this.headerTitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: cardColor,
        child: Row(
          children: [
            Expanded(
              child: Text(
                headerTitle,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
