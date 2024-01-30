import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clickpay_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_clickpay_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkApms.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_clickpay_bridge/flutter_clickpay_bridge.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_address.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_add_address.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_after_complete_order.dart';

class BuyerReviewOrderBeforeBuy extends StatefulWidget {
  const BuyerReviewOrderBeforeBuy({super.key,required this.price,required this.delivery,required this.products,required this.sellerId,required this.market,required this.taxes,required this.amolaFactor,required this.zekaTaxes});
  final int price;
  final int delivery;
  final List<Product> products;
  final String sellerId;
  final String market;
  final double taxes;
  final double zekaTaxes;
  final double amolaFactor;

  @override
  State<BuyerReviewOrderBeforeBuy> createState() => _BuyerReviewOrderBeforeBuyState();
}

class _BuyerReviewOrderBeforeBuyState extends State<BuyerReviewOrderBeforeBuy> {

  List<Address> addresses = [];
  List<List<String>> addressesString = [];
  int itemCounter = 1;
  late double walletAmount;
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  bool stillPay = false;// Flag to track i

  bool sending = false;// Flag to track

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();

    fetchData(); // Fetch initial data when widget is initialized
  }

  @override
  void dispose(){
    super.dispose();
    fetchData().ignore();
    _controller.dispose();
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      if(mounted){
        setState(() {
          isLoading = true;
        });
      }

      final responseMap = await get("${ApiPaths.getBuyerWalletAmount}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];

        final responseMap2 = await get("${ApiPaths.getAddress}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
          return {
            'code':999
          };
        });

        if (responseMap2['code'] >= 200 && responseMap2['code'] < 300) {
          final Map<String, dynamic> responseData2 = responseMap2['body'];
          final List<Address> newAddresses = [];
          final List<List<String>> newAddressesString = [];

          for(int i=0;i<responseData2["results"];i++){
            newAddresses.add(createAddress(responseData2["data"][i]));
            newAddressesString.add([newAddresses[i].city,newAddresses[i].area,newAddresses[i].supArea,newAddresses[i].street]);
          }

          if(mounted){
            setState(() {
              addresses.addAll(newAddresses);
              addressesString.addAll(newAddressesString);
              if(addressesString.isNotEmpty){
                dropdownValue = addressesString.first;
                dropdownValueId = addresses.first.id;
              }
              walletAmount = responseData["data"]*1.0;
              itemCounter = addresses.length;
              isLoading = false;
            });
          }
        } else if (responseMap2['code'] == 999) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                backgroundColor: AppColors.mainColor,
                showCloseIcon: true,
              ),
            );
          }
        } else {
        }
      } else if (responseMap['code'] == 999) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
              backgroundColor: AppColors.mainColor,
              showCloseIcon: true,
            ),
          );
        }
      } else {
      }
    }
  }

  Future<void> _refresh() async{
    fetchData();
  }

  PaymentSdkConfigurationDetails generateConfig(String id,String method) {

    var billingDetails = BillingDetails(sharedPreferences.getString('name')??'', sharedPreferences.getString('email')??'',
        sharedPreferences.getString('phone')??'', '${dropdownValue[0]}, ${dropdownValue[1]}, ${dropdownValue[2]}, ${dropdownValue[3]}', "SA", dropdownValue[0], dropdownValue[1], "12345");

    var shippingDetails = ShippingDetails(sharedPreferences.getString('name')??'', sharedPreferences.getString('email')??'',
        sharedPreferences.getString('phone')??'', '${dropdownValue[0]}, ${dropdownValue[1]}, ${dropdownValue[2]}, ${dropdownValue[3]}', "SA", dropdownValue[0], dropdownValue[1], "12345");

    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.STC_PAY);
    apms.add(PaymentSdkAPms.APPLE_PAY);

    String cartProducts = '';
    for(int i=0;i<widget.products.length;i++) {
      if(i == widget.products.length-1) {
        cartProducts = '$cartProducts${widget.products[i].title} . ';
      } else {
        cartProducts = '$cartProducts${widget.products[i].title} , ';
      }
    }

    var configuration = PaymentSdkConfigurationDetails(
        profileId: "42593",
        serverKey: "SLJNLLTNHR-JGWWHDWTLG-LJTRHLRGK2",
        clientKey: "CDKMDM-6BKQ6T-VVHDV7-99GGHH",
        cartId: id,
        cartDescription: cartProducts,
        merchantName: widget.market,
        screentTitle: method=='card'?"الدفع بالبطاقة الائتمانية":method=='stc'?"الدفع ب STC Pay":"الدفع ب Apple Pay",
        amount: double.parse((widget.price+widget.delivery+(widget.price*widget.taxes)).toStringAsFixed(2)),
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: "SAR",
        merchantCountryCode: "SA",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);

    var theme = IOSThemeConfigurations();
    configuration.iOSThemeConfigurations = theme;
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  late List<String> dropdownValue;
  late String dropdownValueId;

  String payMethod = 'credit';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('مراجعة تفاصيل الطلب',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SizedBox(
          height: MAsizes.screenH,
          width: MAsizes.screenW,
          child: isLoading || stillPay?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),):RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText('العنوان',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.buttonGreenColor,
                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            ),
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyerAddAddress(),));
                              },
                              icon: const Icon(Icons.add_location_alt),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                          child: addresses.isNotEmpty?Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                border: Border.all(color: AppColors.mainColor,width: 2),
                                color: AppColors.offWhiteBoxColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<List<String>>(
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  style: const TextStyle(color: AppColors.mainColor),
                                  /*underline: Container(
                                    height: 2,
                                    color: AppColors.mainColor,
                                  ),*/
                                  onChanged: (List<String>? value) {
                                    // This is called when the user selects an item.
                                    for(int i=0;i<addressesString.length;i++) {
                                      if(addressesString[i]==value) {
                                        dropdownValueId = addresses[i].id;
                                      }
                                    }
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: addressesString.map<DropdownMenuItem<List<String>>>((List<String> value) {
                                    return DropdownMenuItem<List<String>>(
                                      value: value,
                                      child: Text('${value[0]}, ${value[1]}, ${value[2]}, ${value[3]}'),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ): SizedBox(
                            child: AppText('لا يوجد عناوين مضافة',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.offWhiteBoxColor,
                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                    ),
                    width: MAsizes.screenW,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          /*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText('البطاقة الاتمانية',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: MAsizes.widthOfSmallEmptySpace/2,
                                    backgroundColor: AppColors.mainColor,
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          payMethod = 'card';
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      child: CircleAvatar(
                                        radius: (MAsizes.widthOfSmallEmptySpace/2)-2,
                                        backgroundColor: payMethod == 'card'?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText('الرصيد المتوفر $walletAmount  ريال',size: MAsizes.textNormalSize*2/3, color: AppColors.textBlackColor),
                                SizedBox(
                                  width: MAsizes.widthOfSmallEmptySpace,
                                ),
                                AppText('محفظة التطبيق',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: MAsizes.widthOfSmallEmptySpace/2,
                                    backgroundColor: AppColors.mainColor,
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          payMethod = 'credit';
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      child: CircleAvatar(
                                        radius: (MAsizes.widthOfSmallEmptySpace/2)-2,
                                        backgroundColor: payMethod == 'credit'?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText('stc pay',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: MAsizes.widthOfSmallEmptySpace/2,
                                    backgroundColor: AppColors.mainColor,
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          payMethod = 'stc';
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      child: CircleAvatar(
                                        radius: (MAsizes.widthOfSmallEmptySpace/2)-2,
                                        backgroundColor: payMethod == 'stc'?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if(Platform.isIOS)Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText('apple pay',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: MAsizes.widthOfSmallEmptySpace/2,
                                    backgroundColor: AppColors.mainColor,
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          payMethod = 'apple';
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      child: CircleAvatar(
                                        radius: (MAsizes.widthOfSmallEmptySpace/2)-2,
                                        backgroundColor: payMethod == 'apple'?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText('الفاتورة',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.offWhiteBoxColor,
                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                    ),
                    width: MAsizes.screenW,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                AppText(widget.price.toString(),size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                const Expanded(child: SizedBox()),
                                AppText('مجموع سعر المنتجات ',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                AppText((widget.price*widget.taxes).toString(),size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                const Expanded(child: SizedBox()),
                                AppText('مجموع سعر الضريبة ',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                AppText(widget.delivery.toString(),size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                const Expanded(child: SizedBox()),
                                AppText('مجموع سعر التوصيل ',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 1,
                              width: MAsizes.screenW,
                              color: AppColors.buttonGreenColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                AppText((widget.delivery+widget.price+(widget.price*widget.taxes)).toString(),size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                const Expanded(child: SizedBox()),
                                AppText('مجموع السعر ',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText('مراجعة المنتجات',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.offWhiteBoxColor,
                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                    ),
                    width: MAsizes.screenW,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for(int i=0;i<widget.products.length;i++)...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: MAsizes.buttonHeight*2,
                                width: MAsizes.screenW,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppText('السعر : ${widget.products[i].price}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                      const Expanded(child: SizedBox()),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppText(widget.products[i].title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                            AppText('المتاح : ${widget.products[i].available}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            height: MAsizes.widthOfMediumEmptySpace*1.5,
                                            width: MAsizes.widthOfMediumEmptySpace*1.5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(MAsizes.heightOfMediumEmptySpace),
                                              color: AppColors.mainColor
                                            ),
                                            child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Image(image: MemoryImage(widget.products[i].imageCover),fit: BoxFit.fill,isAntiAlias: true),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if(addresses.isEmpty){
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: AppText('برجاء اضافة عنوان لاتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                      }else {
                        if(!sending) {
                          setState(() {
                            sending = true;
                          });
                          if(payMethod != 'credit'||(payMethod == 'credit'&&walletAmount>=(widget.price+widget.delivery+(widget.price*widget.taxes)))) {
                            if(payMethod == 'credit') {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('جاري اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                              Map<String,dynamic> data = {
                                'delivery' : widget.delivery,
                                'seller' : widget.sellerId,
                                'user' : sharedPreferences.getString('token'),
                                'address' : dropdownValueId
                              };
                              Map responseMap = await post(ApiPaths.payOrder,data).onError((error, stackTrace) {
                                return {
                                  'code':999
                                };
                              });


                              if(responseMap['code']>=200 && responseMap['code']<300){
                                Map<String,dynamic> data2 = {
                                  'method' : 'credit',
                                  'user' : sharedPreferences.getString('token'),
                                  'order' : responseMap['body']['order']['_id'],
                                };
                                Map responseMap2 = await post(ApiPaths.payment,data2).onError((error, stackTrace) {
                                  return {
                                    'code':999
                                  };
                                });

                                if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                                  if (context.mounted){
                                    while (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuyerAfterCompleteOrder(code: responseMap['body']['order']['code'].toString(),)));
                                  }
                                } else if (responseMap2['code'] == 999) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                        backgroundColor: AppColors.mainColor,
                                        showCloseIcon: true,
                                      ),
                                    );
                                  }
                                }else{
                                  if (context.mounted){
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(child: AppText('فشل اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                        backgroundColor: AppColors.mainColor,
                                        showCloseIcon: true,
                                      ),
                                    );
                                  }
                                }
                              } else if (responseMap['code'] == 999) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                              }else{
                                if (context.mounted){
                                  print(responseMap);
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('فشل اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                              }
                              setState(() {
                                sending  = false;
                              });
                            } /*else if (payMethod == 'card'){

                          Map<String,dynamic> data = {
                            'delivery' : widget.delivery,
                            'seller' : widget.sellerId,
                            'user' : sharedPreferences.getString('token'),
                            'address' : dropdownValueId
                          };
                          Map responseMap = await post(ApiPaths.payOrder,data).onError((error, stackTrace) {
                                  return {
                                    'code':999
                                  };
                                });

                          if(responseMap['code']>=200 && responseMap['code']<300){
                            bool success = false;

                            setState(() {
                              stillPay = true;
                            });

                            FlutterPaymentSdkBridge.startCardPayment(generateConfig(responseMap['body']['order']['_id'],'card'), (event) async {
                              setState(() {
                                if (event["status"] == "success") {
                                  // Handle transaction details here.
                                  success = true;
                                } else if (event["status"] == "error") {
                                  // Handle error here.
                                } else if (event["status"] == "event") {
                                  // Handle events here.
                                }

                              });

                              if(success) {
                                if(mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('تم الدفع بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                                Map<String,dynamic> data2 = {
                                  'method' : 'card',
                                  'user' : sharedPreferences.getString('token'),
                                  'order' : responseMap['body']['order']['_id']
                                };
                                Map responseMap2 = await post(ApiPaths.payment,data2).onError((error, stackTrace) {
                                  return {
                                    'code':999
                                  };
                                });

                                if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                                  if (context.mounted){
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(child: AppText('تم ارسال الطلب بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                        backgroundColor: AppColors.mainColor,
                                        showCloseIcon: true,
                                      ),
                                    );
                                    Timer(const Duration(seconds: 1), () {
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      while (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }

                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuyerAfterCompleteOrder(code: responseMap['body']['order']['code'].toString(),)));
                                    });
                                  }
                                } else {
                                  if(mounted) {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(child: AppText('فشل ارسال الطلب. رجاء تواصل مع الدعم الفني',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                        backgroundColor: AppColors.mainColor,
                                        showCloseIcon: true,
                                      ),
                                    );
                                  }
                                }
                              } else {
                                if(mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('فشل في عملية الدفع',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                              }
                            }).then((value) {
                              setState(() {
                                stillPay = false;
                              });

                            });

                          } else if (responseMap['code'] == 999) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }else{
                            if (context.mounted){
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('فشل اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                          setState(() {
                              sending  = false;
                            });

                        }*/ else if (payMethod == 'apple'){

                              Map<String,dynamic> data = {
                                'delivery' : widget.delivery,
                                'seller' : widget.sellerId,
                                'user' : sharedPreferences.getString('token'),
                                'address' : dropdownValueId
                              };
                              Map responseMap = await post(ApiPaths.payOrder,data).onError((error, stackTrace) {
                                return {
                                  'code':999
                                };
                              });
                              if(responseMap['code']>=200 && responseMap['code']<300){
                                bool success = false;

                                String cartProducts = '';
                                for(int i=0;i<widget.products.length;i++) {
                                  if(i == widget.products.length-1) {
                                    cartProducts = '$cartProducts${widget.products[i].title} . ';
                                  } else {
                                    cartProducts = '$cartProducts${widget.products[i].title} , ';
                                  }
                                }

                                var configuration = PaymentSdkConfigurationDetails(
                                    profileId: "42593",
                                    serverKey: "SLJNLLTNHR-JGWWHDWTLG-LJTRHLRGK2",
                                    clientKey: "CDKMDM-6BKQ6T-VVHDV7-99GGHH",
                                    cartId: responseMap['body']['order']['_id'],
                                    cartDescription: cartProducts,
                                    merchantName: widget.market,
                                    amount: double.parse((widget.price+widget.delivery+(widget.price*widget.taxes)).toStringAsFixed(2)),
                                    currencyCode: "SAR",
                                    merchantCountryCode: "SA",
                                    merchantApplePayIndentifier: "merchant.clickpay.com",
                                    simplifyApplePayValidation: true);

                                await FlutterPaymentSdkBridge.startApplePayPayment(configuration, (event) async {
                                  setState(() {
                                    if (event["status"] == "success") {
                                      // Handle transaction details here.
                                      success = true;
                                    } else if (event["status"] == "error") {
                                      // Handle error here.
                                    } else if (event["status"] == "event") {
                                      // Handle events here.
                                    }

                                  });

                                  if(success) {
                                    if(mounted) {
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('تم الدفع بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
                                    Map<String,dynamic> data2 = {
                                      'method' : 'apple',
                                      'user' : sharedPreferences.getString('token'),
                                      'order' : responseMap['body']['order']['_id']
                                    };
                                    Map responseMap2 = await post(ApiPaths.payment,data2).onError((error, stackTrace) {
                                      return {
                                        'code':999
                                      };
                                    });

                                    if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                                      if (context.mounted){
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Center(child: AppText('تم ارسال الطلب بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                            backgroundColor: AppColors.mainColor,
                                            showCloseIcon: true,
                                          ),
                                        );
                                        Timer(const Duration(seconds: 1), () {
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          while (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuyerAfterCompleteOrder(code: responseMap['body']['order']['code'].toString(),)));
                                        });
                                      }
                                    } else {
                                      if(mounted) {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Center(child: AppText('فشل ارسال الطلب. رجاء تواصل مع الدعم الفني',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                            backgroundColor: AppColors.mainColor,
                                            showCloseIcon: true,
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    if(mounted) {
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('فشل في عملية الدفع',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
                                  }
                                }).then((value) {
                                  setState(() {
                                    stillPay = false;
                                  });
                                  setState(() {
                                    sending  = false;
                                  });

                                });

                              } else if (responseMap['code'] == 999) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                              }else{
                                if (context.mounted){
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('فشل اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                              }

                            } else if (payMethod == 'stc'){

                              Map<String,dynamic> data = {
                                'delivery' : widget.delivery,
                                'seller' : widget.sellerId,
                                'user' : sharedPreferences.getString('token'),
                                'address' : dropdownValueId
                              };
                              Map responseMap = await post(ApiPaths.payOrder,data).onError((error, stackTrace) {
                                return {
                                  'code':999
                                };
                              });
                              if(responseMap['code']>=200 && responseMap['code']<300){
                                bool success = false;

                                await FlutterPaymentSdkBridge.startAlternativePaymentMethod(generateConfig(responseMap['body']['order']['_id'],'stc'), (event) async {
                                  setState(() {
                                    if (event["status"] == "success") {
                                      // Handle transaction details here.
                                      success = true;
                                    } else if (event["status"] == "error") {
                                      // Handle error here.
                                    } else if (event["status"] == "event") {
                                      // Handle events here.
                                    }

                                  });

                                  if(success) {
                                    if(mounted) {
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('تم الدفع بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
                                    Map<String,dynamic> data2 = {
                                      'method' : 'stc',
                                      'user' : sharedPreferences.getString('token'),
                                      'order' : responseMap['body']['order']['_id']
                                    };
                                    Map responseMap2 = await post(ApiPaths.payment,data2).onError((error, stackTrace) {
                                      return {
                                        'code':999
                                      };
                                    });

                                    if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                                      if (context.mounted){
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Center(child: AppText('تم ارسال الطلب بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                            backgroundColor: AppColors.mainColor,
                                            showCloseIcon: true,
                                          ),
                                        );
                                        Timer(const Duration(seconds: 1), () {
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          while (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuyerAfterCompleteOrder(code: responseMap['body']['order']['code'].toString(),)));
                                        });
                                      }
                                    } else {
                                      if(mounted) {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Center(child: AppText('فشل ارسال الطلب. رجاء تواصل مع الدعم الفني',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                            backgroundColor: AppColors.mainColor,
                                            showCloseIcon: true,
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    if(mounted) {
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('فشل في عملية الدفع',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
                                  }
                                }).then((value) {
                                  setState(() {
                                    stillPay = false;
                                  });
                                  setState(() {
                                    sending  = false;
                                  });

                                });


                              } else if (responseMap['code'] == 999) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                                setState(() {
                                  sending  = false;
                                });
                              }else{
                                if (context.mounted){
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('فشل اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                                setState(() {
                                  sending  = false;
                                });
                              }

                            }
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: AppText('المال الموجود بالمحفظة غير كافي',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                backgroundColor: AppColors.mainColor,
                                showCloseIcon: true,
                              ),
                            );
                            setState(() {
                              sending  = false;
                            });
                          }
                        }
                      }
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonBigWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: addresses.isNotEmpty&&!sending&&(payMethod != 'credit'||(payMethod == 'credit'&&walletAmount>=(widget.price+widget.delivery)))?AppColors.buttonGreenColor:AppColors.textGreenColor.withOpacity(0.2)
                        ),
                        child: Center(child: AppText('اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}