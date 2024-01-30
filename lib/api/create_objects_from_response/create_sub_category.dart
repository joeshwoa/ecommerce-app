import 'dart:typed_data';

import 'package:klnakhadem/api/send_and_resive_image_methods/decode.dart';
import 'package:klnakhadem/model/sub_category_model.dart';

SubCategory createSubCategory(Map<String, dynamic> json) {
  final String name = json['name'];
  final String id = json['_id'];
  final Uint8List image = json['image'] != null?decode(json['image']):Uint8List(0);

  return SubCategory(name, image, id);
}
