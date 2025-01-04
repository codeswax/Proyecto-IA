import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/screens/main_screen.dart';
import 'package:proyecto_ia_front/util/constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalúo de Vehículos Usados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor)),
            floatingLabelStyle: TextStyle(color: secondaryColor)),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: secondaryColor,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
