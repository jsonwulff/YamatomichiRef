// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class Uploader extends StatefulWidget {
//   final File file;

//   Uploader({Key key, this.file}) : super(key: key);

//   @override
//   _UploaderState createState() => _UploaderState();
// }

// class _UploaderState extends State<Uploader> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   UploadTask _uploadTask;

//   void _startUpload() {
//     String filePath = 'images/${DateTime.now()}.jpg';

//     setState(() {
//       _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_uploadTask != null) {
//       return StreamBuilder<TaskSnapshot>(
//         stream: _uploadTask.snapshotEvents,
//         builder: (context, snapshot) {
//           var event = snapshot?.data;
//           double progressPercent =
//               event != null ? event.bytesTransferred / event.totalBytes : 0;
//           return Column(
//             children: [
//               // if (event.state == TaskState.success) Text('Upload completed '),
//               // if (event.state == TaskState.paused)
//               //   ElevatedButton(
//               //     onPressed: _uploadTask.resume,
//               //     child: Icon(Icons.play_arrow),
//               //   ),
//               // if (event.state == TaskState.running)
//               //   ElevatedButton(
//               //     onPressed: _uploadTask.pause,
//               //     child: Icon(Icons.pause),
//               //   ),
//               LinearProgressIndicator(
//                 value: progressPercent,
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       return ElevatedButton.icon(
//         onPressed: _startUpload,
//         icon: Icon(Icons.cloud_upload),
//         label: Text('Upload image'),
//       );
//     }
//   }
// }