import 'package:app/middleware/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _store = FirebaseFirestore.instance;

addComment(Map<String, dynamic> data, String collection, String docID) async {
  Comment newComment = Comment();
  newComment.createdBy = data['createdBy'];
  newComment.comment = data['comment'];
  newComment.createdAt = Timestamp.now();
  newComment.imgUrl = data['imgUrl'];

  var mapToSave = newComment.toMap();
  mapToSave.remove('id');

  CollectionReference comment =
      _store.collection(collection).doc(docID).collection('comments');

  var documentRef = await comment.add(mapToSave);
  await comment.doc(documentRef.id).update({
    "id": documentRef.id,
  });
  //mapToSave['id'] = documentRef.id;
  return mapToSave;
}

/*getComments(String collection, String docID) async {
  var snapshot = await _store.collection(collection).doc(docID).collection('comments').get();
  List<Map<String, dynamic>> comments = [];

  for (DocumentReference doc in snapshot.docs) {
    comments.add(Comment.fromFirestore(doc.data()).toMap());
  }

  return comments;
}*/

getComments(String collection, String docID) async {
  var snaps = await _store
      .collection(collection)
      .doc(docID)
      .collection('comments')
      .orderBy('createdAt')
      .get();
  List<Map<String, dynamic>> comments = [];
  snaps.docs.forEach((element) => comments.add(element.data()));
  return comments;
}

delete(String collection, String docID, String commentID) async {
  print('delete comment begun');
  print(docID + " " + commentID);
  await _store
      .collection(collection)
      .doc(docID)
      .collection('comments')
      .doc(commentID)
      .delete()
      .then((value) => {print("comment deleted")});
}
