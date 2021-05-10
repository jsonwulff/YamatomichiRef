import 'package:flutter/material.dart';

class PacklistFilterNotifier with ChangeNotifier {
  RangeValues _currentDaysValues;
  RangeValues _currentTotalWeight;
  List<bool> _selectedSeasons;
  bool _showYamaGeneratedPacklists;
  List<bool> _selectedCategories;

  RangeValues get currentDaysValues => _currentDaysValues;
  RangeValues get currentTotalWeight => _currentTotalWeight;
  List<bool> get selectedSeasons => _selectedSeasons;
  bool get showYamaGeneratedPacklists => _showYamaGeneratedPacklists;
  List<bool> get selectedCategories => _selectedCategories;

  set currentDaysValues(
    RangeValues currentDaysValues,
  ) {
    _currentDaysValues = currentDaysValues;
  }

  set currentTotalWeight(
    RangeValues currentTotalWeight,
  ) {
    _currentTotalWeight = currentTotalWeight;
  }

  set selectedSeasons(List<bool> selectedSeasons) {
    _selectedSeasons = selectedSeasons;
  }

  set showYamaGeneratedPacklists(bool showYamaGeneratedPacklists) {
    _showYamaGeneratedPacklists = showYamaGeneratedPacklists;
  }

  set selectedCategories(List<bool> selectedCategories) {
    _selectedCategories = selectedCategories;
  }

  remove() {
    _selectedSeasons = null;
    _currentDaysValues = null;
    _currentTotalWeight = null;
    _showYamaGeneratedPacklists = null;
    _selectedCategories = null;
    print('values removed from filter notifier');
  }
}
