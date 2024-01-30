import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_keep_tracking_return_order_box.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_review_return_order.dart';

class MAmyReturnOrderCard extends StatefulWidget {
  const MAmyReturnOrderCard({super.key,required this.orderNumber,required this.price,required this.state,required this.orderId});
  final int orderNumber;
  final double price;
  final String state;
  final String orderId;

  @override
  State<MAmyReturnOrderCard> createState() => _MAmyReturnOrderCardState();
}

class _MAmyReturnOrderCardState extends State<MAmyReturnOrderCard> {

  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: open? Container(
        height: MAsizes.heightOfMyOrderContainer*4/5,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: AppColors.textWhiteColor
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
              MAkeepTrackingReturnOrderBox(state: widget.state),
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
                      AppText('${widget.price}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerReviewReturnOrder(orderId: widget.orderId,price: widget.price),));
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
            color: AppColors.textWhiteColor
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
