import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_product_edit.dart';

class MAsellerProductCard extends StatefulWidget {
  const MAsellerProductCard({super.key,required this.product});
  final Product product;

  @override
  State<MAsellerProductCard> createState() => _MAsellerProductCardState();
}

class _MAsellerProductCardState extends State<MAsellerProductCard> {

  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: open? Container(
        height: MAsizes.heightOfSellerProductCard,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: AppColors.offWhiteBoxColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MAsizes.buttonHeight*2,
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
                      icon: const Icon(Icons.arrow_upward),
                    ),
                    const Expanded(child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppText(widget.product.title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                              color: AppColors.mainColor,
                            ),
                            child: Image(image: MemoryImage(widget.product.imageCover),fit: BoxFit.cover,isAntiAlias: true)
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppText(' ريال ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        AppText('${widget.product.price}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    AppText('السعر', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppText(' ريال ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        AppText('${widget.product.deliveryPrice}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    AppText('السعر التوصيل', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(child: SizedBox()),
                        AppText('وصف المنتج', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(widget.product.description, size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 3),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppText('${widget.product.available}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    const Expanded(child: SizedBox()),
                    AppText('الكمية المتوفرة', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SellerProductEdit(product: widget.product),));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(Icons.edit,color: AppColors.mainColor,),
                      const Expanded(child: SizedBox()),
                      AppText('تعديل المنتج', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(Icons.delete,color: AppColors.mainColor,),
                      const Expanded(child: SizedBox()),
                      AppText('حذف المنتج', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ) : Container(
        height: MAsizes.buttonHeight*2,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: AppColors.offWhiteBoxColor
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
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppText(widget.product.title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                        color: AppColors.mainColor,
                      ),
                      child: Image(image: MemoryImage(widget.product.imageCover),fit: BoxFit.cover,isAntiAlias: true)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}