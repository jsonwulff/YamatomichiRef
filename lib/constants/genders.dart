import 'package:app/constants/constants.dart';
import 'package:flutter/cupertino.dart';

List<String> getGendersListTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _gendersListEnglish;
    case languageCodeJapanese:
      return _gendersListJapanese;
    default:
      return _gendersListEnglish;
  }
}

int getGenderIdFromString(BuildContext context, String gender) {
  return getGendersListTranslated(context).indexOf(gender);
}

String getGenderTranslated(BuildContext context, String _genderId) {
  var genderId = int.parse(_genderId);
  return getGendersListTranslated(context)[genderId];
}

const List<String> _gendersListEnglish = [
  'Male',
  'Female',
  'Other',
  'Prefer not to disclose'
];

const List<String> _gendersListJapanese = ['男性', '女性', 'その他', '公開したくない'];
