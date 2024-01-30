import 'dart:typed_data';

import 'package:klnakhadem/api/send_and_resive_image_methods/decode.dart';
import 'package:klnakhadem/model/auction_model.dart';

Auction createAuction(Map<String, dynamic> json) {
  final String title = json['title'];
  final String id = json['_id'];
  final String description = json['description'];
  final int quantity = json['quantity'];
  final int sold = json['sold'];
  final int price = json['price'];
  final Uint8List imageCover = decode(json['imageCover']);
  final String marketID = json['market'];
  final String categoryID = json['category'];
  final double rating = json['rating'] ?? 0;
  final int ratingQuantity = json['ratingQuantity'] ?? 0;
  final bool newProduct = json['status'] ?? true;
  final String deliveryOrPickup = json['delivery'] == 2
      ? "both"
      : (json['delivery'] == 0 ? "delivery" : "pickup");
  final List<Uint8List> images = [
    for (int index = 0; index < json['images'].length; index++) ...[
      decode(json['images'][index]),
    ]
  ];
  final int available = quantity - sold;
  final int deliveryPrice = json['deliveryPrice']??0;
  final int bestOffer = json['bestOffer']??price;
  final String userOfBestOffer = json['user']??'لا يوجد';
  final DateTime endAt = DateTime.parse(json['time']);
  final bool joined = json['joined']??false;
  /*final bool canReturn = json['canReturn'];*/
  final String sellerID = json['seller']['_id'];
  final String marketName = json['seller']['market'];
  final String marketAddress = '${json['market']['town']}, ${json['market']['region']}, ${json['market']['area']}, ${json['market']['street']}';

  return Auction(categoryID, quantity, price, deliveryOrPickup, newProduct, description, title, imageCover, marketID, rating, ratingQuantity, images, id, sold, available, deliveryPrice, bestOffer, userOfBestOffer, endAt, joined, sellerID, marketAddress, marketName);
}
