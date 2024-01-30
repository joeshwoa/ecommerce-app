import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/delete.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_favorite_product_card.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_shopping_cart.dart';

class BuyerFavoriteProducts extends StatefulWidget {
  const BuyerFavoriteProducts({super.key,required this.cubit});
  final BuyerLayoutCubit cubit;

  @override
  State<BuyerFavoriteProducts> createState() => _BuyerFavoriteProductsState();
}

class _BuyerFavoriteProductsState extends State<BuyerFavoriteProducts> {
  List<Product> products = [];
  List<String> recordId = [];
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        itemCounter = products.length +1;
      });
      fetchData();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    fetchData(); // Fetch initial data when widget is initialized
  }

  @override
  void dispose(){
    super.dispose();
    fetchData().ignore();
    _controller.dispose();
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      if(mounted){
        setState(() {
          isLoading = true;
        });
      }

      final responseMap = await get("${ApiPaths.getFavoriteProducts}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Product> newProducts = [];
        final List<String> newRecordId = [];
        
        for(int i=0;i<responseData["results"];i++){
          newProducts.add(createProduct(responseData["data"][i]['product']));
          newRecordId.add(responseData["data"][i]['_id']);
        }

        if(mounted){
          setState(() {
            products.addAll(newProducts);
            recordId.addAll(newRecordId);

            itemCounter = products.length;
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
        // Handle error case
      }
    }
  }

  Future<void> _refresh() async{
    setState(() {
      itemCounter = 1;
      products.clear();
    });
    fetchData();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('المفضلة',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuyerShoppingCart(cubit: widget.cubit),));
              },
              icon: const Icon(Icons.shopping_cart),
            )
          ],
        ),
        body: SizedBox(
          height: MAsizes.screenH,
          width: MAsizes.screenW,
          child: !isLoading && products.isEmpty?Center(
            child: AppText('لا يوجد منتجات مفضلة',color: AppColors.textGreenColor,size: MAsizes.textBigSize,),
          ):RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: itemCounter, // Add 1 for the loading indicator
              itemBuilder: (context, index) {
                if (index < products.length) {
                  // Render category card
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () async {
                            final responseMap = await delete("${ApiPaths.deleteFavoriteProducts}${recordId[index]}", {}).onError((error, stackTrace) {
                              return {
                                'code':999
                              };
                            });
                            if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
                              setState(() {
                                products.removeAt(index);
                                recordId.removeAt(index);
                              });
                            }  else if (responseMap['code'] == 999) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.favorite,color: Colors.red),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: MAfavoriteProductCard(product: products[index],recordId: recordId[index],cubit: widget.cubit),
                      ),
                    ],
                  );
                } else if (isLoading) {
                  // Render loading indicator while fetching more data
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.mainColor,),
                  );
                } else {
                  // Render an empty container at the end
                  return Container(
                  );
                }
              },
              controller: _controller,
            ),
          ),
        ),
      ),
    );
  }
}
