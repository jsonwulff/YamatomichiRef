import 'package:app/ui/views/support/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helper/create_app_helper.dart';

void main() {
  testWidgets('Ensure everything form support is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestApp(SupportView()));

    expect(find.byKey(Key('Support_ContactTitle')), findsOneWidget);
    expect(find.byKey(Key('Support_Contactsubtitle')), findsOneWidget);
    expect(find.byKey(Key('Support_ContactMailSubject')), findsOneWidget);
    expect(find.byKey(Key('Support_ContactMailBody')), findsOneWidget);
    expect(find.byKey(Key('Support_SendMailButton')), findsOneWidget);
    expect(find.byKey(Key('Support_faqTitle')), findsOneWidget);

    await tester.drag(find.byKey(Key('Support_faqTitle')), Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('Support_ProductSupportTitle')), findsOneWidget);
    expect(find.byKey(Key('Support_ProductSupportButton')), findsOneWidget);
  });
}
