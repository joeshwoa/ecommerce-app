import 'package:klnakhadem/model/address_model.dart';

Address createAddress(Map<String, dynamic> json) {
  final String city = json['town'];
  final String area = json['region'];
  final String supArea = json['area'];
  final String street = json['street'];
  final String id = json['_id'];

  return Address(city, area, supArea, street, id);
}
