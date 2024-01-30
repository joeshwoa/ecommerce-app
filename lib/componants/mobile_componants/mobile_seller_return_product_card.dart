import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_show_return_order_products.dart';

class MAsellerReturnProductCard extends StatefulWidget {
  const MAsellerReturnProductCard({super.key,required this.orderNumber,required this.price,required this.orderId});
  final int orderNumber;
  final double price;
  final String orderId;

  @override
  State<MAsellerReturnProductCard> createState() => _MAsellerReturnProductCardState();
}

class _MAsellerReturnProductCardState extends State<MAsellerReturnProductCard> {

  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: open? Container(
        height: MAsizes.heightOfMyOrderContainer*0.5,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: AppColors.textWhiteColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                child: MaterialButton(
                  onPressed: (){

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.money),
                      AppText(widget.price.toStringAsFixed(2), size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Expanded(child: SizedBox()),
                      AppText('المبلغ المستحق من الطلب', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Icon(Icons.price_change),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SellerShowReturnOrderProducts(orderId: widget.orderId),));
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