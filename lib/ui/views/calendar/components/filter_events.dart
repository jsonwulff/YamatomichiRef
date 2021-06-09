import 'package:app/constants/categories.dart';
import 'package:app/constants/countryRegion.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_filter_notifier.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> filterEvents(List<Map<String, dynamic>> events,
    EventFilterNotifier eventFilterNotifier, String userID, BuildContext context) async {
  if (eventFilterNotifier == null) return events;
  RangeValues _currentOpenSpotsValues = eventFilterNotifier.currentOpenSpotsValues;
  RangeValues _currentDaysValues = eventFilterNotifier.currentDaysValues;
  String _country = eventFilterNotifier.country;
  String _region = eventFilterNotifier.region;
  bool _showMeGeneratedEvents = eventFilterNotifier.showMeGeneratedEvents;
  bool _showUserGeneratedEvents = eventFilterNotifier.showUserGeneratedEvents;
  bool _showYamaGeneratedEvents = eventFilterNotifier.showYamaGeneratedEvents;
  List<bool> _selectedCategories = eventFilterNotifier.selectedCategories;

  if (_showMeGeneratedEvents == null) _showMeGeneratedEvents = true;
  if (_showUserGeneratedEvents == null) _showUserGeneratedEvents = true;
  if (_showYamaGeneratedEvents == null) _showYamaGeneratedEvents = true;

  List<String> _nonYamaCategories = getCategoriesTranslated(context);
  List<String> _yamaCategories = getYamaCategoriesTranslated(context);
  List<String> _categories = _nonYamaCategories + _yamaCategories;
  UserProfileService ups = UserProfileService();

  filterByGeneratedBy(Map<String, dynamic> event) async {
    UserProfile createdBy = await ups.getUserProfile(event['createdBy']);
    if (_showMeGeneratedEvents == true) if (createdBy.id == userID) return true;
    if (_showMeGeneratedEvents == false) if (createdBy.id == userID) return false;
    if (_showUserGeneratedEvents == true) if (createdBy.roles['ambassador'] == false &&
        createdBy.roles['yamatomichi'] == false) return true;
    if (_showYamaGeneratedEvents == true) if (createdBy.roles['ambassador'] == true ||
        createdBy.roles['yamatomichi'] == true) return true;
    if (createdBy.id == "???????") return true;
    return false;
  }

  //Filter spots
  if (_currentOpenSpotsValues != null)
    events = events.where((event) {
      int openSpots = event['maxParticipants'] - event['participants'].length;
      if (openSpots >= _currentOpenSpotsValues.start || openSpots <= _currentOpenSpotsValues.end)
        return true;
      return false;
    }).toList();

  //Filter days
  if (_currentDaysValues != null)
    events = events.where((event) {
      DateTime endDate = event['endDate'].toDate();
      DateTime startDate = event['startDate'].toDate();
      int days = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0)
          .difference(DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0))
          .inDays;
      if (days == 0) days++;
      if (days >= _currentDaysValues.start &&
          (days <= _currentDaysValues.end || _currentDaysValues.end == 5)) return true;
      return false;
    }).toList();

  //Filter Country
  if (_country != null)
    events = events.where((event) {
      return getCountryTranslated(context, event['country']) == _country;
    }).toList();

  //Filter region
  if (_region != null)
    events = events.where((event) {
      return getRegionTranslated(context, event['country'], event['region']) == _region;
    }).toList();

  //Filter generated
  var toRemoveEvents = [];
  await Future.forEach(events, (event) async {
    if (!await filterByGeneratedBy(event)) {
      toRemoveEvents.add(event);
    }
  });
  events.removeWhere((event) => toRemoveEvents.contains(event));
  //Filter categories
  if (_selectedCategories != null && _selectedCategories.contains(true)) {
    events = events.where((event) {
      bool found = true;
      _categories.asMap().forEach((index, category) {
        if (getSingleCategoryFromId(context, event['category']) ==
            category) if (_selectedCategories[index] == true)
          found = true;
        else
          found = false;
      });
      return found;
    }).toList();
  }

  return events;
}
