import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class Packlist {
  String id;
  String title;
  String amountOfDays;
  String season;
  String tag;
  String description;
  Timestamp createdAt;
  Timestamp updatedAt;
  List<File> images;
  List<Tuple2<String, List<GearItem>>> gearItemsAsTuples;
  String createdBy;
  bool endorsedHighlighted;
  bool allowComments;
  List<dynamic> imageUrl;
  bool private;
  int totalWeight;
  int totalAmount;
  //String mainImage;

  Packlist({
    this.id,
    this.title,
    this.amountOfDays,
    this.season,
    this.tag,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.endorsedHighlighted,
    this.allowComments,
    this.imageUrl,
    this.private,
    this.createdBy,
    this.totalAmount,
    this.totalWeight,
    this.gearItemsAsTuples,
    //this.mainImage
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amountOfDays': amountOfDays,
      'season': season,
      'tag': tag,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'endorsed': endorsedHighlighted,
      'allowComments': allowComments,
      'imageUrl': imageUrl,
      'private': private,
      'createdBy': createdBy,
    };
  }

  Packlist.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    amountOfDays = data['amountOfDays'];
    season = data['season'];
    tag = data['tag'];
    description = data['description'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    endorsedHighlighted = data['endorsedHighlighted'];
    allowComments = data['allowComments'];
    imageUrl = data['imageUrl'];
    private = data['private'];
    createdBy = data['createdBy'];
  }

  factory Packlist.fromFirestore(DocumentSnapshot documentSnapshot) {
    print("documentsnapshot : " + documentSnapshot.exists.toString());
    Map data = documentSnapshot.data();
    print("data : " + data.toString());

    return Packlist(
      id: documentSnapshot.id,
      title: data['title'],
      amountOfDays: data['amountOfDays'],
      season: data['season'],
      tag: data['tag'],
      description: data['description'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      endorsedHighlighted: data['endorsedHighlighted'],
      allowComments: data['allowComments'],
      imageUrl: data['imageUrl'],
      private: data['private'],
      createdBy: data['createdBy'],
    );
  }
}

class GearItem {
  String id;
  Timestamp createdAt;
  Timestamp updatedAt;
  String title;
  int weight;
  int amount;
  String url;
  String brand;

  GearItem({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.weight,
    this.amount,
    this.url,
    this.brand,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'title': title,
      'weight': weight,
      'amount': amount,
      'url': url,
      'brand': brand,
    };
  }

  GearItem.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    title = data['title'];
    weight = data['weight'];
    amount = data['amount'];
    url = data['url'];
    brand = data['brand'];
  }

  factory GearItem.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return GearItem(
      id: documentSnapshot.id,
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      title: data['title'],
      weight: data['weight'],
      amount: data['amount'],
      url: data['url'],
      brand: data['brand'],
    );
  }
}
