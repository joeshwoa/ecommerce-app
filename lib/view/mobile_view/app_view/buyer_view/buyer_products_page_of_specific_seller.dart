import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_product_card.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/model/product_model.dart';

class BuyerProductPageForSpecificSeller extends StatefulWidget {
  const BuyerProductPageForSpecificSeller({super.key,required this.sellerID,required this.sellerName,required this.cubit});
  final String sellerID;
  final String sellerName;
  final BuyerLayoutCubit cubit;

  @override
  State<BuyerProductPageForSpecificSeller> createState() => _BuyerProductPageForSpecificSellerState();
}

class _BuyerProductPageForSpecificSellerState extends State<BuyerProductPageForSpecificSeller> {

  List<Product> products = [];
  int page = 1; // Initial page number
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

      final responseMap = await get("${ApiPaths.getProductBySeller}${widget.sellerID}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Product> newProducts = [];

        for(int i=0;i<responseData["results"];i++){
          newProducts.add(createProduct(responseData["data"][i]));
        }

        if(mounted){
          setState(() {
            products.addAll(newProducts);
            itemCounter = products.length;
            page++; // Increment page number for the next API call
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
      page=1;
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
          title: AppText(widget.sellerName,size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: !isLoading && products.isEmpty?Center(
            child: AppText('لا يوجد منتجات',color: AppColors.textGreenColor,size: MAsizes.textBigSize,),
          ):Column(
            children: [
              SizedBox(
                height: MAsizes.heightOfSmallEmptySpace/2,
              ),
              /*Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: MAsizes.buttonHeight*1.5,
                  width: MAsizes.screenW,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                      color: AppColors.offWhiteBoxColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppText('بحث', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ],
                    ),
                  ),
                ),
              ),*/
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: itemCounter, // Add 1 for the loading indicator
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        // Render category card
                        return MAproductCard(
                          product: products[index],
                          cubit: widget.cubit,
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
              SizedBox(
                height: MAsizes.heightOfMediumEmptySpace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}