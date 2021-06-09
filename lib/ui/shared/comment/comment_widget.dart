import 'dart:io';

import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/comment.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/components/mini_avatar.dart';
import 'package:app/ui/shared/dialogs/img_pop_up.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:app/ui/views/personalProfile/personal_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/shared/dialogs/image_picker_modal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentWidget extends StatefulWidget {
  final String documentRef;
  final DBCollection collection;

  const CommentWidget({Key key, this.documentRef, this.collection}) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Map<String, dynamic>> comments = [];
  List<File> images = [];
  CommentService commentService = CommentService();
  UserProfileService userProfileService = UserProfileService();
  static var commentTextController = TextEditingController();
  static var commentImageController = TextEditingController();
  UserProfileNotifier userProfileNotifier;

  @override
  void initState() {
    super.initState();
    String userUid;
    userProfileNotifier = Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
    } else {
      userUid = context.read<AuthenticationService>().user.uid;
    }
  }

  imageView(BuildContext context) {
    return Container(
        height: images.length == 0
            ? 0.0
            : images.length % 5 == 0
                ? 80 * ((images.length / 5))
                : images.length < 5
                    ? 80
                    : 80 * ((images.length / 5).floor() + 1.0),
        child: GridView.count(
            crossAxisCount: 5,
            children: List.generate(images.length, (index) {
              return Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: InkWell(
                      onTap: () => imagePopUp(context, images.elementAt(index)),
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey,
                        image: DecorationImage(
                            image: FileImage(images.elementAt(index)), fit: BoxFit.cover),
                        //NetworkImage(url), fit: BoxFit.cover),
                      ))));
            })));
  }

  imagePopUp(BuildContext context, File url) async {
    if (await imgDeleteChoiceDialog(context, url) == 'remove') {
      setState(() {
        images.remove(url);
      });
    }
  }

  Widget commentInput(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        //Image / content
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: TextFormField(
              controller: commentTextController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              maxLength: 200,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: texts.addAComment),
              // width: MediaQuery.of(context).size.width / 2.6,
            ),
          ),
          Container(
              width: 40.0,
              child: TextButton(
                child: Icon(Icons.image),
                onPressed: () {
                  //_inputImageDialog(context);
                  inputImagePickerModal(context);
                },
              )),
          Container(
              width: 40.0,
              child: TextButton(
                child: Icon(Icons.add),
                onPressed: () {
                  postComment();
                },
              ))
        ],
      ),
    );
  }

  inputImagePickerModal(BuildContext context) async {
    var texts = AppLocalizations.of(context);
    await imagePickerModal(
      context: context,
      modalTitle: texts.uploadPicture,
      cameraButtonText: texts.takePicture,
      onCameraButtonTap: () async {
        var tempImageFile = await ImageUploader.pickImage(ImageSource.camera);
        var tempCroppedImageFile =
            await ImageUploader.cropImageWithoutRestrictions(tempImageFile.path);

        images.add(tempCroppedImageFile);
        //await addImageToStorage(tempCroppedImageFile);

        _setImagesState();

        //Navigator.pop(context);
      },
      photoLibraryButtonText: texts.chooseFromPhotoLibrary,
      onPhotoLibraryButtonTap: () async {
        var tempImageFile = await ImageUploader.pickImage(ImageSource.gallery);
        /*var tempCroppedImageFile =
            await ImageUploader.cropImage(tempImageFile.path);*/

        images.add(tempImageFile);
        //await addImageToStorage(tempCroppedImageFile);

        _setImagesState();

        //Navigator.pop(context);
      },
      showDeleteButton: false,
      deleteButtonText: '',
      onDeleteButtonTap: null,
    );
  }

  void _setImagesState() {
    setState(() {});
  }

  postComment() async {
    if (commentTextController.text.isEmpty && images.isEmpty)
      return;
    else {
      List<String> storageImages = [];
      if (images.isNotEmpty) {
        for (File file in images) {
          String datetime =
              DateTime.now().toString().replaceAll(':', '').replaceAll('-', '').replaceAll(' ', '');
          String filePath =
              'commentImages/${widget.collection.toString().split('.').last}/${userProfileNotifier.userProfile.id}/$datetime.jpg';
          Reference reference = _storage.ref().child(filePath);
          await reference.putFile(file).whenComplete(() async {
            var url = await reference.getDownloadURL();
            storageImages.add(url);
          });
        }
        images.clear();
      }
      var data = {
        'createdBy': userProfileNotifier.userProfile.id,
        'comment': commentTextController.text,
        'imgUrl': storageImages,
      };
      commentService.addComment(data, widget.collection, widget.documentRef).then((comment) {
        FocusScope.of(context).unfocus();
        commentTextController.clear();
        commentImageController.clear();
      });
    }
  }

  Widget commentsBar() {
    var texts = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(
            '${comments.length} ' + texts.comments,
            style: TextStyle(fontSize: 15, color: Color.fromRGBO(81, 81, 81, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<Widget> commentImage(Comment comment) {
    if (comment.imgUrl.isNotEmpty)
      return List.generate(comment.imgUrl.length, (index) {
        return Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Image(image: NetworkImage(comment.imgUrl.elementAt(index))));
      }).toList();
    else
      return [Container()];
  }

  Widget commentText(Comment comment) {
    if (comment.comment != '')
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            '${comment.comment}', //no translate
            style: TextStyle(fontSize: 13, color: Color.fromRGBO(81, 81, 81, 1)),
          ));
    else
      return Container();
  }

  Widget commentDisplay(Comment comment) {
    var texts = AppLocalizations.of(context);
    return FutureBuilder(
      future: userProfileService.getUserProfile(comment.createdBy),
      builder: (context, _user) {
        if (_user.connectionState != ConnectionState.done || _user.hasData == null) {
          return Text('');
        }

        UserProfile user = _user.data;
        var commentDate = comment.createdAt != null
            ? _formatDateTime(comment.createdAt.toDate())
            : _formatDateTime(Timestamp.now().toDate());
        return Stack(children: [
          Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 30, 15),
                child: Column(
                  children: [
                    Row(
                      //Image / content
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: PersonalProfileView(userID: user.id),
                                withNavBar: false,
                              );
                            },
                            child: MiniAvatar(user: user),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            //Content
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style:
                                      TextStyle(fontSize: 15, color: Color.fromRGBO(81, 81, 81, 1)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '$commentDate',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(81, 81, 81, 0.5),
                                  ),
                                ),
                                Padding(
                                  //Content
                                  padding: EdgeInsets.only(top: 10, right: 10), //image padding
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      commentText(comment),
                                    ]..addAll(commentImage(comment)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 0,
              right: 0,
              child: userProfileNotifier.userProfile.roles['ambassador'] == true ||
                      userProfileNotifier.userProfile.roles['yamatomichi'] ||
                      userProfileNotifier.userProfile.id == comment.createdBy
                  ? IconButton(
                      onPressed: () =>
                          userProfileNotifier.userProfile.roles['ambassador'] == true ||
                                  userProfileNotifier.userProfile.roles['yamatomichi']
                              ? showBottomSheet(comment, texts.hideComment)
                              : showBottomSheet(comment, texts.deleteComment),
                      icon: Icon(
                        Icons.keyboard_control_outlined,
                        color: Colors.black,
                      ),
                    )
                  : Container())
        ]);
      },
    );
  }

  Future<Widget> makeComments() async {
    await getComments();
    List<Widget> commentWidgets = [];
    if (comments != null || comments.isNotEmpty)
      comments.forEach((c) => commentWidgets.add(commentDisplay(Comment.fromMap(c))));
    return Column(children: commentWidgets);
  }

  Future<void> showBottomSheet(Comment comment, String text) {
    return showModalBottomSheet<void>(
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
                      text,
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.center,
                    ),
                    // dense: true,
                    onTap: () => userProfileNotifier.userProfile.roles['ambassador'] == true ||
                            userProfileNotifier.userProfile.roles['yamatomichi'] == true
                        ? hideComment(comment)
                        : deleteComment(comment)),
              ]));
        });
  }

  deleteComment(Comment comment) async {
    var texts = AppLocalizations.of(context);
    if (await simpleChoiceDialog(context, texts.areYouSureYouWantToDeleteThisComment)) {
      for (String url in comment.imgUrl) {
        _storage.refFromURL(url.split('?alt').first).delete();
      }
      commentService.deleteComment(comment.id, widget.collection, widget.documentRef);
      Navigator.pop(context);
      setState(() {});
    }
  }

  hideComment(Comment comment) async {
    commentService
        .updateComment(widget.collection, widget.documentRef, comment.id, {'hidden': true});
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(children: [
              imageView(context),
              commentInput(context),
              Container(
                  child: FutureBuilder(
                      future: makeComments(),
                      builder: (context, _makeComments) {
                        if (_makeComments.connectionState == ConnectionState.done &&
                            _makeComments.hasData) {
                          return Column(children: [
                            commentsBar(),
                            _makeComments.data,
                          ]);
                        } else
                          return Container();
                      }))
            ])));
  }

  @override
  void dispose() {
    commentTextController.clear();
    commentImageController.clear();
    super.dispose();
  }

  Future<String> getComments() async {
    await commentService.getComments(widget.collection, widget.documentRef).then((e) => {
          comments.clear(),
          e.forEach((element) => {element['hidden'] != true ? comments.insert(0, element) : null})
        });
    return 'Success';
  }
}

_formatDateTime(DateTime dateTime) {
  return DateFormat('dd. MMMM y').format(dateTime);
}
