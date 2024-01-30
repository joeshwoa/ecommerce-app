import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map> put(String apiUrl, Map<String, dynamic> map) async {
  final headers = {'Content-Type': 'application/json'};
  final response = await http.put(Uri.parse(apiUrl),
      headers: headers, body: jsonEncode(map));
  Map<String, dynamic> resMap;
  if(response.body.isNotEmpty){
    if(response.body[0] != '{') {
      resMap = {
        'code' : 999,
        'body' : {}
      };
    } else {
      resMap = {
        'code' : response.statusCode,
        'body' : jsonDecode(response.body)
      };
    }
  }else {
    resMap = {
      'code' : response.statusCode,
      'body' : {}
    };
  }
  return resMap;
}
