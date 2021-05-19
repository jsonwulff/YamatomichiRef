import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';

List<String> getSeasonListTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _seasonCategoriesEnglish;
    case languageCodeJapanese:
      return _seasonCategoriesJapanese;
    default:
      return _seasonCategoriesEnglish;
  }
}

String getSeasonCategoryFromId(BuildContext context, String _categoryId) {
  print(_categoryId);
  var categoryId = int.parse(_categoryId);
  var countryCode = Localizations.localeOf(context).languageCode;
  switch (countryCode) {
    case languageCodeEnglish:
      return _seasonCategoriesEnglish[categoryId];
    case languageCodeJapanese:
      return _seasonCategoriesJapanese[categoryId];
    default:
      return _seasonCategoriesEnglish[categoryId];
  }
}

String getSeasonIdFromString(BuildContext context, String category) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _seasonCategoriesEnglish.indexOf(category).toString();
    case languageCodeJapanese:
      return _seasonCategoriesJapanese.indexOf(category).toString();
    default:
      return _seasonCategoriesEnglish.indexOf(category).toString();
  }
}

const List<String> _seasonCategoriesEnglish = [
  'Fall',
  'Winter',
  'Summer',
  'Spring',
];
const List<String> _seasonCategoriesJapanese = [
  '春',
  '冬',
  '夏',
  '秋',
];
