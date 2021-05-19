import 'package:app/constants/Seasons.dart';
import 'package:app/constants/pCategories.dart';
import 'package:app/middleware/notifiers/packlist_filter_notifier.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/form_fields/custom_checkbox.dart';
import 'package:app/ui/shared/form_fields/custom_chips_selector.dart';
import 'package:app/ui/shared/form_fields/custom_range_slider.dart';
import 'package:app/ui/views/filters/components/filter_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FiltersForPacklistView extends StatefulWidget {
  FiltersForPacklistView({Key key}) : super(key: key);

  @override
  _FiltersForPacklistState createState() => _FiltersForPacklistState();
}

class _FiltersForPacklistState extends State<FiltersForPacklistView> {
  //Filter Notifier
  PacklistFilterNotifier packlistFilterNotifier;

  // Fields for sliders
  RangeValues _currentDaysValues = const RangeValues(0, 20);
  RangeValues _currentWeightValues = const RangeValues(0, 10000);

  // Fields for checkboxes
  bool showYamaGeneratedPacklists = false;

  bool isStateInitial = true;

  AppLocalizations texts;

  //Lists for categories in filterChips
  List<String> _seasonCategories;
  List<bool> _selectedSeasonCategories = [false, false, false, false];

  List<String> _categories;
  List<bool> _selectedCategories = [false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    packlistFilterNotifier = Provider.of<PacklistFilterNotifier>(context, listen: false);
    packlistFilterNotifier.currentDaysValues != null
        ? _currentDaysValues = packlistFilterNotifier.currentDaysValues
        : _currentDaysValues = const RangeValues(0, 20);
    packlistFilterNotifier.currentTotalWeight != null
        ? _currentWeightValues = packlistFilterNotifier.currentTotalWeight
        : _currentWeightValues = const RangeValues(0, 10000);
    packlistFilterNotifier.showYamaGeneratedPacklists != null
        ? showYamaGeneratedPacklists = packlistFilterNotifier.showYamaGeneratedPacklists
        : showYamaGeneratedPacklists = false;
    packlistFilterNotifier.selectedCategories != null
        ? _selectedCategories = packlistFilterNotifier.selectedCategories
        : _selectedCategories = [false, false, false, false, false, false, false];
    packlistFilterNotifier.selectedSeasons != null
        ? _selectedSeasonCategories = packlistFilterNotifier.selectedSeasons
        : _selectedSeasonCategories = [false, false, false, false];
    packlistFilterNotifier.selectedCategories != null ||
            packlistFilterNotifier.currentDaysValues != null ||
            packlistFilterNotifier.showYamaGeneratedPacklists != null ||
            packlistFilterNotifier.selectedCategories != null
        ? isStateInitial = false
        : isStateInitial = true;
  }

  Widget _buildAmountOfDaysSlider() {
    return CustomRangeSlider(
      min: 0,
      max: 20,
      rangeValues: _currentDaysValues,
      onChanged: (RangeValues values) {
        setState(() => _currentDaysValues = values);
        isStateInitial = false;
      },
    );
  }

  Widget _buildWeightSlider() {
    return CustomRangeSlider(
      min: 0,
      max: 10000,
      rangeValues: _currentWeightValues,
      onChanged: (RangeValues values) {
        setState(() => _currentWeightValues = values);
        isStateInitial = false;
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
            isStateInitial = false;
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
            isStateInitial = false;
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
            isStateInitial = false;
          });
        });
  }

  Widget _buildClearFiltersButton() {
    var texts = AppLocalizations.of(context);

    return Button(
      onPressed: () {
        packlistFilterNotifier.remove();
        if (!isStateInitial)
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (_, __, ___) => FiltersForPacklistView(),
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
      packlistFilterNotifier.selectedSeasons = _selectedSeasonCategories;
      packlistFilterNotifier.currentDaysValues = _currentDaysValues;
      packlistFilterNotifier.currentTotalWeight = _currentWeightValues;
      packlistFilterNotifier.showYamaGeneratedPacklists = showYamaGeneratedPacklists;
      packlistFilterNotifier.selectedCategories = _selectedCategories;
    }
    Navigator.of(context).pop();
  }

  void setTranslations(context) {
    _seasonCategories = getSeasonListTranslated(context);
    _categories = getPCategoriesTranslated(context);
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    setTranslations(context);
    return Scaffold(
      appBar: FilterAppBar(() => apply(), appBarTitle: texts.packlistFilters),
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
