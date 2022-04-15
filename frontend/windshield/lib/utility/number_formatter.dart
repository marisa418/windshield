import 'package:intl/intl.dart';

class HelperNumber {
  static final formatter = NumberFormat(',###.##');
  static String format(double number) {
    return formatter.format(number);
  }
}
