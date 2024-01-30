import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_done_order.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_layout.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_show_order_products.dart';

class MAsellerDileveredUserOrderCard extends StatefulWidget {
  const MAsellerDileveredUserOrderCard({super.key,required this.orderNumber,required this.price,required this.orderId,required this.address});
  final int orderNumber;
  final double price;
  final String orderId;
  final Address address;

  @override
  State<MAsellerDileveredUserOrderCard> createState() => _MAsellerDileveredUserOrderCardState();
}

class _MAsellerDileveredUserOrderCardState extends State<MAsellerDileveredUserOrderCard> {

  bool open = false;

  TextEditingController codeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                child: Form(
                  key: formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          if(formKey.currentState!.validate()) {
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
                              'status': 'DONE',
                              'code': int.parse(codeController.text)
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerDoneOrder(),));
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
                          }
                        },
                        child: Container(
                            height: MAsizes.buttonHeight,
                            width: MAsizes.buttonBigWidth*0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                color: AppColors.buttonGreenColor
                            ),
                            child: Center(child: AppText('اتمام الطلب',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                        ),
                      ),
                      Expanded(
                        child: AppTextFormField(
                          validator: (value){
                            if(value == null || value.isEmpty || value.characters.length <6)
                            {
                              return 'رقم تاكيد الطلب يحب ان يكون 6 خانات';
                            }
                            return null;
                          },
                          mycontroller: codeController,
                          hintText: 'ادخل رقم تاكيد الطلب',
                          labelText: 'رقم تاكيد الطلب',
                          icon: Icons.numbers,
                          keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                        ),
                      )
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