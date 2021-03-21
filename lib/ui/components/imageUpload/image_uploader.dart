import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  // Active image file
  File _imageFile;
  File _croppedImageFile;

  // Select an image with gallery or cameray
  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected = await ImagePicker().getImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
      _croppedImageFile = File(selected.path);
    });
  }

  // Remove image
  void _clear() {
    setState(() {
      _imageFile = null;
      _croppedImageFile = null;
    });
  }

  // Crop image
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        maxHeight: 256,
        maxWidth: 256,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 40,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white));
    setState(() {
      _croppedImageFile = cropped ?? _imageFile;
    });
  }

  Future<File> _pickImageWithInstanCrop(ImageSource source) async {
    PickedFile selected = await ImagePicker().getImage(source: source);

    File cropped = await ImageCropper.cropImage(
        sourcePath: selected.path,
        maxHeight: 256,
        maxWidth: 256,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 40,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white));

    setState(() {
      _imageFile = File(selected.path);
      _croppedImageFile = File(selected.path);
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
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
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
                    onPressed: () =>
                        _pickImageWithInstanCrop(ImageSource.gallery),
                  ),
                  ElevatedButton(
                    onPressed: () => _cropImage(),
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

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.jpg';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: _uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          var event = snapshot?.data;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalBytes : 0;
          return Column(
            children: [
              // if (event.state == TaskState.success) Text('Upload completed '),
              // if (event.state == TaskState.paused)
              //   ElevatedButton(
              //     onPressed: _uploadTask.resume,
              //     child: Icon(Icons.play_arrow),
              //   ),
              // if (event.state == TaskState.running)
              //   ElevatedButton(
              //     onPressed: _uploadTask.pause,
              //     child: Icon(Icons.pause),
              //   ),
              LinearProgressIndicator(
                value: progressPercent,
              ),
            ],
          );
        },
      );
    } else {
      return ElevatedButton.icon(
        onPressed: _startUpload,
        icon: Icon(Icons.cloud_upload),
        label: Text('Upload image'),
      );
    }
  }
}
