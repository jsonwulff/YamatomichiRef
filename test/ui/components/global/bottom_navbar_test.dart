import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/create_app_helper.dart';

main() {
  testWidgets('Checks that everything renders', (WidgetTester tester) async {
    await tester
        .pumpWidget(CreateAppHelper.generateSimpleApp(Container(), bottomAppBar: BottomNavBar()));

    expect((tester.firstWidget(find.byType(BottomAppBar)) as BottomAppBar).color, Colors.black);

    expect(find.byKey(Key('BottomNavBar_1')), findsOneWidget);
    expect((tester.firstWidget(find.byKey(Key('BottomNavBar_1Icon'))) as Icon).color, Colors.white);

    expect(find.byKey(Key('BottomNavBar_2')), findsOneWidget);
    expect(find.byKey(Key('BottomNavBar_3')), findsOneWidget);
    expect(find.byKey(Key('BottomNavBar_4')), findsOneWidget);
  });
}
