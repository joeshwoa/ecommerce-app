import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_product_detailes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MAfavoriteProductCard extends StatelessWidget {
  const MAfavoriteProductCard({super.key,required this.product,required this.recordId,required this.cubit});
  final Product product;
  final String recordId;
  final BuyerLayoutCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: MaterialButton(
        height: MAsizes.heightOfProductContainer/2,
        padding: EdgeInsets.zero,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerProductDetails(product: product,cubit: cubit),));
        },
        child: Container(
          height: MAsizes.heightOfProductContainer/2,
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
                      AppText(product.title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      AppText('${product.price}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppText(product.newProduct?'جديد':'مستعمل', size: MAsizes.textNormalSize, color:product.newProduct?AppColors.textGreenColor:Colors.red),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor:product.newProduct?AppColors.textGreenColor:Colors.red,
                              minRadius: 1.w,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: SizedBox(width: MAsizes.screenW,child: Image(image: MemoryImage(product.imageCover),fit: BoxFit.cover)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}