import 'package:flutter/services.dart';

class DecimalAmountInputFormatter extends TextInputFormatter {
  const DecimalAmountInputFormatter();

  static final RegExp _pattern = RegExp(r'^[0-9]*[.,]?[0-9]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    if (_pattern.hasMatch(newValue.text)) return newValue;
    return oldValue;
  }
}
