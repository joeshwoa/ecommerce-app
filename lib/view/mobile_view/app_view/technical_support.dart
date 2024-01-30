import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';

class MAtechnicalSupport extends StatefulWidget {
  const MAtechnicalSupport({super.key,required this.user});

  final bool user;

  @override
  State<MAtechnicalSupport> createState() => _MAtechnicalSupportState();
}

class _MAtechnicalSupportState extends State<MAtechnicalSupport> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController detailsController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('الدعم الفني',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SizedBox(
          height: MAsizes.screenH,
          width: MAsizes.screenW,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AppTextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'عنوان المشكلة لا يمكن ان يكون فارغ';
                        }
                        return null;
                      },
                      mycontroller: titleController,
                      hintText: 'عنوان المشكلة',
                      labelText: 'عنوان المشكلة',
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AppTextFormField(
                      minline: 15,
                      maxline: 25,
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'تفاصيل المشكلة لا يمكن ان تكون فارغة';
                        }
                        return null;
                      },
                      mycontroller: detailsController,
                      hintText: 'تفاصيل المشكلة',
                      labelText: 'تفاصيل المشكلة',
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText('للتواصل مع الدعم عن طريق البريد الالكتروني',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText('support@klnakhadm.com',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate())
                        {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('جاري ارسال مشكلتك للدعم الفني',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Map<String,dynamic> data = {
                            'title':titleController.text,
                            'description':detailsController.text,
                            if(widget.user)'user':sharedPreferences.getString('token'),
                            if(!widget.user)'seller':sharedPreferences.getString('token'),
                          };
                          Map responseMap = await post(ApiPaths.sendProblemToTechnicalSupport,data).onError((error, stackTrace) {
                            return {
                              'code':999
                            };
                          });
                          if((responseMap['code']>=200 && responseMap['code']<300)){
                            if (context.mounted){
                              setState(() {
                                detailsController.clear();
                                titleController.clear();
                              });
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('تم ارسال المشكلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          } else if (responseMap['code'] == 999) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                  backgroundColor: AppColors.mainColor,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }else{
                            if (context.mounted){
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: AppText('فشل ارسال المشكلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                          width: MAsizes.buttonBigWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                              color: AppColors.buttonGreenColor
                          ),
                          child: Center(child: AppText('ارسال المشكلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
