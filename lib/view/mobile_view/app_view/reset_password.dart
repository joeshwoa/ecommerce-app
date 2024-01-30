import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/put.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/view/mobile_view/app_view/password_reseted.dart';

class MAResetPassword extends StatefulWidget {
  const MAResetPassword({super.key,required this.userType,required this.email});
  final String userType;

  final String email;

  @override
  State<MAResetPassword> createState() => _MAResetPasswordState();
}

class _MAResetPasswordState extends State<MAResetPassword> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordAgainController = TextEditingController();

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('اعادة تعيين كلمة المرور',color: AppColors.textWhiteColor,size: MAsizes.textBetweenNormalAndBigSize),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.buttonWhiteColor),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: SizedBox(
            height: MAsizes.screenH/2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText('الرجاء ادخال كلمة المرور الجديدة',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    mycontroller: passwordController,
                    obscureText: showPassword,
                    hintText: 'ادخل كلمة المرور الجديدة',
                    labelText: 'كلمة المرورالجديدة',
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
                    keyboardType: TextInputType.visiblePassword,
                    mycontroller: passwordAgainController,
                    obscureText: showPassword,
                    hintText: 'ادخل تاكيد كلمة المرور الجديدة',
                    labelText: 'تاكيد كلمة المرور الجديدة',
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
                MaterialButton(
                  onPressed: () async {
                    if(widget.userType == 'buyer'){
                      if(formKey.currentState!.validate())
                      {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: AppText('جاري اعادة تعيين كلمة المرور',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                        Map<String,dynamic> data = {
                          'email':widget.email,
                          'newPassword': passwordController.text,
                          'newPasswordConfirm': passwordAgainController.text
                        };
                        Map responseMap = await put(ApiPaths.resetPasswordForBuyer,data).onError((error, stackTrace) {
                          return {
                            'code':999
                          };
                        });
                        if((responseMap['code']>=200 && responseMap['code']<300)){
                          if(mounted) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MAPasswordReseted(userType: widget.userType)));
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
                                content: Center(child: AppText('فشل اعادة تعيين كلمة المرور',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                            content: Center(child: AppText('جاري اعادة تعيين كلمة المرور',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                        Map<String,dynamic> data = {
                          'email':widget.email,
                          'newPassword': passwordController.text,
                          'newPasswordConfirm': passwordAgainController.text
                        };
                        Map responseMap = await put(ApiPaths.resetPasswordForSeller,data).onError((error, stackTrace) {
                          return {
                            'code':999
                          };
                        });
                        if((responseMap['code']>=200 && responseMap['code']<300)){
                          if(mounted) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MAPasswordReseted(userType: widget.userType)));
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
                                content: Center(child: AppText('فشل اعادة تعيين كلمة المرور',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                      child: Center(child: AppText('حفظ كلمة المرور الجديدة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
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
