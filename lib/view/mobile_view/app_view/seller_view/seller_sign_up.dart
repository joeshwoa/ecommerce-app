import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_clip_path_box.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/view/mobile_view/app_view/account_created.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_policy.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_terms.dart';

class SellerSignUp extends StatefulWidget {
  const SellerSignUp({super.key});

  @override
  State<SellerSignUp> createState() => _SellerSignUpState();
}

class _SellerSignUpState extends State<SellerSignUp> {

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController marketController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordAgainController = TextEditingController();

  final _scrollController = ScrollController();

  final nameFocusNode = FocusNode();

  final emailFocusNode = FocusNode();

  final phoneFocusNode = FocusNode();

  final marketFocusNode = FocusNode();

  final passwordFocusNode = FocusNode();

  final passwordAgainFocusNode = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showPassword = true;

  bool acceptPolicy = false;
  bool acceptTerms = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    marketFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordAgainFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(() {
      _scrollToField(nameFocusNode);
    });
    emailFocusNode.addListener(() {
      _scrollToField(emailFocusNode);
    });
    phoneFocusNode.addListener(() {
      _scrollToField(phoneFocusNode);
    });
    marketFocusNode.addListener(() {
      _scrollToField(marketFocusNode);
    });
    passwordFocusNode.addListener(() {
      _scrollToField(passwordFocusNode);
    });
    passwordAgainFocusNode.addListener(() {
      _scrollToField(passwordAgainFocusNode);
    });
  }

  void _scrollToField(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      final RenderObject? renderObject = focusNode.context!.findRenderObject();
      final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
      viewport.showOnScreen(
        descendant: renderObject,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
      body: SizedBox(
        height: MAsizes.screenH,
        width: MAsizes.screenW,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const MobileClipPathBox(),
            SingleChildScrollView(
              controller: _scrollController,
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
                    height: MAsizes.heightOfSignupContainer,
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
                          AppText('تسجيل التاجر',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textGreenColor,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppTextFormField(
                              focusNode: nameFocusNode,
                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'الاسم لا يمكن ان يكون فارغ';
                                }
                                if(value.length < 3)
                                {
                                  return 'الاسم لا يمكن ان يكون اقل من 3';
                                }
                                return null;
                              },
                              mycontroller: nameController,
                              hintText: 'ادخل الاسم',
                              labelText: 'الاسم',
                              icon: Icons.person,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppTextFormField(
                              focusNode: emailFocusNode,
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
                              focusNode: phoneFocusNode,
                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'رقم الجوال لا يمكن ان يكون فارغ';
                                }
                                else if(value.characters.contains(' '))
                                {
                                  return 'لا يوجد رقم جوال يحتوي علي مسافات';
                                }
                                else if(value.characters.length < 10)
                                {
                                  return 'رقم الجوال غير مكتمل';
                                }
                                else if(value[0] != '0'|| ( value[1] != '1' && value[1] != '5' && value[1] != '8' ))
                                {
                                  return 'رقم الجوال غير صحيح';
                                }
                                return null;
                              },
                              mycontroller: phoneController,
                              hintText: 'ادخل رقم الجوال',
                              labelText: 'رقم الجوال',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppTextFormField(
                              focusNode: marketFocusNode,
                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'اسم المتجر لا يمكن ان يكون فارغ';
                                }
                                return null;
                              },
                              mycontroller: marketController,
                              hintText: 'ادخل اسم الماركت',
                              labelText: 'اسم الماركت',
                              icon: Icons.person,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppTextFormField(
                              focusNode: passwordFocusNode,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppTextFormField(
                              focusNode: passwordAgainFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              mycontroller: passwordAgainController,
                              obscureText: showPassword,
                              hintText: 'ادخل تاكيد كلمة المرور',
                              labelText: 'تاكيد كلمة المرور',
                              icon: Icons.remove_red_eye,
                              onPressedicon: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              validator: (value){
                                if(value != passwordController.text)
                                {
                                  return 'تاكيد كلمة المرور غير متطابق مع كلمة المرور';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Checkbox(
                                  activeColor: AppColors.mainColor,
                                  side: BorderSide(color: acceptPolicy?AppColors.mainColor:Colors.red),
                                  value: acceptPolicy,
                                  onChanged: (value){
                                    setState(() {
                                      acceptPolicy = value!;
                                    });
                                  },
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerPolicy(),));
                                    },
                                    child: AppText('سياسة الخصوصية ',size: MAsizes.textNormalSize,color: AppColors.textGreenColor,)
                                ),
                                AppText('اوفق علي ',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textGreenColor,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Checkbox(
                                  activeColor: AppColors.mainColor,
                                  side: BorderSide(color: acceptTerms?AppColors.mainColor:Colors.red),
                                  value: acceptTerms,
                                  onChanged: (value){
                                    setState(() {
                                      acceptTerms = value!;
                                    });
                                  },
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerTerms(),));
                                      },
                                    child: AppText('سياسة الاستخدام ',size: MAsizes.textNormalSize,color: AppColors.textGreenColor,)
                                ),
                                AppText('اوفق علي ',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textGreenColor,),
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if(formKey.currentState!.validate()&&acceptPolicy&&acceptTerms)
                              {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('جاري انشاء حساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                                Map<String,dynamic> data = {
                                  'email':emailController.text,
                                  'name':nameController.text,
                                  'password':passwordController.text,
                                  'passwordConfirm':passwordAgainController.text,
                                  'phone':phoneController.text,
                                  'market':marketController.text,
                                };
                                Map responseMap = await post(ApiPaths.sellerSignUp,data).onError((error, stackTrace) {
                                  return {
                                    'code':999
                                  };
                                });
                                if((responseMap['code']>=200 && responseMap['code']<300)){
                                  sharedPreferences.setString('token', responseMap['body']['token']);
                                  if (context.mounted){
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(child: AppText('تم انشاء حساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                        backgroundColor: AppColors.mainColor,
                                        showCloseIcon: true,
                                      ),
                                    );
                                    Timer(const Duration(seconds: 1), () {
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAAccountCreated(userType: 'seller')));
                                    });
                                  }
                                } else if(responseMap['code']==400 && responseMap['body']['errors'].length > 0){
                                  if (context.mounted){
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                  }
                                  for(int i = 0;i<responseMap['body']['errors'].length;i++){
                                    if(responseMap['body']['errors'][i]['msg'] == 'E-mail already in seller') {
                                      if (context.mounted){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Center(child: AppText('البريد الاكتروني مستخدم من قبل',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                            backgroundColor: AppColors.mainColor,
                                            showCloseIcon: true,
                                          ),
                                        );
                                      }
                                    }
                                    if(responseMap['body']['errors'][i]['msg'] == 'phone already in seller') {
                                      if (context.mounted){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Center(child: AppText('رقم الجوال مستخدم من قبل',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                            backgroundColor: AppColors.mainColor,
                                            showCloseIcon: true,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }else if(responseMap['code']==500 && responseMap['body']['error']['keyPattern']['phone'] != null){
                                  if (context.mounted){
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(child: AppText('فشل في اكمال البيانات. رقم الجوال مستخدم من قبل',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                        backgroundColor: AppColors.mainColor,
                                        showCloseIcon: true,
                                      ),
                                    );
                                  }
                                }else if (responseMap['code'] == 999) {
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
                                        content: Center(child: AppText('فشل انشاء حساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                        backgroundColor: AppColors.mainColor,
                                        showCloseIcon: true,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                width: MAsizes.buttonNormalWidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: acceptPolicy&&acceptTerms?AppColors.buttonGreenColor:Colors.grey
                                ),
                                child: Center(child: AppText('انشاء حساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
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
                          size: MAsizes.textBetweenNormalAndBigSize,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      AppText(
                        'لديك حساب ؟ ',
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
