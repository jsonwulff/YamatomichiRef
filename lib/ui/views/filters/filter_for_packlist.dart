import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/form_fields/custom_checkbox.dart';
import 'package:app/ui/shared/form_fields/custom_chips_selector.dart';
import 'package:app/ui/shared/form_fields/custom_range_slider.dart';
import 'package:app/ui/views/filters/components/filter_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltersForPacklistView extends StatefulWidget {
  FiltersForPacklistView({Key key}) : super(key: key);

  @override
  _FiltersForPacklistState createState() => _FiltersForPacklistState();
}

class _FiltersForPacklistState extends State<FiltersForPacklistView> {
  // Fields for sliders
  RangeValues _currentDaysValues = const RangeValues(0, 20);
  RangeValues _currentWeightValues = const RangeValues(0, 20);

  // Fields for checkboxes
  bool showYamaGeneratedPacklists = false;

  bool isStateIntial = true;

  AppLocalizations texts;

  //Lists for categories in filterChips
  List<String> _seasonCategories = [
    'Fall',
    'Winter',
    'Summer',
    'Spring',
  ];
  List<bool> _selectedSeasonCategories = [false, false, false, false];

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
  List<bool> _selectedCategories = [false, false, false, false, false, false, false, false, false];

  Widget _buildAmountOfDaysSlider() {
    return CustomRangeSlider(
      min: 0,
      max: 20,
      rangeValues: _currentDaysValues,
      onChanged: (RangeValues values) {
        setState(() => _currentDaysValues = values);
        isStateIntial = false;
      },
    );
  }

  Widget _buildWeightSlider() {
    return CustomRangeSlider(
      min: 0,
      max: 20,
      rangeValues: _currentWeightValues,
      onChanged: (RangeValues values) {
        setState(() => _currentWeightValues = values);
        isStateIntial = false;
      },
    );
  }

  Widget _buildSeasonSelector() {
    return CustomChipsSelector(
      categories: _seasonCategories,
      selectedCategories: _selectedSeasonCategories,
      onSelected: (bool selected, int index) {
        setState(
          () {
            _selectedSeasonCategories[index] = selected;
            isStateIntial = false;
          },
        );
      },
    );
  }

  Widget _buildCategoriesSelector() {
    return CustomChipsSelector(
      categories: _categories,
      selectedCategories: _selectedCategories,
      onSelected: (bool selected, int index) {
        setState(
          () {
            _selectedCategories[index] = selected;
            isStateIntial = false;
          },
        );
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey,
      height: 1.5,
    );
  }

  Widget _checkBox() {
    var texts = AppLocalizations.of(context);

    return CustomCheckBox(
        label: texts.onlyShowYamaGeneratedPacklists,
        boolean: showYamaGeneratedPacklists,
        onChanged: (bool selected) {
          setState(() {
            showYamaGeneratedPacklists = selected;
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
                pageBuilder: (_, __, ___) => FiltersForPacklistView(),
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
      appBar: FilterAppBar(appBarTitle: texts.packlistFilters + " STATIC"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: Text(
                texts.amountOfDays,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildAmountOfDaysSlider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.season,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _buildSeasonSelector(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.category,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _buildCategoriesSelector(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.weight,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildWeightSlider(),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
              child: _buildDivider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.additionals,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _checkBox(),
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
