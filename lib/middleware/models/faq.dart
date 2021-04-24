import 'package:cloud_firestore/cloud_firestore.dart';

// abstract class Models {
//   Map<String, dynamic> toMap();

//   Models fromMap(Map<String, dynamic> data);

//   factory Models.fromDatabase(DocumentSnapshot documentSnapshot)
// }

class FaqItem {
  String id;
  String title;
  String body;

  FaqItem({this.id, this.title, this.body});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }
  
  FaqItem.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    body = data['body'];
  }

  factory FaqItem.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return FaqItem(
      id: documentSnapshot.id,
      title: data['title'],
      body: data['title'],
    );
  }
}