import 'package:app/middleware/models/event.dart';
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

  RangeValues get currentOpenSpotsValues => _currentOpenSpotsValues;
  RangeValues get currentDaysValues => _currentDaysValues;
  String get country => _country;
  String get region => _region;
  bool get showMeGeneratedEvents => _showMeGeneratedEvents;
  bool get showUserGeneratedEvents => _showUserGeneratedEvents;
  bool get showYamaGeneratedEvents => _showYamaGeneratedEvents;
  List<bool> get selectedCategories => _selectedCategories;

  set currentOpenSpotsValues(
    RangeValues currentOpenSpotsValue,
  ) {
    _currentOpenSpotsValues = currentOpenSpotsValue;
  }

  set currentDaysValues(
    RangeValues currentDaysValues,
  ) {
    _currentDaysValues = currentDaysValues;
  }

  set country(
    String country,
  ) {
    _country = country;
  }

  set region(
    String region,
  ) {
    _region = region;
  }

  set showMeGeneratedEvents(
    bool showMeGeneratedEvents,
  ) {
    _showMeGeneratedEvents = showMeGeneratedEvents;
  }

  set showUserGeneratedEvents(bool showUserGeneratedEvents) {
    _showUserGeneratedEvents = showUserGeneratedEvents;
  }

  set showYamaGeneratedEvents(
    bool showYamaGeneratedEvents,
  ) {
    _showYamaGeneratedEvents = showYamaGeneratedEvents;
  }

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
