import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';

class MAMoneyTransformationBox extends StatelessWidget {
  const MAMoneyTransformationBox({super.key,required this.year,required this.month,required this.day,required this.money,required this.plus});
  final int year;
  final int month;
  final int day;
  final double money;
  final bool plus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
              AppText('$year/$month/$day', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
              const Expanded(child: SizedBox()),
              AppText('ريال', size: MAsizes.textNormalSize, color: plus?AppColors.textGreenColor:Colors.red),
              AppText('$money', size: MAsizes.textNormalSize, color: plus?AppColors.textGreenColor:Colors.red),
              /*AppText(plus?'+':'-', size: MAsizes.textNormalSize, color: plus?AppColors.textGreenColor:Colors.red),*/
            ],
          ),
        ),
      ),
    );
  }
}
