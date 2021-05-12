import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime date) {
  if (date == null) return "";
  return DateFormat('dd-MM-yyyy - kk:mm').format(date);
}

String formatCalendarDateTime(BuildContext context, DateTime startDate, DateTime endDate) {
  var buffer = StringBuffer();

  buffer.write(startDate.day);
  buffer.write('.');
  buffer.write(_getMonthWith3LettersAsString(context, startDate));

  buffer.write(' - ');

  buffer.write(endDate.day);
  buffer.write('.');
  buffer.write(_getMonthWith3LettersAsString(context, endDate));

  return buffer.toString();
}

String _getMonthWith3LettersAsString(BuildContext context, DateTime date) {
  var texts = AppLocalizations.of(context);

  switch (date.month) {
    case 1:
      return texts.jan;
    case 2:
      return texts.feb;
    case 3:
      return texts.mar;
    case 4:
      return texts.apr;
    case 5:
      return texts.may;
    case 6:
      return texts.jun;
    case 7:
      return texts.jul;
    case 8:
      return texts.aug;
    case 9:
      return texts.sep;
    case 10:
      return texts.okt;
    case 11:
      return texts.nov;
    case 12:
      return texts.dec;
  }

  return null;
}
