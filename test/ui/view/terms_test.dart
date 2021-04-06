import 'package:app/ui/view/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helper/create_app_helper.dart';

void main() {
  testWidgets('Ensure everything form support is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestApp(TermsView()));

    expect(find.byKey(Key('Terms_RichText')), findsOneWidget);
  });
}
