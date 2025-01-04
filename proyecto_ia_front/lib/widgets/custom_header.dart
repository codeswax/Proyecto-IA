import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/util/constants.dart';
import 'package:proyecto_ia_front/util/responsive.dart';

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
            if (!Responsive.isDesktop(context))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: const Icon(Icons.menu, color: primaryColor, size: 30),
                  onTap: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  headerTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
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
