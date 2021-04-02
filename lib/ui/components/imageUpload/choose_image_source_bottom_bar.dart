import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/ui/components/imageUpload/image_uploader.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;
  File _croppedImageFile;

  void _clear() {
    setState(() {
      _imageFile = null;
      _croppedImageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async => _imageFile =
                  await ImageUploader.pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () async => _imageFile =
                  await ImageUploader.pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            if (_imageFile != null) ...[
              CircleAvatar(
                radius: 100,
                backgroundImage: FileImage(_croppedImageFile),
              ),
              // Image.file(_imageFile),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    child: Icon(Icons.photo),
                    onPressed: () async =>
                        await ImageUploader.pickImageWithInstanCrop(
                            ImageSource.gallery,
                            originalFile: _imageFile,
                            croppedFile: _croppedImageFile),
                  ),
                  ElevatedButton(
                    onPressed: () async => _croppedImageFile = await ImageUploader.cropImage(_imageFile.path),
                    child: Icon(Icons.crop),
                  ),
                  ElevatedButton(
                    onPressed: _clear,
                    child: Icon(Icons.refresh),
                  )
                ],
              ),
              Uploader(file: _imageFile)
            ]
          ],
        ),
      ),
    );
  }
}