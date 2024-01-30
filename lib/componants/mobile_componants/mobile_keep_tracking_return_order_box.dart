import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';

class MAkeepTrackingReturnOrderBox extends StatelessWidget {
  const MAkeepTrackingReturnOrderBox({super.key,required this.state});
  final String state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MAsizes.widthOfKeepTrackingOrderBox,
      height: MAsizes.heightOfKeepTrackingOrderBox,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                 flex: 1,
                 child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: Center(child: AppText('مراجعة الطلب', size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: Center(child: AppText('تم ارسال الطلب الاسترجاع', size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 3,
                    height: MAsizes.heightOfKeepTrackingOrderBox,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: state=='DONE'?AppColors.mainColor:AppColors.mainColor.withOpacity(0.20),
                          child: const Icon(Icons.done,color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: state=='delivered to seller'|| state=='DONE'?AppColors.mainColor:AppColors.mainColor.withOpacity(0.20),
                          child: const Icon(Icons.check_box,color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: state=='delivered to user' || state=='delivered to seller' || state=='DONE'?AppColors.mainColor:AppColors.mainColor.withOpacity(0.20),
                          child: const Icon(Icons.numbers,color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: state=='delivered to user' || state=='delivered to seller' || state=='DONE'?AppColors.mainColor:AppColors.mainColor.withOpacity(0.20),
                          child: const Icon(Icons.handshake,color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(child: AppText('تم استلام المبلغ بنجاح', size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: Center(child: AppText('تسليم الطلب و استلام الرمز', size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
