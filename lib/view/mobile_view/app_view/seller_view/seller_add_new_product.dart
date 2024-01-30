import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_review_product_before_publish.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SellerAddNewProduct extends StatefulWidget {
  const SellerAddNewProduct({super.key});

  @override
  State<SellerAddNewProduct> createState() => _SellerAddNewProductState();
}

class _SellerAddNewProductState extends State<SellerAddNewProduct> {
  TextEditingController productNameController = TextEditingController();

  TextEditingController productDetailsController = TextEditingController();

  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();

  int numbersOfOptions = 0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool newProduct = true;

  bool hasReturnOption = false;

  String deliveryOrPickup = 'both';

  late String dropdownValueCategory;
  late String dropdownValueIDCategory;

  late String dropdownValueSubCategory;
  late String dropdownValueIDSubCategory;

  int numberOfPhotos =0;

  bool loading = true;

  bool getSubCategoriesLoading = true;

  List<bool> first = [true,true,true,true,true];

  final List<File?> images = [null,null,null,null,null];

  Map responseMap = {};
  List<String> category = [];
  List<String> categoryID = [];

  Map responseMap2 = {};
  List<String> subCategory = [];
  List<String> subCategoryID = [];

  double returnedPrice = 0;

  double taxesPrice = 0;
  double priceOutTaxes = 0;

  late final double taxes;
  late final double zekaTaxes;
  late final double amolaFactor;

  Future<void> _pickImage(ImageSource source, int i) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source,imageQuality: 20);

    setState(() {
      if (pickedImage != null) {
        images[i] = File(pickedImage.path);
      } else {
        images[i] = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if(loading)
    {
      get(ApiPaths.getVatAndZekaAndAmolaValues).then((value){
        if((value['code']>=200 && value['code']<300))
        {
          taxes = value['body']['vat'];
          zekaTaxes = value['body']['zeka'];
          amolaFactor = value['body']['commission']*1.0;
          get(ApiPaths.getAllCategories).then((value){
            responseMap=value;
            if((responseMap['code']>=200 && responseMap['code']<300))
            {
              for(int i=0;i<responseMap['body']['results'];i++)
              {
                category.add(responseMap['body']['data'][i]['name']);
                categoryID.add(responseMap['body']['data'][i]['_id']);
              }
              dropdownValueCategory = category.first;
              dropdownValueIDCategory = categoryID.first;

              get(ApiPaths.getAllSubCategories+dropdownValueIDCategory).then((value){

                responseMap2=value;
                if((responseMap2['code']>=200 && responseMap2['code']<300))
                {
                  for(int i=0;i<responseMap2['body']['results'];i++)
                  {
                    subCategory.add(responseMap2['body']['data'][i]['name']);
                    subCategoryID.add(responseMap2['body']['data'][i]['_id']);
                  }
                  dropdownValueSubCategory = subCategory.first;
                  dropdownValueIDSubCategory = subCategoryID.first;

                  setState(() {
                    loading = false;
                    getSubCategoriesLoading = false;
                  });
                }
              }).onError((error, stackTrace) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                      backgroundColor: AppColors.mainColor,
                      showCloseIcon: true,
                    ),
                  );
                }
              });
            }
          }).onError((error, stackTrace) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                  backgroundColor: AppColors.mainColor,
                  showCloseIcon: true,
                ),
              );
            }
          });
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
              backgroundColor: AppColors.mainColor,
              showCloseIcon: true,
            ),
          );
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('اضافة منتج',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: loading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                        value: dropdownValueCategory,
                        icon: const Icon(Icons.arrow_downward),
                        style: const TextStyle(color: AppColors.mainColor),
                        underline: Container(
                          height: 2,
                          color: AppColors.mainColor,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValueCategory = value!;
                            dropdownValueIDCategory = categoryID[category.indexOf(value)];
                            getSubCategoriesLoading = true;
                          });
                          subCategory.clear();
                          subCategoryID.clear();

                          get(ApiPaths.getAllSubCategories+dropdownValueIDCategory).then((value){
                            responseMap2=value;
                            if((responseMap2['code']>=200 && responseMap2['code']<300))
                            {
                              for(int i=0;i<responseMap2['body']['results'];i++)
                              {
                                subCategory.add(responseMap2['body']['data'][i]['name']);
                                subCategoryID.add(responseMap2['body']['data'][i]['_id']);
                              }
                              dropdownValueSubCategory = subCategory.first;
                              dropdownValueIDSubCategory = subCategoryID.first;

                              setState(() {
                                getSubCategoriesLoading = false;
                              });
                            }
                          }).onError((error, stackTrace) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          });
                        },
                        items: category.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    getSubCategoriesLoading?const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(color: AppColors.mainColor,),
                    ):Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                        value: dropdownValueSubCategory,
                        icon: const Icon(Icons.arrow_downward),
                        style: const TextStyle(color: AppColors.mainColor),
                        underline: Container(
                          height: 2,
                          color: AppColors.mainColor,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValueSubCategory = value!;
                            dropdownValueIDSubCategory = subCategoryID[subCategory.indexOf(value)];
                          });
                        },
                        items: subCategory.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty || value.characters == Characters(' '))
                          {
                            return 'اسم المنتج لا يمكن ان يكون فارغ';
                          }
                          return null;
                        },
                        mycontroller: productNameController,
                        hintText: 'اسم المنتج',
                        labelText: 'اسم المنتج',
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextFormField(
                        minline: 10,
                        maxline: 25,
                        validator: (value){
                          if(value == null || value.isEmpty || value.characters == Characters(' '))
                          {
                            return 'تفاصيل المنتج لا يمكن ان تكون فارغة';
                          }
                          return null;
                        },
                        mycontroller: productDetailsController,
                        hintText: 'تفاصيل المنتج',
                        labelText: 'تفاصيل المنتج',
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleSwitch(
                            minWidth: MAsizes.buttonNormalWidth,
                            initialLabelIndex: newProduct?0:1,
                            cornerRadius: MAsizes.buttonBorderRadius,
                            activeFgColor: AppColors.textWhiteColor,
                            inactiveBgColor: AppColors.offWhiteBoxColor,
                            inactiveFgColor: AppColors.textGreenColor,
                            totalSwitches: 2,
                            customTextStyles: [TextStyle(
                                fontFamily: 'El_Messiri',
                                fontSize: MAsizes.textNormalSize*2/3
                            ),TextStyle(
                                fontFamily: 'El_Messiri',
                                fontSize: MAsizes.textNormalSize*2/3
                            )],
                            labels: const ['جديد', 'مستخدم'],
                            icons: const [Icons.gpp_good_outlined, Icons.gpp_bad_outlined],
                            activeBgColors: const [[AppColors.mainColor],[AppColors.mainColor]],
                            onToggle: (i){
                              if(i == 0){
                                newProduct = true;
                              } else if (i == 1){
                                newProduct = false;
                              }
                            },
                          ),
                          SizedBox(
                            width: MAsizes.widthOfSmallEmptySpace,
                          ),
                          AppText('حالة المنتج',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleSwitch(
                            minWidth: MAsizes.buttonNormalWidth,
                            initialLabelIndex: hasReturnOption?1:0,
                            cornerRadius: MAsizes.buttonBorderRadius,
                            activeFgColor: AppColors.textWhiteColor,
                            inactiveBgColor: AppColors.offWhiteBoxColor,
                            inactiveFgColor: AppColors.textGreenColor,
                            totalSwitches: 2,
                            customTextStyles: [TextStyle(
                                fontFamily: 'El_Messiri',
                                fontSize: MAsizes.textNormalSize*2/3
                            ),TextStyle(
                                fontFamily: 'El_Messiri',
                                fontSize: MAsizes.textNormalSize*2/3
                            )],
                            labels: const ['لا', 'نعم'],
                            icons: const [Icons.gpp_good_outlined, Icons.gpp_bad_outlined],
                            activeBgColors: const [[AppColors.mainColor],[AppColors.mainColor]],
                            onToggle: (i){
                              if(i == 0){
                                hasReturnOption = false;
                              } else if (i == 1){
                                hasReturnOption = true;
                              }
                            },
                          ),
                          SizedBox(
                            width: MAsizes.widthOfSmallEmptySpace,
                          ),
                          AppText('متاح ارجاع المنتج',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: ToggleSwitch(
                          minWidth: MAsizes.buttonNormalWidth,
                          initialLabelIndex: deliveryOrPickup=='both'?0:deliveryOrPickup=='delivery'?2:1,
                          cornerRadius: MAsizes.buttonBorderRadius,
                          activeFgColor: AppColors.textWhiteColor,
                          inactiveBgColor: AppColors.offWhiteBoxColor,
                          inactiveFgColor: AppColors.textGreenColor,
                          totalSwitches: 3,
                          customTextStyles: [TextStyle(
                            fontFamily: 'El_Messiri',
                              fontSize: MAsizes.textNormalSize*2/3
                          ),TextStyle(
                            fontFamily: 'El_Messiri',
                              fontSize: MAsizes.textNormalSize*2/3
                          ),TextStyle(
                            fontFamily: 'El_Messiri',
                              fontSize: MAsizes.textNormalSize*2/3
                          )],
                          labels: const ['كلاهما', 'استلام', 'توصيل'],
                          activeBgColors: const [[AppColors.mainColor],[AppColors.mainColor],[AppColors.mainColor]],
                          onToggle: (i){
                            if(i == 0){
                              setState(() {
                                deliveryOrPickup = 'both';
                              });
                            } else if (i == 1){
                              setState(() {
                                deliveryController.clear();
                                deliveryOrPickup = 'pickup';
                              });
                            } else if (i == 2){
                              setState(() {
                                deliveryOrPickup = 'delivery';
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppTextFormField(

                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'الكمية لا يمكن ان يكون فارغ';
                                }
                                return null;
                              },
                              mycontroller: quantityController,
                              hintText: 'الكمية',
                              labelText: 'الكمية',
                              keyboardType: const TextInputType.numberWithOptions(decimal: false,signed: false),
                            ),
                          ),
                          if(deliveryOrPickup == 'delivery' || deliveryOrPickup == 'both')SizedBox(
                            width: MAsizes.widthOfSmallEmptySpace/2,
                          ),
                          if(deliveryOrPickup == 'delivery' || deliveryOrPickup == 'both')Expanded(
                            flex: 1,
                            child: AppTextFormField(

                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'سعر التوصيل لا يمكن ان يكون فارغ';
                                }
                                return null;
                              },
                              mycontroller: deliveryController,
                              hintText: 'سعر التوصيل',
                              labelText: 'سعر التوصيل',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                AppText(returnedPrice.toStringAsFixed(2),size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                AppText('السعر المستحق للتاجر : ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MAsizes.widthOfSmallEmptySpace/2,
                          ),
                          Expanded(
                            flex: 1,
                            child: AppTextFormField(
                              onChanged: (value) {
                                if(value != null && value.isNotEmpty) {
                                  setState(() {
                                    double total = int.parse(value) * taxes + int.parse(value);
                                    double zeka = total * zekaTaxes;
                                    double amola = zeka * amolaFactor;
                                    returnedPrice = int.parse(value) - amola;
                                    priceOutTaxes = returnedPrice / (1+taxes);
                                    taxesPrice = returnedPrice - priceOutTaxes;
                                  });
                                } else {
                                  setState(() {
                                    returnedPrice = 0;
                                    priceOutTaxes = 0;
                                    taxesPrice = 0;
                                  });
                                }
                              },
                              validator: (value){
                                if(value == null || value.isEmpty || value.characters == Characters(' '))
                                {
                                  return 'السعر لا يمكن ان يكون فارغ';
                                }
                                return null;
                              },
                              mycontroller: priceController,
                              hintText: 'السعر',
                              labelText: 'السعر',
                              keyboardType: const TextInputType.numberWithOptions(decimal: false,signed: false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*if(sharedPreferences.getBool('registered')!)Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppText('السعر بدون الضريبة : ''${priceOutTaxes.toStringAsFixed(2)}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          ),
                          SizedBox(
                            width: MAsizes.widthOfSmallEmptySpace/2,
                          ),
                          Expanded(
                            flex: 1,
                            child: AppText('السعر الضريبة : ''${taxesPrice.toStringAsFixed(2)}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          ),
                        ],
                      ),
                    ),*/
                    AppText('اضافة صورة للمنتج او الحرفة',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for(int i=0;i<5;i++)...[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if(images[i] != null) Expanded(
                                    flex: 1,
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          images[i] = null;
                                          numberOfPhotos-=1;
                                          first[i]=true;
                                        });
                                      },
                                      child: const Center(child: Icon(Icons.cancel_outlined,color: Colors.red)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: images[i] != null ? Image.file(images[i]!) : const SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: MaterialButton(
                                      onPressed: (){
                                        _pickImage(ImageSource.gallery,i);
                                        if(first[i]){
                                          numberOfPhotos+=1;
                                          first[i]=false;
                                        }
                                      },
                                      child: Container(
                                          height: MAsizes.buttonHeight,
                                          /*width: MAsizes.buttonBigWidth,*/
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                              color: AppColors.buttonGreenColor
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(child: AppText('المعرض',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          )
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: MaterialButton(
                                      onPressed: (){
                                        _pickImage(ImageSource.camera,i);
                                        if(first[i]){
                                          numberOfPhotos+=1;
                                          first[i]=false;
                                        }
                                      },
                                      child: Container(
                                          height: MAsizes.buttonHeight,
                                          /*width: MAsizes.buttonBigWidth,*/
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                              color: AppColors.buttonGreenColor
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(child: AppText('الكاميرا',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()&&numberOfPhotos>0) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SellerReviewProductBeforePublish(
                              productName: productNameController.text,
                              category: dropdownValueCategory,
                              subCategory: dropdownValueSubCategory,
                              newProduct: newProduct,
                              hasReturnOption: hasReturnOption,
                              deliveryOrPickup: deliveryOrPickup,
                              productDetails: productDetailsController.text,
                              numberOfPhotos: numberOfPhotos,
                              price: int.parse(priceController.text),
                              quantity: int.parse(quantityController.text),
                              images: images,
                              categoryID: dropdownValueIDCategory,
                              subCategoryID: dropdownValueIDSubCategory,
                              deliveryPrice: deliveryOrPickup != 'pickup'?int.parse(deliveryController.text):null
                            )));
                          }
                        },
                        child: Container(
                            height: MAsizes.buttonHeight,
                            width: MAsizes.screenW,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                color: numberOfPhotos>0?AppColors.buttonGreenColor:Colors.grey
                            ),
                            child: Center(child: AppText('اضافة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
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
