import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';

class BuyerAuctionPolicy extends StatefulWidget {
  const BuyerAuctionPolicy({super.key});

  @override
  State<BuyerAuctionPolicy> createState() => _BuyerAuctionPolicyState();
}

class _BuyerAuctionPolicyState extends State<BuyerAuctionPolicy> {
  bool acceptPolicy = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('شروط الانضمام الي المزاد',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SizedBox(
          height: MAsizes.screenH,
          width: MAsizes.screenW,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    AppText('شرط',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AppText('مبلغ التامين :',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textBlackColor,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AppText('150 ريال ',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textGreenColor,),
                          AppText('يتم دفع مبلغ التامين قبل دخول المزاد و هو ',size: MAsizes.textNormalSize,color: AppColors.textGreenColor,),
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
                            side: BorderSide(color: acceptPolicy?AppColors.mainColor:Colors.red),
                            value: acceptPolicy,
                            onChanged: (value){
                              setState(() {
                                acceptPolicy = value!;
                              });
                            },
                          ),
                          AppText('سياسة الخصوصية ',size: MAsizes.textNormalSize,color: AppColors.textGreenColor,),
                          AppText('اوفق علي ',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textGreenColor,),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if(acceptPolicy)
                        {

                        }
                      },
                      child: Container(
                          height: MAsizes.buttonHeight,
                          width: MAsizes.buttonBigWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                              color: AppColors.buttonGreenColor
                          ),
                          child: Center(child: AppText('الانتقال الي صفحة الدفع',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
