import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/models/comment.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  List<Map<String, dynamic>> comments = [];
  CommentService commentService = CommentService();
  static var commentTextController = TextEditingController();
  static var commentImageController = TextEditingController();
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
              child: TextButton(
                child: Icon(Icons.image),
                onPressed: () {
                  _inputImageDialog(context);
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

  Future<void> _inputImageDialog(BuildContext context) async {
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
  }

  postComment() {
    //var userProfileId =
    //Provider.of<UserProfileNotifier>(context).userProfile.id;

    if (commentTextController.text.isEmpty &&
        commentImageController.text.isEmpty)
      print('comment = null');
    else {
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
                                      commentImage(comment),
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
          child: IconButton(
            onPressed: () => showBottomSheet(comment),
            icon: Icon(
              Icons.keyboard_control_outlined,
              color: Colors.black,
            ),
          ))
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

  Future<void> showBottomSheet(Comment comment) {
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
                    'Delete event',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                  // dense: true,
                  onTap: () => deleteComment(comment),
                ),
              ]));
        });
  }

  deleteComment(Comment comment) async {
    print('delete button action');
    if (await simpleChoiceDialog(
        context, 'Are you sure you want to delete this comment?')) {
      commentService.deleteComment(
          comment.toMap(), DBCollection.Calendar, widget.documentRef);
      Navigator.pop(context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(widget.documentRef),
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
    commentService.getComments(DBCollection.Calendar, widget.documentRef).then(
        (e) => {
              comments.clear(),
              e.forEach((element) => comments.add(element)),
              setState(() {})
            });
  }
}

_formatDateTime(DateTime dateTime) {
  return DateFormat('dd. MMMM y').format(dateTime);
}
