import 'package:app/ui/components/global/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/create_app_helper.dart';

main() {
  testWidgets('Checks that the app bar loads with the correct brightness of dark and the correct text with Text', (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateSimpleApp(Container(),
        appBar: AppBarCustom.basicAppBar('Text')));

    expect(find.text('Text'), findsOneWidget);
    expect((tester.firstWidget(find.byType(AppBar)) as AppBar).brightness, Brightness.dark);
  });
}
