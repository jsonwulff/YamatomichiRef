@Skip('Might be needed later')
import 'package:app/constants/constants.dart';
import 'package:app/ui/shared/form_fields/country_dropdown.dart';
import 'package:app/ui/shared/form_fields/region_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CountryRegionTestWidget extends StatefulWidget {
  @override
  _CountryRegionTestWidgetState createState() => _CountryRegionTestWidgetState();
}

class _CountryRegionTestWidgetState extends State<CountryRegionTestWidget> {
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();
  List<String> currentRegions = ['no countries selected yet'];
  bool changedRegion = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('scaffold'),
      appBar: AppBar(),
      body: Column(
        children: [
          CountryDropdown(
            hint: 'Choose country',
            onSaved: (value) {},
            validator: (value) {},
            initialValue: null,
            onChanged: (value) {
              setState(() {
                _regionKey.currentState.reset();
                currentRegions = countryRegions[value];
                changedRegion = true;
              });
            },
          ),
          RegionDropdown(
            regionKey: _regionKey,
            hint: 'Choose region',
            onSaved: (value) {},
            validator: (value) {},
            initialValue: null,
            currentRegions: currentRegions,
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('Testing scaffold exists', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CountryRegionTestWidget()));
    expect(find.byKey(Key('scaffold')), findsOneWidget);
  });

  testWidgets('Testing hints are displayed when nothing is tapped or choosen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CountryRegionTestWidget()));
    expect(find.text('Choose country'), findsOneWidget);
    expect(find.text('Choose region'), findsOneWidget);
  });

  testWidgets('Test if all constants are loaded for each country', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CountryRegionTestWidget()));
    // await tester.tap(find.text('Choose country'));

    for (final country in countriesList) {
      expect(find.text(country), findsNWidgets(1));
    }
  });

  testWidgets('Test if all regions are loaded for Japan', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CountryRegionTestWidget()));
    // final _CountryRegionTestWidgetState state = tester.state(find.byType(CountryRegionTestWidget));
    await tester.tap(find.text('Choose country'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Japan').last);
    await tester.pumpAndSettle();

    for (final region in countryRegions['Japan']) {
      expect(find.text(region), findsOneWidget);
    }
  });

  testWidgets('Test if all regions are loaded for their country', (WidgetTester tester) async {
    for (final country in countriesList) {
      await tester.pumpWidget(MaterialApp(home: CountryRegionTestWidget()));
      await tester.tap(find.text('Choose country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(country).last);
      await tester.pumpAndSettle();
      for (final region in countryRegions[country]) {
        expect(find.text(region), findsOneWidget);
      }
    }
  });

  testWidgets(
      'Test if all regions are loaded for their country and regions are reset when a country is choosen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CountryRegionTestWidget()));
    await tester.tap(find.text('Choose country'));
    await tester.pumpAndSettle();

    for (var i = 0; i < countriesList.length; i++) {
      // Tap the i'th country
      await tester.tap(find.text(countriesList[i]).last);
      await tester.pumpAndSettle();
      // Check that regions for the current countries are loaded in the regions dropwdown
      for (final region in countryRegions[countriesList[i]]) {
        expect(find.text(region), findsOneWidget);
      }
      // Check that regions not for the current countries are loaded in the regions dropwdown
      for (var j = 0; j < countriesList.length; j++) {
        if (j == i) {
          break;
        } else {
          for (final region in countryRegions[countriesList[j]]) {
            if (region == 'Other') {
              expect(find.text(region), findsOneWidget);
            } else {
              expect(find.text(region), findsNothing);
            }
          }
        }
      }
      await tester.tap(find.text(countriesList[i]));
      await tester.pumpAndSettle();
    }
  });
}
