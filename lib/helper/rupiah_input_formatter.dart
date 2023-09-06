import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: 'Rp. 0');
    }

    final amount =
        int.parse(newValue.text.replaceAll('Rp. ', '').replaceAll(',', ''));
    final formattedValue =
        'Rp. ${NumberFormat.decimalPattern('id_ID').format(amount)}';

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
