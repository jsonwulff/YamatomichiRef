import 'dart:io';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/shared/dialogs/image_picker_modal.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:app/ui/views/profile/components/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileAvatar extends StatefulWidget {
  final UserProfile userProfile;
  final Function setUploadImage;
  final Function deleteUploadImage;

  const EditProfileAvatar({
    Key key,
    this.userProfile,
    this.setUploadImage,
    this.deleteUploadImage,
  }) : super(key: key);

  @override
  _EditProfileAvatarState createState() => _EditProfileAvatarState();
}

class _EditProfileAvatarState extends State<EditProfileAvatar> {
  final UserProfileService userProfileService = UserProfileService();

  File imageFile;
  File croppedImageFile;
  bool isImageUpdated;

  void setImagesState(File image, File croppedImage) {
    setState(() {
      imageFile = image;
      croppedImageFile = croppedImage;
      isImageUpdated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: GestureDetector(
            child: ProfileAvatar(widget.userProfile, 60, imageFile: croppedImageFile),
            onTap: () async {
              // Edit image before uploading it if not cropped properly
              if (croppedImageFile != null) {
                File tempCroppedImageFile = await ImageUploader.cropImage(imageFile.path);
                setState(() => croppedImageFile = tempCroppedImageFile);
              }
            },
          ),
        ),
        InkWell(
          // TODO: Translate
          child: Text(
            texts.changeProfilePicture,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            imagePickerModal(
                context: context,
                modalTitle: widget.userProfile.imageUrl == null
                    ? texts.uploadPicture
                    : texts.changeProfilePicture,
                cameraButtonText: texts.takePicture,
                onCameraButtonTap: () async {
                  File tempImageFile = await ImageUploader.pickImage(ImageSource.camera);
                  File tempCroppedImageFile = await ImageUploader.cropImage(tempImageFile.path);
                  setImagesState(tempImageFile, tempCroppedImageFile);
                },
                photoLibraryButtonText: texts.chooseFromPhotoLibrary,
                onPhotoLibraryButtonTap: () async {
                  File tempImageFile = await ImageUploader.pickImage(ImageSource.gallery);
                  File tempCroppedImageFile = await ImageUploader.cropImage(tempImageFile.path);
                  widget.setUploadImage(tempCroppedImageFile);
                  setImagesState(tempImageFile, tempCroppedImageFile);
                },
                showDeleteButton: widget.userProfile.imageUrl != null,
                deleteButtonText: texts.deleteExistingProfilePicture,
                onDeleteButtonTap: () => widget.deleteUploadImage()
                // userProfileService.deleteUserProfileImage(userProfile, userProfileUpdated);
                );
          },
        ),
      ],
    );
  }
}
