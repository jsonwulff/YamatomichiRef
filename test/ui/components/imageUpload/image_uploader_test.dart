import 'dart:io';

import 'package:app/ui/components/imageUpload/image_uploader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mockito/mockito.dart';

class ImagePickerMock extends Mock implements ImagePicker {}

main() {
  var imagePickerMock;
  final imageTestFilePath = 'test/assets/IMG_20180118_145943.jpg';

  setUp(() {
    imagePickerMock = ImagePickerMock();
  });

  tearDown(() {
    imagePickerMock == null;
  });

  group('pickImage tests', () {
    test('Given ImagePicker returns image, returns the same image', () async {
      when(imagePickerMock.getImage(source: ImageSource.camera))
          .thenAnswer((_) async => PickedFile(imageTestFilePath));

      var file = await ImageUploader.pickImage(ImageSource.camera,
          imagePicker: imagePickerMock);

      expect(file.path, imageTestFilePath);
    });

    test('Given non functioning ImagePicker throws FileSystemException', () async {
      // var file = await ImageUploader.pickImage(ImageSource.camera,
      //     imagePicker: imagePickerMock);

      expect(
          () async => await ImageUploader.pickImage(ImageSource.camera,
              imagePicker: imagePickerMock),
          throwsException);
    });
  });

  // TODO: _clear
  // TODO: _cropImage
  // TODO: _pickImageInstantCrop

  // TODO: build
  // TODO: _startupload
  // TODO: build2
}
