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
import 'package:klnakhadem/api/create_objects_from_response/create_seller_wallet.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_seller_money_transformation_box.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/seller_wallet_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SellerProfits extends StatefulWidget {
  const SellerProfits({super.key});

  @override
  State<SellerProfits> createState() => _SellerProfitsState();
}

class _SellerProfitsState extends State<SellerProfits> {

  PaymentSdkConfigurationDetails generateConfig(String id,String method) {

    var billingDetails = BillingDetails(sharedPreferences.getString('name')??'', sharedPreferences.getString('email')??'',
        sharedPreferences.getString('phone')??'', 'القطيف', "SA", 'القطيف', 'القطيف', "12345");

    var shippingDetails = ShippingDetails(sharedPreferences.getString('name')??'', sharedPreferences.getString('email')??'',
        sharedPreferences.getString('phone')??'', 'القطيف', "SA", 'القطيف', 'القطيف', "12345");

    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.STC_PAY);
    apms.add(PaymentSdkAPms.APPLE_PAY);

    String cartProducts = 'شحن محفظة التطبيق';

    var configuration = PaymentSdkConfigurationDetails(
        profileId: "42593",
        serverKey: "SLJNLLTNHR-JGWWHDWTLG-LJTRHLRGK2",
        clientKey: "CDKMDM-6BKQ6T-VVHDV7-99GGHH",
        cartId: id,
        cartDescription: cartProducts,
        merchantName: 'كلنا خادم',
        screentTitle: method=='card'?"الدفع بالبطاقة الائتمانية":method=='stc'?"الدفع ب STC Pay":"الدفع ب Apple Pay",
        amount: double.parse(moneyController.text),
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

  String payMethod = 'credit';

  TextEditingController moneyController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _onAlertForAddMoney(context) {
    Alert(
        context: context,
        title: "المبلغ",
        closeIcon: IconButton(
          icon: const Icon(Icons.close,color: Colors.redAccent),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        style: AlertStyle(
            animationType: AnimationType.fromBottom,
            animationDuration: const Duration(milliseconds: 500),
            descTextAlign: TextAlign.center,
            alertAlignment: Alignment.center,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
              side: const BorderSide(
                color: Colors.grey,
              ),
            ),
            descStyle: TextStyle(
              color: AppColors.textBlackColor,
              fontFamily: 'El_Messiri',
              fontSize: MAsizes.textBetweenNormalAndBigSize,
              overflow: TextOverflow.ellipsis,
            ),
            titleStyle: TextStyle(
              color: AppColors.mainColor,
              fontFamily: 'El_Messiri',
              fontSize: MAsizes.textBetweenNormalAndBigSize,
              overflow: TextOverflow.ellipsis,
            )
        ),
        content: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              AppTextFormField(
                validator: (value){
                  if(value == null || value.isEmpty)
                  {
                    return 'المبلغ لا يمكن ان يكون فارغ';
                  }
                  else if(int.parse(value) == 0)
                  {
                    return 'المبلغ لا يمكن ان يكون صفر';
                  }
                  return null;
                },
                mycontroller: moneyController,
                hintText: ' ادخال المبلغ',
                labelText: 'المبلغ',
                keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              if(formKey.currentState!.validate()){
                bool success = false;

                await FlutterPaymentSdkBridge.startAlternativePaymentMethod(generateConfig(wallet.history.length.toString(),'stc'), (event) async {
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
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: Center(child: AppText('تم الدفع بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: (){
                                ScaffoldMessenger.of(context).clearMaterialBanners();
                              },
                            )
                          ],
                        ),
                      );
                    }
                    Map<String,dynamic> data = {
                      'amount' : int.parse(moneyController.text)
                    };
                    Map responseMap = await post(ApiPaths.addSellerWalletAmount+sharedPreferences.getString('token')!,data).onError((error, stackTrace) {
                      return {
                        'code':999
                      };
                    });

                    if((responseMap['code']>=200 && responseMap['code']<300)) {
                      if (context.mounted){
                        Navigator.pop(context);
                        moneyController.clear();
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            content: Center(child: AppText('تم شحن المحفظة بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            actions: [
                              IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.redAccent,
                                ),
                                onPressed: (){
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                },
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      if(mounted) {
                        Navigator.pop(context);
                        moneyController.clear();
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            content: Center(child: AppText('فشل شحن المحفظة. رجاء تواصل مع الدعم الفني',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            actions: [
                              IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.redAccent,
                                ),
                                onPressed: (){
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                },
                              )
                            ],
                          ),
                        );
                      }
                    }
                  } else {
                    if(mounted) {
                      Navigator.pop(context);
                      moneyController.clear();
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: Center(child: AppText('فشل في عملية الدفع',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: (){
                                ScaffoldMessenger.of(context).clearMaterialBanners();
                              },
                            )
                          ],
                        ),
                      );
                    }
                  }
                });
              }
            },
            color: Colors.transparent,
            height: MAsizes.buttonNormalWidth,
            width: MAsizes.buttonNormalWidth,
            /*radius: BorderRadius.circular(MAsizes.buttonBorderRadius),*/
            child: const Center(
              child: Image(
                image: AssetImage(AppImages.stcPayLogo),
                fit: BoxFit.contain,
              ),
            )/*Center(child: AppText('شحن المحفظة عن طريق stcpay',color: AppColors.textWhiteColor,size: Platform.isIOS?MAsizes.textNormalSize*2/3:MAsizes.textNormalSize,))*/,
          ),
          if(Platform.isIOS)DialogButton(
            onPressed: () async {
              if(formKey.currentState!.validate()){
                bool success = false;

                String cartProducts = 'شحن محفظة التطبيق';

                var configuration = PaymentSdkConfigurationDetails(
                    profileId: "42593",
                    serverKey: "SLJNLLTNHR-JGWWHDWTLG-LJTRHLRGK2",
                    clientKey: "CDKMDM-6BKQ6T-VVHDV7-99GGHH",
                    cartId: wallet.history.length.toString(),
                    cartDescription: cartProducts,
                    merchantName: 'كلنا خادم',
                    amount: double.parse(moneyController.text),
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
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: Center(child: AppText('تم الدفع بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: (){
                                ScaffoldMessenger.of(context).clearMaterialBanners();
                              },
                            )
                          ],
                        ),
                      );
                    }
                    Map<String,dynamic> data = {
                      'amount' : int.parse(moneyController.text)
                    };
                    Map responseMap = await post(ApiPaths.addSellerWalletAmount+sharedPreferences.getString('token')!,data);

                    if((responseMap['code']>=200 && responseMap['code']<300)) {
                      if (context.mounted){
                        Navigator.pop(context);
                        moneyController.clear();
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            content: Center(child: AppText('تم شحن المحفظة بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            actions: [
                              IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.redAccent,
                                ),
                                onPressed: (){
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                },
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      if(mounted) {
                        Navigator.pop(context);
                        moneyController.clear();
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            content: Center(child: AppText('فشل شحن المحفظة. رجاء تواصل مع الدعم الفني',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            actions: [
                              IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.redAccent,
                                ),
                                onPressed: (){
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                },
                              )
                            ],
                          ),
                        );
                      }
                    }
                  } else {
                    if(mounted) {
                      Navigator.pop(context);
                      moneyController.clear();
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: Center(child: AppText('فشل في عملية الدفع',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: (){
                                ScaffoldMessenger.of(context).clearMaterialBanners();
                              },
                            )
                          ],
                        ),
                      );
                    }
                  }
                });
              }
            },
            color: Colors.transparent,
            height: MAsizes.buttonNormalWidth,
            width: MAsizes.buttonNormalWidth,
            /*radius: BorderRadius.circular(MAsizes.buttonBorderRadius),*/
            child: const Center(
              child: Image(
                image: AssetImage(AppImages.applePayLogo),
                fit: BoxFit.contain,
              ),
            )/*Center(child: AppText('شحن المحفظة عن طريق apple pay',color: AppColors.textWhiteColor,size: Platform.isIOS?MAsizes.textNormalSize*2/3:MAsizes.textNormalSize,))*/,
          ),
        ]).show();
  }

  _onAlertForPullMoney(context) {
    Alert(
        context: context,
        title: "المبلغ",
        closeIcon: IconButton(
          icon: const Icon(Icons.close,color: Colors.redAccent),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        style: AlertStyle(titleStyle: TextStyle(
          color: AppColors.mainColor,
          fontFamily: 'El_Messiri',
          fontSize: MAsizes.textBetweenNormalAndBigSize,
          overflow: TextOverflow.ellipsis,
        )),
        content: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              AppTextFormField(
                validator: (value){
                  if(value == null || value.isEmpty)
                  {
                    return 'المبلغ لا يمكن ان يكون فارغ';
                  }
                  else if(int.parse(value) == 0)
                  {
                    return 'المبلغ لا يمكن ان يكون صفر';
                  }
                  else if(int.parse(value) > wallet.amount)
                  {
                    return 'المبلغ لا يمكن اكبر من الرصيد المتاح';
                  }
                  return null;
                },
                mycontroller: moneyController,
                hintText: ' ادخال المبلغ',
                labelText: 'المبلغ',
                keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              if(formKey.currentState!.validate()){
                Map<String,dynamic> data = {
                  'amount' : int.parse(moneyController.text),
                  'seller' : sharedPreferences.getString('token')
                };
                Map responseMap = await post(ApiPaths.pullSellerWalletAmount+sharedPreferences.getString('token')!,data).onError((error, stackTrace) {
                  return {
                    'code':999
                  };
                });

                if((responseMap['code']>=200 && responseMap['code']<300)) {
                  if (mounted){
                    Navigator.pop(context);
                    moneyController.clear();
                    ScaffoldMessenger.of(context).clearMaterialBanners();
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        content: Center(child: AppText('تم تقديم طلب سحب بنجاح',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                        backgroundColor: AppColors.mainColor,
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                            ),
                            onPressed: (){
                              ScaffoldMessenger.of(context).clearMaterialBanners();
                            },
                          )
                        ],
                      ),
                    );
                  }
                } else if(responseMap['code'] == 999){
                  if(mounted) {
                    Navigator.pop(context);
                    moneyController.clear();
                    ScaffoldMessenger.of(context).clearMaterialBanners();
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                        backgroundColor: AppColors.mainColor,
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                            ),
                            onPressed: (){
                              ScaffoldMessenger.of(context).clearMaterialBanners();
                            },
                          )
                        ],
                      ),
                    );
                  }
                } else{
                  if(mounted) {
                    Navigator.pop(context);
                    moneyController.clear();
                    ScaffoldMessenger.of(context).clearMaterialBanners();
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        content: Center(child: AppText('فشل تقديم طلب سحب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                        backgroundColor: AppColors.mainColor,
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                            ),
                            onPressed: (){
                              ScaffoldMessenger.of(context).clearMaterialBanners();
                            },
                          )
                        ],
                      ),
                    );
                  }
                }
              }
            },
            color: AppColors.buttonGreenColor,
            height: MAsizes.buttonHeight,
            width: MAsizes.buttonBigWidth,
            radius: BorderRadius.circular(MAsizes.buttonBorderRadius),
            child: Center(child: AppText('تقديم طلب سحب نقود',color: AppColors.textWhiteColor,size: Platform.isIOS?MAsizes.textNormalSize*2/3:MAsizes.textNormalSize,)),
          ),
        ]).show();
  }

  late SellerWallet wallet;
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;

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

      final responseMap = await get("${ApiPaths.getSellerWallet}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        if(mounted){
          setState(() {
            wallet = createSellerWallet(responseData["data"]);
            isLoading = false;
          });
        }
      }  else if (responseMap['code'] == 999) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearMaterialBanners();
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: AppText(
              'رجاء تسجيل الدخول اولا',
              color: AppColors.textWhiteColor,
              size: MAsizes.textNormalSize,
            ),
            actions: [
              TextButton(
                child: AppText(
                  'حسنا',
                  color: AppColors.textWhiteColor,
                  size: MAsizes.textNormalSize,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).clearMaterialBanners();
                },
              ),
            ],
            backgroundColor: AppColors.mainColor,

          ));
          Timer(const Duration(seconds: 3), () {
            ScaffoldMessenger.of(context).clearMaterialBanners();
          });
        }
      }else {
        // Handle error case
      }
    }
  }

  Future<void> _refresh() async{
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),) : SizedBox(
      height: MAsizes.screenH,
      width: MAsizes.screenW,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MAsizes.heightOfWalletContainer/2,
                width: MAsizes.widthOfWalletContainer*0.7,
                decoration: BoxDecoration(
                  color: AppColors.offWhiteBoxColor,
                  borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      AppText('ريال',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                      SizedBox(width: MAsizes.widthOfSmallEmptySpace/3,),
                                      AppText('${wallet.amount}',size: MAsizes.textNormalSize*0.9, color: AppColors.textGreenColor),
                                    ],
                                  ),
                                  AppText('الرصيد الحالي',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MAsizes.heightOfWalletContainer/2,
                width: MAsizes.widthOfWalletContainer,
                decoration: BoxDecoration(
                  color: AppColors.offWhiteBoxColor,
                  borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: MaterialButton(
                                onPressed: (){
                                  _onAlertForAddMoney(context);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Icon(Icons.add_card),
                                    AppText('اضافة اموال',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: MaterialButton(
                                onPressed: (){
                                  _onAlertForPullMoney(context);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Icon(Icons.attach_money),
                                    AppText('سحب الارباح',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MAsizes.heightOfWalletContainer/2,
                width: MAsizes.widthOfWalletContainer*1.3,
                decoration: BoxDecoration(
                  color: AppColors.offWhiteBoxColor,
                  borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(Icons.monetization_on_outlined),
                                  AppText('رصيد قيد الانتظار',size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 2),
                                  Expanded(
                                    child: Center(child: AppText('${wallet.wait}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(Icons.monetization_on),
                                  AppText('رصيد تم ايداعه',size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 2),
                                  Expanded(
                                    child: Center(child: AppText('${wallet.transfered}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(Icons.monetization_on),
                                  AppText('النقاط المكتسبة',size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 2),
                                  Expanded(
                                    child: Center(child: AppText('${wallet.point}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            AppText('العمليات السابقة',size: MAsizes.textBigSize, color: AppColors.textGreenColor),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context,index)=>MAsellerMoneyTransformationBox(
                  day: wallet.history[index].date.day,
                  month: wallet.history[index].date.month,
                  year: wallet.history[index].date.year,
                  money: wallet.history[index].amount,
                  plus: wallet.history[index].amount>0,
                ),
                itemCount: wallet.history.length,
              ),
            ),
            SizedBox(
              height: MAsizes.heightOfMediumEmptySpace,
            ),
          ],
        ),
      ),
    );
  }
}