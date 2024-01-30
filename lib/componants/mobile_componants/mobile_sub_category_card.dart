import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_products_page_of_specifc_sub_category.dart';

class MAsubCategoryCard extends StatelessWidget {
  const MAsubCategoryCard({super.key,required this.name,required this.imageBytes,required this.id,required this.cubit});
  final String name;
  final Uint8List imageBytes;
  final String id;
  final BuyerLayoutCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: MaterialButton(
        height: MAsizes.heightOfCategoryContainer,
        padding: EdgeInsets.zero,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerProductPageForSpecificSubCategory(categoryID: id,categoryName: name,cubit: cubit),));
        },
        child: Container(
          width: MAsizes.widthOfCategoryContainer,
          height: MAsizes.heightOfCategoryContainer,
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
              SizedBox(
                height: MAsizes.heightOfCategoryContainer*2/3,
                width: MAsizes.widthOfCategoryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.mainColor,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(width: MAsizes.widthOfCategoryContainer*0.57,height: MAsizes.widthOfCategoryContainer*0.57,clipBehavior: Clip.antiAlias,decoration: BoxDecoration(borderRadius: BorderRadius.circular(MAsizes.screenH)),child: imageBytes.isNotEmpty?Image(image: MemoryImage(imageBytes),fit: BoxFit.cover,isAntiAlias: true):const Icon(Icons.category_rounded,color: AppColors.textBlackColor)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MAsizes.heightOfCategoryContainer/3,
                width: MAsizes.widthOfCategoryContainer,
                child: Center(child: AppText(name, size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}