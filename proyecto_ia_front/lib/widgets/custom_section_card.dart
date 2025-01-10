import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/util/constants.dart';

class CustomSectionCard extends StatelessWidget {
  final IconData headerIcon;
  final String headerTitle;
  final Widget content;
  final Color color;

  const CustomSectionCard({
    super.key,
    required this.headerIcon,
    required this.headerTitle,
    required this.content,
    this.color = cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    headerIcon,
                    size: 24,
                    color: primaryColor,
                  ),
                ),
                Text(
                  headerTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          content,
        ],
      ),
    );
  }
}
