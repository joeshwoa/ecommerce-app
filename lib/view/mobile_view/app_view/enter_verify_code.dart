import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_email_login.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_layout.dart';
import 'package:klnakhadem/view/mobile_view/app_view/selete_user_type.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_email_login.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_layout.dart';

class MAEnterVerifyCode extends StatefulWidget {
  const MAEnterVerifyCode({Key? key,required this.userType,required this.fromSignupPage}) : super(key: key);

  final String userType;
  final bool fromSignupPage;

  @override
  State<MAEnterVerifyCode> createState() => _MAEnterVerifyCodeState();
}

class _MAEnterVerifyCodeState extends State<MAEnterVerifyCode> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<TextEditingController> controllers = List.generate(
    6,
        (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('ادخل رمز التحقق',color: AppColors.textWhiteColor,size: MAsizes.textBetweenNormalAndBigSize),
          leading: const SizedBox()/*IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.buttonWhiteColor),
            onPressed: (){
              Navigator.pop(context);
            },
          )*/,
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MAsizes.screenH/2,
                  width: MAsizes.screenW/2,
                  child: const Image(image: AssetImage(AppImages.getResetCode),fit: BoxFit.contain),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText('رجاء ادخال الرمز المرسل علي البريد الالكتروني',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      for (int i = 0; i < 6; i++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              controller: controllers[i],
                              keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'خطأ';
                                }
                                return null;
                              },
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.none,
                              cursorColor: AppColors.mainColor,
                              decoration: InputDecoration(
                                counter: const SizedBox(),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),borderSide: const BorderSide(color: AppColors.mainColor,width: 2)),
                                labelStyle: const TextStyle(color: AppColors.mainColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),borderSide: const BorderSide(color: AppColors.mainColor)),
                              ),
                              onChanged: (text) {
                                if (text.length == 1) {
                                  // Move focus to the next TextFormField
                                  if (i < 5) {
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    // If this is the last TextFormField, hide the keyboard
                                    FocusScope.of(context).unfocus();
                                  }
                                } else {
                                  if (i > 0) {
                                    FocusScope.of(context).previousFocus();
                                  } else {
                                    // If this is the last TextFormField, hide the keyboard
                                    FocusScope.of(context).unfocus();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if(formKey.currentState!.validate())
                      {
                        String id = sharedPreferences.getString('token') ?? '';
                        String otp = '';
                        for(int i=0;i<controllers.length;i++) {
                          otp+=controllers[i].text;
                        }
                        Map<String,dynamic> data = {
                          'id':id,
                          'otp':otp
                        };
                        if(widget.userType == "buyer") {
                          Map responseMap = await post(ApiPaths.sendBuyerOTP,data).onError((error, stackTrace) {
                            return {
                              'code':999
                            };
                          });
                          if((responseMap['code']>=200 && responseMap['code']<300)){
                            if (context.mounted && widget.fromSignupPage) {
                              while (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAbuyerLayout()));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType()));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyerEmailLogin()));
                            }
                            else {
                              if (context.mounted){
                                ScaffoldMessenger.of(context)
                                    .clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                        child: AppText(
                                          'تم تسجيل الدخول للحساب بنجاح',
                                          color: AppColors.textWhiteColor,
                                          size: MAsizes.textNormalSize,
                                        )),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                              userType='buyer';
                              sharedPreferences.setString('userType', userType);
                              sharedPreferences.setString('name', responseMap['body']['data']['name']);
                              sharedPreferences.setString('email', responseMap['body']['data']['email']);
                              sharedPreferences.setString('phone', responseMap['body']['data']['phone']);
                              Timer(const Duration(seconds: 1), () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                if (context.mounted){
                                  while (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const MAbuyerLayout()));
                                }
                              });
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
                            if(mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                      child: AppText(
                                        'خطأ في رمز التحقق',
                                        color: AppColors.textWhiteColor,
                                        size: MAsizes.textNormalSize,
                                      )),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                        } else if(widget.userType == 'seller') {
                          Map responseMap = await post(ApiPaths.sendSellerOTP,data).onError((error, stackTrace) {
                            return {
                              'code':999
                            };
                          });
                          if((responseMap['code']>=200 && responseMap['code']<300)){
                            if (context.mounted && widget.fromSignupPage) {
                              while (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAbuyerLayout()));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType()));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerEmailLogin()));
                            }
                            else if (context.mounted){
                              userType='seller';
                              String? marketID = sharedPreferences.getString('marketID');
                              Map responseMap2 = await get("${ApiPaths.getMarketData}$marketID").onError((error, stackTrace) {
                                return {
                                  'code':999
                                };
                              });
                              if((responseMap2['code']>=200 && responseMap2['code']<300) && responseMap2['body']['data'].length != 0)
                              {
                                userType = 'sellerComplete';
                              }else if((responseMap2['code']>=200 && responseMap2['code']<300) && responseMap2['body']['data'].length == 0) {
                                userType = 'seller';
                              }
                              sharedPreferences.setString('userType', userType);
                              sharedPreferences.setString('name', responseMap['body']['data']['name']);
                              sharedPreferences.setString('email', responseMap['body']['data']['email']);
                              sharedPreferences.setString('phone', responseMap['body']['data']['phone']);
                              if (context.mounted){
                                ScaffoldMessenger.of(context)
                                    .clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                        child: AppText(
                                          'تم تسجيل الدخول للحساب بنجاح',
                                          color: AppColors.textWhiteColor,
                                          size: MAsizes.textNormalSize,
                                        )),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                                Timer(const Duration(seconds: 1), () {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  while (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const MAsellerLayout()));
                                });

                              }
                            }
                          } else {
                            if(mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                      child: AppText(
                                        'خطأ في رمز التحقق',
                                        color: AppColors.textWhiteColor,
                                        size: MAsizes.textNormalSize,
                                      )),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                        }
                      }
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonNormalWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: AppColors.buttonGreenColor
                        ),
                        child: Center(child: AppText('تحقق',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context)
                          .clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                              child: AppText(
                                'جاري اعادة ارسال الرمز',
                                color: AppColors.textWhiteColor,
                                size: MAsizes.textNormalSize,
                              )),
                          backgroundColor: AppColors.mainColor,
                          showCloseIcon: true,
                        ),
                      );
                      final responseMap2 = await get("${ApiPaths.requestNewBuyerOTP}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
                        return {
                          'code':999
                        };
                      });
                      if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: AppText(
                                    'تم اعادة ارسال الرمز',
                                    color: AppColors.textWhiteColor,
                                    size: MAsizes.textNormalSize,
                                  )),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
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
                        if(mounted) {
                          ScaffoldMessenger.of(context)
                              .clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: AppText(
                                    'فشل اعادة ارسال الرمز',
                                    color: AppColors.textWhiteColor,
                                    size: MAsizes.textNormalSize,
                                  )),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                        }

                      }
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonBigWidth*1.5/2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: AppColors.buttonGreenColor
                        ),
                        child: Center(child: AppText('اعادة ارسل رمز',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
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