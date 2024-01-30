import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/selete_user_type.dart';

class MAPleaseLogin extends StatelessWidget {
  const MAPleaseLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MAsizes.screenH,
      width: MAsizes.screenW,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText('الرجاء تسجيل الدخول اولا',color: AppColors.textGreenColor,size: MAsizes.textBigSize),
          SizedBox(
            height: MAsizes.screenH/2,
            width: MAsizes.screenW/2,
            child: const Image(image: AssetImage('assets/images/Please_Signin.png'),fit: BoxFit.contain),
          ),
          MaterialButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType()));
            },
            child: Container(
                height: MAsizes.buttonHeight,
                width: MAsizes.buttonBigWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                    color: AppColors.buttonGreenColor
                ),
                child: Center(child: AppText('تسجيل الدخول',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
            ),
          ),
          SizedBox(
            height: MAsizes.heightOfSmallEmptySpace/2,
          ),
        ],
      ),
    );
  }
}
