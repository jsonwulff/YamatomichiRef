import 'package:flutter/material.dart';

class EventFilterNotifier with ChangeNotifier {
  RangeValues _currentOpenSpotsValues;
  RangeValues _currentDaysValues;
  String _country;
  String _region;
  bool _showMeGeneratedEvents;
  bool _showUserGeneratedEvents;
  bool _showYamaGeneratedEvents;
  List<bool> _selectedCategories;

  // ignore: unnecessary_getters_setters
  RangeValues get currentOpenSpotsValues => _currentOpenSpotsValues;
  // ignore: unnecessary_getters_setters
  RangeValues get currentDaysValues => _currentDaysValues;
  // ignore: unnecessary_getters_setters
  String get country => _country;
  // ignore: unnecessary_getters_setters
  String get region => _region;
  // ignore: unnecessary_getters_setters
  bool get showMeGeneratedEvents => _showMeGeneratedEvents;
  // ignore: unnecessary_getters_setters
  bool get showUserGeneratedEvents => _showUserGeneratedEvents;
  // ignore: unnecessary_getters_setters
  bool get showYamaGeneratedEvents => _showYamaGeneratedEvents;
  // ignore: unnecessary_getters_setters
  List<bool> get selectedCategories => _selectedCategories;

  // ignore: unnecessary_getters_setters
  set currentOpenSpotsValues(
    RangeValues currentOpenSpotsValue,
  ) {
    _currentOpenSpotsValues = currentOpenSpotsValue;
  }

  // ignore: unnecessary_getters_setters
  set currentDaysValues(
    RangeValues currentDaysValues,
  ) {
    _currentDaysValues = currentDaysValues;
  }

  // ignore: unnecessary_getters_setters
  set country(
    String country,
  ) {
    _country = country;
  }

  // ignore: unnecessary_getters_setters
  set region(
    String region,
  ) {
    _region = region;
  }

  // ignore: unnecessary_getters_setters
  set showMeGeneratedEvents(
    bool showMeGeneratedEvents,
  ) {
    _showMeGeneratedEvents = showMeGeneratedEvents;
  }

  // ignore: unnecessary_getters_setters
  set showUserGeneratedEvents(bool showUserGeneratedEvents) {
    _showUserGeneratedEvents = showUserGeneratedEvents;
  }

  // ignore: unnecessary_getters_setters
  set showYamaGeneratedEvents(
    bool showYamaGeneratedEvents,
  ) {
    _showYamaGeneratedEvents = showYamaGeneratedEvents;
  }

  // ignore: unnecessary_getters_setters
  set selectedCategories(List<bool> selectedCategories) {
    _selectedCategories = selectedCategories;
  }

  remove() {
    _currentOpenSpotsValues = null;
    _currentDaysValues = null;
    _country = null;
    _region = null;
    _showMeGeneratedEvents = null;
    _showUserGeneratedEvents = null;
    _showYamaGeneratedEvents = null;
    _selectedCategories = null;
    print('values removed from filter notifier');
  }
}
