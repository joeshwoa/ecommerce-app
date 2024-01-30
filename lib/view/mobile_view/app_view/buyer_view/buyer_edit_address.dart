import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/put.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/model/address_model.dart';

class BuyerEditAddress extends StatefulWidget {
  const BuyerEditAddress({super.key,required this.address});
  final Address address;

  @override
  State<BuyerEditAddress> createState() => _BuyerEditAddressState();
}

class _BuyerEditAddressState extends State<BuyerEditAddress> {
  late TextEditingController cityController;

  late TextEditingController areaController;

  late TextEditingController supAreaController;

  late TextEditingController streetController;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController(text: widget.address.city);
    areaController = TextEditingController(text: widget.address.area);
    supAreaController = TextEditingController(text: widget.address.supArea);
    streetController = TextEditingController(text: widget.address.street);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('تعديل العنوان',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
                            if(!editMode) {
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
                            } else {
                              setState(() {
                                editMode = false;
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('وضع التعديل غير فعال',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              });
                            }
                          },
                          child: Container(
                              height: MAsizes.buttonHeight,
                              width: MAsizes.buttonNormalWidth*1.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                  color: editMode?AppColors.buttonGreenColor:AppColors.offWhiteBoxColor
                              ),
                              child: Center(child: AppText('وضع التعديل غير فعال',color: !editMode?AppColors.buttonGreenColor:AppColors.offWhiteBoxColor,size: MAsizes.textNormalSize*0.8,))
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
                        if(formKey.currentState!.validate() && editMode)
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
                          Map responseMap = await put('${ApiPaths.editAddress}${widget.address.id}',data).onError((error, stackTrace) {
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
                              Navigator.pop(context);
                            }
                          }
                        } else if(!editMode) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('وضع التعديل غير فعال',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                        }
                      },
                      child: Container(
                          height: MAsizes.buttonHeight,
                          width: MAsizes.buttonBigWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                              color: editMode?AppColors.buttonGreenColor:AppColors.offWhiteBoxColor
                          ),
                          child: Center(child: AppText('حفظ التغييرات',color: !editMode?AppColors.buttonGreenColor:AppColors.offWhiteBoxColor,size: MAsizes.textNormalSize,))
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