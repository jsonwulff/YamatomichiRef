import 'package:cloud_firestore/cloud_firestore.dart';

class Packlist {
  String id;
  String title;
  String amountOfDays;
  String season;
  String tag;
  String description;
  List<String> imageUrls;
  Timestamp createdAt;
  Timestamp updatedAt;
  List<dynamic> carrying;
  List<dynamic> sleepingGear;
  List<dynamic> clothesPacked;
  List<dynamic> clothesWorn;
  List<dynamic> foodAndCooking;
  List<dynamic> other;
  String createdBy;

  Packlist({
    this.id,
    this.title,
    this.amountOfDays,
    this.season,
    this.tag,
    this.description,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amountOfDays': amountOfDays,
      'season': season,
      'tag': tag,
      'description': description,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Packlist.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    amountOfDays = data['amountOfDays'];
    season = data['season'];
    tag = data['tag'];
    description = data['description'];
    imageUrls = data['imageUrls'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  factory Packlist.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return Packlist(
      id: documentSnapshot.id,
      title: data['title'],
      amountOfDays: data['amountOfDays'],
      season: data['season'],
      tag: data['tag'],
      description: data['description'],
      imageUrls: data['imageUrls'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}

class GearItem {
  String id;
  Timestamp createdAt;
  String title;
  int weight;
  int amount;
  String url;
  String brand;

  GearItem({
    this.id,
    this.createdAt,
    this.title,
    this.weight,
    this.amount,
    this.url,
    this.brand,
  });
}
