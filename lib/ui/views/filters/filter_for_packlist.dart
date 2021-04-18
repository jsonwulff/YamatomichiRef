import 'package:app/ui/shared/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart'; // Use localization

class FiltersForPacklistView extends StatefulWidget {
  FiltersForPacklistView({Key key}) : super(key: key);

  @override
  _FiltersForPacklistState createState() => _FiltersForPacklistState();
}

class _FiltersForPacklistState extends State<FiltersForPacklistView> {
  RangeValues _currentDaysValues = const RangeValues(0, 20);
  RangeValues _currentWeightValues = const RangeValues(0, 20);

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
        title: Text(texts.packlistFilters,
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
            child: RangeSlider(
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
                }),
          ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    texts.fall,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(texts.winter,
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(texts.spring,
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(texts.summer,
                      style: Theme.of(context).textTheme.subtitle1),
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
                        SelectableText(texts.hike,
                            style: Theme.of(context).textTheme.subtitle1),
                        SelectableText("Snow hike",
                            style: Theme.of(context).textTheme.subtitle1),
                        SelectableText("Fastpacking",
                            style: Theme.of(context).textTheme.subtitle1),
                        SelectableText("Ski",
                            style: Theme.of(context).textTheme.subtitle1),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectableText("Run",
                            style: Theme.of(context).textTheme.subtitle1),
                        SelectableText("Popup",
                            style: Theme.of(context).textTheme.subtitle1),
                        SelectableText("UL101",
                            style: Theme.of(context).textTheme.subtitle1),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectableText("MYOG Workshop",
                            style: Theme.of(context).textTheme.subtitle1),
                        SelectableText("Repair Workshop",
                            style: Theme.of(context).textTheme.subtitle1),
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
          RangeSlider(
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
              }),
          Divider(
            color: Colors.grey,
            height: 1.5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              texts.additionals,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          //CheckboxListTile( TODO IMPLEMENT CHECKBOX
          //    title: Text("Title"),
          //    value: checkedValue,
          //    onChanged: (newValue) {
          //      setState(() {
          //        checkedValue = newValue;
          //      });
          //    }),
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
