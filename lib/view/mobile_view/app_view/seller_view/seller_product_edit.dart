import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/put.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_comment.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/model/comment_model.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SellerProductEdit extends StatefulWidget {
  const SellerProductEdit({super.key,required this.product});

  final Product product;

  @override
  State<SellerProductEdit> createState() => _SellerProductEditState();
}

class _SellerProductEditState extends State<SellerProductEdit> {


  late TextEditingController quantityController;
  late TextEditingController productNameController;
  late TextEditingController productDetailsController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _pageController = PageController(initialPage: 0);
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int currentImage = 0;
  String deliveryOrPickup = 'delivery';
  bool isLoading = false;
  List<Comment> comments = [];
  late Product product;

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "بيانات المنتج المتاح تعديلها",
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
        content: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
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
                padding: const EdgeInsets.all(8.0),
                child: AppTextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty)
                    {
                      return 'الكمية لا يمكن ان تكون فارغة';
                    }
                    else if(int.parse(value) < 0)
                    {
                      return 'الكمية لا يمكن ان اقل من صفر';
                    }
                    return null;
                  },
                  mycontroller: quantityController,
                  hintText: 'ادخال الكمية المتاحة',
                  labelText: 'الكمية المتاحة',
                  keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                ),
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              if(formKey.currentState!.validate())
              {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: AppText('جاري تحديث بيانات المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                    backgroundColor: AppColors.mainColor,
                    showCloseIcon: true,
                  ),
                );
                Map<String,dynamic> data = {
                  'quantity':product.sold+int.parse(quantityController.text),
                  'title':productNameController.text,
                  'description':productDetailsController.text,
                };
                Map responseMap = await put('${ApiPaths.editProduct}${product.id}',data).onError((error, stackTrace) {
                  return {
                    'code':999
                  };
                });
                if((responseMap['code']>=200 && responseMap['code']<300)){
                  setState(() {
                    product.available = product.sold+int.parse(quantityController.text);
                  });
                  if (context.mounted){
                    ScaffoldMessenger.of(context)
                        .clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                            child: AppText(
                              'تم تحديث بيانات المنتج',
                              color: AppColors.textWhiteColor,
                              size: MAsizes.textNormalSize,
                            )),
                        backgroundColor: AppColors.mainColor,
                        showCloseIcon: true,
                      ),
                    );
                    Navigator.pop(context);
                  }
                }else{
                  quantityController.text = product.available.toString();
                  if (context.mounted){
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: AppText('فشل تحديث بيانات المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                        backgroundColor: AppColors.mainColor,
                        showCloseIcon: true,
                      ),
                    );
                    Navigator.pop(context);
                  }
                }
              }
            },
            color: AppColors.buttonGreenColor,
            height: MAsizes.buttonHeight,
            width: MAsizes.buttonBigWidth,
            radius: BorderRadius.circular(MAsizes.buttonBorderRadius),
            child: Center(child: AppText('تعديل بيانات المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
          )
        ]).show();
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      if(mounted){
        setState(() {
          isLoading = true;
        });
      }

      final responseMap = await get("${ApiPaths.getComment}${widget.product.id}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        for(int i = 0;i<responseData["data"].length;i++) {
          comments.add(createComment(responseData["data"][i]));
        }

        if(widget.product.images.isEmpty) {
          final responseMap2 = await get("${ApiPaths.getProductDetails}${widget.product.id}").onError((error, stackTrace) {
            return {
              'code':999
            };
          });

          if (responseMap2['code'] >= 200 && responseMap2['code'] < 300) {
            final Map<String, dynamic> responseData2 = responseMap2['body'];
            product = createProduct(responseData2["data"]);


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
          } else {
          }
        } else {
          product = widget.product;
        }

        if(mounted){
          setState(() {
            isLoading = false;
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
      } else {
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    quantityController = TextEditingController(text: product.available.toString());
    productNameController = TextEditingController(text: product.title);
    productDetailsController = TextEditingController(text: product.description);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('تفاصيل منتج',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: isLoading? const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),) :Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                            color: AppColors.offWhiteBoxColor
                        ),
                        height: MAsizes.heightOfBigEmptySpace*2,
                        width: MAsizes.screenW,
                        child: PageView.builder(
                          physics: const PageScrollPhysics(),
                          itemCount: product.images.length,
                          controller: _pageController,
                          scrollBehavior: MouseEnabledScrollBehavior(),
                          itemBuilder: (context, index) {
                            return SizedBox.expand(
                                child: InteractiveViewer(
                                  child: Image(image: MemoryImage(product.images[index])),
                                ));
                          },
                          onPageChanged: (event){
                            setState(() {
                              currentImage = event.toInt();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for(int i=0;i<product.images.length;i++)...[
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.mainColor,
                                  radius: currentImage == i? 8:4,
                                  child: MaterialButton(
                                    onPressed: (){
                                      setState(() {
                                        currentImage = i;
                                      });
                                      _pageController.animateToPage(i,duration: _kDuration, curve: _kCurve);
                                    },
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(product.title,size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(product.marketName,size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(product.marketAddress,size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(product.description,size: MAsizes.textNormalSize, color: AppColors.textBlackColor,max: 10),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppText("${product.price}",size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      AppText('السعر ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppText('${product.available}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      AppText('الكمية ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
                if(product.deliveryOrPickup=='both')Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: ToggleSwitch(
                      minWidth: MAsizes.buttonNormalWidth,
                      initialLabelIndex: deliveryOrPickup=='delivery'?0:1,
                      cornerRadius: MAsizes.buttonBorderRadius,
                      activeFgColor: AppColors.textWhiteColor,
                      inactiveBgColor: AppColors.offWhiteBoxColor,
                      inactiveFgColor: AppColors.textGreenColor,
                      totalSwitches: 2,
                      customTextStyles: const [TextStyle(
                        fontFamily: 'El_Messiri',
                      ),TextStyle(
                        fontFamily: 'El_Messiri',
                      )],
                      labels: const ['استلام', 'توصيل'],
                      activeBgColors: const [[AppColors.mainColor],[AppColors.mainColor]],
                      onToggle: (i){
                        if(i == 0){
                          deliveryOrPickup = 'delivery';
                        } else if (i == 1){
                          deliveryOrPickup = 'pickup';
                        }
                      },
                    ),
                  ),
                ),
                if(product.deliveryOrPickup!='both')Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Container(
                      width: MAsizes.buttonNormalWidth,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(child: AppText(product.deliveryOrPickup=='pickup'?'استلام':'توصيل',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor)),
                      ),
                    ),
                  ),
                ),
                if(product.deliveryOrPickup!='pickup')Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppText(product.deliveryPrice.toString(),size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      AppText('سعر التوصيل ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: RatingBar.builder(
                      initialRating: product.rating,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            AppText('التعليقات',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          ],
                        ),
                      ),
                      Container(
                        height: MAsizes.screenH/2,
                        width: MAsizes.screenW,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                            border: Border.all(
                                color: AppColors.offWhiteBoxColor,
                                width: 2
                            )
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.offWhiteBoxColor,
                                borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AppText(comments[index].comment,size: MAsizes.textNormalSize, color: AppColors.textBlackColor,max: 3),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AppText(comments[index].user,size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                                        RatingBar.builder(
                                          initialRating: comments[index].rate,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ignoreGestures: true,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount: comments.length,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MaterialButton(
                    onPressed: (){
                      _onAlertWithCustomContentPressed(context);
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonBigWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: AppColors.buttonGreenColor
                        ),
                        child: Center(child: AppText('تعديل بعض بيانات المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MouseEnabledScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}