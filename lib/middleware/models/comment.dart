import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String createdBy;
  String comment;
  Timestamp time;
  String imgUrl;

  Comment({this.id, this.createdBy, this.comment, this.time, this.imgUrl = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'comment': comment,
      'time': time,
      'imgUrl': imgUrl,
    };
  }

  Comment.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdBy = data['createdBy'];
    comment = data['comment'];
    time = data['time'];
    imgUrl = data['imgUrl'];
  }

  factory Comment.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return Comment(
      id: data['id'],
      createdBy: data['createdBy'],
      comment: data['comment'],
      time: data['title'],
      imgUrl: data['imgUrl'],
    );
  }
}
