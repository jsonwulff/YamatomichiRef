import 'package:app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization


List<String> getCategoriesTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _categoriesEnglish;
    case languageCodeJapanese:
      return _categoriesJapanese(context);
    default:
      return _categoriesEnglish;
  }
}

const List<String> _categoriesEnglish = [
  'Hike',
  'Snow Hike',
  'Fastpacking',
  'Ski',
  'UL 101',
  'Run',
  'Popup',
  'MYOG Workshop',
  'Repair Workshop',
  'Other'
];

List<String> _categoriesJapanese(BuildContext context) {
  var texts = AppLocalizations.of(context);

  return [
    texts.hike,
    'Snow Hike',
    'Fastpacking',
    'Ski',
    'UL 101',
    'Run',
    'Popup',
    'MYOG Workshop',
    'Repair Workshop',
    'Other'
  ];
}
