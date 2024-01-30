import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_product_card.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/model/product_model.dart';

class BuyerProductSearch extends StatefulWidget {
  const BuyerProductSearch({super.key,required this.cubit});
  final BuyerLayoutCubit cubit;

  @override
  State<BuyerProductSearch> createState() => _BuyerProductSearchState();
}

class _BuyerProductSearchState extends State<BuyerProductSearch> {

  List<Product> products = [];
  int page = 1; // Initial page number
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;

  TextEditingController searchController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  }

  @override
  void dispose(){
    super.dispose();
    fetchData().ignore();
    _controller.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      products.clear();
      itemCounter = 1;
    });
    if (!isLoading) {
      if(mounted){
        setState(() {
          isLoading = true;
        });
      }

      Map<String,dynamic> data = {
        'val':searchController.text,
      };

      final responseMap = await post(ApiPaths.productSearch+page.toString(),data).onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Product> newProducts = [];


        for(int i=0;i<responseData["data"].length;i++){
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
        setState(() {
          isLoading = false;
        });
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
        setState(() {
          isLoading = false;
        });
        // Handle error case
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
          title: AppText("بحث",size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: _controller,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.white60,
              leadingWidth: MAsizes.buttonNormalWidth*0.75,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.buttonGreenColor,
                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          fetchData();
                        }
                      },
                      icon: const Icon(Icons.search,color: AppColors.textWhiteColor),
                    ),
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Row(
                      children: [
                        /*Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.buttonGreenColor,
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()) {
                                    fetchData();
                                  }
                                },
                                icon: const Icon(Icons.search,color: AppColors.textWhiteColor),
                              ),
                            ),
                          ),
                        ),*/
                        Expanded(
                          /*flex: 6,*/
                          child: TextFormField(
                            keyboardType: TextInputType.name,

                            validator: (value){
                              if(value == null || value.isEmpty || value.characters == Characters(' '))
                              {
                                return 'اسم المنتج لا يمكن ان يكون فارغ';
                              }
                              return null;
                            },
                            cursorColor: AppColors.mainColor,
                            controller: searchController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: MAsizes.textNormalSize),
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),borderSide: const BorderSide(color: AppColors.mainColor,width: 2)),
                              labelStyle: const TextStyle(color: AppColors.mainColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),borderSide: const BorderSide(color: AppColors.mainColor)),
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              floating: true, // Set to true to hide the app bar on scrolling up
              snap: true, // Set to true to show the app bar when scrolling down

            ),
            SliverGrid.builder(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: !isLoading && products.isEmpty?1:2),
              itemCount: itemCounter, // Add 1 for the loading indicator
              itemBuilder: (context, index) {
                if(!isLoading && products.isEmpty) {
                  return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText('قم بكتابة اسم المنتج',color: AppColors.textGreenColor,size: MAsizes.textBigSize),
                      AppText('ثم',color: AppColors.textGreenColor,size: MAsizes.textBigSize),
                      AppText(' اضعط علي عدسة البحث',color: AppColors.textGreenColor,size: MAsizes.textBigSize),
                    ],
                  ),
                );
                }
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
            ),
          ],
        ),
      ),
    );
  }
}