import 'package:cloud_firestore/cloud_firestore.dart';

class Packlist {
  String id;
  String title;
  String amountOfDays;
  String season;
  String tag;
  String description;
  Timestamp createdAt;
  Timestamp updatedAt;
  List<dynamic> gearItemsAsTuples;
  // List<dynamic> sleepingGear;
  // List<dynamic> clothesPacked;
  // List<dynamic> clothesWorn;
  // List<dynamic> foodAndCooking;
  // List<dynamic> other;
  String createdBy;
  bool endorsedHighlighted;
  bool allowComments;
  List<dynamic> imageUrl;
  bool public;
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
    this.endorsedHighlighted,
    this.allowComments,
    this.imageUrl,
    this.public,
    this.createdBy,
    this.totalAmount,
    this.totalWeight,
    //this.mainImage
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'public': public,
      'createdBy': createdBy,
      //'mainImage': mainImage
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
    public = data['public'];
    createdBy = data['createdBy'];
    //mainImage = data['mainImage'];
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
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      endorsedHighlighted: data['endorsedHighlighted'],
      allowComments: data['allowComments'],
      imageUrl: data['imageUrl'],
      public: data['public'],
      createdBy: data['createdBy'],
      //mainImage: data['mainImage'],
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
      'id': id,
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
