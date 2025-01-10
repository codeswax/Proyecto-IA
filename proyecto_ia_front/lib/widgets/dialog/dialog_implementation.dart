import 'package:flutter/material.dart';
import 'package:proyecto_ia_front/widgets/dialog/dialog_interface.dart';

class DialogImplementation implements DialogService {
  @override
  Future<void> showLoadingDialog(BuildContext context, String message) async {
    if (!context.mounted) return;
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Cargando...'),
        content: Row(
          children: [
            const CircularProgressIndicator(color: Colors.blue),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(message),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> showExceptionDialog(
      BuildContext context, String exception) async {
    if (!context.mounted) return;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.error,
              size: 20,
              color: Colors.red[900],
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(exception),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
