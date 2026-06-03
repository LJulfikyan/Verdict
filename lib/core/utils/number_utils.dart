import 'package:intl/intl.dart';

abstract final class NumberUtils {
  static String compact(num value) => NumberFormat.compact().format(value);
}
