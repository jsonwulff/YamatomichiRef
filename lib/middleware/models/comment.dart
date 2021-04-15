import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String createdBy;
  String comment;
  Timestamp createdAt;
  String imgUrl;

  Comment({this.id, this.createdBy, this.comment, this.createdAt, this.imgUrl = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'comment': comment,
      'createdAt': createdAt,
      'imgUrl': imgUrl,
    };
  }

  Comment.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdBy = data['createdBy'];
    comment = data['comment'];
    createdAt = data['createdAt'];
    imgUrl = data['imgUrl'];
  }

  factory Comment.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return Comment(
      id: documentSnapshot.id,
      createdBy: data['createdBy'],
      comment: data['comment'],
      createdAt: data['createdAt'],
      imgUrl: data['imgUrl'],
    );
  }
}
