import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_comment.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/model/comment_model.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_shopping_cart.dart';
import 'package:klnakhadem/view/mobile_view/app_view/selete_user_type.dart';
import 'package:toggle_switch/toggle_switch.dart';

class BuyerProductDetails extends StatefulWidget {
  const BuyerProductDetails({super.key,required this.product,required this.cubit});

  final Product product;
  final BuyerLayoutCubit cubit;

  @override
  State<BuyerProductDetails> createState() => _BuyerProductDetailsState();
}

class _BuyerProductDetailsState extends State<BuyerProductDetails> {

  TextEditingController quantityController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int currentImage = 0;
  String deliveryOrPickup = 'delivery';
  bool isLoading = false;
  List<Comment> comments = [];
  late Product product;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial data when widget is initialized
  }

  @override
  void dispose(){
    super.dispose();
    fetchData().ignore();
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
          actions: [
            IconButton(
              onPressed: (){
                if(userType=='buyer')
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BuyerShoppingCart(cubit: widget.cubit,)));
                }else{
                  if (context.mounted){
                    ScaffoldMessenger.of(context).clearMaterialBanners();
                    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                      content: AppText(
                        'رجاء تسجيل الدخول اولا',
                        color: AppColors.textWhiteColor,
                        size: MAsizes.textNormalSize,
                      ),
                      actions: [
                        TextButton(
                          child: AppText(
                            'حسنا',
                            color: AppColors.textWhiteColor,
                            size: MAsizes.textNormalSize,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).clearMaterialBanners();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType(),));
                          },
                        ),
                      ],
                      backgroundColor: AppColors.mainColor,

                    ));
                    Timer(const Duration(seconds: 3), () {
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                    });
                  }
                }
              },
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 8,
                      child: Center(
                        child: AppText(
                          BuyerLayoutCubit.cartNumber.toString(),
                          color: AppColors.textWhiteColor,
                          size: MAsizes.textNormalSize*0.55,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: SizedBox(
          height: MAsizes.screenH,
          width: MAsizes.screenW,
          child: isLoading? const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),) :SingleChildScrollView(
            child: Column(
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
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            scrollPhysics: const PageScrollPhysics(),
                            height: MAsizes.heightOfBigEmptySpace*2,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            initialPage: 0,
                            pauseAutoPlayOnTouch: true,
                            pauseAutoPlayOnManualNavigate: true,
                            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentImage = index;
                              });
                            },
                          ),
                          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                              SizedBox.expand(
                                  child: InteractiveViewer(
                                    child: Image(image: MemoryImage(product.images[itemIndex])),
                                  )),
                          itemCount: product.images.length,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for(int i=0;i<product.images.length;i++)...[
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.mainColor,
                                    radius: currentImage == i? 6:3,
                                  ),
                                ),
                              ]
                            ],
                          ),
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
                      initialLabelIndex: deliveryOrPickup=='delivery'?1:0,
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
                        if(i == 1){
                          deliveryOrPickup = 'delivery';
                        } else if (i == 0){
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
                Form(
                  key: formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: AppText('جاري اضافة المنتج في المفضلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                backgroundColor: AppColors.mainColor,
                                showCloseIcon: true,
                              ),
                            );
                            Map<String,dynamic> data = {
                              'user':sharedPreferences.getString('token'),
                              'product':product.id,
                            };
                            Map responseMap = await post(ApiPaths.addFavoriteProduct,data).onError((error, stackTrace) {
                              return {
                                'code':999
                              };
                            });
                            if((responseMap['code']>=200 && responseMap['code']<300)) {
                              if(mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('تم اضافة المنتج في المفضلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            } else {
                              if(mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('فشل اضافة المنتج في المفضلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.favorite),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppTextFormField(
                            validator: (value){
                              if(value == null || value.isEmpty)
                              {
                                return 'الكمية لا يمكن ان تكون فارغة';
                              }
                              else if(int.parse(value) == 0)
                              {
                                return 'الكمية لا يمكن ان تكون صفر';
                              }
                              else if(int.parse(value) > product.available)
                              {
                                return 'الكمية لا بمكن ان تكون اكبر من المتاح';
                              }
                              return null;
                            },
                            mycontroller: quantityController,
                            hintText: ' ادخال الكمية',
                            labelText: 'الكمية',
                            keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if(userType == 'notSign') {
                                if (context.mounted){
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                                    content: AppText(
                                      'رجاء تسجيل الدخول اولا',
                                      color: AppColors.textWhiteColor,
                                      size: MAsizes.textNormalSize,
                                    ),
                                    actions: [
                                      TextButton(
                                        child: AppText(
                                          'حسنا',
                                          color: AppColors.textWhiteColor,
                                          size: MAsizes.textNormalSize,
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).clearMaterialBanners();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType(),));
                                        },
                                      ),
                                    ],
                                    backgroundColor: AppColors.mainColor,

                                  ));
                                  Timer(const Duration(seconds: 3), () {
                                    ScaffoldMessenger.of(context).clearMaterialBanners();
                                  });
                                }
                              } else {
                                if(formKey.currentState!.validate())
                                {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: AppText('جاري اضافة المنتج الي السلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                      backgroundColor: AppColors.mainColor,
                                      showCloseIcon: true,
                                    ),
                                  );
                                  Map<String,dynamic> data = {
                                    'user':sharedPreferences.getString('token'),
                                    'seller':product.sellerID,
                                    'product':product.id,
                                    'quantity':int.parse(quantityController.text),
                                    'delivery': deliveryOrPickup == 'delivery' ? 0 : 1,
                                  };
                                  Map responseMap = await post(ApiPaths.shoppingCart,data).onError((error, stackTrace) {
                                    return {
                                      'code':999
                                    };
                                  });
                                  if((responseMap['code']>=200 && responseMap['code']<300)){
                                    quantityController.clear();
                                    await get("${ApiPaths.getShoppingCartNumber}${sharedPreferences.getString('token')}").then((value) {
                                      if(value['code']>=200 && value['code']<300) {
                                        BuyerLayoutCubit.cartNumber = value['body']['data'];
                                      }
                                      widget.cubit.fetchCartNumber();
                                    });
                                    if (context.mounted){
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(
                                              child: AppText(
                                                'تم اضافة المنتج بنجاح',
                                                color: AppColors.textWhiteColor,
                                                size: MAsizes.textNormalSize,
                                              )),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
                                  }else if (responseMap['code']==400&&responseMap['body']['message']=='') {
                                    quantityController.clear();
                                    if (context.mounted){
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('المنتج غير متوفر منه الكمية المطلوبة حاليا',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
                                  } else{
                                    quantityController.clear();
                                    if (context.mounted){
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: AppText('فشل اضافة المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                          backgroundColor: AppColors.mainColor,
                                          showCloseIcon: true,
                                        ),
                                      );
                                    }
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
                                child: Center(child: AppText('اضافة الي السلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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