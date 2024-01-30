import 'dart:typed_data';

class Product {
  Product(this.categoryID,this.quantity,this.price,this.deliveryOrPickup,this.newProduct,this.description,this.title,this.imageCover,this.marketID,this.rating,this.ratingQuantity,this.images,this.id,this.sold,this.available,this.deliveryPrice,this.canReturn,this.marketName,this.marketAddress,this.sellerID);
  String title;
  String id;
  String description;
  int quantity;
  int sold;
  int price;
  int deliveryPrice;
  Uint8List imageCover;
  String marketID;
  String marketName;
  String marketAddress;
  String categoryID;
  double rating;
  int ratingQuantity;
  bool newProduct;
  bool canReturn;
  String deliveryOrPickup;
  List<Uint8List> images;
  int available;
  String sellerID;
}