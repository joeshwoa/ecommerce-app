import 'package:klnakhadem/api/create_objects_from_response/create_address.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/model/order_model.dart';

Order createOrder(Map<String, dynamic> json) {

  final String code = json['code'].toString();
  final String id = json['_id'];
  final String state = json['status'];
  final double price = json['price'] * 1.0;
  final double priceBuyer = json['priceBuyer'] * 1.0;
  final double priceSeller = json['priceSeller'] * 1.0;
  final String paymentMethod = json['method'];
  final Address address = createAddress(json['address']);
  final int delivery = json['delivery'];
  final int serial = json['serial'];


  return Order(state, id, price, code, paymentMethod, address, delivery, serial,priceBuyer,priceSeller);
}
