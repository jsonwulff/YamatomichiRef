import 'package:app/middleware/api/comment_api.dart' as api;

enum DBCollection { Calendar, Packlist }

class CommentService {
  Map<DBCollection, String> collections = {DBCollection.Calendar: 'calendarEvent'};

  Future<Map<String, dynamic>> addComment(
      Map<String, dynamic> data, DBCollection collection, String docID) async {
    return await api.addComment(data, collections[collection], docID);
  }

  Future<List<Map<String, dynamic>>> getComments(DBCollection collection, String docID) async {
    var test = await api.getComments(collections[collection], docID);
    print('test:' + test);
    return test;
  }

  Future<void> deleteComment(
      Map<String, dynamic> data, DBCollection collection, String docID) async {
    print(collections[collection] + " " + docID + " " + data['id']);
    await api.delete(collections[collection], docID, data['id']);
  }

  Future<void> updateComment(
      DBCollection collection, String docID, String commentID, Map<String, dynamic> data) async {
    await api.update(collections[collection], docID, commentID, data);
  }
}
