import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<T> imagePickerModal<T>({
  @required BuildContext context,
  @required String modalTitle,
  @required String cameraButtonText,
  @required VoidCallback onCameraButtonTap,
  @required String photoLibraryButtonText,
  @required VoidCallback onPhotoLibraryButtonTap,
  @required bool showDeleteButton,
  @required String deleteButtonText,
  @required VoidCallback onDeleteButtonTap,
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
                onCameraButtonTap();
                Navigator.pop(context);
              },
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(photoLibraryButtonText, textAlign: TextAlign.center),
              onTap: () {
                onPhotoLibraryButtonTap();
                Navigator.pop(context);
              },
            ),
            if (showDeleteButton) ...[
              Divider(thickness: 1),
              ListTile(
                title: Text(deleteButtonText, textAlign: TextAlign.center),
                onTap: () {
                  onDeleteButtonTap();
                  Navigator.pop(context);
                },
              )
            ],
            Divider(thickness: 1),
            ListTile(
              title: Text(
                AppLocalizations.of(context).close,
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
}
