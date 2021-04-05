import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helper/create_app_helper.dart';

class BuildContextMock extends Mock implements BuildContext {}

main() {
  var buildContextMock;

  setUp(() {
    buildContextMock = BuildContextMock();
  });

  testWidgets(
      'Checks that the app bar loads with the correct brightness of dark and the correct text with Text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        CreateAppHelper.generateSimpleApp(Container(), appBar: AppBarCustom.basicAppBar('Text')));

    expect(find.text('Text'), findsOneWidget);
    expect((tester.firstWidget(find.byType(AppBar)) as AppBar).brightness, Brightness.dark);
    expect((tester.firstWidget(find.byType(AppBar)) as AppBar).backgroundColor, Colors.black);
  });

  testWidgets(
      'Checks that the app bar loads with the correct brightness of dark and the correct text with Text with a mocked context',
      (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateSimpleApp(Container(),
        appBar: AppBarCustom.basicAppBarWithContext('Text', buildContextMock)));

    expect(find.text('Text'), findsOneWidget);
    expect((tester.firstWidget(find.byType(AppBar)) as AppBar).brightness, Brightness.dark);
    expect((tester.firstWidget(find.byType(AppBar)) as AppBar).backgroundColor, Colors.black);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
