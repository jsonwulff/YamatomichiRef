import 'package:flutter/material.dart';

const Map<String, Map<String, List<String>>> coutryRegions = {
  'English' : countryRegionsEnglish,
  'Japanese' : countryRegionsJapanese,
};

const Map<String, List<String>> countryList = {
  'Egnlish': countriesListEnglish,
  'Japanese' : countriesListJapanese,
};

const Map<String, List<String>> genderList = {
  'Egnlish' : gendersListEnglish,
  'Japanese' : gendersListJapanese,
};

const List<Color> profileImageColors = [Colors.blue, Colors.green, Colors.red];

const List<String> gendersListEnglish = [
  'Male',
  'Female',
  'Other',
  'Prefer not to disclose'
];
const List<String> gendersListJapanese = [
  '男性',
  '女性',
  'その他',
  '公開したくない'
];

const List<String> countriesListEnglish = ['Japan', 'Taiwan', 'Hong Kong'];
const List<String> countriesListJapanese = ['日本', '台湾', '香港'];

const Map<String, List<String>> countryRegionsEnglish = {
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
const Map<String, List<String>> countryRegionsJapanese = {
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

List<String> listOfMonths = [
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MAY",
  "JUN",
  "JUL",
  "AUG",
  "SEP",
  "OCT",
  "NOV",
  "DEC"
];

List<String> listOfDays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
