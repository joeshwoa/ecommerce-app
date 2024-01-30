import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_dilevered_user_order.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_layout.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_show_order_products.dart';

class MAsellerDileveredSellerOrderCard extends StatefulWidget {
  const MAsellerDileveredSellerOrderCard({super.key,required this.orderNumber,required this.price,required this.orderId,required this.address});
  final int orderNumber;
  final double price;
  final String orderId;
  final Address address;

  @override
  State<MAsellerDileveredSellerOrderCard> createState() => _MAsellerDileveredSellerOrderCardState();
}

class _MAsellerDileveredSellerOrderCardState extends State<MAsellerDileveredSellerOrderCard> {

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
                    Clipboard.setData(ClipboardData(
                        text: widget.price.toStringAsFixed(2)));
                    if (Navigator.of(context).mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content: Center(child: AppText('تم نسخ المبلغ',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                    Clipboard.setData(ClipboardData(
                        text: '${widget.address.city}, ${widget.address.area}, ${widget.address.supArea}, ${widget.address.street}'));
                    if (Navigator.of(context).mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content: Center(child: AppText('تم نسخ العنوان',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                      Expanded(child: AppText('${widget.address.city}, ${widget.address.area}, ${widget.address.supArea}, ${widget.address.street}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),),
                      AppText('العنوان', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      const Icon(Icons.price_change),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SellerShowOrderProducts(orderId: widget.orderId),));
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: AppText('جاري تغير حالة الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                        backgroundColor: AppColors.mainColor,
                        showCloseIcon: true,
                      ),
                    );
                    Map<String,dynamic> data = {
                      'order': widget.orderId,
                      'status': 'delivered to user'
                    };
                    Map responseMap = await post(ApiPaths.changeOrderState,data);
                    if((responseMap['code']>=200 && responseMap['code']<300)){
                      if (context.mounted){
                        ScaffoldMessenger.of(context)
                            .clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                                child: AppText(
                                  'تم تغير حالة الطلب',
                                  color: AppColors.textWhiteColor,
                                  size: MAsizes.textNormalSize,
                                )),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                        while (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MAsellerLayout()));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerDeliveredUserOrder(),));
                      }
                    }else{
                      if (context.mounted){
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: AppText('فشل تغير حالة الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                            backgroundColor: AppColors.mainColor,
                            showCloseIcon: true,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                      height: MAsizes.buttonHeight,
                      width: MAsizes.buttonBigWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                          color: AppColors.buttonGreenColor
                      ),
                      child: Center(child: AppText('اخبار العميل ببدأ توصيل الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
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