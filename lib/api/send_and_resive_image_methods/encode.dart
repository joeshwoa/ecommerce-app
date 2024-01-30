import 'dart:convert';
import 'dart:io';

Future<String> encode(File file) async {
  final imageBytes = await file.readAsBytes();
  return base64Encode(imageBytes);
}
