import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/delete.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_layout.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BuyerPersonalInformation extends StatelessWidget {
  const BuyerPersonalInformation({super.key});

  // Alert with single button.
  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "حقا تريد حذف الحساب",
      desc: "سيتم حذف الحساب و لكن يمكنك استعادته مع الدعم الفني",
      closeIcon: IconButton(
        icon: const Icon(Icons.close,color: Colors.redAccent),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      style: AlertStyle(titleStyle: TextStyle(
        color: AppColors.mainColor,
        fontFamily: 'El_Messiri',
        fontSize: MAsizes.textBetweenNormalAndBigSize,
        overflow: TextOverflow.ellipsis,
      )),
      buttons: [
        DialogButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(child: AppText('جاري حذف الحساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                backgroundColor: AppColors.mainColor,
                showCloseIcon: true,
              ),
            );
            final responseMap = await delete("${ApiPaths.deleteBuyerAccount}${sharedPreferences.getString('token')}", {}).onError((error, stackTrace) {
              return {
                'code':999
              };
            });
            if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
              userType = 'notSign';
              sharedPreferences.setString('userType', userType);
              if (context.mounted){
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MAbuyerLayout()));
              }
            } else if (responseMap['code'] == 999) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                    backgroundColor: AppColors.mainColor,
                    showCloseIcon: true,
                  ),
                );
              }
            }else{
              if (context.mounted){
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: AppText('فشل حذف الحساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                    backgroundColor: AppColors.mainColor,
                    showCloseIcon: true,
                  ),
                );
              }
            }
          },
          color: AppColors.mainColor,
          height: MAsizes.buttonHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "حذف الحساب",
              style: TextStyle(
                color: AppColors.textWhiteColor,
                fontFamily: 'El_Messiri',
                fontSize: MAsizes.textBetweenNormalAndBigSize,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('المعلومات الشخصية',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
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
                        AppText(sharedPreferences.getString('name')??'', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 1,
                            height: MAsizes.heightOfSmallEmptySpace/2,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const Icon(Icons.person),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
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
                        AppText(sharedPreferences.getString('email')??'', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 1,
                            height: MAsizes.heightOfSmallEmptySpace/2,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const Icon(Icons.email_outlined),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
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
                        AppText(sharedPreferences.getString('phone')??'', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 1,
                            height: MAsizes.heightOfSmallEmptySpace/2,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const Icon(Icons.phone),
                      ],
                    ),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _onAlertButtonPressed(context);
                },
                child: Container(
                    height: MAsizes.buttonHeight,
                    width: MAsizes.buttonBigWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                        color: AppColors.buttonGreenColor
                    ),
                    child: Center(child: AppText('حذف الحساب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
