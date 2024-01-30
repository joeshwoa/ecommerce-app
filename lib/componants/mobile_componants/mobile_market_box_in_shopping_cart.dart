import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klnakhadem/api/api_methods/delete.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_methods/put.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/cubits/shopping_cart_cubit.dart';
import 'package:klnakhadem/model/product_model.dart';

class MAmarketBoxInShoppingCart extends StatefulWidget {
  const MAmarketBoxInShoppingCart({super.key,required this.deliveryCost,required this.marketName,required this.products,required this.recordsId,required this.quantity,required this.cubit,required this.shoppingCartCubit});

  final String marketName;
  final int deliveryCost;
  final List<Product> products;
  final List<String> recordsId;
  final List<int> quantity;
  final BuyerLayoutCubit cubit;
  final ShoppingCartCubit shoppingCartCubit;

  @override
  State<MAmarketBoxInShoppingCart> createState() => _MAmarketBoxInShoppingCartState();
}

class _MAmarketBoxInShoppingCartState extends State<MAmarketBoxInShoppingCart> {

  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return BuyerLayoutCubit();
      },
      child: BlocConsumer<BuyerLayoutCubit, BuyerLayoutState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                  color: AppColors.offWhiteBoxColor,
                  border: Border.all(color: AppColors.mainColor,width: ShoppingCartCubit.get(context).selectedMarket == widget.marketName ? 2:0 )
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText(widget.marketName,size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          AppText('متجر ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        for(int i=0;i<widget.products.length;i++)...[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            IconButton(
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
                                                  'product':widget.products[i].id,
                                                };
                                                Map responseMap = await post(ApiPaths.addFavoriteProduct,data);
                                                if((responseMap['code']>=200 && responseMap['code']<300)) {
                                                  if(mounted){
                                                    ScaffoldMessenger.of(context).clearSnackBars();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Center(child: AppText('تم اضافة المنتج في المفضلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                                        backgroundColor: AppColors.mainColor,
                                                        showCloseIcon: true,
                                                      ),
                                                    );
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
                                                  if(mounted){
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
                                              icon: const Icon(Icons.favorite_border),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context).clearSnackBars();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Center(child: AppText('جاري ازالة المنتج من عربة التسوق',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                                    backgroundColor: AppColors.mainColor,
                                                    showCloseIcon: true,
                                                  ),
                                                );
                                                final responseMap = await delete("${ApiPaths.deleteProductFromShoppingCart}/${widget.recordsId[i]}", {});
                                                if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
                                                  await get("${ApiPaths.getShoppingCartNumber}${sharedPreferences.getString('token')}").then((value) {
                                                    BuyerLayoutCubit.cartNumber = value['body']['data'];
                                                    widget.cubit.fetchCartNumber();
                                                  });
                                                  if(context.mounted){
                                                    ScaffoldMessenger.of(context).clearSnackBars();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Center(child: AppText('تمت ازالة المنتج من عربة التسوق',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                                        backgroundColor: AppColors.mainColor,
                                                        showCloseIcon: true,
                                                      ),
                                                    );
                                                    ShoppingCartCubit.get(context).deleteItem(widget.marketName, i);
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
                                                  if(mounted){
                                                    ScaffoldMessenger.of(context).clearSnackBars();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Center(child: AppText('فشل ازالة المنتج من عربة التسوق',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                                        backgroundColor: AppColors.mainColor,
                                                        showCloseIcon: true,
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              icon: const Icon(Icons.delete_outline),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              AppText("اسم المنتج : ${widget.products[i].title}",size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 2),
                                              AppText('سعر المنتج : ${widget.products[i].price}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 2),
                                              AppText('كمية المنتج : ${widget.quantity[i]}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 2),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius)
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image(image: MemoryImage(widget.products[i].imageCover),fit: BoxFit.cover,isAntiAlias: true),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () async {
                                          if(!sending) {
                                            setState(() {
                                              sending = true;
                                            });
                                            Map<String,dynamic> data = {
                                              'id': sharedPreferences.getString('token'),
                                              'product': widget.products[i].id,
                                              'amount': 1
                                            };
                                            Map responseMap = await put(ApiPaths.plusAndMinusProductQuantityInShoppingCart,data).onError((error, stackTrace) {
                                              return {
                                                'code':999
                                              };
                                            });
                                            if((responseMap['code']>=200 && responseMap['code']<300)){
                                              setState(() {
                                                widget.quantity[i] = responseMap['body']['quantity'];
                                              });

                                              widget.shoppingCartCubit.quantities[widget.marketName]![i] = responseMap['body']['quantity'];
                                            }
                                            setState(() {
                                              sending = false;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.plus_one_rounded,color: sending?Colors.grey:Colors.black,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        height: 40,
                                        width: 40,
                                        child: Center(
                                          child: AppText('${widget.quantity[i]}',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
                                        ),
                                      ),
                                    ),
                                    if(widget.shoppingCartCubit.quantities[widget.marketName]![i]>1)Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () async {
                                          if(!sending) {
                                            setState(() {
                                              sending = true;
                                            });
                                            Map<String,dynamic> data = {
                                              'id': sharedPreferences.getString('token'),
                                              'product': widget.products[i].id,
                                              'amount': -1
                                            };
                                            Map responseMap = await put(ApiPaths.plusAndMinusProductQuantityInShoppingCart,data).onError((error, stackTrace) {
                                              return {
                                                'code':999
                                              };
                                            });
                                            if((responseMap['code']>=200 && responseMap['code']<300)){
                                              setState(() {
                                                widget.quantity[i] = responseMap['body']['quantity'];
                                              });
                                              widget.shoppingCartCubit.quantities[widget.marketName]![i] = responseMap['body']['quantity'];
                                            }
                                            setState(() {
                                              sending = false;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.exposure_minus_1_rounded,color: sending?Colors.grey:Colors.black),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]
                      ],

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: AppText(' سعر التوصيل ${widget.deliveryCost} ريال ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
