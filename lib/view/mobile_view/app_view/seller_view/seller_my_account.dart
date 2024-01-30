import 'package:flutter/material.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_my_account_button.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_layout.dart';
import 'package:klnakhadem/view/mobile_view/app_view/selete_user_type.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_my_addresses.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_my_bills.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_personal_information.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_policy.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_terms.dart';
import 'package:klnakhadem/view/mobile_view/app_view/technical_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SellerMyAccount extends StatelessWidget {
  const SellerMyAccount({super.key});

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "تسجيل خروج",
        closeIcon: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(image: const AssetImage(AppImages.logo),fit: BoxFit.contain,height: MAsizes.heightOfSmallEmptySpace*1.2,width: MAsizes.heightOfSmallEmptySpace*1.2),
            ),
            IconButton(
              icon: const Icon(Icons.close,color: Colors.redAccent),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
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
            fontSize: MAsizes.textNormalSize,
            overflow: TextOverflow.ellipsis,
          ),
          titleStyle: TextStyle(
            color: Colors.redAccent,
            fontFamily: 'El_Messiri',
            fontSize: MAsizes.textBetweenNormalAndBigSize,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        type: AlertType.error,
        desc: "هل انت متأكد بأنك تريد تسجيل الخروج؟",
        buttons: [
          DialogButton(
            onPressed: () {
              userType = 'notSign';
              sharedPreferences.setString('userType', userType);
              sharedPreferences.setString('token', '');
              if (context.mounted){
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MAbuyerLayout()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType(),));
              }
            },
            color: AppColors.mainColor,
            child: AppText(
              'تسجيل خروج',
              size: MAsizes.textNormalSize,
              color: AppColors.textWhiteColor,
            ),
          ),
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MAsizes.screenH,
      width: MAsizes.screenW,
      child: Column(
        children: [
          SizedBox(
            height: MAsizes.heightOfSmallEmptySpace/2,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MAsizes.buttonHeight*1.5,
              width: MAsizes.screenW,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                  color: AppColors.offWhiteBoxColor
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText('حساب تاجر مع متجر خاص', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    const Icon(Icons.account_circle_outlined)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const MAmyAccountButton(word: 'المعلومات الشخصية', goTo: SellerPersonalInformation(), icon: Icons.person_outline),
                  const MAmyAccountButton(word: 'عنواني', goTo: SellerMyAddresses(), icon: Icons.location_on_outlined),
                  const MAmyAccountButton(word: 'فواتيري', goTo: SellerMyBills(), icon: Icons.text_snippet_outlined),
                  const MAmyAccountButton(word: 'الدعم الفني', goTo: MAtechnicalSupport(user: false), icon: Icons.support_agent_outlined),
                  const MAmyAccountButton(word: 'سياسة الاستخدام', goTo: SellerTerms(), icon: Icons.security_outlined),
                  const MAmyAccountButton(word: 'سياسة الخصوصية', goTo: SellerPolicy(), icon: Icons.security_outlined),
                  MAmyAccountButton(word: 'تسجيل الخروج', goTo: const MAselectUserType(), icon: Icons.logout_outlined,onPressed: (){
                    _onAlertWithCustomContentPressed(context);
                  }),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MAsizes.heightOfMediumEmptySpace,
          ),
        ],
      ),
    );
  }
}