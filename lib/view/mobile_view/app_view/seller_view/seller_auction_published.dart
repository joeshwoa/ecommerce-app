import 'package:flutter/material.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_layout.dart';

class SellerAuctionPublished extends StatelessWidget {
  const SellerAuctionPublished({super.key});

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
              AppText('تم اضافة منتجك بنجاح',color: AppColors.textGreenColor,size: MAsizes.textBigSize),
              AppText('سيتم اضافته خلال دقائق',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
              SizedBox(
                height: MAsizes.screenH/2,
                width: MAsizes.screenW/2,
                child: const Image(image: AssetImage(AppImages.productPublished),fit: BoxFit.contain),
              ),
              MaterialButton(
                onPressed: (){
                  while(Navigator.canPop(context))
                  {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAsellerLayout()));
                },
                child: Container(
                    height: MAsizes.buttonHeight,
                    width: MAsizes.buttonBigWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                        color: AppColors.buttonGreenColor
                    ),
                    child: Center(child: AppText('الذهاب للصفحة الرئيسية',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}