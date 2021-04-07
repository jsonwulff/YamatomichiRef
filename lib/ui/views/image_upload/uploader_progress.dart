import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploaderProgress extends StatefulWidget {
  final File file;

  UploaderProgress({Key key, this.file}) : super(key: key);

  @override
  _UploaderProgressState createState() => _UploaderProgressState();
}

class _UploaderProgressState extends State<UploaderProgress> {
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