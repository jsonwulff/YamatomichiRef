import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  static Future<File> pickImage(ImageSource source,
      {@visibleForTesting ImagePicker imagePicker}) async {
    var image;

    imagePicker != null
        ? image = await imagePicker.getImage(source: source)
        : image = await ImagePicker().getImage(source: source);

    if (image == null || image.path == null || image.path == '') {
      throw FileSystemException('Could not find the given file');
    }

    return File(image.path);
  }

  static Future<File> cropImage(String imageFilePath) async {
    return await ImageCropper.cropImage(
        sourcePath: imageFilePath,
        maxHeight: 256,
        maxWidth: 256,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 40,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white));
  }

  static Future<File> pickImageWithInstanCrop(ImageSource source,
      {File originalFile,
      File croppedFile,
      int height = 256,
      int width = 256,
      double aspectRatioX = 1.0,
      double aspectRatioY = 1.0,
      int compressQuality = 40}) async {
    File selected = await pickImage(source);

    File cropped = await ImageCropper.cropImage(
      sourcePath: selected.path,
      maxHeight: height,
      maxWidth: width,
      aspectRatio: CropAspectRatio(ratioX: aspectRatioX, ratioY: aspectRatioY),
      compressQuality: compressQuality,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop profile image',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        activeControlsWidgetColor: Colors.blue,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Crop profile image',
        doneButtonTitle: 'Done',
        cancelButtonTitle: 'Cancel',
      ),
    );

    if (originalFile != null) originalFile = selected;
    if (croppedFile != null) croppedFile = File(cropped.path);

    return cropped;
  }
}
