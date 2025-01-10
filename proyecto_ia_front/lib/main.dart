import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/screens/main_screen.dart';
import 'package:proyecto_ia_front/util/constants.dart';
import 'package:proyecto_ia_front/widgets/data_table/car_table_scroll.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalúo de Vehículos Usados',
      scrollBehavior: MyCustomScrollBehavior(),
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
        dataTableTheme: DataTableThemeData(
          headingRowColor: WidgetStateProperty.resolveWith(
            (states) => primaryColor,
          ),
          headingTextStyle: const TextStyle(
            color: backgroundColor,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
