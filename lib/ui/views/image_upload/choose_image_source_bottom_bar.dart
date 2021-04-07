import 'dart:io';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:app/ui/views/image_upload/uploader_progress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCaptureBottomBar extends StatefulWidget {
  @override
  _ImageCaptureBottomBarState createState() => _ImageCaptureBottomBarState();
}

class _ImageCaptureBottomBarState extends State<ImageCaptureBottomBar> {
  File _imageFile;
  File _croppedImageFile;

  void _clear() {
    setState(() {
      _imageFile = null;
      _croppedImageFile = null;
    });
  }

  void setImages(File imageFile, File croppedImageFile) {
    setState(() {
      _imageFile = imageFile;
      _croppedImageFile = croppedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              key: Key('ImageCaptureBottomBar_takePictureIconButton'),
              icon: Icon(Icons.photo_camera),
              onPressed: () async => _imageFile = await ImageUploader.pickImage(ImageSource.camera),
            ),
            IconButton(
              key: Key('ImageCaptureBottomBar_takeImageFromGalleryIconButton'),
              icon: Icon(Icons.photo_library),
              onPressed: () async =>
                  _imageFile = await ImageUploader.pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            if (_imageFile != null) ...[
              CircleAvatar(
                key: Key('ImageCaptureBottomBar_circleAvatar'),
                radius: 100,
                backgroundImage: FileImage(_croppedImageFile),
              ),
              // Image.file(_imageFile),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    key: Key('ImageCaptureBottomBar_uploadImageFromCircleAbatar'),
                    child: Icon(Icons.photo),
                    onPressed: () async => await ImageUploader.pickImageWithInstanCrop(
                        ImageSource.gallery,
                        originalFile: _imageFile,
                        croppedFile: _croppedImageFile),
                  ),
                  ElevatedButton(
                    key: Key('ImageCaptureBottomBar_editChosenImage'),
                    onPressed: () async =>
                        _croppedImageFile = await ImageUploader.cropImage(_imageFile.path),
                    child: Icon(Icons.crop),
                  ),
                  ElevatedButton(
                    key: Key('ImageCaptureBottomBar_clear'),
                    onPressed: _clear,
                    child: Icon(Icons.refresh),
                  )
                ],
              ),
              UploaderProgress(file: _imageFile)
            ]
          ],
        ),
      ),
    );
  }
}
