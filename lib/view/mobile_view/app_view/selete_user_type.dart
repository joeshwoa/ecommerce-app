import 'package:flutter/material.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_email_login.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_email_login.dart';

class MAselectUserType extends StatelessWidget {
  const MAselectUserType({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold( resizeToAvoidBottomInset: false,
      /*backgroundColor: AppColors.mainColor,*/
      body: SizedBox(
        height: MAsizes.screenH,
        width: MAsizes.screenW,
        child: Stack(
          children: [
            SizedBox(
              height: MAsizes.screenH,
              width: MAsizes.screenW,
              child: const Image(image: AssetImage(AppImages.splashBackground),fit: BoxFit.cover),
            ),
            Container(
              height: MAsizes.screenH,
              width: MAsizes.screenW,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        AppColors.mainColor.withOpacity(0.8),
                        Colors.white.withOpacity(0.8)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
            ),
            SizedBox(
              height: MAsizes.screenH,
              width: MAsizes.screenW,
              child: Column(
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
                  SizedBox(
                      width: MAsizes.screenW/3,
                      height: MAsizes.screenH/3,
                      child: const Image(image: AssetImage(AppImages.logo),fit: BoxFit.contain)
                  ),
                  Center(
                    child: SizedBox(
                      height: MAsizes.heightOfSmallEmptySpace,
                      child: AppText('مرحبا بك في كلنا خادم!',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: MAsizes.heightOfSmallEmptySpace,
                      child: AppText('تطبيق التاجر و العميل',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,),
                    ),
                  ),
                  SizedBox(
                    height: MAsizes.heightOfSmallEmptySpace,
                  ),
                  Center(
                    child: SizedBox(
                      height: MAsizes.heightOfSmallEmptySpace,
                      child: AppText('الرجاء الاختيار',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,),
                    ),
                  ),
                  SizedBox(
                    width: MAsizes.screenW,
                    height: MAsizes.heightOfMediumEmptySpace,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyerEmailLogin()));
                          },
                          child: Container(
                              height: MAsizes.buttonHeight,
                              width: MAsizes.buttonNormalWidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                  color: AppColors.buttonWhiteColor
                              ),
                              child: Center(child: AppText('عميل',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,))
                          ),
                        ),
                        SizedBox(width: MAsizes.widthOfMediumEmptySpace),
                        MaterialButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerEmailLogin()));
                          },
                          child: Container(
                              height: MAsizes.buttonHeight,
                              width: MAsizes.buttonNormalWidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                  color: AppColors.buttonWhiteColor
                              ),
                              child: Center(child: AppText('تاجر',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,))
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MAsizes.heightOfBigEmptySpace),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
