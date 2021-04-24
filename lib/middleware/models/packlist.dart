import 'package:cloud_firestore/cloud_firestore.dart';

class Packlist {
  String id;
  String title;
  String amountOfDays;
  String season;
  String tag;
  String description;
  List<String>
      imageUrls; //well this is awkward TODO : remove either this or imageUrl
  Timestamp createdAt;
  Timestamp updatedAt;
  List<dynamic> carrying;
  List<dynamic> sleepingGear;
  List<dynamic> clothesPacked;
  List<dynamic> clothesWorn;
  List<dynamic> foodAndCooking;
  List<dynamic> other;
  String createdBy;
  bool endorsedHighlighted;
  bool allowComments;
  List<dynamic> imageUrl;
  //String mainImage;

  Packlist({
    this.id,
    this.title,
    this.amountOfDays,
    this.season,
    this.tag,
    this.description,
    this.imageUrls, //well this is awkward TODO : remove either this or imageUrl
    this.createdAt,
    this.updatedAt,
    this.endorsedHighlighted,
    this.allowComments,
    this.imageUrl,
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
      'imageUrls':
          imageUrls, //well this is awkward TODO : remove either this or imageUrl
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'endorsed': endorsedHighlighted,
      'allowComments': allowComments,
      'imageUrl': imageUrl,
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
    imageUrls = data[
        'imageUrls']; //well this is awkward TODO : remove either this or imageUrl
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    endorsedHighlighted = data['endorsedHighlighted'];
    allowComments = data['allowComments'];
    imageUrl = data['imageUrl'];
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
      imageUrls: data[
          'imageUrls'], //well this is awkward TODO : remove either this or imageUrl
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      endorsedHighlighted: data['endorsedHighlighted'],
      allowComments: data['allowComments'],
      imageUrl: data['imageUrl'],
      //mainImage: data['mainImage'],
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
