import 'dart:typed_data';

import 'package:klnakhadem/api/send_and_resive_image_methods/decode.dart';
import 'package:klnakhadem/model/product_model.dart';

Product createProduct(Map<String, dynamic> json) {

  final String title = json['title'];
  final String id = json['_id'];
  final String description = json['description']??'';
  final int quantity = json['quantity'];
  final int sold = json['sold'];
  final int price = json['price'];
  final Uint8List imageCover = decode(json['imageCover']);
  final String marketID = json['market']['_id']??'';
  final String marketName = json['seller']['market']??'';
  final String marketAddress = '${json['market']['town']}, ${json['market']['region']}, ${json['market']['area']}, ${json['market']['street']}';
  final String categoryID = json['category']??'';
  final double rating =  json['ratingsAverage'] != null? json['ratingsAverage']*1.0 : 0;
  final int ratingQuantity = json['ratingQuantity'] ?? 0;
  final bool newProduct = json['status'];
  final String deliveryOrPickup = json['delivery'] == 2
      ? "both"
      : (json['delivery'] == 0 ? "delivery" : "pickup");
  final List<Uint8List> images;
  if(json['images'] != null) {
    images = [
      for (int index = 0; index < json['images'].length; index++) ...[
        decode(json['images'][index]),
      ]
    ];
  } else {
    images = [];
  }
  final int available = quantity - sold;
  final int deliveryPrice = json['deliveryPrice']??0;
  final bool canReturn = json['canReturn']??true;
  final String sellerID = json['seller']['_id']??'';

  return Product(categoryID, quantity, price, deliveryOrPickup, newProduct, description, title, imageCover, marketID, rating, ratingQuantity, images, id, sold, available, deliveryPrice, canReturn, marketName, marketAddress, sellerID);
}
