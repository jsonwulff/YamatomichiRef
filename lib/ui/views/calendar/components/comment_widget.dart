import 'package:app/middleware/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentList extends StatefulWidget {
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List<Comment> comments = [];
  static var commentTextController = TextEditingController();
  static var commentImageController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                    labelText: 'Image Url', hintText: 'http://www.imageurl.com/img'),
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
    print('post: ' + commentTextController.text);
    print('postimage' + commentImageController.text);
    if (commentTextController.text.isEmpty && commentImageController.text.isEmpty)
      print('comment = null');
    else {
      comments.insert(
          0,
          Comment(
              createdBy: 'Malou Landsgaard',
              comment: commentTextController.text,
              imgUrl: commentImageController.text));
      FocusScope.of(context).unfocus();
      commentTextController.clear();
      commentImageController.clear();
      setState(() {});
    }
  }

  Widget commentsBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(
            '${comments.length} Comments',
            style: TextStyle(fontSize: 15, color: Color.fromRGBO(81, 81, 81, 1)),
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
    var commentDate = comment.time != null
        ? _formatDateTime(comment.time.toDate())
        : _formatDateTime(Timestamp.now().toDate());
    return Container(
      padding: EdgeInsets.only(top: 15, right: 30, bottom: 15),
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
                                '${comment.createdBy}',
                                style:
                                    TextStyle(fontSize: 15, color: Color.fromRGBO(81, 81, 81, 1)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                //Content
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  '$commentDate',
                                  style: TextStyle(
                                      fontSize: 12, color: Color.fromRGBO(81, 81, 81, 0.5)),
                                ),
                              )
                            ],
                          ),
                          //Comment
                          Padding(
                            //Content
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commentText(comment),
                                commentImage(comment),
                              ],
                            ),
                          )
                        ],
                      )))
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> makeComments() {
    List<Widget> commentWidgets = [];
    if (comments.isNotEmpty) comments.forEach((c) => commentWidgets.add(commentDisplay(c)));
    return commentWidgets;
  }

  @override
  Widget build(BuildContext context) {
    print('builds:');

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
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
}

_formatDateTime(DateTime dateTime) {
  return DateFormat('dd. MMMM y').format(dateTime);
}
