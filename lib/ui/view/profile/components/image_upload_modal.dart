import 'package:flutter/material.dart';

class ImageUploadModal extends StatelessWidget {
  const ImageUploadModal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        "Change profile picture",
        style: TextStyle(color: Colors.blue),
      ),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
          ),
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                // height: 330,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Change profile image',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(thickness: 1),
                  ListTile(
                    title: const Text(
                      'Take profile picture',
                      textAlign: TextAlign.center,
                    ),
                    // dense: true,
                    onTap: () {},
                  ),
                  Divider(
                    thickness: 1,
                    height: 5,
                  ),
                  ListTile(
                    title: const Text(
                      'Choose from photo library',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {},
                  ),
                  Divider(thickness: 1),
                  ListTile(
                    title: const Text(
                      'Delete existing profile picture',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {},
                  ),
                  Divider(thickness: 1),
                  ListTile(
                    title: const Text(
                      'Close',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => Navigator.pop(context),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
