import 'package:klnakhadem/model/address_model.dart';

class BillForBuyer {
  BillForBuyer(this.id,this.address,this.delivery,this.productsName,this.productsPriceAfterVat,this.productsPricePerOne,this.productsQuantity,this.productsVat,this.buyer,this.orderTotalPrice,this.productTotalPrice,this.vatTotalPrice,this.productsId,this.billTime,this.vat,this.serial,this.companyRegisterNumber);

  String id;
  String buyer;
  Address address;
  int delivery;
  DateTime billTime;
  List<String> productsName;
  List<String> productsId;
  List<int> productsPricePerOne;
  List<int> productsQuantity;
  List<double> productsPriceAfterVat;
  List<double> productsVat;
  double orderTotalPrice;
  double vatTotalPrice;
  double productTotalPrice;
  double vat;
  String serial;
  String companyRegisterNumber;
}