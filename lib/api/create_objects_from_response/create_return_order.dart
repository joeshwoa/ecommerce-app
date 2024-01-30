import 'package:klnakhadem/model/return_order_model.dart';

ReturnOrder createReturnOrder(Map<String, dynamic> json) {

  final String id = json['_id'];
  final String state = json['status'];
  final double price = double.parse(json['price'].toString());
  /*final int serial = json['serial'];*/

  return ReturnOrder(state, id, price);
}