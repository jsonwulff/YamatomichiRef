import 'package:app/ui/views/image_upload/choose_image_source_bottom_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helper/create_app_helper.dart';

class FirebaseStorageMock extends Mock implements FirebaseStorage {}

main() {
  testWidgets('Check that ImageCaptureBottomBar loads with no image chosen',
      (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateSimpleApp(ImageCaptureBottomBar()));

    expect(find.byKey(Key('ImageCaptureBottomBar_takePictureIconButton')), findsOneWidget);
    expect(find.byKey(Key('ImageCaptureBottomBar_takeImageFromGalleryIconButton')), findsOneWidget);
    expect(find.byKey(Key('ImageCaptureBottomBar_circleAvatar')), findsNothing);
    expect(find.byKey(Key('ImageCaptureBottomBar_uploadImageFromCircleAbatar')), findsNothing);
    expect(find.byKey(Key('ImageCaptureBottomBar_editChosenImage')), findsNothing);
    expect(find.byKey(Key('ImageCaptureBottomBar_clear')), findsNothing);
  });
}