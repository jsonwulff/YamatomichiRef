import 'package:flutter/material.dart';

Future<T> imagePickerModal<T>({
  @required BuildContext context,
  @required String modalTitle,
  @required String cameraButtonText,
}) {
  return showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                modalTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                cameraButtonText,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // _pickImageWithInstanCrop(ImageSource.camera);
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    },
  );
}
