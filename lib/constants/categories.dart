import 'package:app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

List<String> getCategoriesTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _nonYamaCategoriesEnglish;
    case languageCodeJapanese:
      return _nonYamaCategoriesJapanese;
    default:
      return _nonYamaCategoriesEnglish;
  }
}

String getSingleCategoryFromId(BuildContext context, String _categoryId) {
  var categoryId = int.parse(_categoryId);
  var countryCode = Localizations.localeOf(context).languageCode;
  switch (countryCode) {
    case languageCodeEnglish:
      return superListEnglish[categoryId];
    case languageCodeJapanese:
      return superListJapanese[categoryId];
    default:
      return superListEnglish[categoryId];
  }
}

String getCategoryIdFromString(BuildContext context, String category) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return superListEnglish.indexOf(category).toString();
    case languageCodeJapanese:
      return superListJapanese.indexOf(category).toString();
    default:
      return superListEnglish.indexOf(category).toString();
  }
}

List<String> getYamaCategoriesTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _yamaCategoriesEnglish;
    case languageCodeJapanese:
      return _yamaCategoriesJapanese;
    default:
      return _yamaCategoriesEnglish;
  }
}

const List<String> _nonYamaCategoriesEnglish = [
  'Hiking',
  'Trail Running',
  'Bicycling',
  'Snow Hiking',
  'Ski',
  'Fast Packing',
  'Workshop',
  'Seminar',
  'Event',
  'Exhibition',
  'Shop',
  'Others',
];
const List<String> _nonYamaCategoriesJapanese = [
  'ハイキング',
  'トレイルランニング',
  'サイクリング',
  'スノーハイキング',
  'スキー',
  'ファストパッキング',
  'ワークショップ',
  'セミナー',
  'イベント',
  '展示',
  'ショップ',
  'そのほか',
];

const List<String> _yamaCategoriesEnglish = [
  'UL Hiking Lecture',
  'UL Hiking Workshop',
  'UL Hiking Practise',
  'Ambassador\'s Signature',
  'Guest Seminar',
  'Local Study Hiking',
  'Yamatomichi Festival'
];

const List<String> _yamaCategoriesJapanese = [
  'ULハイキングレクチャー',
  'ULハイキングワークショップ',
  'ULハイキング実践',
  'アンバサダーシグネチャー',
  'ゲストセミナー',
  'ローカルスタディーハイク',
  '山道祭'
];
List<String> superListEnglish = _nonYamaCategoriesEnglish + _yamaCategoriesEnglish;
List<String> superListJapanese = _nonYamaCategoriesJapanese + _yamaCategoriesJapanese;
