// ignore_for_file: file_names

import 'package:intl/intl.dart';

class DateUtility {
  static const String _dateFormatDescriptive = "MMM dd, yyyy";
  static const String _dateFormat = "dd-MM-yyyy"; //Display Date in mobile
  static const String _dateTimeFormat =
      "dd-MM-yyyy hh:mm:ss aa"; //Display DateTime
  static const String _timeFormatDescriptive = "hh:mm aa";

  static const String _apiDateFormat = "yyyy-MM-dd"; //Date format from API
  static const String _apiDateTimeFormat =
      "yyyy-MM-dd hh:mm:ss"; //Date Time Format From API
  static const String _apiTimeFormat = "hh:mm";

  //region DISPLAY DATA
  //Returns String which use to display to 12Hrs format
  static String getDisplayTimeDescriptiveFormat(DateTime? selectedDate) {
    if (selectedDate == null) return "-";
    return DateFormat(
      DateUtility._timeFormatDescriptive,
    ).format(selectedDate);
  }

  //Returns String which use to display to user dd-MM-yyyy
  static String getDisplayDateDescriptiveFormat(DateTime? selectedDate) {
    if (selectedDate == null) return "-";
    return DateFormat(
      DateUtility._dateFormatDescriptive,
    ).format(selectedDate);
  }

  //Returns String which use to display to user dd-MM-yyyy
  static String getDisplayDate(DateTime? selectedDate) {
    if (selectedDate == null) return "-";
    return DateFormat(
      DateUtility._dateFormat,
    ).format(selectedDate);
  }

  static String getDisplayDateTime(DateTime? selectedDate) {
    if (selectedDate == null) return "-";
    return DateFormat(
      DateUtility._dateTimeFormat,
    ).format(selectedDate);
  }
  //endregion

  //region FROM API

  //Parse string api date to DateTime datatype yyyy-MM-dd
  static DateTime? convertAPITime(String date) {
    try {
      return DateFormat(DateUtility._apiTimeFormat).parse(date);
    } catch (e) {
      return null;
    }
  }

  //Parse string api date to DateTime datatype yyyy-MM-dd
  static DateTime? convertAPIDate(String date) {
    try {
      return DateFormat(DateUtility._apiDateFormat).parse(date);
    } catch (e) {
      return null;
    }
  }

  //Parse string api date to DateTime datatype yyyy-MM-dd hh:mm:ss
  static DateTime? convertAPIDateTime(String date) {
    try {
      return DateFormat(DateUtility._apiDateTimeFormat).parse(date);
    } catch (e) {
      return null;
    }
  }

  //Parse the User Display Date Format dd-MM-yyyy to yyyy-MM-dd
  static String parseToAPIDate(String dateTime) {
    var cdateTime = DateFormat(DateUtility._dateFormat).parse(dateTime);
    return DateFormat(DateUtility._apiDateFormat).format(cdateTime);
  }

  static String parseToAPIDateByDate(DateTime dateTime) {
    return DateFormat(DateUtility._apiDateFormat).format(dateTime);
  }

  //endregion

  //region Between Dates
  static bool _isAfterOrEqualTo(DateTime compareDate, DateTime currentDate) {
    final isAtSameMomentAs = compareDate.isAtSameMomentAs(currentDate);
    return isAtSameMomentAs | currentDate.isAfter(compareDate);
  }

  static bool _isBeforeOrEqualTo(DateTime compareDate, DateTime currentDate) {
    final isAtSameMomentAs = compareDate.isAtSameMomentAs(currentDate);
    return isAtSameMomentAs | currentDate.isBefore(compareDate);
  }

  static bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
    DateTime currentDate,
  ) {
    final isAfter = _isAfterOrEqualTo(fromDateTime, currentDate);
    final isBefore = _isBeforeOrEqualTo(toDateTime, currentDate);
    return isAfter && isBefore;
  }

  static String convertTo12Hour(String timeOfDay) {
    // Split timeOfDay into hours and minutes
    var hours = int.parse(timeOfDay.split(':')[0]);
    var minutes = int.parse(timeOfDay.split(':')[1]);

    // Convert to 12 hour format
    String period = 'AM';
    if (hours == 0) {
      hours = 12;
    } else if (hours == 12) {
      period = 'PM';
    } else if (hours > 12) {
      hours = hours % 12;
      period = 'PM';
    }

    // Construct the final time string
    String hourString = hours.toString().padLeft(2, '0');
    String minuteString = minutes.toString().padLeft(2, '0');
    return '$hourString:$minuteString $period';
  }

  static String convertDateDDMMMYYYY(String dateToConvert) {
    DateTime dt = DateTime.parse(dateToConvert);
    final DateFormat format = DateFormat('dd MMM yyyy');
    final String formattedDate = format.format(dt);
    return formattedDate;
    // print("DATE----> $formatted");
  }

  static String convertDateDDMMMYY(String dateToConvert) {
    DateTime dt = DateTime.parse(dateToConvert);
    final DateFormat format = DateFormat('dd MMM yy');
    final String formattedDate = format.format(dt);
    // ignore: avoid_print
    print("DATE----> $formattedDate");

    return formattedDate;
  }

  static String convertDate(String dateToConvert) {
    DateTime dt = DateTime.parse(dateToConvert);
    final DateFormat format = DateFormat('dd MMM yyyy');
    final String formattedDate = format.format(dt);
    return formattedDate;
    // print("DATE----> $formatted");
  }
  //endregion
}
