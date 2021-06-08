import 'package:flutter/material.dart';

class PacklistFilterNotifier with ChangeNotifier {
  RangeValues _currentDaysValues;
  RangeValues _currentTotalWeight;
  List<bool> _selectedSeasons;
  bool _showYamaGeneratedPacklists;
  List<bool> _selectedCategories;

  // ignore: unnecessary_getters_setters
  RangeValues get currentDaysValues => _currentDaysValues;
  // ignore: unnecessary_getters_setters
  RangeValues get currentTotalWeight => _currentTotalWeight;
  // ignore: unnecessary_getters_setters
  List<bool> get selectedSeasons => _selectedSeasons;
  // ignore: unnecessary_getters_setters
  bool get showYamaGeneratedPacklists => _showYamaGeneratedPacklists;
  // ignore: unnecessary_getters_setters
  List<bool> get selectedCategories => _selectedCategories;

  // ignore: unnecessary_getters_setters
  set currentDaysValues(
    RangeValues currentDaysValues,
  ) {
    _currentDaysValues = currentDaysValues;
  }

  // ignore: unnecessary_getters_setters
  set currentTotalWeight(
    RangeValues currentTotalWeight,
  ) {
    _currentTotalWeight = currentTotalWeight;
  }

  // ignore: unnecessary_getters_setters
  set selectedSeasons(List<bool> selectedSeasons) {
    _selectedSeasons = selectedSeasons;
  }

  // ignore: unnecessary_getters_setters
  set showYamaGeneratedPacklists(bool showYamaGeneratedPacklists) {
    _showYamaGeneratedPacklists = showYamaGeneratedPacklists;
  }

  // ignore: unnecessary_getters_setters
  set selectedCategories(List<bool> selectedCategories) {
    _selectedCategories = selectedCategories;
  }

  remove() {
    _selectedSeasons = null;
    _currentDaysValues = null;
    _currentTotalWeight = null;
    _showYamaGeneratedPacklists = null;
    _selectedCategories = null;
  }
}
