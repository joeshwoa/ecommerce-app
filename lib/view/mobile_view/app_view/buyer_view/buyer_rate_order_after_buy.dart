import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_product.dart';

class BuyerRateOrderAfterBuy extends StatefulWidget {
  const BuyerRateOrderAfterBuy({super.key,required this.orderId});
  final String orderId;

  @override
  State<BuyerRateOrderAfterBuy> createState() => _BuyerRateOrderAfterBuyState();
}

class _BuyerRateOrderAfterBuyState extends State<BuyerRateOrderAfterBuy> {

  List<Product> products = [];
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;

  final List<TextEditingController> commentsControllers = [];
  final List<double> ratings = [];

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

      final responseMap = await get("${ApiPaths.getProductOfOrder}${widget.orderId}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {

        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Product> newProducts = [];

        for(int i=0;i<responseData["results"];i++){
          newProducts.add(createProduct(responseData["data"][i]['product']));
        }

        if(mounted){
          setState(() {
            products.addAll(newProducts);
            for(int i=0;i<products.length;i++) {
              commentsControllers.add(TextEditingController());
              ratings.add(0);
            }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('تقيم المنتج',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: isLoading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) =>  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MAsizes.screenW,
                      height: MAsizes.heightOfProductContainer,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.offWhiteBoxColor,
                        borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppTextFormField(
                                    mycontroller: commentsControllers[index],
                                    hintText: 'تعليق',
                                    labelText: 'تعليق',
                                    icon: Icons.comment,
                                    keyboardType: TextInputType.multiline,
                                  ),
                                  Center(
                                    child: RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        ratings[index] = rating;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(image: MemoryImage(products[index].imageCover),fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: AppText('جاري اضافة التقييم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                        backgroundColor: AppColors.mainColor,
                        showCloseIcon: true,
                      ),
                    );
                    bool sendRate = true;

                    for(int i = 0;i<products.length;i++) {
                      Map<String,dynamic> data = {
                        'user':sharedPreferences.getString('token'),
                        'product': products[i].id,
                        'dis':commentsControllers[i].text,
                        'rate':ratings[i],
                      };
                      Map responseMap = await post(ApiPaths.addComment,data).onError((error, stackTrace) {
                        return {
                          'code':999
                        };
                      });
                      if((responseMap['code']>=200 && responseMap['code']<300)){

                      }else{
                        if (context.mounted){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('فشل ارسال التقييم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                        }
                        sendRate = false;
                      }
                      if(!sendRate){
                        break;
                      }
                    }
                    if(sendRate) {
                      if (context.mounted){
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: AppText('تم ارسال التقييم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Container(
                      height: MAsizes.buttonHeight,
                      width: MAsizes.screenW,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                          color: AppColors.buttonGreenColor
                      ),
                      child: Center(child: AppText('ارسال التقييم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
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