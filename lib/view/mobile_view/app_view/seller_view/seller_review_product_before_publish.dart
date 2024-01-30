import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/send_and_resive_image_methods/encode.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_product_published.dart';

class SellerReviewProductBeforePublish extends StatefulWidget {
  const SellerReviewProductBeforePublish({super.key,required this.hasReturnOption,required this.newProduct,required this.category,required this.deliveryOrPickup,required this.numberOfPhotos,required this.productDetails,required this.productName,required this.images,required this.price,required this.quantity,required this.categoryID,this.deliveryPrice,required this.subCategory,required this.subCategoryID});
  final String category;
  final String categoryID;
  final String subCategory;
  final String subCategoryID;
  final String productName;
  final String productDetails;
  final bool newProduct;
  final String deliveryOrPickup;
  final bool hasReturnOption;
  final int numberOfPhotos;
  final List<File?> images;
  final int quantity;
  final int price;
  final int? deliveryPrice;

  @override
  State<SellerReviewProductBeforePublish> createState() => _SellerReviewProductBeforePublishState();
}

class _SellerReviewProductBeforePublishState extends State<SellerReviewProductBeforePublish> {

  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('مراجعة المنتج قبل النشر',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('فئة المنتج او الحرفة',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('${widget.category} , ${widget.subCategory}',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('اسم المنتج او الحرفة',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText(widget.productName,size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('وصف المنتج او الحرفة',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText(widget.productDetails,size: MAsizes.textNormalSize, color: AppColors.textBlackColor,max: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('حالة المنتج او الحرفة',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText(widget.newProduct?'جديد':'مستعمل',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('توصيل او استلام',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText(widget.deliveryOrPickup=='both'?'كلاهما':widget.deliveryOrPickup=='delivery'?'توصيل':'استلام',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('هل متاح ارجاع المنتج؟',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText(widget.hasReturnOption?'نعم':'لا',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('سعر المنتج',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText("${widget.price}",size: MAsizes.textNormalSize, color: AppColors.textBlackColor,max: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('كمية المنتج',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText("${widget.quantity}",size: MAsizes.textNormalSize, color: AppColors.textBlackColor,max: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText('عدد الصور',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AppText("${widget.numberOfPhotos}",size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if(!sending) {
                        setState(() {
                          sending = true;
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: AppText('جاري اضافة المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                        String? token = sharedPreferences.getString('token');
                        String? marketID = sharedPreferences.getString('marketID');
                        List<String> imagesEncoded = [];
                        for(int i=0;i<widget.images.length;i++){
                          if(widget.images[i] != null) {
                            String imageEncoded = await encode(widget.images[i]!);
                            imagesEncoded.add(imageEncoded);
                          }
                        }
                        Map<String,dynamic> data = {
                          'title':widget.productName,
                          'description':widget.productDetails,
                          'quantity':widget.quantity,
                          'price':widget.price,
                          'imageCover':imagesEncoded.first,
                          'images':imagesEncoded,
                          'category':widget.categoryID,
                          'subCategory':widget.subCategoryID,
                          'seller':token,
                          'market':marketID,
                          'status': widget.newProduct,
                          'canReturn': widget.hasReturnOption,
                          'delivery': widget.deliveryOrPickup == 'delivery' ? 0 : (widget.deliveryOrPickup == 'pickup' ? 1 : 2),
                          if(widget.deliveryOrPickup == 'delivery'||widget.deliveryOrPickup == 'both')'deliveryPrice': widget.deliveryPrice,
                        };
                        Map responseMap = await post(ApiPaths.addProducts,data).onError((error, stackTrace) {
                          return {
                            'code':999
                          };
                        });


                        if((responseMap['code']>=200 && responseMap['code']<300)){
                          if (context.mounted){
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: AppText('تم اضافة المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                backgroundColor: AppColors.mainColor,
                                showCloseIcon: true,
                              ),
                            );
                            Timer(const Duration(seconds: 1), () {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SellerProductPublished()));
                            });
                          }
                          setState(() {
                            sending = false;
                          });
                        }else{
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
                          setState(() {
                            sending = false;
                          });
                        }
                      }
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.screenW,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: sending?Colors.grey:AppColors.buttonGreenColor
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
    );
  }
}
