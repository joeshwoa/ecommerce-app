import 'package:klnakhadem/model/comment_model.dart';

Comment createComment(Map<String, dynamic> json) {
  final String user = json['user']['name'];
  final String id = json['_id'];
  final String comment = json['dis'];
  final double rate = json['rate'];

  return Comment(id, user, comment, rate);
}