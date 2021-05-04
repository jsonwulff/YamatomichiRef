import 'package:cloud_firestore/cloud_firestore.dart';

String timestampToDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}";
}

String dateTimeToDate(DateTime dateTime) {
  return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}";
}

Timestamp dateTimeToTimestamp(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}
