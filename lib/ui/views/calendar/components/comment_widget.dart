import 'dart:io';

import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/models/comment.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/shared/dialogs/image_picker_modal.dart';

class CommentWidget extends StatefulWidget {
  final String documentRef;

  const CommentWidget({
    Key key,
    this.documentRef,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Map<String, dynamic>> comments = [];
  List<String> images = [];
  CommentService commentService = CommentService();
  static var commentTextController = TextEditingController();
  static var commentImageController = TextEditingController();
  File newImage;
  UserProfileNotifier userProfileNotifier;

  @override
  void initState() {
    super.initState();
    String userUid;
    userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
    } else {
      userUid = context.read<AuthenticationService>().user.uid;
    }
  }

  imageView() {
    return Container(
        height: images.length == 0
            ? 0.0
            : images.length % 4 == 0
                ? 80 * ((images.length / 4))
                : images.length < 4
                    ? 80
                    : 80 * ((images.length / 4).floor() + 1.0),
        child: GridView.count(
            crossAxisCount: 5,
            children: List.generate(images.length, (index) {
              return Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: InkWell(
                      onTap: () => null,
                      /*eventPreviewPopUp(
                            images.elementAt(index).toString()),*/
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey,
                        image: DecorationImage(
                            image: NetworkImage(
                                images.elementAt(index).toString()),
                            fit: BoxFit.cover),
                        //NetworkImage(url), fit: BoxFit.cover),
                      ))));
            })));
  }

  Widget commentInput(BuildContext context) {
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
              decoration: InputDecoration(hintText: 'Add a comment'),
              // width: MediaQuery.of(context).size.width / 2.6,
            ),
          ),
          Container(
              width: 40.0,
              child: newImage == null
                  ? TextButton(
                      child: Icon(Icons.image),
                      onPressed: () {
                        //_inputImageDialog(context);
                        inputImagePickerModal(context);
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: InkWell(
                          onTap: () => null, //eventPreviewPopUp(mainImage),
                          child: Container(
                              height: 40,
                              width: 0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Colors.grey,
                                image: DecorationImage(
                                    image: FileImage(newImage),
                                    fit: BoxFit.cover),
                                //NetworkImage(url), fit: BoxFit.cover),
                              ))))),
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
    await imagePickerModal(
      context: context,
      modalTitle: 'Upload picture',
      cameraButtonText: 'Take picture',
      onCameraButtonTap: () async {
        var tempImageFile = await ImageUploader.pickImage(ImageSource.camera);
        var tempCroppedImageFile =
            await ImageUploader.cropImage(tempImageFile.path);

        newImage = tempCroppedImageFile;
        //await addImageToStorage(tempCroppedImageFile);

        _setImagesState();

        //Navigator.pop(context);
      },
      photoLibraryButtonText: 'Choose from photo library',
      onPhotoLibraryButtonTap: () async {
        var tempImageFile = await ImageUploader.pickImage(ImageSource.gallery);
        var tempCroppedImageFile =
            await ImageUploader.cropImage(tempImageFile.path);

        newImage = tempCroppedImageFile;
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

  /*Future<void> _inputImageDialog(BuildContext context) async {
    if (await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter networkimage URL'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                controller: commentImageController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Image Url',
                    hintText: 'http://www.imageurl.com/img'),
              ))
            ],
          ),
          actions: [
            TextButton(
              child: Text('Upload'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    )) {
      print('uploaded:' + commentImageController.text);
    } else {
      print('not uploaded' + commentImageController.text);
      commentImageController.clear();
    }
  }*/

  postComment() async {
    //var userProfileId =
    //Provider.of<UserProfileNotifier>(context).userProfile.id;

    if (commentTextController.text.isEmpty && newImage == null)
      print('comment = null');
    else {
      if (newImage != null) {
        String filePath =
            'commentImages/${userProfileNotifier.userProfile.id}/${DateTime.now()}.jpg';
        Reference reference = _storage.ref().child(filePath);
        await reference.putFile(newImage).whenComplete(() async {
          var url = await reference.getDownloadURL();
          commentImageController.text = url;
          newImage = null;
        });
      }
      var data = {
        'createdBy': userProfileNotifier.userProfile.id,
        'comment': commentTextController.text,
        'imgUrl': commentImageController.text
      };
      commentService
          .addComment(data, DBCollection.Calendar, widget.documentRef)
          .then((comment) {
        print(comment['comment']);
        //comments.insert(
        //  0,
        //  comment);

        FocusScope.of(context).unfocus();
        commentTextController.clear();
        commentImageController.clear();
        setState(() {});
      });
    }
  }

  Widget commentsBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(
            '${comments.length} Comments',
            style:
                TextStyle(fontSize: 15, color: Color.fromRGBO(81, 81, 81, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget commentImage(Comment comment) {
    if (comment.imgUrl != '')
      return Container(
          padding: EdgeInsets.only(top: 15),
          child: Image(image: NetworkImage('${comment.imgUrl}')));
    else
      return Container();
  }

  Widget commentText(Comment comment) {
    if (comment.comment != '')
      return Text(
        '${comment.comment}',
        style: TextStyle(fontSize: 13, color: Color.fromRGBO(81, 81, 81, 1)),
      );
    else
      return Container();
  }

  Widget commentDisplay(Comment comment) {
    var commentDate = comment.createdAt != null
        ? _formatDateTime(comment.createdAt.toDate())
        : _formatDateTime(Timestamp.now().toDate());
    return Stack(children: [
      Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 30, 15),
            child: Column(
              children: [
                Row(
                  //Image / content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //Image
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Flexible(
                        child: Padding(
                            //Content
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  //Name / time
                                  children: [
                                    Text(
                                      //'${comment.createdBy}',
                                      'Laura',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(81, 81, 81, 1)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      //Content
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        '$commentDate',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color.fromRGBO(
                                                81, 81, 81, 0.5)),
                                      ),
                                    ),
                                  ],
                                ),
                                //Comment
                                Padding(
                                  //Content
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commentText(comment),
                                      //commentImage(comment),
                                    ],
                                  ),
                                )
                              ],
                            ))),
                  ],
                ),
              ],
            ),
          )),
      Positioned(
          top: 0,
          right: 10,
          child: userProfileNotifier.userProfile.roles['administrator'] ==
                      true ||
                  userProfileNotifier.userProfile.id == comment.createdBy
              ? IconButton(
                  onPressed: () =>
                      userProfileNotifier.userProfile.roles['administrator'] ==
                              true
                          ? showBottomSheet(comment, 'Hide comment')
                          : showBottomSheet(comment, 'Delete comment'),
                  icon: Icon(
                    Icons.keyboard_control_outlined,
                    color: Colors.black,
                  ),
                )
              : Container())
    ]);
  }

  List<Widget> makeComments() {
    getComments();
    List<Widget> commentWidgets = [];
    if (comments.isNotEmpty)
      comments.forEach(
          (c) => commentWidgets.add(commentDisplay(Comment.fromMap(c))));
    return commentWidgets;
  }

  Future<void> showBottomSheet(Comment comment, String text) {
    return showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
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
                    onTap: () => userProfileNotifier
                                .userProfile.roles['administrator'] ==
                            true
                        ? hideComment(comment)
                        : deleteComment(comment)),
              ]));
        });
  }

  deleteComment(Comment comment) async {
    print('delete button action');
    if (await simpleChoiceDialog(
        context, 'Are you sure you want to delete this comment?')) {
      if (_storage.refFromURL(comment.imgUrl) != null)
        _storage.refFromURL(comment.imgUrl).delete();
      commentService.deleteComment(
          comment.toMap(), DBCollection.Calendar, widget.documentRef);
      Navigator.pop(context);
      setState(() {});
    }
  }

  hideComment(Comment comment) async {
    commentService.updateComment(DBCollection.Calendar, widget.documentRef,
        comment.id, {'hidden': true});
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(widget.documentRef),
          imageView(),
          commentInput(context),
          commentsBar(),
          Column(children: makeComments()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentTextController.clear();
    commentImageController.clear();
    super.dispose();
  }

  void getComments() {
    commentService
        .getComments(DBCollection.Calendar, widget.documentRef)
        .then((e) => {
              comments.clear(),
              images.clear(),
              e.forEach((element) => {
                    comments.add(element),
                    element['imgUrl'] != ''
                        ? images.add(element['imgUrl'])
                        : null
                  }),
              setState(() {})
            });
  }
}

_formatDateTime(DateTime dateTime) {
  return DateFormat('dd. MMMM y').format(dateTime);
}
