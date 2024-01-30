import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_edit_address.dart';

class MAaddressBox extends StatelessWidget {
  const MAaddressBox({super.key,required this.address});
  final Address address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: MaterialButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerEditAddress(address: address),));
        },
        child: Container(
          height: MAsizes.buttonHeight*1.5,
          width: MAsizes.screenW,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
              color: AppColors.offWhiteBoxColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(address.city, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    AppText(' : ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    AppText('المدينة', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(address.area, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    AppText(' : ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    AppText('المنطقة ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
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
