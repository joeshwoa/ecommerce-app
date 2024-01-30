import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/send_and_resive_image_methods/decode.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/temp_photos_fo_null_safe.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_add_new_auction.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_add_new_product.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_complete_information.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_dilevered_seller_order.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_dilevered_user_order.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_done_order.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_return_product_order.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {

  late int deliveredSeller, deliveredUser, done, returnProduct;
  bool isLoading = false;// Flag to track if an API call is in progress

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

      final responseMap = await get("${ApiPaths.getSellerHomeNumbers}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body']['data'];

        deliveredSeller = responseData['delivered to seller'];
        deliveredUser = responseData['delivered to user'];
        done = responseData['Done'];
        returnProduct = responseData['return Order'];

        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      } else if (responseMap['code'] == 999) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearMaterialBanners();
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: AppText(
              'الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',
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
        // Handle error case
      }
    }
  }

  Future<void> _refresh() async{
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MAsizes.screenH,
      width: MAsizes.screenW,
      child: userType == 'seller' ?ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MAsizes.heightOfSellerInformationInHomePage,
                  width: MAsizes.widthOfSellerInformationInHomePage,
                  decoration: BoxDecoration(
                    color: AppColors.offWhiteBoxColor,
                    borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppText(sharedPreferences.getString('name')??'',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: MAsizes.heightOfMediumEmptySpace,
                            backgroundColor: AppColors.mainColor,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(borderRadius: BorderRadius.circular(MAsizes.screenH)),child: Image(image: MemoryImage(decode(sellerTempPhoto)),fit: BoxFit.cover,isAntiAlias: true)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppText('تتبع الطلبات',color: AppColors.textGreenColor,size: MAsizes.textBetweenNormalAndBigSize),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MAsizes.screenH/3,
                  width: MAsizes.screenW,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                      color: AppColors.offWhiteBoxColor
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            AppText('طلبات مرتجع',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            const Icon(Icons.assignment_return,color: AppColors.mainColor,)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: AppText('0',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                      color: AppColors.offWhiteBoxColor
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            AppText('طلبات تم توصيلها',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            const Icon(Icons.done,color: AppColors.mainColor,)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: AppText('0',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                      color: AppColors.offWhiteBoxColor
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            AppText('طلبات جديدة',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            const Icon(Icons.handshake,color: AppColors.mainColor,)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: AppText('0',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                      color: AppColors.offWhiteBoxColor
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            AppText('طلبات قيد التوصيل',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            const Icon(Icons.delivery_dining,color: AppColors.mainColor,)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: AppText('0',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                        ),
                                      ),
                                    ],
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const  SellerCompleteYourInformation()));
                  },
                  child: Container(
                      height: MAsizes.buttonHeight,
                      width: MAsizes.buttonBigWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                          color: AppColors.buttonGreenColor
                      ),
                      child: Center(child: AppText('اكمل البيانات الاساسبة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppText('الرجاء اكمال بعض البيانات الاساسية لتفعيل \nالحساب و امكانية اضافة المنتجات و ادارتها',color: AppColors.textGreenColor,size: MAsizes.textBetweenNormalAndBigSize),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MAsizes.heightOfSmallEmptySpace/2,
                ),
              ),
            ],
          ),
        ],
      ):isLoading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MAsizes.heightOfSellerInformationInHomePage,
                    width: MAsizes.widthOfSellerInformationInHomePage,
                    decoration: BoxDecoration(
                        color: AppColors.offWhiteBoxColor,
                        borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AppText(sharedPreferences.getString('name')??'',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: MAsizes.heightOfMediumEmptySpace,
                              backgroundColor: AppColors.mainColor,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(borderRadius: BorderRadius.circular(MAsizes.screenH)),child: Image(image: MemoryImage(decode(sellerTempPhoto)),fit: BoxFit.cover,isAntiAlias: true)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText('تتبع الطلبات',color: AppColors.textGreenColor,size: MAsizes.textBetweenNormalAndBigSize),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MAsizes.screenH/3,
                    width: MAsizes.screenW,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerReturnProductOrder(),));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                          color: AppColors.offWhiteBoxColor
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                AppText('طلبات مرتجع',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                                const Icon(Icons.assignment_return,color: AppColors.mainColor,)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: AppText(returnProduct.toString(),color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerDoneOrder(),));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                          color: AppColors.offWhiteBoxColor
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                AppText('طلبات تم توصيلها',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                                const Icon(Icons.done,color: AppColors.mainColor,)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: AppText(done.toString(),color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerDeliveredSellerOrder(),));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                          color: AppColors.offWhiteBoxColor
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                AppText('طلبات جديدة',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                                const Icon(Icons.handshake,color: AppColors.mainColor,)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: AppText(deliveredSeller.toString(),color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerDeliveredUserOrder(),));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                          color: AppColors.offWhiteBoxColor
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                AppText('طلبات قيد التوصيل',color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                                const Icon(Icons.delivery_dining,color: AppColors.mainColor,)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: AppText(deliveredUser.toString(),color: AppColors.textGreenColor,size: MAsizes.textNormalSize),
                                            ),
                                          ),
                                        ],
                                      ),

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerAddNewProduct()));
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonBigWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: AppColors.buttonGreenColor
                        ),
                        child: Center(child: AppText('اضافة منتج جديد',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: (){
                      /*ScaffoldMessenger.of(context).clearMaterialBanners();
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: Center(child: AppText('ستكون متاحة التحديث القادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          actions: [
                            TextButton(
                              child: AppText(
                                'حسنا',
                                color: AppColors.textWhiteColor,
                                size: MAsizes.textNormalSize,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearMaterialBanners();
                              },
                            ),
                          ],
                        )
                      );*/
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const  SellerAddNewAuction()));
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonBigWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: AppColors.buttonGreenColor
                        ),
                        child: Center(child: AppText('اضافة مزاد جديد',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
