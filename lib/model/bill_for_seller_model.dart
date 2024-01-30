import 'package:klnakhadem/model/address_model.dart';

class BillForSeller {
  BillForSeller(this.id,this.address,this.delivery,this.marketRegistered,this.marketRegisteredNumber,this.productsName,this.productsPricePerOne,this.productsQuantity,this.seller,this.productsId,this.billTime,this.productTotalPriceForSeller,this.vat,this.companyAddress,this.companyRegisterNumber,this.serial,this.productsPricePerOneWithVat);

  String id;
  String seller;
  Address address;
  int delivery;
  bool marketRegistered;
  String marketRegisteredNumber;
  DateTime billTime;
  List<String> productsName;
  List<String> productsId;
  List<double> productsPricePerOne;
  List<double> productsPricePerOneWithVat;
  List<int> productsQuantity;
  double productTotalPriceForSeller;
  double vat;
  String companyAddress;
  String companyRegisterNumber;
  String serial;
}