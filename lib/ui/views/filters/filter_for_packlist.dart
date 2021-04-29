import 'package:app/ui/shared/buttons/button.dart';
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

  int _value = 1; // TO BE DELETED

  Widget _buildAmountOfDaysSlider() {
    return RangeSlider(
        values: _currentDaysValues,
        min: 0,
        max: 20,
        labels: RangeLabels(
          _currentDaysValues.start.round().toString(),
          _currentDaysValues.end.round().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _currentDaysValues = values;
          });
        });
  }

  Widget _buildWeightSlider() {
    return RangeSlider(
        values: _currentWeightValues,
        min: 0,
        max: 20,
        labels: RangeLabels(
          _currentWeightValues.start.round().toString(),
          _currentWeightValues.end.round().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _currentWeightValues = values;
          });
        });
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
            margin: EdgeInsets.fromLTRB(30, 10, 10, 10),
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
              style: new TextStyle(color: Colors.black),
            ),
          ],
        )),
      ],
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
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              texts.amountOfDays,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SliderTheme(
              data:
                  SliderThemeData(), // TODO GET TICK / CURRENT VALUE TO SHOW HERE UI
              child: _buildAmountOfDaysSlider()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              texts.season,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  // TODO THIS IS WHAT WE SHOULD BE DOING!!!!!!!!!!!! SOMEHOW :) https://api.flutter.dev/flutter/material/ChoiceChip-class.html
                  children: List<Widget>.generate(
                    3,
                    (int index) {
                      return ChoiceChip(
                        label: Text('Item $index'),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = selected ? index : null;
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(
                      texts.fall,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(
                      texts.winter,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(
                      texts.spring,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(
                      texts.summer,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              texts.category,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                            texts.hike,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Chip(
                          label: Text(
                            "Snow hike",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Chip(
                          label: Text(
                            "Fastpacking",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Chip(
                          label: Text(
                            "Ski",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                            "Run",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Chip(
                          label: Text(
                            "Popup",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Chip(
                            label: Text(
                          "UL101",
                          style: Theme.of(context).textTheme.subtitle1,
                        )),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                            label: Text(
                          "MYOG Workshop",
                          style: Theme.of(context).textTheme.subtitle1,
                        )),
                        Chip(
                          label: Text(
                            "Repair Workshop",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              texts.weight,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          _buildWeightSlider(),
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
            padding: const EdgeInsets.all(40.0),
            child: Button(
                onPressed: () => Navigator.of(context)
                    .pop(), // TODO MAKE THIS TO CLEAR THE FILTERS
                label: texts.clearFilters),
          ),
        ],
      ),
    );
  }
}
