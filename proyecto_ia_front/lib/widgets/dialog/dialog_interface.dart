import 'package:flutter/material.dart';

abstract class DialogService {
  Future<void> showExceptionDialog(BuildContext context, String exception);
  Future<void> showLoadingDialog(BuildContext context, String message);
}
