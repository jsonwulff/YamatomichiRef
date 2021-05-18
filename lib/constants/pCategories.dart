import 'package:app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

List<String> getPCategoriesTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _CategoriesEnglish;
    case languageCodeJapanese:
      return _CategoriesJapanese;
    default:
      return _CategoriesEnglish;
  }
}

String getPSingleCategoryFromId(BuildContext context, String _categoryId) {
  print(_categoryId);
  var categoryId = int.parse(_categoryId);
  var countryCode = Localizations.localeOf(context).languageCode;
  switch (countryCode) {
    case languageCodeEnglish:
      return _CategoriesEnglish[categoryId];
    case languageCodeJapanese:
      return _CategoriesJapanese[categoryId];
    default:
      return _CategoriesEnglish[categoryId];
  }
}

String getPCategoryIdFromString(BuildContext context, String category) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _CategoriesEnglish.indexOf(category).toString();
    case languageCodeJapanese:
      return _CategoriesJapanese.indexOf(category).toString();
    default:
      return _CategoriesEnglish.indexOf(category).toString();
  }
}

const List<String> _CategoriesEnglish = [
  'Hiking',
  'Trail Running',
  'Bicycling',
  'Snow Hiking',
  'Ski',
  'Fast Packing',
  'Others',
];
const List<String> _CategoriesJapanese = [
  'ハイキング',
  'トレイルランニング',
  'サイクリング',
  'スノーハイキング',
  'スキー',
  'ファストパッキング',
  'そのほか',
];
