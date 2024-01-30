import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_my_return_product_order.dart';

class BuyerReturnProductsOrderRequest extends StatefulWidget {
  const BuyerReturnProductsOrderRequest({super.key,required this.products,required this.quantity,required this.orderId});
  final List<Product> products;
  final List<int> quantity;
  final String orderId;

  @override
  State<BuyerReturnProductsOrderRequest> createState() => _BuyerReturnProductsOrderRequestState();
}

class _BuyerReturnProductsOrderRequestState extends State<BuyerReturnProductsOrderRequest> {

  final List<bool> checkBoxes = [];
  final List<Product> returnProduct = [];
  final List<int> returnProductQuantity = [];

  @override
  void initState() {
    super.initState();

    for(int i=0; i<widget.products.length; i++) {
      if(widget.products[i].canReturn) {
        returnProduct.add(widget.products[i]);
        checkBoxes.add(false);
        returnProductQuantity.add(widget.quantity[i]);
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
          title: AppText('المنتجات المتاح بها استرجاع',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for(int i=0; i<returnProduct.length; i++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MAsizes.buttonHeight*2,
                          width: MAsizes.screenW,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppText('${returnProduct[i].price}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AppText(returnProduct[i].title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                      AppText(returnProductQuantity[i].toString(), size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                    ],
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
                                        child: Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(borderRadius: BorderRadius.circular(MAsizes.screenH)),child: Image(image: MemoryImage(returnProduct[i].imageCover),fit: BoxFit.cover,isAntiAlias: true)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Checkbox(
                      activeColor: AppColors.mainColor,
                      side: BorderSide(color: checkBoxes[i]?AppColors.mainColor:Colors.grey),
                      value: checkBoxes[i],
                      onChanged: (value){
                        setState(() {
                          checkBoxes[i] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: MaterialButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: AppText('جاري اضافة المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          showCloseIcon: true,
                        ),
                      );
                      Map<String,String> returnProducts = {};
                      for(int i=0;i<widget.products.length;i++) {
                        if(checkBoxes[i]) {
                          returnProducts[widget.products[i].id]=widget.products[i].id;
                        }
                      }
                      Map<String,dynamic> data = {
                        'products':returnProducts,
                        'order':widget.orderId,
                        'user':sharedPreferences.getString("token")
                      };
                      Map responseMap = await post(ApiPaths.addReturnOrder,data).onError((error, stackTrace) {
                        return {
                          'code':999
                        };
                      });

                      if((responseMap['code']>=200 && responseMap['code']<300)){
                        if (context.mounted){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('تم ارسال طلب استرجاع',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Timer(const Duration(seconds: 1), () {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BuyerMyReturnProductOrder()));
                          });
                        }
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
                      }
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonBigWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: AppColors.buttonGreenColor
                        ),
                        child: Center(child: AppText('ارسال طلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
