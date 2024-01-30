import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/model/product_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_product_detailes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MAproductCard extends StatelessWidget {
  const MAproductCard({super.key,required this.product,required this.cubit});
  final Product product;
  final BuyerLayoutCubit cubit;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: MaterialButton(
        height: MAsizes.heightOfProductContainer,
        padding: EdgeInsets.zero,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerProductDetails(product: product,cubit: cubit),));
        },
        child: Container(
          width: MAsizes.widthOfProductContainer,
          height: MAsizes.heightOfProductContainer,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.offWhiteBoxColor,
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(width: MAsizes.screenW,child: Image(image: MemoryImage(product.imageCover),fit: BoxFit.cover,)),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(product.available>0)Expanded(
                          flex: 1,
                          child: AppText(product.title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ),
                      if(product.available>0)Expanded(
                          flex: 1,
                          child: AppText('${product.price} ريال', size: MAsizes.textNormalSize*0.9, color: AppColors.textGreenColor),
                      ),
                      if(product.available>0)Expanded(
                        flex: 1,
                        child: AppText('السعر غير شامل الضريبة', size: MAsizes.textNormalSize*0.7, color: AppColors.textGreenColor),
                      ),
                      if(product.available>0)Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            AppText(product.newProduct?'جديد':'مستعمل', size: MAsizes.textNormalSize, color:product.newProduct?AppColors.textGreenColor:Colors.red),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                backgroundColor:product.newProduct?AppColors.textGreenColor:Colors.red,
                                minRadius: 0.5.w,
                              ),
                            )
                          ],
                        ),
                      ),
                      if(product.available<=0)Expanded(
                        flex: 1,
                        child: Center(child: AppText('غير متوفر حاليا', size: MAsizes.textNormalSize, color: Colors.redAccent)),
                      ),
                      if(product.available<=0)Expanded(
                        flex: 1,
                        child: Center(child: AppText('بالمتجر', size: MAsizes.textNormalSize, color: Colors.redAccent)),
                      )
                    ],
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
