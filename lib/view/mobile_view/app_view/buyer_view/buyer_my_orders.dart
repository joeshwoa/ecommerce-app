import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_order.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_my_order_card.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/order_model.dart';

class BuyerMyOrders extends StatefulWidget {
  const BuyerMyOrders({super.key});

  @override
  State<BuyerMyOrders> createState() => _BuyerMyOrdersState();
}

class _BuyerMyOrdersState extends State<BuyerMyOrders> {

  List<Order> orders = [];
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;
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

      final responseMap = await get("${ApiPaths.getOrders}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
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
          title: AppText('طلباتي',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
                      itemBuilder: (context,index)=> MAmyOrderCard(
                        price: orders[index].price,
                        priceBuyer: orders[index].priceBuyer,
                        code: orders[index].code,
                        state: orders[index].state,
                        orderNumber: orders[index].serial,
                        orderId: orders[index].id,
                        paymentMethod: orders[index].paymentMethod,
                        address: orders[index].address,
                        delivery: orders[index].delivery,
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
