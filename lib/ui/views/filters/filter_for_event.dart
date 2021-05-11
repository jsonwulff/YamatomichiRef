import 'package:app/constants/countryRegion.dart';
import 'package:app/middleware/notifiers/event_filter_notifier.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/form_fields/country_dropdown.dart';
import 'package:app/ui/shared/form_fields/custom_checkbox.dart';
import 'package:app/ui/shared/form_fields/custom_chips_selector.dart';
import 'package:app/ui/shared/form_fields/custom_range_slider.dart';
import 'package:app/ui/shared/form_fields/region_dropdown.dart';
import 'package:app/ui/views/filters/components/filter_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FiltersForEventView extends StatefulWidget {
  FiltersForEventView({Key key}) : super(key: key);

  @override
  _FiltersForEventState createState() => _FiltersForEventState();
}

class _FiltersForEventState extends State<FiltersForEventView> {
  //Filter Notifier
  EventFilterNotifier eventFilterNotifier;

  // Fields for sliders
  RangeValues _currentOpenSpotsValues;
  RangeValues _currentDaysValues;

  // Fields for country dropdown
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();
  String country;
  String region;
  List<String> currentRegions = ['Choose country'];

  // Fields for checkboxes
  bool showMeGeneratedEvents;
  bool showUserGeneratedEvents;
  bool showYamaGeneratedEvents;

  bool isStateInitial = true;

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
  List<bool> _selectedCategories;

  @override
  void initState() {
    super.initState();
    eventFilterNotifier = Provider.of<EventFilterNotifier>(context, listen: false);
    eventFilterNotifier.currentOpenSpotsValues != null
        ? _currentOpenSpotsValues = eventFilterNotifier.currentOpenSpotsValues
        : _currentOpenSpotsValues = const RangeValues(0, 20);
    eventFilterNotifier.currentDaysValues != null
        ? _currentDaysValues = eventFilterNotifier.currentDaysValues
        : _currentDaysValues = const RangeValues(1, 5);
    eventFilterNotifier.country != null ? country = eventFilterNotifier.country : country = null;
    eventFilterNotifier.region != null ? region = eventFilterNotifier.region : region = null;
    eventFilterNotifier.showMeGeneratedEvents != null
        ? showMeGeneratedEvents = eventFilterNotifier.showMeGeneratedEvents
        : showMeGeneratedEvents = true;
    eventFilterNotifier.showUserGeneratedEvents != null
        ? showUserGeneratedEvents = eventFilterNotifier.showUserGeneratedEvents
        : showUserGeneratedEvents = true;
    eventFilterNotifier.showYamaGeneratedEvents != null
        ? showYamaGeneratedEvents = eventFilterNotifier.showYamaGeneratedEvents
        : showYamaGeneratedEvents = true;
    eventFilterNotifier.selectedCategories != null
        ? _selectedCategories = eventFilterNotifier.selectedCategories
        : _selectedCategories = [true, true, true, true, true, true, true, true, true];
    eventFilterNotifier.selectedCategories != null ||
            eventFilterNotifier.currentDaysValues != null ||
            eventFilterNotifier.country != null ||
            eventFilterNotifier.region != null ||
            eventFilterNotifier.showMeGeneratedEvents != null ||
            eventFilterNotifier.showUserGeneratedEvents != null ||
            eventFilterNotifier.showYamaGeneratedEvents != null ||
            eventFilterNotifier.selectedCategories != null
        ? isStateInitial = false
        : isStateInitial = true;
  }

  Widget _buildOpenSpotsSlider() {
    return CustomRangeSlider(
      min: 0,
      max: 20,
      rangeValues: _currentOpenSpotsValues,
      onChanged: (RangeValues values) {
        setState(() {
          _currentOpenSpotsValues = values;
          isStateInitial = false;
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
          isStateInitial = false;
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
          isStateInitial = false;
        });
      },
    );
  }

  setUpDropdowns() {
    if (country != null) currentRegions = getCountriesRegionsTranslated(context)[country];
  }

  Widget _buildCountryDropdown() {
    var texts = AppLocalizations.of(context);
    if (country != null) print("country " + country);
    setUpDropdowns();
    return CountryDropdown(
      hint: texts.country,
      outlined: true,
      initialValue: country,
      onChanged: (value) {
        setState(() {
          country = value;
          _regionKey.currentState.reset();
          currentRegions = getCountriesRegionsTranslated(context)[value];
          isStateInitial = false;
        });
      },
    );
  }

  Widget _buildRegionDropdown() {
    var texts = AppLocalizations.of(context);
    if (region != null) print('region ' + region);

    return RegionDropdown(
      outlined: true,
      regionKey: _regionKey,
      hint: texts.region,
      initialValue: currentRegions.contains(region) ? region : null,
      currentRegions: currentRegions,
      onChanged: (value) {
        setState(() {
          region = value;
        });
      },
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
            isStateInitial = false;
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
            isStateInitial = false;
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
            isStateInitial = false;
          });
        });
  }

  Widget _buildClearFiltersButton() {
    var texts = AppLocalizations.of(context);

    return Button(
      onPressed: () {
        eventFilterNotifier.remove();
        if (!isStateInitial)
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (_, __, ___) => FiltersForEventView(),
            ),
          );
      },
      label: isStateInitial ? texts.noFiltersSelected : texts.clearFilters,
      backgroundColor: isStateInitial ? Colors.grey : Colors.red,
      height: 35,
    );
  }

  void apply() {
    if (!isStateInitial) {
      eventFilterNotifier.currentOpenSpotsValues = _currentOpenSpotsValues;
      eventFilterNotifier.currentDaysValues = _currentDaysValues;
      eventFilterNotifier.country = country;
      eventFilterNotifier.region = region;
      eventFilterNotifier.showMeGeneratedEvents = showMeGeneratedEvents;
      eventFilterNotifier.showUserGeneratedEvents = showUserGeneratedEvents;
      eventFilterNotifier.showYamaGeneratedEvents = showYamaGeneratedEvents;
      eventFilterNotifier.selectedCategories = _selectedCategories;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    eventFilterNotifier = Provider.of<EventFilterNotifier>(context, listen: false);
    // filterNotifier = Provider.of<FilterNotifier>(context, listen: false);
    // if (eventListNotifier == null || filterNotifier == null) return Container();

    return Scaffold(
      appBar: FilterAppBar(() => apply(), appBarTitle: texts.filtersForEvents + " STATIC"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
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
