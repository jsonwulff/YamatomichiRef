import 'package:app/middleware/notifiers/event_filter_notifier.dart';
import 'package:flutter/material.dart';

filterEvents(List<Map<String, dynamic>> events, EventFilterNotifier eventFilterNotifier) {
  if (eventFilterNotifier == null) return;
  RangeValues _currentOpenSpotsValues = eventFilterNotifier.currentOpenSpotsValues;
  RangeValues _currentDaysValues = eventFilterNotifier.currentDaysValues;
  String _country = eventFilterNotifier.country;
  String _region = eventFilterNotifier.region;
  bool _showMeGeneratedEvents = eventFilterNotifier.showMeGeneratedEvents;
  bool _showUserGeneratedEvents = eventFilterNotifier.showUserGeneratedEvents;
  bool _showYamaGeneratedEvents = eventFilterNotifier.showYamaGeneratedEvents;
  List<bool> _selectedCategories = eventFilterNotifier.selectedCategories;

  //Filter spots
  if (_currentOpenSpotsValues != null)
    events = events.where((event) {
      int openSpots = event['maxParticipants'] - event['participants'].length;
      if (openSpots < _currentOpenSpotsValues.start || openSpots > _currentOpenSpotsValues.end)
        return false;
      return true;
    });

  //Filter days
  if (_currentDaysValues != null)
    events = events.where((event) {
      int days = DateTime.parse(event['endDate']).compareTo(DateTime.parse(event['startDate']));
      print(days);
      if (days > _currentDaysValues.start || days < _currentDaysValues.end) return false;
      return true;
    });
  //Filter Country

  //Filter region

  //Filter generated

  //Filter categories
}
