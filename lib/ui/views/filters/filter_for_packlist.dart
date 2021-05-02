import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/form_fields/custom_range_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltersForPacklistView extends StatefulWidget {
  FiltersForPacklistView({Key key}) : super(key: key);

  @override
  _FiltersForPacklistState createState() => _FiltersForPacklistState();
}

class _FiltersForPacklistState extends State<FiltersForPacklistView> {
  RangeValues _currentDaysValues = const RangeValues(0, 20);
  RangeValues _currentWeightValues = const RangeValues(0, 20);

  bool showYamaGeneratedPacklists = false;

  AppLocalizations texts;

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

  Widget _buildAmountOfDaysSlider() {
    return CustomRangeSlider(
      min: 0,
      max: 20,
      rangeValues: _currentDaysValues,
      onChanged: (RangeValues values) {
        setState(() => _currentDaysValues = values);
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
      },
    );
  }

  List<Widget> _buildSeasonSelector() {
    List<Widget> seasonChips = [];

    for (int i = 0; i < _seasonCategories.length; i++) {
      FilterChip filterChip = FilterChip(
        showCheckmark: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).scaffoldBackgroundColor,
        label: Text(
          _seasonCategories[i],
          style: TextStyle(
              color: _selectedSeasonCategories[i]
                  ? Colors.blue
                  : Color(0xFF818181)),
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        selected: _selectedSeasonCategories[i],
        onSelected: (bool selected) {
          setState(() {
            _selectedSeasonCategories[i] = selected;
          });
        },
      );
      seasonChips.add(filterChip);
    }
    return seasonChips;
  }

  List<Widget> _buildCategoriesSelector() {
    List<Widget> chips = [];

    for (int i = 0; i < _categories.length; i++) {
      FilterChip filterChip = FilterChip(
        showCheckmark: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).scaffoldBackgroundColor,
        label: Text(
          _categories[i],
          style: TextStyle(
              color: _selectedCategories[i] ? Colors.blue : Color(0xFF818181)),
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        selected: _selectedCategories[i],
        onSelected: (bool selected) {
          setState(() {
            _selectedCategories[i] = selected;
          });
        },
      );
      chips.add(filterChip);
    }
    return chips;
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey,
      height: 1.5,
    );
  }

  Widget _checkBox() {
    return Row(
      children: [
        Material(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: showYamaGeneratedPacklists == true
                      ? Colors.blue
                      : Colors.black,
                  width: 2.3),
            ),
            width: 20,
            height: 20,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: showYamaGeneratedPacklists,
                key: Key('filter_checkbox'),
                onChanged: (bool value) {
                  setState(
                    () {
                      showYamaGeneratedPacklists = value;
                    },
                  );
                },
                checkColor: Colors.blue,
                activeColor: Colors.transparent,
              ),
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Only show Yama generated packlists ",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClearFiltersButton() {
    var texts = AppLocalizations.of(context);

    return Button(
      onPressed: () =>
          Navigator.of(context).pop(), // TODO MAKE THIS TO CLEAR THE FILTERS
      label: texts.clearFilters,
      backgroundColor: Colors.red,
      height: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Container(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              texts.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        title: Text(texts.packlistFilters + " STATIC",
            style: TextStyle(color: Colors.black, fontSize: 17)),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/packList');
              },
              child: Text(texts.apply),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.amountOfDays,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _buildAmountOfDaysSlider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.season,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 6.0,
              runSpacing: 6.0,
              children: _buildSeasonSelector(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.category,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 6.0,
              runSpacing: 6.0,
              children: _buildCategoriesSelector(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.weight,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _buildWeightSlider(),
            SizedBox(
              height: 30,
            ),
            _buildDivider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texts.additionals,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            _checkBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(110, 20, 110, 0),
              child: _buildClearFiltersButton(),
            ),
          ],
        ),
      ),
    );
  }
}
