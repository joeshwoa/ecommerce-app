import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_return_order.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_my_return_order_card.dart';
import 'package:klnakhadem/model/return_order_model.dart';

class BuyerMyReturnProductOrder extends StatefulWidget {
  const BuyerMyReturnProductOrder({super.key});

  @override
  State<BuyerMyReturnProductOrder> createState() => _BuyerMyReturnProductOrderState();
}

class _BuyerMyReturnProductOrderState extends State<BuyerMyReturnProductOrder> {

  List<ReturnOrder> returnOrders = [];
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        itemCounter = returnOrders.length +1;
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

      final responseMap = await get("${ApiPaths.getBuyerReturnProductOrders}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        final List<ReturnOrder> newReturnOrders = [];

        for(int i=0;i<responseData["results"];i++){
          newReturnOrders.add(createReturnOrder(responseMap['body']['data'][i]));
        }

        if(mounted){
          setState(() {
            returnOrders.addAll(newReturnOrders);

            itemCounter = returnOrders.length;
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
      returnOrders.clear();
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
          title: AppText('طلبات المرتجع',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: !isLoading && returnOrders.isEmpty?Center(
            child: AppText('لا يوجد طلبات مرتجع',color: AppColors.textGreenColor,size: MAsizes.textBigSize,),
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
                      itemBuilder: (context,index)=> MAmyReturnOrderCard(
                        price: returnOrders[index].price,
                        state: returnOrders[index].state,
                        orderNumber: index+1,
                        orderId: returnOrders[index].id,
                      ),
                      itemCount: returnOrders.length,
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
