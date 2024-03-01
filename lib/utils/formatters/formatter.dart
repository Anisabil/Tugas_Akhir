import 'package:intl/intl.dart';

class FVFormatter {
  static String formatDate(DateTime date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_IDN', symbol: 'Rp').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    return phoneNumber;
  }
}
