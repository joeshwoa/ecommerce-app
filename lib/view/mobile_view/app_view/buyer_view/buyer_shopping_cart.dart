import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_market_box_in_shopping_cart.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/cubits/shopping_cart_cubit.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_favorite_products.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_review_order_before_buy.dart';

class BuyerShoppingCart extends StatefulWidget {
  const BuyerShoppingCart({super.key,required this.cubit});

  final BuyerLayoutCubit cubit;

  @override
  State<BuyerShoppingCart> createState() => _BuyerShoppingCartState();
}

class _BuyerShoppingCartState extends State<BuyerShoppingCart> {

  bool first = true;

  late final double taxes;
  late final double zekaTaxes;
  late final double amolaFactor;

  late final ShoppingCartCubit cubit;

  Future<void> fetchData(context) async {
    if (!ShoppingCartCubit.get(context).isLoading) {
      ShoppingCartCubit.get(context).startFetching();

      final responseMap = await get("${ApiPaths.getShoppingCartForBuyer}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String ,dynamic> responseData = responseMap['body'];
        final Map<String ,List<Product>> newProducts = {};
        final Map<String ,List<int>> newQuantities = {};
        final Set<String> newMarkets = {};
        final Map<String ,int> newTotalProductsPrice = {};
        final Map<String ,List<String>> newRecordId = {};
        final Map<String, String> newSellerId = {};
        final Map<String ,List<int>> newDeliveryPrice = {};

        for(int i=0;i<responseData["results"];i++){

          if(!newMarkets.contains(responseData["data"][i]['product']['seller']['market'])) {
            newMarkets.add(responseData["data"][i]['product']['seller']['market']);
            newQuantities.addAll({
              responseData["data"][i]['product']['seller']['market']: []
            });
            newDeliveryPrice.addAll({
              responseData["data"][i]['product']['seller']['market']: []
            });
            newProducts.addAll({
              responseData["data"][i]['product']['seller']['market']: []
            });
            newTotalProductsPrice.addAll({
              responseData["data"][i]['product']['seller']['market']: 0
            });
            newRecordId.addAll({
              responseData["data"][i]['product']['seller']['market']: []
            });
            newSellerId.addAll({
              responseData["data"][i]['product']['seller']['market']:responseData["data"][i]['product']['seller']['_id']
            });
          }

          newProducts[responseData["data"][i]['product']['seller']['market']]!.add(createProduct(responseData["data"][i]['product']));
          newQuantities[responseData["data"][i]['product']['seller']['market']]!.add(responseData["data"][i]['quantity']);
          newDeliveryPrice[responseData["data"][i]['product']['seller']['market']]!.add(responseData["data"][i]['delivery'] == 0 ?responseData["data"][i]['product']['deliveryPrice']:0);
          newRecordId[responseData["data"][i]['product']['seller']['market']]!.add(responseData["data"][i]['_id']);
          int temp= 0;
          for(int ii=0;ii<newQuantities[responseData["data"][i]['product']['seller']['market']]!.length;ii++){
            temp += newQuantities[responseData["data"][i]['product']['seller']['market']]![ii] * newProducts[responseData["data"][i]['product']['seller']['market']]![ii].price;
          }
          newTotalProductsPrice[responseData["data"][i]['product']['seller']['market']] = temp;

        }

        if(mounted){
          ShoppingCartCubit.get(context).products.addAll(newProducts);
          ShoppingCartCubit.get(context).markets.addAll(newMarkets);
          ShoppingCartCubit.get(context).quantities.addAll(newQuantities);
          ShoppingCartCubit.get(context).deliveryPrice.addAll(newDeliveryPrice);
          ShoppingCartCubit.get(context).totalProductsPrice.addAll(newTotalProductsPrice);
          ShoppingCartCubit.get(context).recordId.addAll(newRecordId);
          ShoppingCartCubit.get(context).sellerId.addAll(newSellerId);
        }
        ShoppingCartCubit.get(context).stopFetching();
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
        // Handle error case
        ShoppingCartCubit.get(context).stopFetching();
      }
    }
  }

  Future<void> _refresh(context) async{
    ShoppingCartCubit.get(context).products.clear();
    ShoppingCartCubit.get(context).quantities.clear();
    ShoppingCartCubit.get(context).totalProductsPrice.clear();
    ShoppingCartCubit.get(context).recordId.clear();
    ShoppingCartCubit.get(context).markets.clear();
    ShoppingCartCubit.get(context).sellerId.clear();
    ShoppingCartCubit.get(context).selectedMarket = '';
    fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ShoppingCartCubit();
      },
      child: BlocConsumer<ShoppingCartCubit, ShoppingCartState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          if(first) {
            first = false;
            cubit = ShoppingCartCubit.get(context);
            get(ApiPaths.getVatAndZekaAndAmolaValues).then((value){
              if((value['code']>=200 && value['code']<300))
              {
                taxes = value['body']['vat'];
                zekaTaxes = value['body']['zeka'];
                amolaFactor = value['body']['commission']*1.0;
                fetchData(context);// Fetch initial data when widget is initialized
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
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.mainColor,
                centerTitle: true,
                title: AppText('عربة التسوق',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                actions: [
                  IconButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuyerFavoriteProducts(cubit: widget.cubit),));
                    },
                    icon: const Icon(Icons.favorite),
                  )
                ],
              ),
              body: SizedBox(
                height: MAsizes.screenH,
                width: MAsizes.screenW,
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: !ShoppingCartCubit.get(context).isLoading && ShoppingCartCubit.get(context).markets.isEmpty?Center(
                        child: AppText('لا يوجد منتجات',color: AppColors.textGreenColor,size: MAsizes.textBigSize,),
                      ):RefreshIndicator(
                        onRefresh: () => _refresh(context),
                        child: ShoppingCartCubit.get(context).isLoading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):ListView(
                          children: [
                            for(String market in ShoppingCartCubit.get(context).markets)...[
                              MaterialButton(
                                  onPressed: (){
                                    setState(() {
                                      ShoppingCartCubit.get(context).selectedMarket = market;
                                    });
                                  },
                                  child: MAmarketBoxInShoppingCart(deliveryCost: ShoppingCartCubit.get(context).getDeliveryPrice(market), marketName: market,products: ShoppingCartCubit.get(context).products[market]!,recordsId: ShoppingCartCubit.get(context).recordId[market]!,quantity: ShoppingCartCubit.get(context).quantities[market]!,cubit: widget.cubit,shoppingCartCubit: cubit,)
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColors.buttonGreenColor,
                        width: MAsizes.screenW,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor),
                                  AppText(ShoppingCartCubit.get(context).selectedMarket!=''?ShoppingCartCubit.get(context).totalProductsPrice[ShoppingCartCubit.get(context).selectedMarket].toString():'0',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor),
                                  AppText('مجموع سعر المنتجات ',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor),
                                  AppText(ShoppingCartCubit.get(context).selectedMarket!=''?(ShoppingCartCubit.get(context).totalProductsPrice[ShoppingCartCubit.get(context).selectedMarket]!*taxes).toString():'0',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor),
                                  AppText('مجموع سعر الضريبة ',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor),
                                  AppText(ShoppingCartCubit.get(context).selectedMarket!=''?ShoppingCartCubit.get(context).getDeliveryPrice(ShoppingCartCubit.get(context).selectedMarket).toString():'0',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor),
                                  AppText('مجموع سعر التوصيل ',size: MAsizes.textBetweenNormalAndBigSize*0.8, color: AppColors.textWhiteColor)
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: MaterialButton(
                                      onPressed: () {
                                        if(ShoppingCartCubit.get(context).selectedMarket!=''){
                                          int delivery = ShoppingCartCubit.get(context).getDeliveryPrice(ShoppingCartCubit.get(context).selectedMarket);
                                          int price = ShoppingCartCubit.get(context).totalProductsPrice[ShoppingCartCubit.get(context).selectedMarket]!;
                                          List<Product> products = ShoppingCartCubit.get(context).products[ShoppingCartCubit.get(context).selectedMarket]!;
                                          String sellerId = ShoppingCartCubit.get(context).sellerId[ShoppingCartCubit.get(context).selectedMarket]!;
                                          String market = ShoppingCartCubit.get(context).selectedMarket;
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerReviewOrderBeforeBuy(delivery: delivery,price: price,products: products,sellerId: sellerId,market: market,amolaFactor: amolaFactor,taxes: taxes,zekaTaxes: zekaTaxes,)));
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        height: MAsizes.buttonHeight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                          color: ShoppingCartCubit.get(context).selectedMarket!=''?AppColors.buttonWhiteColor:Colors.grey,
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AppText('اتمام الطلب',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AppText(' ريال',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textWhiteColor),
                                        AppText(ShoppingCartCubit.get(context).selectedMarket!=''?(ShoppingCartCubit.get(context).totalProductsPrice[ShoppingCartCubit.get(context).selectedMarket]! + (ShoppingCartCubit.get(context).totalProductsPrice[ShoppingCartCubit.get(context).selectedMarket]!*taxes) + ShoppingCartCubit.get(context).getDeliveryPrice(ShoppingCartCubit.get(context).selectedMarket)).toString():'0',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textWhiteColor),
                                        AppText('المجموع ',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textWhiteColor)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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

