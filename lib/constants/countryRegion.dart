import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';

Map<String, List<String>> getCountriesRegionsTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _countryRegionsEnglish;
    case languageCodeJapanese:
      return _countryRegionsJapanese;
    default:
      return _countryRegionsEnglish;
  }
}

List<String> getCountriesListTranslated(BuildContext context) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _countryEnglish;
    case languageCodeJapanese:
      return _countryJapanese;
    default:
      return _countryEnglish;
  }
}

String getCountryIdFromString(BuildContext context, String country) {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return _countryEnglish.indexOf(country).toString();
    case languageCodeJapanese:
      return _countryJapanese.indexOf(country).toString();
    default:
      return _countryEnglish.indexOf(country).toString();
  }
}

String getRegionIdFromString(BuildContext context, String country, String region) {
  var translatedText = getCountriesRegionsTranslated(context);

  return translatedText[country].indexOf(region).toString();
}

String getRegionTranslated(BuildContext context, String _countryId, String _regionId) {
  var countryId = int.parse(_countryId);
  var regionId = int.parse(_regionId);
  var translatedText = getCountriesRegionsTranslated(context);
  var countryCode = Localizations.localeOf(context).languageCode;
  var country = '';
  switch (countryCode) {
    case languageCodeEnglish:
      country = _countryEnglish[countryId];
      return translatedText[country][regionId];
      break;

    case languageCodeJapanese:
      country = _countryJapanese[countryId];
      return translatedText[country][regionId];
      break;

    default:
      country = _countryEnglish[countryId];
      return translatedText[country][regionId];
      break;
  }
}

String getCountryTranslated(BuildContext context, String _countryId) {
  var countryId = int.parse(_countryId);
  var countryCode = Localizations.localeOf(context).languageCode;
  switch (countryCode) {
    case languageCodeEnglish:
      return _countryEnglish[countryId];
      break;

    case languageCodeJapanese:
      return _countryJapanese[countryId];
      break;

    default:
      return _countryEnglish[countryId];
      break;
  }
}

const List<String> _countryEnglish = ['Japan', 'Taiwan', 'Hong Kong'];
const List<String> _countryJapanese = ['日本', '台湾', '香港'];
const Map<String, List<String>> _countryRegionsEnglish = {
  'Japan': [
    'Hokkaido',
    'Tohoku',
    'Kanto',
    'Chubu',
    'Kinki/Kansai',
    'Chugoku',
    'Shikoku',
    'Kyushu (incl. Okinawa)',
    'Other',
  ],
  'Taiwan': [
    'Northern Taiwan',
    'Central Taiwan',
    'Southern Taiwan',
    'Eastern Taiwan',
    'Outer islands',
    'Other',
  ],
  'Hong Kong': [
    'Islands',
    'Kwai Tsing',
    'North',
    'Sai Kung',
    'Sha Tin',
    'Tai Po',
    'Tsuen Wan',
    'Tuen Mun',
    'Yuen Long',
    'Kowloon City',
    'Kwun Tong',
    'Sham Shui Po',
    'Wong Tai Sin',
    'Yau Tsim Mong',
    'Central and Western',
    'Eastern',
    'Southern',
    'Wan Chai',
    'Other',
  ],
};

const Map<String, List<String>> _countryRegionsJapanese = {
  '日本': [
    '北海道',
    '東北',
    '関東地方',
    '中部地方',
    '関西地方',
    '中国地方',
    '四国',
    '沖縄を含む九州',
    'その他',
  ],
  '台湾': [
    '台湾北部',
    'Central Taiwan',
    'Southern Taiwan',
    'Eastern Taiwan',
    'Outer islands',
    'Other',
  ],
  '香港': [
    'Islands',
    'Kwai Tsing',
    'North',
    'Sai Kung',
    'Sha Tin',
    'Tai Po',
    'Tsuen Wan',
    'Tuen Mun',
    'Yuen Long',
    'Kowloon City',
    'Kwun Tong',
    'Sham Shui Po',
    'Wong Tai Sin',
    'Yau Tsim Mong',
    'Central and Western',
    'Eastern',
    'Southern',
    'Wan Chai',
    'Other',
  ],
};
