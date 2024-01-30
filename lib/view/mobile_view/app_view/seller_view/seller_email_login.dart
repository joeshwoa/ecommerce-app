import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_clip_path_box.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/view/mobile_view/app_view/enter_verify_code.dart';
import 'package:klnakhadem/view/mobile_view/app_view/forget_password.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_layout.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_phone_login.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_sign_up.dart';

class SellerEmailLogin extends StatefulWidget {
  const SellerEmailLogin({super.key});

  @override
  State<SellerEmailLogin> createState() => _SellerEmailLoginState();
}

class _SellerEmailLoginState extends State<SellerEmailLogin> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
      body: SizedBox(
        height: MAsizes.screenH,
        width: MAsizes.screenW,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const MobileClipPathBox(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: MAsizes.heightOfBigEmptySpace,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MAsizes.heightOfLoginContainer,
                    width: MAsizes.widthOfSignupOrLoginContainer,
                    decoration: BoxDecoration(
                        color: AppColors.offWhiteBoxColor,
                        borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius)
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppText('اهلا بك في صفحة',size: MAsizes.textNormalSize,color: AppColors.textGreenColor,),
                          AppText('تسجيل دخول التاجر',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textGreenColor,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppTextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'البريد الالكتروني لا يمكن ان يكون فارغ';
                                }
                                else if(!value.characters.contains('@'))
                                {
                                  return 'لا يمكن ان يوجد بريد الالكتروني بدون علامة @';
                                }
                                else if(value.characters.contains(' '))
                                {
                                  return 'لا يوجد بريد الكتروني يحتوي علي مسافات';
                                }
                                return null;
                              },
                              mycontroller: emailController,
                              hintText: ' ادخال البريد الالكتروني',
                              labelText: 'البريد الالكتروني',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppTextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              mycontroller: passwordController,
                              obscureText: showPassword,
                              hintText: 'ادخل كلمة المرور',
                              labelText: 'كلمة المرور',
                              icon: Icons.remove_red_eye,
                              onPressedicon: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              validator: (value){
                                if(value == null || value.isEmpty || value.length < 8)
                                {
                                  return 'كلمة المرور يجب ان تكون من 8 خانات او اكثر';
                                }
                                else if(value.characters.length < 2)
                                {
                                  return 'لا يمكن ان تحتوي كلمة المرور علي حرف واحد فقط';
                                }
                                else if(value.characters.contains(' '))
                                {
                                  return 'لا يمكن ان تحتوي كلمة المرور علي مسافات';
                                }
                                return null;
                              },
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if(formKey.currentState!.validate())
                              {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('جاري تسجيل الدخول',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                                Map<String,dynamic> data = {
                                  'email':emailController.text,
                                  'password':passwordController.text,
                                };
                                Map responseMap = await post(ApiPaths.sellerLogIn,data);
                                if((responseMap['code']>=200 && responseMap['code']<300)){
                                  sharedPreferences.setString('token', responseMap['body']['token']);
                                  bool active = responseMap['body']['data']['active'];
                                  if(active) {
                                    userType='seller';
                                    if(responseMap['body']['market'] != null && responseMap['body']['market'].length != 0)
                                    {
                                      userType = 'sellerComplete';
                                      sharedPreferences.setBool('registered', responseMap['body']['market']['registered']);

                                      sharedPreferences.setString('city', responseMap['body']['market']['town']);
                                      sharedPreferences.setString('area', responseMap['body']['market']['region']);
                                      sharedPreferences.setString('supArea', responseMap['body']['market']['area']);
                                      sharedPreferences.setString('street', responseMap['body']['market']['street']);

                                      sharedPreferences.setString('marketID', responseMap['body']['market']['_id']);
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
                                  else {
                                    final responseMap2 = await get("${ApiPaths.requestNewSellerOTP}${responseMap['body']['token']}");
                                    if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                                      if (context.mounted) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MAEnterVerifyCode(userType: 'seller',fromSignupPage: false),));
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
                                  if(responseMap['body']['message']=='Incorrect email or password' || responseMap['body']['message']=='Incorrect email  or password') {
                                    if (context.mounted){
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('البريد الالكتروني او كلمة المرور خطأ',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
                                  } else {
                                    if (context.mounted){
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('فشل تسجيل الدخول للحساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                                child: Center(child: AppText('تسجيل دخول',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                            ),
                          ),
                          MaterialButton(
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerPhoneLogin()));
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                width: MAsizes.buttonBigWidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: AppColors.buttonGreenColor
                                ),
                                child: Center(child: AppText('تسجيل دخول برقم الجوال',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: AppText(
                          'اضغط هنا',
                          color: AppColors.textGreenColor,
                          size: MAsizes.textNormalSize,
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MAForgetPassword(userType: 'seller',)));
                        },
                      ),
                      AppText(
                        'نسيت كلمة المرور ؟ ',
                        color: AppColors.textGreenColor,
                        size: MAsizes.textBetweenNormalAndBigSize,
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: AppText(
                          'اضغط هنا',
                          color: AppColors.textGreenColor,
                          size: MAsizes.textBetweenNormalAndBigSize,
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerSignUp()));
                        },
                      ),
                      AppText(
                        'ليس لديك حساب ؟ ',
                        color: AppColors.textGreenColor,
                        size: MAsizes.textBigSize,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
