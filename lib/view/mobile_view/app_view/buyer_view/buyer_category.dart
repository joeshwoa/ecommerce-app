import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_category.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_category_card.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/model/category_model.dart';

class BuyerCategory extends StatefulWidget {
  const BuyerCategory({super.key,required this.cubit});
  final BuyerLayoutCubit cubit;

  @override
  State<BuyerCategory> createState() => _BuyerCategoryState();
}

class _BuyerCategoryState extends State<BuyerCategory> {

  List<Category> categories = [];
  int page = 1; // Initial page number
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        itemCounter = categories.length +1;
      });
      fetchData();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    fetchData(); // Fetch initial data when widget is initialized
  }

  @override
  void dispose(){
    super.dispose();
    fetchData().ignore();
    _controller.dispose();
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      if(mounted){
        setState(() {
          isLoading = true;
        });
      }

      final responseMap = await get("${ApiPaths.getCategories}$page").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Category> newCategories = [];

        for(int i=0;i<responseData["results"];i++){
          newCategories.add(createCategory(responseData["data"][i]));
        }

        if(mounted){
          setState(() {
            categories.addAll(newCategories);

            itemCounter = categories.length;
            page++; // Increment page number for the next API call
            isLoading = false;
          });
        }
      }  else if (responseMap['code'] == 999) {
        if (mounted) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
              backgroundColor: AppColors.mainColor,
              actions: [
                TextButton(
                  child: AppText(
                    'حسنا',
                    color: AppColors.textWhiteColor,
                    size: MAsizes.textNormalSize,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearMaterialBanners();
                  },
                ),
              ],
            ),
          );
          Timer(const Duration(seconds: 3), () {
            ScaffoldMessenger.of(context).clearMaterialBanners();
          });
        }
      }else {
        // Handle error case
      }
    }
  }

  Future<void> _refresh() async{
    setState(() {
      itemCounter = 1;
      page=1;
      categories.clear();
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MAsizes.screenH,
      width: MAsizes.screenW,
      child: !isLoading && categories.isEmpty?Center(
        child: AppText('لا يوجد فئات',color: AppColors.textGreenColor,size: MAsizes.textBigSize,),
      ):Column(
        children: [
          SizedBox(
            height: MAsizes.heightOfSmallEmptySpace/2,
          ),
          /*Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MAsizes.buttonHeight*1.5,
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
                    AppText('بحث', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
            ),
          ),*/
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: itemCounter, // Add 1 for the loading indicator
                itemBuilder: (context, index) {
                  if (index < categories.length) {
                    // Render category card
                    return MAcategoryCard(
                      imageBytes: categories[index].image,
                      name: categories[index].name,
                      id: categories[index].id,
                      cubit: widget.cubit,
                    );
                  } else if (isLoading) {
                    // Render loading indicator while fetching more data
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.mainColor,),
                    );
                  } else {
                    // Render an empty container at the end
                    return Container(
                    );
                  }
                },
                controller: _controller,
              ),
            ),
          ),
          SizedBox(
            height: MAsizes.heightOfMediumEmptySpace,
          ),
        ],
      ),
    );
  }
}
