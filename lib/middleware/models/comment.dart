import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String createdBy;
  String comment;
  Timestamp createdAt;
  List<dynamic> imgUrl;
  bool hidden;

  Comment(
      {this.id,
      this.createdBy,
      this.comment,
      this.createdAt,
      this.imgUrl,
      this.hidden});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'comment': comment,
      'createdAt': createdAt,
      'imgUrl': imgUrl,
      'hidden': hidden,
    };
  }

  Comment.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdBy = data['createdBy'];
    comment = data['comment'];
    createdAt = data['createdAt'];
    imgUrl = data['imgUrl'];
    hidden = data['hidden'];
  }

  factory Comment.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return Comment(
      id: documentSnapshot.id,
      createdBy: data['createdBy'],
      comment: data['comment'],
      createdAt: data['createdAt'],
      imgUrl: data['imgUrl'],
      hidden: data['hidden'],
    );
  }
}
