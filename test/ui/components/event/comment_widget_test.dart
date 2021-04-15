import 'package:app/ui/views/calendar/components/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helper/create_app_helper.dart';

void main() {
  testWidgets('Create comment widget, shows bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      CreateAppHelper.generateYamatomichiTestApp(
        Scaffold(body: CommentWidget()),
      ),
    );
    final labelTextFinder1 = find.text('Add a comment');
    final labelTextFinder2 = find.text('0 Comments');
    expect(labelTextFinder1, findsOneWidget);
    expect(labelTextFinder2, findsOneWidget);
  });
}
