import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/view/mobile_view/app_view/enter_reset_code.dart';

class MAForgetPassword extends StatefulWidget {
  const MAForgetPassword({super.key,required this.userType});
  final String userType;

  @override
  State<MAForgetPassword> createState() => _MAForgetPasswordState();
}

class _MAForgetPasswordState extends State<MAForgetPassword> {

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: AppText('نسيت كلمة المرور',color: AppColors.textWhiteColor,size: MAsizes.textBetweenNormalAndBigSize),
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
                child: const Image(image: AssetImage(AppImages.forgetPassword),fit: BoxFit.contain),
              ),
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
              SizedBox(height: MAsizes.heightOfSmallEmptySpace,),
              MaterialButton(
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
                        'email':emailController.text,
                      };
                      Map responseMap = await post(ApiPaths.getOtpToResetPasswordForBuyer,data).onError((error, stackTrace) {
                        return {
                          'code':999
                        };
                      });
                      if((responseMap['code']>=200 && responseMap['code']<300)){
                        if(mounted) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MAEnterResetCode(userType: widget.userType,email: emailController.text,)));
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
                        'email':emailController.text,
                      };
                      Map responseMap = await post(ApiPaths.getOtpToResetPasswordForSeller,data).onError((error, stackTrace) {
                        return {
                          'code':999
                        };
                      });
                      if((responseMap['code']>=200 && responseMap['code']<300)){
                        if(mounted) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MAEnterResetCode(userType: widget.userType,email: emailController.text,)));
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
                    width: MAsizes.buttonBigWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                        color: AppColors.buttonGreenColor
                    ),
                    child: Center(child: AppText('ارسل رمز التحقق',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
