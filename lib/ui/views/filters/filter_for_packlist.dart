import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

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
        leadingWidth: 65,
        leading: Container(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              texts.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        title: Text("Packlist filters", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/packList');
              },
              child: Text("Apply"),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(texts.amountOfDays),
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
            child: Text(texts.season),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SelectableText("Fall",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SelectableText("Winter"),
                SelectableText("Spring"),
                SelectableText("Summer")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(texts.category),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [
                  SelectableText("Hike"),
                  SelectableText("Snow hike"),
                  SelectableText("Fastpacking"),
                  SelectableText("Ski"),
                ]),
                Row(children: [
                  SelectableText("Run"),
                  SelectableText("Popup"),
                  SelectableText("UL101"),
                  SelectableText("MYOG Workshop"),
                  SelectableText("Repair Workshop"),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(texts.weight),
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
            child: Text("Additionals"),
          ),
          //CheckboxListTile( TODO IMPLEMENT CHECKBOX
          //    title: Text("Title"),
          //    value: checkedValue,
          //    onChanged: (newValue) {
          //      setState(() {
          //        checkedValue = newValue;
          //      });
          //    }),
        ],
      ),
    );
  }
}
