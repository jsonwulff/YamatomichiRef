import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String title;
  String createdBy;
  List<dynamic> images;
  String description;
  String category;
  String store;
  String usage;
  String imageUrl;
  bool highlighted;
  Timestamp createdAt;
  Timestamp updatedAt;

  Review(
      {this.id,
      this.title,
      this.createdBy,
      this.images,
      this.description,
      this.category,
      this.store,
      this.usage,
      this.imageUrl,
      this.highlighted = false,
      this.createdAt,
      this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdBy': createdBy,
      'description': description,
      'category': category,
      'store': store,
      'usage': usage,
      'highlighted': highlighted,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  Review.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    createdBy = data['createdBy'];
    description = data['description'];
    category = data['category'];
    store = data['store'];
    usage = data['usage'];
    imageUrl = data['imageUrl'];
    highlighted = data['highlighted'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  factory Review.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return Review(
      id: documentSnapshot.id,
      title: data['title'],
      createdBy: data['createdBy'],
      description: data['description'],
      category: data['category'],
      store: data['store'],
      usage: data['usage'],
      imageUrl: data['imageUrl'],
      highlighted: data['highlighted'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}
