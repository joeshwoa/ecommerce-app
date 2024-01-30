import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/product_model.dart';

class SellerShowOrderProducts extends StatefulWidget {
  const SellerShowOrderProducts({super.key,required this.orderId});
  final String orderId;

  @override
  State<SellerShowOrderProducts> createState() => _SellerShowOrderProductsState();
}

class _SellerShowOrderProductsState extends State<SellerShowOrderProducts> {

  List<Product> products = [];
  List<int> quantity = [];
  List<int> deliveryStat = [];
  int productPrice = 0;
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

      final responseMap = await get("${ApiPaths.getProductsOfOrders}${widget.orderId}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {

        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Product> newProducts = [];
        final List<int> newQuantity = [];
        final List<int> newDeliveryStats = [];

        for(int i=0;i<responseData["results"];i++){
          newProducts.add(createProduct(responseData["data"][i]['product']));
          productPrice += newProducts[i].price;
          newQuantity.add(responseData["data"][i]['quantity']);
          newDeliveryStats.add(responseData["data"][i]['delivery']);
        }

        if(mounted){
          setState(() {
            products.addAll(newProducts);
            quantity.addAll(newQuantity);
            deliveryStat.addAll(newDeliveryStats);
            itemCounter = products.length;
            isLoading = false;
          });
        }
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
      }else {
        // Handle error case

      }
    }
  }

  Future<void> _refresh() async{
    setState(() {
      itemCounter = 1;
      products.clear();
      quantity.clear();
      deliveryStat.clear();
      productPrice = 0;
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
          title: AppText('تفاصيل الطلب',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: isLoading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText('مراجعة المنتجات',size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.offWhiteBoxColor,
                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                    ),
                    width: MAsizes.screenW,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for(int i=0; i<products.length; i++) ...[
                            Padding(
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
                                      AppText('سعر المنتج :${products[i].price}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                      const Expanded(child: SizedBox()),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppText("اسم المنتج :${products[i].title}", size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                            AppText("كمية المنتج :${quantity[i]}", size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                            AppText(deliveryStat[i] == 0?'توصيل':'استلام', size: MAsizes.textNormalSize, color: AppColors.textGreenColor)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                                  color: AppColors.mainColor,
                                              ),child: Image(image: MemoryImage(products[i].imageCover),fit: BoxFit.cover,isAntiAlias: true)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
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