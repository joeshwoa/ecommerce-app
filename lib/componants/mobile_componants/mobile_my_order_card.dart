import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_keep_tracking_order_box.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_rate_order_after_buy.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_review_order_after_buy.dart';

class MAmyOrderCard extends StatefulWidget {
  const MAmyOrderCard({super.key,required this.orderNumber,required this.price,required this.code,required this.state,required this.orderId,required this.paymentMethod,required this.address,required this.delivery,required this.priceBuyer});
  final int orderNumber;
  final String code;
  final double price;
  final double priceBuyer;
  final String state;
  final String orderId;
  final String paymentMethod;
  final Address address;
  final int delivery;

  @override
  State<MAmyOrderCard> createState() => _MAmyOrderCardState();
}

class _MAmyOrderCardState extends State<MAmyOrderCard> {

  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: open? Container(
        height: MAsizes.heightOfMyOrderContainer,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: widget.state == 'DONE'?AppColors.mainColor.withOpacity(0.1):widget.state == 'delivered to seller'?AppColors.textWhiteColor:Colors.yellow.withOpacity(0.1)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        open = !open;
                      });
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  const Expanded(child: SizedBox()),
                  AppText('${widget.orderNumber}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  AppText(' # ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  AppText('الطلب رقم', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ],
              ),
              Container(
                height: 1,
                width: MAsizes.screenW,
                decoration: const BoxDecoration(
                  color: AppColors.mainColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppText('تتبع الطلب', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              MAkeepTrackingOrderBox(state: widget.state),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){
                    if(widget.state == 'DONE') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerRateOrderAfterBuy(orderId: widget.orderId),));
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: AppText('لا يمكن تقيم المنتجات الا عند وصوله',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          showCloseIcon: true,
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.arrow_back_ios),
                      const Expanded(child: SizedBox()),
                      AppText('تقييم المنتج', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Icon(Icons.star),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){
                    Clipboard.setData(ClipboardData(
                        text: widget.code));
                    if (Navigator.of(context).mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content: Center(child: AppText('تم نسخ الرقم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                        backgroundColor: AppColors.mainColor,
                        showCloseIcon: true,
                      ),);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.numbers),
                      AppText(widget.code, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Expanded(child: SizedBox()),
                      AppText('رمز التوصيل', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Icon(Icons.security),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.money),
                      AppText('${widget.priceBuyer+widget.delivery}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Expanded(child: SizedBox()),
                      AppText('سعر الطلب شامل التوصيل', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Icon(Icons.price_change),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerReviewOrderAfterBuy(orderId: widget.orderId,paymentMethod: widget.paymentMethod,address: widget.address,price: widget.price,delivery: widget.delivery,state: widget.state,priceBuyer: widget.priceBuyer),));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.arrow_back_ios),
                      const Expanded(child: SizedBox()),
                      AppText('تفاصيل الطلب', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Icon(Icons.format_line_spacing),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ) : Container(
        height: MAsizes.buttonHeight*1.5,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: widget.state == 'DONE'?AppColors.mainColor.withOpacity(0.1):widget.state == 'delivered to seller'?AppColors.textWhiteColor:Colors.yellow.withOpacity(0.1)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    open = !open;
                  });
                },
                  icon: const Icon(Icons.arrow_downward),
              ),
              const Expanded(child: SizedBox()),
              AppText('${widget.orderNumber}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
              AppText(' # ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
              AppText('الطلب رقم', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
            ],
          ),
        ),
      ),
    );
  }
}
