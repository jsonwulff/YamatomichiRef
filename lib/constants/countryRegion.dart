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