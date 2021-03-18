import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String createdBy;
  String description;
  String category;
  String region;
  String price;
  String payment;
  int maxParticipants;
  int minParticipants;
  List<dynamic> participants;
  String requirements;
  String equipment;
  String meeting;
  String dissolution;
  String imageUrl;
  Timestamp startDate;
  Timestamp endDate;
  Timestamp deadline;
  bool flagged;
  bool highlighted;
  Timestamp createdAt;
  Timestamp updatedAt;

  Event(
      {this.id,
      this.title,
      this.createdBy,
      this.description,
      this.category,
      this.region,
      this.price,
      this.payment,
      this.maxParticipants,
      this.minParticipants,
      this.participants,
      this.requirements,
      this.equipment,
      this.meeting,
      this.dissolution,
      this.imageUrl,
      this.startDate,
      this.endDate,
      this.deadline,
      this.flagged = false,
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
      'region': region,
      'price': price,
      'payment': payment,
      'maxParticipants': maxParticipants,
      'minParticipants': minParticipants,
      'participants': participants,
      'requirements': requirements,
      'equipment': equipment,
      'meeting': meeting,
      'dissolution': dissolution,
      'imageUrl': imageUrl,
      'startDate': startDate,
      'endDate': endDate,
      'deadline': deadline,
      'flagged': flagged,
      'highlighted': highlighted,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  Event.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    createdBy = data['createdBy'];
    region = data['region'];
    description = data['description'];
    category = data['category'];
    price = data['price'];
    payment = data['payment'];
    maxParticipants = data['maxParticipants'];
    minParticipants = data['minParticipants'];
    participants = data['participants'];
    requirements = data['requirements'];
    equipment = data['equipment'];
    meeting = data['meeting'];
    dissolution = data['dissolution'];
    imageUrl = data['imageUrl'];
    startDate = data['startDate'];
    endDate = data['endDate'];
    deadline = data['deadline'];
    flagged = data['flagged'];
    highlighted = data['highlighted'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  factory Event.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return Event(
      id: documentSnapshot.id,
      title: data['title'],
      createdBy: data['createdBy'],
      description: data['description'],
      category: data['category'],
      region: data['region'],
      price: data['price'],
      payment: data['payment'],
      maxParticipants: data['maxParticipants'],
      minParticipants: data['minParticipants'],
      participants: data['participants'],
      requirements: data['requirements'],
      equipment: data['equipment'],
      meeting: data['meeting'],
      dissolution: data['dissolution'],
      imageUrl: data['imageUrl'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      deadline: data['deadline'],
      flagged: data['flagged'],
      highlighted: data['highlighted'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}
