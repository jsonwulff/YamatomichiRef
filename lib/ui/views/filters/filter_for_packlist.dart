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
          iconTheme:
              IconThemeData(color: Colors.black), //change your color here
          title: Text("Filters for packlist",
              style: TextStyle(color: Colors.black)),
        ),
        body: ListView(
          children: [
            Text(texts.amountOfDays),
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
            Text(texts.season),
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
            Text(texts.category),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SelectableText("Hike"),
                  SelectableText("Snow hike"),
                  SelectableText("Fastpacking"),
                  SelectableText("Ski"),
                  SelectableText("Run"),
                  SelectableText("Popup"),
                  SelectableText("UL101"),
                  SelectableText("MYOG Workshop"),
                  SelectableText("Repair Workshop"),
                ],
              ),
            ),
            Text(texts.weight),
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
          ],
        ));
  }
}
