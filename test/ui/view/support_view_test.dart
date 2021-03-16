import 'package:app/ui/view/support/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helper/create_app_helper.dart';

class UrlLauncherMock extends Mock implements UrlLauncherPlatform {}

void main() {
  testWidgets('Ensure everything form support is rendered',
      (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateBasicApp(SupportView()));

    expect(find.byKey(Key('Support_ContactTitle')), findsOneWidget);
    expect(find.byKey(Key('Support_Contactsubtitle')), findsOneWidget);
    expect(find.byKey(Key('Support_ContactMailSubject')), findsOneWidget);
    expect(find.byKey(Key('Support_ContactMailBody')), findsOneWidget);
    expect(find.byKey(Key('Support_SendMailButton')), findsOneWidget);
    expect(find.byKey(Key('Support_faqTitle')), findsOneWidget);

    await tester.drag(find.byKey(Key('Support_faqTitle')), Offset(0, -500));
    await tester.pumpAndSettle();
    
    expect(find.byKey(Key('Support_ProductSupportTitle')), findsOneWidget);
    expect(find.byKey(Key('Support_ProductSupportButton')), findsOneWidget);
  });
}
