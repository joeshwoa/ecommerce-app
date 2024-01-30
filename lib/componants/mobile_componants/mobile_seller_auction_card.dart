import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/auction_model.dart';

class MAsellerAuctionCard extends StatefulWidget {
  const MAsellerAuctionCard({super.key,required this.auction});
  final Auction auction;

  @override
  State<MAsellerAuctionCard> createState() => _MAsellerAuctionCardState();
}

class _MAsellerAuctionCardState extends State<MAsellerAuctionCard> {

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
                          AppText(widget.auction.title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: MAsizes.heightOfMediumEmptySpace,
                          backgroundColor: AppColors.mainColor,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(borderRadius: BorderRadius.circular(MAsizes.screenH)),child: Image(image: MemoryImage(widget.auction.imageCover),fit: BoxFit.cover,isAntiAlias: true)),
                          ),
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
                        AppText('ريال', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        AppText('${widget.auction.bestOffer}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    AppText('السوم الحالي', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
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
                      child: AppText(widget.auction.description, size: MAsizes.textNormalSize, color: AppColors.textGreenColor,max: 3),
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
                    AppText('${widget.auction.quantity}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    const Expanded(child: SizedBox()),
                    AppText('الكمية المتوفرة', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: (){

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
                    AppText(widget.auction.title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: MAsizes.heightOfMediumEmptySpace,
                    backgroundColor: AppColors.mainColor,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(borderRadius: BorderRadius.circular(MAsizes.screenH)),child: Image(image: MemoryImage(widget.auction.imageCover),fit: BoxFit.cover,isAntiAlias: true)),
                    ),
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