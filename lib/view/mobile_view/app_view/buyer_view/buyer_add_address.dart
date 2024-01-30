import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_address_added.dart';

class BuyerAddAddress extends StatefulWidget {
  const BuyerAddAddress({super.key});

  @override
  State<BuyerAddAddress> createState() => _BuyerAddAddressState();
}

class _BuyerAddAddressState extends State<BuyerAddAddress> {
  TextEditingController cityController = TextEditingController();

  TextEditingController areaController = TextEditingController();

  TextEditingController supAreaController = TextEditingController();

  TextEditingController streetController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String placeName = 'home';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('اضافة عنوان',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          MaterialButton(
                            onPressed: (){
                              setState(() {
                                placeName = 'other';
                              });
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(
                                color: placeName == 'other'?AppColors.buttonGreenColor:AppColors.buttonWhiteColor,
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                border: Border.all(
                                  color: AppColors.buttonGreenColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: AppText('اخري',size: MAsizes.textNormalSize, color: AppColors.textBlackColor)),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: (){
                              setState(() {
                                placeName = 'work';
                              });
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(
                                color: placeName == 'work'?AppColors.buttonGreenColor:AppColors.buttonWhiteColor,
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                border: Border.all(
                                  color: AppColors.buttonGreenColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: AppText('عمل',size: MAsizes.textNormalSize, color: AppColors.textBlackColor)),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: (){
                              setState(() {
                                placeName = 'home';
                              });
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(
                                color: placeName == 'home'?AppColors.buttonGreenColor:AppColors.buttonWhiteColor,
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                border: Border.all(
                                  color: AppColors.buttonGreenColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: AppText('منزل',size: MAsizes.textNormalSize, color: AppColors.textBlackColor)),
                              ),
                            ),
                          ),
                          AppText('اختر اسم المكان',size: MAsizes.textNormalSize, color: AppColors.textBlackColor)
                        ],
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty || value.characters == Characters(' '))
                          {
                            return 'اسم المدينة لا يمكن ان يكون فارغ';
                          }
                          return null;
                        },
                        mycontroller: cityController,
                        hintText: 'المدينة',
                        labelText: 'المدينة',
                        icon: Icons.location_city,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty || value.characters == Characters(' '))
                          {
                            return 'اسم المنطقة لا يمكن ان يكون فارغ';
                          }
                          return null;
                        },
                        mycontroller: areaController,
                        hintText: 'المنطقة',
                        labelText: 'المنطقة',
                        icon: Icons.location_city,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty || value.characters == Characters(' '))
                          {
                            return 'اسم الحي لا يمكن ان يكون فارغ';
                          }
                          return null;
                        },
                        mycontroller: supAreaController,
                        hintText: 'الحي',
                        labelText: 'الحي',
                        icon: Icons.location_city,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty || value.characters == Characters(' '))
                          {
                            return 'اسم الشارع لا يمكن ان يكون فارغ';
                          }
                          return null;
                        },
                        mycontroller: streetController,
                        hintText: 'الشارع',
                        labelText: 'الشارع',
                        icon: Icons.location_city,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if(formKey.currentState!.validate())
                          {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: AppText('جاري اضافة العنوان',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                backgroundColor: AppColors.mainColor,
                                showCloseIcon: true,
                              ),
                            );
                            Map<String,dynamic> data = {
                              'town' : cityController.text,
                              'region' : areaController.text,
                              'area' : supAreaController.text,
                              'street' : streetController.text,
                              'user' : sharedPreferences.getString('token'),
                            };
                            Map responseMap = await post(ApiPaths.addAddress,data).onError((error, stackTrace) {
                              return {
                                'code':999
                              };
                            });
                            if((responseMap['code']>=200 && responseMap['code']<300)){
                              if (context.mounted){
                                ScaffoldMessenger.of(context)
                                    .clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                        child: AppText(
                                          'تم اضافة العنوان بنجاح',
                                          color: AppColors.textWhiteColor,
                                          size: MAsizes.textNormalSize,
                                        )),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                                Timer(const Duration(seconds: 1), () {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  while (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const BuyerAddressAdded(),));
                                });
                              }
                            } else if (responseMap['code'] == 999) {
                              if (mounted) {
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
                                    content: Center(child: AppText('فشل اضافة العنوان',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Container(
                            height: MAsizes.buttonHeight,
                            width: MAsizes.buttonBigWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                color: AppColors.buttonGreenColor
                            ),
                            child: Center(child: AppText('اضافة العنوان',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}