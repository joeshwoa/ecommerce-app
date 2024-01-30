import 'package:klnakhadem/api/create_objects_from_response/create_address.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/model/bill_for_seller_model.dart';

BillForSeller createBillForSeller(List<dynamic> json) {

  final String id = json[0]['_id']??'';
  final String seller = json[0]['seller']['market'];
  final Address address = createAddress(json[0]['market']);
  final int delivery = json[1]['delivery'];
  final bool marketRegistered = json[0]['market']['registered'];
  final String marketRegisteredNumber = json[0]['market']['registerNumber'];
  final DateTime billTime = DateTime.parse(json[0]['createdAt']);
  final List<String> productsName = [];
  final List<String> productsId = [];
  final List<double> productsPricePerOne = [];
  final List<int> productsQuantity = [];

  for(int i=2;i<json.length;i++) {
    productsName.add(json[i]['product']['title']);
    productsId.add(json[i]['product']['_id']);
    productsPricePerOne.add((json[i]['product']['price']-json[i]['omola'])/(1+json[0]['vat']));
    productsPricePerOne.add(json[i]['product']['price']-json[i]['omola']);
    productsQuantity.add(json[i]['quantity']);
  }

  final double productTotalPriceForSeller = json[1]['priceSeller']*1.0;

  final double vat = json[0]['vat'];

  final String companyAddress = json[0]['companyAddress'];
  final String companyRegisterNumber = json[0]['companyRegisterNumber'].toString();

  final String serial = json[1]['serial'].toString();

  return BillForSeller(id, address, delivery, marketRegistered, marketRegisteredNumber, productsName, productsPricePerOne, productsQuantity, seller, productsId, billTime, productTotalPriceForSeller, vat, companyAddress, companyRegisterNumber, serial, productsPricePerOne);
}