import 'package:klnakhadem/model/address_model.dart';

class Order {
  Order(this.state,this.id,this.price,this.code,this.paymentMethod,this.address,this.delivery,this.serial,this.priceBuyer,this.priceSeller);
  String state;
  String id;
  String code;
  String paymentMethod;
  double price;
  double priceBuyer;
  double priceSeller;
  Address address;
  int delivery;
  int serial;
}