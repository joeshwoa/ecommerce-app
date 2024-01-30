import 'package:klnakhadem/api/create_objects_from_response/create_address.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/model/bill_for_buyer_model.dart';

BillForBuyer createBillForBuyer(List<dynamic> json) {

  final String id = json[0]['_id']??'';
  final String buyer = json[0]['user']['name'];
  final Address address = createAddress(json[0]['address']);
  final int delivery = json[1]['delivery'];
  final DateTime billTime = DateTime.parse(json[0]['createdAt']);
  double orderTotalPrice = 0;
  double vatTotalPrice = 0;
  double productTotalPrice = 0;
  final List<String> productsName = [];
  final List<String> productsId = [];
  final List<int> productsPricePerOne = [];
  final List<int> productsQuantity = [];
  final List<double> productsPriceAfterVat = [];
  final List<double> productsVat = [];

  for(int i=2;i<json.length;i++) {
    productsName.add(json[i]['product']['title']);
    productsId.add(json[i]['product']['_id']);
    productsPricePerOne.add(json[i]['product']['price']);
    productsQuantity.add(json[i]['quantity']);
    productsPriceAfterVat.add(json[i]['priceAfter']*1.0);
    productsVat.add(json[i]['vat']*1.0);

    vatTotalPrice += productsVat[i-2];
    orderTotalPrice += productsPriceAfterVat[i-2];
  }

  productTotalPrice += orderTotalPrice - vatTotalPrice;

  final double vat = json[0]['vat'];

  final String serial = json[1]['serial'].toString();

  final String companyRegisterNumber = json[0]['companyRegisterNumber'].toString();

  return BillForBuyer(id, address, delivery, productsName, productsPriceAfterVat, productsPricePerOne, productsQuantity, productsVat, buyer, orderTotalPrice, productTotalPrice, vatTotalPrice, productsId, billTime, vat, serial, companyRegisterNumber);
}