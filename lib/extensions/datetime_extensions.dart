import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Gets only [year], [month], and [day] components of the current instance
  /// of [DateTime] object.
  DateTime get date => DateTime(year, month, day);

  String getDateOnly() => DateFormat('dd/MM/yyyy').format(this);

  String getTimeOnly() => DateFormat('hh:mm a').format(this);

  String getTime24HoursOnly() => DateFormat.Hm().format(this);

  String getHourMinute() => DateFormat('HH:mm').format(this);

  String getDateOnly2() => DateFormat('dd MMM yyyy').format(this);

  String getDateOnly3() => DateFormat('MMM dd, yyyy').format(this);

  String getShortMonthDate() => DateFormat('dd MMM yyyy').format(this);

  String getDayDate() => DateFormat('EEE MMM dd').format(this);

  DateTime startOfDay() => DateTime(year, month, day);
}
