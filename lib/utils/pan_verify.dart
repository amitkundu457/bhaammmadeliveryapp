import 'package:flutter/services.dart';

class PANCardTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toUpperCase();

    newText = newText.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    StringBuffer formatted = StringBuffer();
    int letterCount = 0;
    int digitCount = 0;

    for (int i = 0; i < newText.length; i++) {
      if (letterCount < 5 && _isLetter(newText[i])) {
        formatted.write(newText[i]);
        letterCount++;
      } else if (letterCount >= 5 && digitCount < 4 && _isDigit(newText[i])) {
        formatted.write(newText[i]);
        digitCount++;
      } else if (letterCount == 5 && digitCount == 4 && _isLetter(newText[i])) {
        formatted.write(newText[i]);
        letterCount++;
      }
    }

    if (formatted.length <= 10) {
      return TextEditingValue(
        text: formatted.toString(),
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return TextEditingValue(
      text: formatted.toString().substring(0, 10),
      selection: const TextSelection.collapsed(offset: 10),
    );
  }

  bool _isLetter(String input) {
    return RegExp(r'[a-zA-Z]').hasMatch(input);
  }

  bool _isDigit(String input) {
    return RegExp(r'[0-9]').hasMatch(input);
  }
}
