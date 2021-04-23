import 'package:app/middleware/api/comment_api.dart';

enum DBCollection { Calendar, Packlist }

class CommentService {
  CommentApi _api;

  CommentService({CommentApi api}) {
    api != null ? _api = api : _api = new CommentApi();
  }

  Map<DBCollection, String> collections = {
    DBCollection.Calendar: 'calendarEvent'
  };

  Future<Map<String, dynamic>> addComment(
      Map<String, dynamic> data, DBCollection collection, String docID) async {
    return await _api.addComment(data, collections[collection], docID);
  }

  Future<List<Map<String, dynamic>>> getComments(
      DBCollection collection, String docID) async {
    return await _api.getComments(collections[collection], docID);
  }

  Future<void> deleteComment(
      Map<String, dynamic> data, DBCollection collection, String docID) async {
    print(collections[collection] + " " + docID + " " + data['id']);
    await _api.delete(collections[collection], docID, data['id']);
  }

  Future<void> updateComment(DBCollection collection, String docID,
      String commentID, Map<String, dynamic> data) async {
    await _api.update(collections[collection], docID, commentID, data);
  }
}
