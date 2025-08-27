import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydrivenepal/shared/constant/constants.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

import 'util.dart';

String convertStringToDateFormat(String dateString, {format = ''}) {
  try {
    int indexOfT = dateString.indexOf("T");
    if (indexOfT != -1) {
      var parts = dateString.split("T")[0].split("-");
      var timeParts = dateString.split("T")[1].split(":");
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      int second = int.parse(timeParts[2].split(".")[0]);
      DateTime utcTime = DateTime.utc(year, month, day, hour, minute, second);
      String formattedDate = DateFormat(format).format(utcTime.toLocal());
      return formattedDate;
    } else {
      return "Invalid input";
    }
  } catch (e) {
    return "Error occurred: $e";
  }
}

String formatDate(String inputDateString) {
  DateTime inputDate = DateTime.parse(inputDateString);

  String formattedDate = DateFormat("MMM d, y").format(inputDate.toLocal());

  return (formattedDate);
}

String formatDateOnly(String? inputDateString) {
  // Handle null, empty, or N/A cases
  if (!isNotEmpty(inputDateString) ||
      inputDateString == null ||
      inputDateString.trim().isEmpty ||
      inputDateString == "N/A") {
    return 'N/A';
  }

  try {
    // Parse the date string
    DateTime inputDate = DateTime.parse(inputDateString.trim());

    // Format the date

    String formattedDate =
        DateFormat(DateFormatConstant.MM_DD_YY).format(inputDate);

    return formattedDate;
  } catch (e) {
    // Handle any parsing errors
    print('Error parsing date: $inputDateString - Error: $e');
    return 'N/A';
  }
}

DateTime getCurrentDate() {
  DateTime now = DateTime.now();
  DateTime currentDate = DateTime(now.year, now.month, now.day);
  return currentDate;
}

DateTime getPreviousYearDate() {
  DateTime now = DateTime.now();
  DateTime previousYearDate = DateTime(now.year - 1, now.month, now.day);
  return previousYearDate;
}

String convertCurrentTimeToUtc() {
  try {
    DateTime localTime = DateTime.now();
    DateTime utcTime = localTime.toUtc();
    String formattedUtcTime =
        DateFormat(DateFormatConstant.DEFAULT).format(utcTime);

    return formattedUtcTime;
  } catch (e) {
    return "Error: $e";
  }
}

String getDayFromDate(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);
    String dayOfWeek = DateFormat('EEEE').format(dateTime);
    return dayOfWeek;
  } catch (e) {
    return "Error: $e";
  }
}

DateTime getDateFromString(String date1) {
  String inputDate = date1;
  DateFormat inputFormat = DateFormat(DateFormatConstant.MM_DD_YY);
  DateTime date = inputFormat.parse(inputDate);
  return date;
}

String formatRegisterDate(String inputDate,
    {String format = DateFormatConstant.MM_DD_YY}) {
  DateTime parsedDate =
      DateFormat(DateFormatConstant.YYYY_MM_DD).parse(inputDate);

  // Format the parsed date to 'MM/dd/yyyy' by default
  String formattedDate = DateFormat(format).format(parsedDate);

  return formattedDate;
}

Future<DateTime?> openDatePicker(BuildContext context) async {
  final appColors = context.appColors;

  DateTime? selectedDate = await showDatePickerDialog(
    context: context,
    minDate: DateTime.now().subtract(
      const Duration(days: 36000000),
    ),
    currentDate: DateTime.now(),
    // controller.text.isNotEmpty ? getDateForDob(controller.text) : null,
    maxDate: DateTime.now(),
    enabledCellsTextStyle: Theme.of(context).textTheme.labelLarge,
    disabledCellsTextStyle: Theme.of(context)
        .textTheme
        .labelLarge!
        .copyWith(color: appColors.gray.soft),
    currentDateTextStyle: Theme.of(context).textTheme.labelLarge!,
    selectedCellTextStyle: Theme.of(context).textTheme.labelLarge!,
  );
  print("selectedDate: $selectedDate");
  return selectedDate;
}

String getFormattedDateForConversation(DateTime? date) {
  if (date == null) {
    return "";
  }
  return DateFormat(DateFormatConstant.MM_DD_YY).format(date.toLocal());
}

int getUnixTimeFromDate(DateTime? date) {
  if (date == null) {
    return 0;
  }
  return date.toUtc().millisecondsSinceEpoch ~/ 1000;
}

DateTime? getDateFromUnixTime(int? unixTime) {
  if (unixTime == null || unixTime == 0) {
    return null;
  }
  return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000, isUtc: true)
      .toLocal();
}
