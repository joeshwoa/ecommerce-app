import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_order.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_seller_done_order_card.dart';
import 'package:klnakhadem/model/order_model.dart';

class SellerDoneOrder extends StatefulWidget {
  const SellerDoneOrder({super.key});

  @override
  State<SellerDoneOrder> createState() => _SellerDoneOrderState();
}

class _SellerDoneOrderState extends State<SellerDoneOrder> {

  List<Order> orders = [];
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;

  late final double taxes;
  late final double zekaTaxes;
  late final double amolaFactor;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        itemCounter = orders.length +1;
      });
      fetchData();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    setState(() {
      isLoading = true;
    });
    get(ApiPaths.getVatAndZekaAndAmolaValues).then((value){
      if((value['code']>=200 && value['code']<300))
      {
        taxes = value['body']['vat'];
        zekaTaxes = value['body']['zeka'];
        amolaFactor = value['body']['commission']*1.0;
        isLoading = false;
        fetchData(); // Fetch initial data when widget is initialized
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

      final responseMap = await get("${ApiPaths.getSellerDoneOrders}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Order> newOrders = [];

        for(int i=0;i<responseData["results"];i++){
          newOrders.add(createOrder(responseMap['body']['data'][i]));
        }

        if(mounted){
          setState(() {
            orders.addAll(newOrders);

            itemCounter = orders.length;
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
      }
    }
  }

  Future<void> _refresh() async{
    setState(() {
      itemCounter = 1;
      orders.clear();
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
          title: AppText('طلبات تم توصيلها',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: !isLoading && orders.isEmpty?Center(
            child: AppText('لا يوجد طلبات',color: AppColors.textGreenColor,size: MAsizes.textBigSize,),
          ):Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: isLoading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context,index)=> MAsellerDoneOrderCard(
                        price: orders[index].priceSeller+orders[index].delivery,
                        orderNumber: orders[index].serial,
                        orderId: orders[index].id,
                        address: orders[index].address,
                      ),
                      itemCount: orders.length,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}