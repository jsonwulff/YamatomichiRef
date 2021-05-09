import 'package:app/middleware/notifiers/event_filter_notifier.dart';

filterEvents(List<Map<String, dynamic>> events, EventFilterNotifier eventFilterNotifier) {
  if (eventFilterNotifier == null) return;

  //Filter spots
  events = events.where((event) {
    int openSpots = event['maxParticipants'] - event['participants'].length;
    if (openSpots < eventFilterNotifier.currentOpenSpotsValues.start ||
        openSpots > eventFilterNotifier.currentOpenSpotsValues.end)
      return false;
    else
      return true;
  });
  //Filter days

  //Filter Country

  //Filter region

  //Filter generated

  //Filter categories
}

// RangeValues _currentOpenSpotsValues;
// RangeValues _currentDaysValues;
// String _country;
// String _region;
// bool _showMeGeneratedEvents;
// bool _showUserGeneratedEvents;
// bool _showYamaGeneratedEvents;
// List<bool> _selectedCategories;
