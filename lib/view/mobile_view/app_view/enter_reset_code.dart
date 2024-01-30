import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/reset_password.dart';

class MAEnterResetCode extends StatefulWidget {
  const MAEnterResetCode({Key? key,required this.userType,required this.email}) : super(key: key);

  final String userType;
  final String email;

  @override
  State<MAEnterResetCode> createState() => _MAEnterResetCodeState();
}

class _MAEnterResetCodeState extends State<MAEnterResetCode> {

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.buttonWhiteColor),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
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
                      if(widget.userType == 'buyer'){
                        if(formKey.currentState!.validate())
                        {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('جاري التحقق من الرمز',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Map<String,dynamic> data = {
                            'email':widget.email,
                            'otp': controllers[0].text+controllers[1].text+controllers[2].text+controllers[3].text+controllers[4].text+controllers[5].text,
                          };
                          Map responseMap = await post(ApiPaths.verifyResetCodeForBuyer,data).onError((error, stackTrace) {
                            return {
                              'code':999
                            };
                          });
                          if((responseMap['code']>=200 && responseMap['code']<300)){
                            if(mounted) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MAResetPassword(userType: widget.userType,email: widget.email,)));
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
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('فشل في التحقق من الرمز',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                        }
                      } else if(widget.userType == 'seller'){
                        if(formKey.currentState!.validate())
                        {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('جاري التحقق من الرمز',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Map<String,dynamic> data = {
                            'email':widget.email,
                            'otp': controllers[0].text+controllers[1].text+controllers[2].text+controllers[3].text+controllers[4].text+controllers[5].text,
                          };
                          Map responseMap = await post(ApiPaths.verifyResetCodeForSeller,data).onError((error, stackTrace) {
                            return {
                              'code':999
                            };
                          });
                          if((responseMap['code']>=200 && responseMap['code']<300)){
                            if(mounted) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MAResetPassword(userType: widget.userType,email: widget.email,)));
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
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('فشل في التحقق من الرمز',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                      if(widget.userType == 'buyer'){
                        if(formKey.currentState!.validate()){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('جاري ارسال رمز تحقق لاعادة تعيين كلمة السر',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Map<String,dynamic> data = {
                            'email':widget.email,
                          };
                          Map responseMap = await post(ApiPaths.getOtpToResetPasswordForBuyer,data).onError((error, stackTrace) {
                            return {
                              'code':999
                            };
                          });
                          if((responseMap['code']>=200 && responseMap['code']<300)){
                            if(mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('تم اعادة ارسال رمز تحقق لاعادة تعيين كلمة السر',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
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
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('فشل ارسال رمز تحقق لاعادة تعيين كلمة السر',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                        }
                      } else if(widget.userType == 'seller'){
                        if(formKey.currentState!.validate()){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('جاري ارسال رمز تحقق لاعادة تعيين كلمة السر',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Map<String,dynamic> data = {
                            'email':widget.email,
                          };
                          Map responseMap = await post(ApiPaths.getOtpToResetPasswordForSeller,data).onError((error, stackTrace) {
                            return {
                              'code':999
                            };
                          });
                          if((responseMap['code']>=200 && responseMap['code']<300)){
                            if(mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('تم اعادة ارسال رمز تحقق لاعادة تعيين كلمة السر',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
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
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('فشل ارسال رمز تحقق لاعادة تعيين كلمة السر',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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