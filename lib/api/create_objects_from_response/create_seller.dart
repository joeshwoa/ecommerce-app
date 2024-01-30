import 'dart:typed_data';

import 'package:klnakhadem/api/send_and_resive_image_methods/decode.dart';
import 'package:klnakhadem/app_running_data/temp_photos_fo_null_safe.dart';
import 'package:klnakhadem/model/seller_model.dart';

Seller createSeller(Map<String, dynamic> json) {
  final String name = json['name'];
  final String id = json['_id'];
  final Uint8List image = decode(json['image'] ?? sellerTempPhoto);

  return Seller(name, image, id);
}
