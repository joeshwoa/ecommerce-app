import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/enter_verify_code.dart';

class MAAccountCreated extends StatelessWidget {
  const MAAccountCreated({super.key,required this.userType,});
  final String userType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: SizedBox(
            height: MAsizes.screenH*7/100,
            child: const Image(image: AssetImage(AppImages.logo),fit: BoxFit.contain),
          ),
          leading: const SizedBox(),
        ),
        body: SizedBox(
          height: MAsizes.screenH,
          width: MAsizes.screenW,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText('تم انشاء حسابك بنجاح',color: AppColors.textGreenColor,size: MAsizes.textBigSize),
              SizedBox(
                height: MAsizes.screenH/2,
                width: MAsizes.screenW/2,
                child: const Image(image: AssetImage(AppImages.accountCreated),fit: BoxFit.contain),
              ),
              MaterialButton(
                onPressed: () async {
                  if(userType == 'seller')
                  {
                    final responseMap2 = await get("${ApiPaths.requestNewSellerOTP}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
                      return {
                        'code':999
                      };
                    });
                    if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                      if (context.mounted) {
                        while (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MAEnterVerifyCode(userType: userType,fromSignupPage: true),));
                      }
                    } else if (responseMap2['code'] == 999) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                      }
                    }
                  }else if(userType == 'buyer')
                  {
                    final responseMap2 = await get("${ApiPaths.requestNewBuyerOTP}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
                      return {
                        'code':999
                      };
                    });
                    if((responseMap2['code']>=200 && responseMap2['code']<300)) {
                      if (context.mounted) {
                        while (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MAEnterVerifyCode(userType: userType,fromSignupPage: true),));
                      }
                    }  else if (responseMap2['code'] == 999) {
                      if (context.mounted) {
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
                },
                child: Container(
                    height: MAsizes.buttonHeight,
                    width: MAsizes.buttonBigWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                        color: AppColors.buttonGreenColor
                    ),
                    child: Center(child: AppText('الانتقال لتسجيل الدخول',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
