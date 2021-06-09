import 'package:app/constants/Seasons.dart';
import 'package:app/constants/pCategories.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_filter_notifier.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:flutter/material.dart';

Future<List<Packlist>> filterPacklists(List<Packlist> packlists,
    PacklistFilterNotifier packlistFilterNotifier, BuildContext context) async {
  if (packlistFilterNotifier == null) return packlists;

  RangeValues _currentDaysValues = packlistFilterNotifier.currentDaysValues;
  RangeValues _totalWeight = packlistFilterNotifier.currentTotalWeight;
  bool _showYamaGeneratedPacklists = packlistFilterNotifier.showYamaGeneratedPacklists;
  List<bool> _selectedCategories = packlistFilterNotifier.selectedCategories;
  List<bool> _selectedSeasons = packlistFilterNotifier.selectedSeasons;

  if (_showYamaGeneratedPacklists == null) _showYamaGeneratedPacklists = false;

  List<String> _seasons = getSeasonListTranslated(context);

  List<String> _categories = getPCategoriesTranslated(context);

  UserProfileService ups = UserProfileService();

  filterByGeneratedBy(Packlist packlist) async {
    UserProfile createdBy = await ups.getUserProfile(packlist.createdBy);
    bool keep = true;
    if (_showYamaGeneratedPacklists == true) {
      if (!createdBy.roles['ambassador'] == true && !createdBy.roles['yamatomichi'] == true)
        keep = false;
    }
    return keep;
  }

  //Filter days
  if (_currentDaysValues != null)
    packlists = packlists.where((packlist) {
      int days = int.parse(packlist.amountOfDays);
      if (days >= _currentDaysValues.start &&
          (days <= _currentDaysValues.end || _currentDaysValues.end == 5)) return true;
      return false;
    }).toList();

  //Filter generated
  var toRemovePacklists = [];
  await Future.forEach(packlists, (packlist) async {
    if (!await filterByGeneratedBy(packlist)) {
      toRemovePacklists.add(packlist);
    }
  });
  packlists.removeWhere((packList) => toRemovePacklists.contains(packList));

  //Filter categories
  if (_selectedCategories != null && _selectedCategories.contains(true))
    packlists = packlists.where((packlist) {
      bool found = true;
      _categories.asMap().forEach((index, category) {
        if (getPSingleCategoryFromId(context, packlist.tag) ==
            category) if (_selectedCategories[index] == true)
          found = true;
        else
          found = false;
      });
      return found;
    }).toList();

  //Filter seasons
  if (_selectedSeasons != null && _selectedSeasons.contains(true))
    packlists = packlists.where((packlist) {
      bool found = true;
      _seasons.asMap().forEach((index, season) {
        if (getSeasonCategoryFromId(context, packlist.season) ==
            season) if (_selectedSeasons[index] == true)
          found = true;
        else
          found = false;
      });
      return found;
    }).toList();
  //Filter weight
  if (_totalWeight != null) {
    packlists = packlists.where((packlist) {
      int weight = packlist.totalWeight;
      if (weight >= _totalWeight.start && (weight <= _totalWeight.end || _totalWeight.end == 10000))
        return true;
      return false;
    }).toList();
  }
  return packlists;
}
