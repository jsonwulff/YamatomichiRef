import 'package:app/constants/constants.dart';
import 'package:app/constants/countryRegion.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/form_fields/country_dropdown.dart';
import 'package:app/ui/shared/form_fields/custom_checkbox.dart';
import 'package:app/ui/shared/form_fields/custom_chips_selector.dart';
import 'package:app/ui/shared/form_fields/custom_range_slider.dart';
import 'package:app/ui/shared/form_fields/region_dropdown.dart';
import 'package:app/ui/views/filters/components/filter_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltersForEventView extends StatefulWidget {
  FiltersForEventView({Key key}) : super(key: key);

  @override
  _FiltersForEventState createState() => _FiltersForEventState();
}

class _FiltersForEventState extends State<FiltersForEventView> {
  // Fields for sliders
  RangeValues _currentOpenSpotsValues = const RangeValues(0, 20);
  RangeValues _currentDaysValues = const RangeValues(1, 5);

  // Fields for country dropdown
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();
  String country;
  String region;
  List<String> currentRegions = ['Choose country'];

  // Fields for checkboxes
  bool showMeGeneratedEvents = false;
  bool showUserGeneratedEvents = false;
  bool showYamaGeneratedEvents = false;

  bool isStateIntial = true;

  AppLocalizations texts;

  //Lists for categories in filterChips
  List<String> _categories = [
    'Hike',
    'Snow Hike',
    'Fastpacking',
    'Ski',
    'Run',
    'Popup',
    'UL 101',
    'MYOG Workshop',
    'Repair Workshop'
  ];
  List<bool> _selectedCategories = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Widget _buildOpenSpotsSlider() {
    return CustomRangeSlider(
      min: 0,
      max: 20,
      rangeValues: _currentOpenSpotsValues,
      onChanged: (RangeValues values) {
        setState(() {
          _currentOpenSpotsValues = values;
          isStateIntial = false;
        });
      },
    );
  }

  Widget _buildDaysSlider() {
    return CustomRangeSlider(
      min: 1,
      max: 5,
      rangeValues: _currentDaysValues,
      onChanged: (RangeValues values) {
        setState(() {
          _currentDaysValues = values;
          isStateIntial = false;
        });
      },
    );
  }

  Widget _buildCategorySelector() {
    return CustomChipsSelector(
      categories: _categories,
      selectedCategories: _selectedCategories,
      onSelected: (bool selected, int index) {
        setState(() {
          _selectedCategories[index] = selected;
          isStateIntial = false;
        });
      },
    );
  }

  Widget _buildCountryDropdown() {
    var texts = AppLocalizations.of(context);

    return CountryDropdown(
      hint: texts.country,
      onChanged: (value) {
        setState(() {
          _regionKey.currentState.reset();
          currentRegions = getCountriesRegionsTranslated(context)[value];
          isStateIntial = false;
        });
      },
    );
  }

  Widget _buildRegionDropdown() {
    var texts = AppLocalizations.of(context);

    return RegionDropdown(
      regionKey: _regionKey,
      hint: texts.region,
      currentRegions: currentRegions,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey,
      height: 1.5,
    );
  }

  Widget _buildCheckBoxMyEvents() {
    var texts = AppLocalizations.of(context);

    return CustomCheckBox(
        label: texts.onlyShowEventsGeneratedByMe,
        boolean: showMeGeneratedEvents,
        onChanged: (bool selected) {
          setState(() {
            showMeGeneratedEvents = selected;
            isStateIntial = false;
          });
        });
  }

  Widget _buildCheckBoxUserEvents() {
    var texts = AppLocalizations.of(context);

    return CustomCheckBox(
        label: texts.onlyShowUsergeneratedEvents,
        boolean: showUserGeneratedEvents,
        onChanged: (bool selected) {
          setState(() {
            showUserGeneratedEvents = selected;
            isStateIntial = false;
          });
        });
  }

  Widget _buildCheckBoxYamaEvents() {
    var texts = AppLocalizations.of(context);

    return CustomCheckBox(
        label: texts.onlyShowYamaGeneratedEvents,
        boolean: showYamaGeneratedEvents,
        onChanged: (bool selected) {
          setState(() {
            showYamaGeneratedEvents = selected;
            isStateIntial = false;
          });
        });
  }

  Widget _buildClearFiltersButton() {
    var texts = AppLocalizations.of(context);

    return Button(
      onPressed: () => isStateIntial
          ? null
          : Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (_, __, ___) => FiltersForEventView(),
              ),
            ),
      label: isStateIntial ? texts.noFiltersSelected : texts.clearFilters,
      backgroundColor: isStateIntial ? Colors.grey : Colors.red,
      height: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: FilterAppBar(appBarTitle: texts.filtersForEvents + " STATIC"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.openSpots,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: _buildOpenSpotsSlider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.amountOfDays,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: _buildDaysSlider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.category,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _buildCategorySelector(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.country,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCountryDropdown(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.region,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildRegionDropdown(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildDivider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.additionals,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _buildCheckBoxMyEvents(),
            _buildCheckBoxUserEvents(),
            _buildCheckBoxYamaEvents(),
            Padding(
              padding: const EdgeInsets.fromLTRB(75, 20, 75, 0),
              child: _buildClearFiltersButton(),
            ),
          ],
        ),
      ),
    );
  }
}
