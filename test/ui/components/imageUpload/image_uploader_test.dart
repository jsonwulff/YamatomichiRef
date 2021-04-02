import 'dart:io';

import 'package:app/ui/components/imageUpload/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mockito/mockito.dart';

import '../../../helper/create_app_helper.dart';

class ImagePickerMock extends Mock implements ImagePicker {}

class ImageCropperMock extends Mock implements ImageCropper {}

main() {
  var imagePickerMock;
  var imageCropperMock;
  final imageTestFilePath = 'test/assets/IMG_20180118_145943.jpg';

  setUp(() {
    imagePickerMock = ImagePickerMock();
    imageCropperMock = ImageCropperMock();
  });

  tearDown(() {
    // ignore: unnecessary_statements
    imagePickerMock == null;
    imageCropperMock == null;
  });

  void setUpImagePickerWithImage() {
    when(imagePickerMock.getImage(source: ImageSource.camera))
        .thenAnswer((_) async => PickedFile(imageTestFilePath));
  }

  group('pickImage tests', () {
    test('Given ImagePicker returns image, returns the same image', () async {
      setUpImagePickerWithImage();

      var file = await ImageUploader.pickImage(ImageSource.camera,
          imagePicker: imagePickerMock);

      expect(file.path, imageTestFilePath);
    });

    test('Given non functioning ImagePicker throws FileSystemException',
        () async {
      expect(
          () async => await ImageUploader.pickImage(ImageSource.camera,
              imagePicker: imagePickerMock),
          throwsException);
    });
  });

  group('cropImage tests', () {
    test('Given empty file path throws FormatException', () async {
      expect(() async => await ImageUploader.cropImage(''), throwsException);
    });

    test('Given null file path throws FormatException', () async {
      expect(() async => await ImageUploader.cropImage(null), throwsException);
    });
  });
}
