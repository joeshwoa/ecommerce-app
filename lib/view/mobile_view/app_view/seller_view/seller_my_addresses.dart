import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/put.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';

class SellerMyAddresses extends StatefulWidget {
  const SellerMyAddresses({super.key});

  @override
  State<SellerMyAddresses> createState() => _SellerMyAddressesState();
}

class _SellerMyAddressesState extends State<SellerMyAddresses> {

  TextEditingController cityController = TextEditingController(text: sharedPreferences.getString('city'));

  TextEditingController areaController = TextEditingController(text: sharedPreferences.getString('area'));

  TextEditingController supAreaController = TextEditingController(text: sharedPreferences.getString('supArea'));

  TextEditingController streetController = TextEditingController(text: sharedPreferences.getString('street'));

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('عنواني',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
          leading: IconButton(
            onPressed: (){
              ScaffoldMessenger.of(context).clearSnackBars();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: (){
                            setState(() {
                              editMode = true;
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Center(child: AppText('وضع التعديل فعال',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            });
                          },
                          child: Container(
                              height: MAsizes.buttonHeight,
                              width: MAsizes.buttonNormalWidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                  color: editMode?AppColors.buttonGreenColor:AppColors.offWhiteBoxColor
                              ),
                              child: Center(child: AppText('تعديل',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                          ),
                        ),
                        AppText('لتعديل بياناتك اضغط زر التعديل',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 1,
                      width: MAsizes.widthOfWalletContainer,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                      enabled: editMode,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                      enabled: editMode,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                      enabled: editMode,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                      enabled: editMode,
                    ),
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate())
                        {
                          setState(() {
                            editMode = false;
                          });
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('جاري تحديث العنوان',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Map<String,dynamic> data = {
                            'town':cityController.text,
                            'region':areaController.text,
                            'area':supAreaController.text,
                            'street':streetController.text,
                          };
                          Map responseMap = await put('${ApiPaths.editMarketData}${sharedPreferences.getString('marketID')}',data).onError((error, stackTrace) {
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
                                        'تم تحديث العنوان',
                                        color: AppColors.textWhiteColor,
                                        size: MAsizes.textNormalSize,
                                      )),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                              Timer(const Duration(seconds: 1), () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                Navigator.pop(context);
                              });
                            }
                          }else{
                            if (context.mounted){
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('فشل تحديث العنوان حاول مرة اخري',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                              color: editMode?AppColors.buttonGreenColor:AppColors.offWhiteBoxColor
                          ),
                          child: Center(child: AppText('حفظ التغييرات',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}