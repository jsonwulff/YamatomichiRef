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

  CollectionReference comment = _store.collection(collection).doc(docID).collection('comments');

  var documentRef = await comment.add(mapToSave);
  mapToSave['id'] = documentRef.id;
  return mapToSave;
}

// getComments(String collection, String docID) async {
//   var snapshot = await _store.collection(collection).doc(docID).collection('comments').get();
//   List<Map<String, dynamic>> comments = [];

//   for (doc in snapshot.docs) {
//     comments.add(Comment.fromFirestore(doc.data()).toMap());
//   }

//   return comments;
// }
