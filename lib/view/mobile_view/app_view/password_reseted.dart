import 'package:flutter/material.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_email_login.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_layout.dart';
import 'package:klnakhadem/view/mobile_view/app_view/selete_user_type.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_email_login.dart';

class MAPasswordReseted extends StatelessWidget {
  const MAPasswordReseted({super.key,required this.userType});
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
              AppText('تم تغير كلمة المرور بنجاح',color: AppColors.textGreenColor,size: MAsizes.textBigSize),
              SizedBox(
                height: MAsizes.screenH/2,
                width: MAsizes.screenW/2,
                child: const Image(image: AssetImage(AppImages.passwordReseted),fit: BoxFit.contain),
              ),
              MaterialButton(
                onPressed: (){
                  if(userType == 'seller')
                  {
                    if(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAbuyerLayout()));
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const MAselectUserType(),));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerEmailLogin()));
                  }else if(userType == 'buyer')
                  {
                    if(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAbuyerLayout()));
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const MAselectUserType(),));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyerEmailLogin()));
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
