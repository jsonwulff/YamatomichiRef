import 'package:flutter/material.dart';

const List<Color> profileImageColors = [Colors.blue, Colors.green, Colors.red];
const List<String> gendersList = [
  'Male',
  'Female',
  'Other',
  'Prefer not to disclose'
];
const List<String> countriesList = ['Japan', 'Korea', 'China'];
const Map<String, List<String>> countryRegions = {
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
  'Korea': [
    'North Chungcheong',
    'South Chungcheong',
    'Gangwon',
    'Gyeonggi',
    'North Gyeongsang',
    'South Gyeongsang',
    'North Jeolla',
    'South Jeolla',
    'Jeju',
    'Other',
  ],
  'China': [
    'North China',
    'Northeast China',
    'East China',
    'South Central China',
    'South Central China',
    'Southwest China',
    'Northwest China',
    'Other',
  ]
};
