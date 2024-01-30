import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/send_and_resive_image_methods/encode.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_information_compeleted.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SellerCompleteYourInformation extends StatefulWidget {
  const SellerCompleteYourInformation({super.key});

  @override
  State<SellerCompleteYourInformation> createState() => _SellerCompleteYourInformationState();
}

class _SellerCompleteYourInformationState extends State<SellerCompleteYourInformation> {
  TextEditingController idController = TextEditingController();

  TextEditingController ibanController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController areaController = TextEditingController();

  TextEditingController supAreaController = TextEditingController();

  TextEditingController streetController = TextEditingController();

  TextEditingController registerNumberController = TextEditingController();

  late String dropdownValue;
  late String dropdownValueID;
  bool loading = true;
  bool registeredWithTaxes = false;
  Map responseMap = {};
  List<String> bank = [];
  List<String> bankID = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool acceptPolicy = false;

  File? vatImage;

  File? registerImage;

  File? vatPdf;

  File? registerPdf;

  Future<void> _pickVatImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source,imageQuality: 25);

    setState(() {
      if (pickedImage != null) {
        vatImage = File(pickedImage.path) ;
      } else {
        vatImage = null;
      }
    });
  }

  Future<void> _pickRegisterImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source,imageQuality: 25);

    setState(() {
      if (pickedImage != null) {
        registerImage = File(pickedImage.path) ;
      } else {
        registerImage = null;
      }
    });
  }

  Future<void> _pickRegisterFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      if (result != null) {
        registerPdf = File(result.files.single.path!) ;
      } else {
        registerPdf = null;
      }
    });
  }

  Future<void> _pickVatFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      if (result != null) {
        vatPdf = File(result.files.single.path!) ;
      } else {
        vatPdf = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(loading)
    {
      get(ApiPaths.getBanks).then((value){
        responseMap=value;
        if((responseMap['code']>=200 && responseMap['code']<300))
        {
          for(int i=0;i<responseMap['body']['results'];i++)
          {
            bank.add(responseMap['body']['data'][i]['name']);
            bankID.add(responseMap['body']['data'][i]['_id']);
          }
          dropdownValue = bank.first;
          dropdownValueID = bankID.first;
          setState(() {
            loading = false;
          });
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
              backgroundColor: AppColors.mainColor,
              showCloseIcon: true,
            ),
          );
        }
      });
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('المعلومات الاساسية',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: loading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),):Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'رقم الهوية الوطنية لا يمكن ان يكون فارغ';
                        }
                        else if (value.length != 10)
                        {
                          return 'رقم الهوية يجب ان يكون مكون من عشرة ارقام';
                        }
                        return null;
                      },
                      mycontroller: idController,
                      hintText: 'رقم الهوية الوطنية',
                      labelText: 'رقم الهوية الوطنية',
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'رقم IBAN لا يمكن ان يكون فارغ';
                        }
                        else if (value.length != 22)
                        {
                          return 'رقم IBAN يجب ان يكون مكون من اثنين و عشرون';
                        }
                        return null;
                      },
                      mycontroller: ibanController,
                      hintText: 'رقم IBAN من بعد ال SA',
                      labelText: 'رقم IBAN',
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            style: const TextStyle(color: AppColors.mainColor),
                            underline: Container(
                              height: 2,
                              color: AppColors.mainColor,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: bank.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        AppText('البنك التابع له: بنك',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText('هل انت مسجل بالضرائب ؟',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToggleSwitch(
                          minWidth: MAsizes.buttonNormalWidth,
                          initialLabelIndex: registeredWithTaxes?1:0,
                          cornerRadius: MAsizes.buttonBorderRadius,
                          activeFgColor: AppColors.textWhiteColor,
                          inactiveBgColor: AppColors.offWhiteBoxColor,
                          inactiveFgColor: AppColors.textGreenColor,
                          totalSwitches: 2,
                          customTextStyles: const [TextStyle(
                            fontFamily: 'El_Messiri',
                          ),TextStyle(
                            fontFamily: 'El_Messiri',
                          )],
                          labels: const ['لا', 'نعم'],
                          activeBgColors: const [[AppColors.mainColor],[AppColors.mainColor]],
                          onToggle: (i){
                            if(i == 0){
                              setState(() {
                                registerNumberController.clear();
                                registeredWithTaxes = false;
                              });
                            } else if (i == 1){
                              setState(() {
                                registeredWithTaxes = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if(registeredWithTaxes) Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            validator: (value){
                              if(registeredWithTaxes&&(value == null || value.isEmpty || value.characters == Characters(' ')))
                              {
                                return 'رقم التسجيل الضريبي لا يمكن ان يكون فارغ';
                              } else if(registeredWithTaxes&& value!.length != 15)
                              {
                                return 'رقم التسجيل الضريبي يجب ان يكون مكون من 15 رقم';
                              }
                              return null;
                            },
                            mycontroller: registerNumberController,
                            hintText: 'رقم التسجيل بالضرائب',
                            labelText: 'رقم التسجيل بالضرائب',
                            keyboardType: const TextInputType.numberWithOptions(decimal: false,signed: false),
                          ),
                        ),
                        SizedBox(
                          width: MAsizes.widthOfSmallEmptySpace,
                        ),
                        AppText('رقم التسجيل بالضرائب',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  if(registeredWithTaxes) Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText('ارفق صورة الهوية الوطنية او السجل التجاري و شهادة التسجيل',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  if(!registeredWithTaxes) Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText('ارفق صورة الهوية الوطنية او السجل التجاري ',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  if(registerPdf == null) Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText('الصورة الهوية او السجل التجاري',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  if(registerPdf == null) Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if(registerImage != null) Expanded(
                          flex: 1,
                          child: MaterialButton(
                            onPressed: (){
                              setState(() {
                                registerImage = null;
                              });
                            },
                            child: const Center(child: Icon(Icons.cancel_outlined,color: Colors.red)),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: registerImage != null ? Image.file(registerImage!) : const SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            onPressed: (){
                              _pickRegisterImage(ImageSource.gallery);
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                /*width: MAsizes.buttonBigWidth,*/
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: AppColors.buttonGreenColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child: AppText('المعرض',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            onPressed: (){
                              _pickRegisterImage(ImageSource.camera);
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                /*width: MAsizes.buttonBigWidth,*/
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: AppColors.buttonGreenColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child: AppText('الكاميرا',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(registerImage == null) Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText('ملف الهوية او السجل التجاري',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  if(registerImage == null) Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if(registerPdf != null) Expanded(
                          flex: 1,
                          child: MaterialButton(
                            onPressed: (){
                              setState(() {
                                registerPdf = null;
                              });
                            },
                            child: const Center(child: Icon(Icons.cancel_outlined,color: Colors.red)),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: registerPdf != null ? AppText(registerPdf!.path,color: AppColors.textGreenColor,size: MAsizes.textNormalSize,) : const SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            onPressed: (){
                              _pickRegisterFile();
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                /*width: MAsizes.buttonBigWidth,*/
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: AppColors.buttonGreenColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child: AppText('الهاتف',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(registeredWithTaxes&&vatPdf == null) Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText('صورة شهادة التسجيل',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  if(registeredWithTaxes&&vatPdf == null) Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if(vatImage != null) Expanded(
                          flex: 1,
                          child: MaterialButton(
                            onPressed: (){
                              setState(() {
                                vatImage = null;
                              });
                            },
                            child: const Center(child: Icon(Icons.cancel_outlined,color: Colors.red)),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: vatImage != null ? Image.file(vatImage!) : const SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            onPressed: (){
                              _pickVatImage(ImageSource.gallery);
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                /*width: MAsizes.buttonBigWidth,*/
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: AppColors.buttonGreenColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child: AppText('المعرض',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            onPressed: (){
                              _pickVatImage(ImageSource.camera);
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                /*width: MAsizes.buttonBigWidth,*/
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: AppColors.buttonGreenColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child: AppText('الكاميرا',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(registeredWithTaxes&&vatImage == null) Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText('ملف شهادة التسجيل',color: AppColors.textGreenColor,size: MAsizes.textNormalSize,)
                      ],
                    ),
                  ),
                  if(registeredWithTaxes&&vatImage == null) Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if(vatPdf != null) Expanded(
                          flex: 1,
                          child: MaterialButton(
                            onPressed: (){
                              setState(() {
                                vatPdf = null;
                              });
                            },
                            child: const Center(child: Icon(Icons.cancel_outlined,color: Colors.red)),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: vatPdf != null ? AppText(vatPdf!.path,color: AppColors.textGreenColor,size: MAsizes.textNormalSize,) : const SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            onPressed: (){
                              _pickVatFile();
                            },
                            child: Container(
                                height: MAsizes.buttonHeight,
                                /*width: MAsizes.buttonBigWidth,*/
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                    color: AppColors.buttonGreenColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child: AppText('الهاتف',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Checkbox(
                          activeColor: AppColors.mainColor,
                          side: BorderSide(color: acceptPolicy?AppColors.mainColor:Colors.red),
                          value: acceptPolicy,
                          onChanged: (value){
                            setState(() {
                              acceptPolicy = value!;
                            });
                          },
                        ),
                        AppText('اقر بأن معلوماتي أعلاه صحيحة و اتحمل مسؤولية اي خطأ ',size: MAsizes.textNormalSize*4/5,color: AppColors.textGreenColor,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 1,
                      width: MAsizes.screenW,
                      decoration: const BoxDecoration(
                        color: AppColors.buttonGreenColor
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppText('العنوان',size: MAsizes.textBetweenNormalAndBigSize,color: AppColors.textGreenColor,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'اسم المدينة لا يمكن ان يكون فارغ';
                        }
                        return null;
                      },
                      mycontroller: cityController,
                      hintText: 'المدينة',
                      labelText: 'المدينة',
                      icon: Icons.location_city,
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'اسم المنطقة لا يمكن ان يكون فارغ';
                        }
                        return null;
                      },
                      mycontroller: areaController,
                      hintText: 'المنطقة',
                      labelText: 'المنطقة',
                      icon: Icons.location_city,
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'اسم الحي لا يمكن ان يكون فارغ';
                        }
                        return null;
                      },
                      mycontroller: supAreaController,
                      hintText: 'الحي',
                      labelText: 'الحي',
                      icon: Icons.location_city,
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty || value.characters == Characters(' '))
                        {
                          return 'اسم الشارع لا يمكن ان يكون فارغ';
                        }
                        return null;
                      },
                      mycontroller: streetController,
                      hintText: 'الشارع',
                      labelText: 'الشارع',
                      icon: Icons.location_city,
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate() && acceptPolicy && (registerImage != null || registerPdf != null) && (!registeredWithTaxes || vatImage != null || vatPdf != null))
                        {
                          {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: AppText('جاري ارسال البيانات',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                backgroundColor: AppColors.mainColor,
                                showCloseIcon: true,
                              ),
                            );
                            String? token = sharedPreferences.getString('token');
                            late String vatFileEncoded;
                            if(registeredWithTaxes) {
                              vatFileEncoded = vatImage != null ? await encode(vatImage!):await encode(vatPdf!);
                            }
                            String registerFileEncoded = registerImage != null ? await encode(registerImage!):await encode(registerPdf!);
                            Map<String,dynamic> data = {
                              'nationalID':idController.text,
                              'IBAN':'SA${ibanController.text}',
                              'town':cityController.text,
                              'region':areaController.text,
                              'area':supAreaController.text,
                              'street':streetController.text,
                              'owner':token,
                              'registered':registeredWithTaxes,
                              'registerNumber':registerNumberController.text,
                              'registerImage':registerFileEncoded,
                              if(registeredWithTaxes)'vatImage':vatFileEncoded,
                            };
                            Map responseMap = await post(ApiPaths.createMarket,data).onError((error, stackTrace) {
                              return {
                                'code':999
                              };
                            });
                            if((responseMap['code']>=200 && responseMap['code']<300)){
                              if (context.mounted){
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('تم اكمال البيانات و انشاء متجر لك',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                                userType = 'sellerComplete';
                                sharedPreferences.setBool("registered", registeredWithTaxes);
                                sharedPreferences.setString("userType", userType);
                                final String marketId = responseMap['body']['data']['_id'];
                                sharedPreferences.setString('marketID', marketId);

                                sharedPreferences.setString('city', cityController.text);
                                sharedPreferences.setString('area', areaController.text);
                                sharedPreferences.setString('supArea', supAreaController.text);
                                sharedPreferences.setString('street', streetController.text);

                                Timer(const Duration(seconds: 1), () {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SellerInformationCompeleted()));
                                });
                              }
                            }
                            else if(responseMap['code']==500 && responseMap['body']['error']['keyPattern']['nationalID'] != null){
                              if (context.mounted){
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('فشل في اكمال البيانات. رقم الهوية مستخدم من قبل',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }else if(responseMap['code']==500 && responseMap['body']['error']['keyPattern']['IBAN'] != null){
                              if (context.mounted){
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: AppText('فشل في اكمال البيانات. رقم IBAN مستخدم من قبل',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
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
                                    content: Center(child: AppText('فشل في اكمال البيانات',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                                    backgroundColor: AppColors.mainColor,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }
                          }
                        }
                      },
                      child: Container(
                          height: MAsizes.buttonHeight,
                          width: MAsizes.buttonBigWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                              color: (acceptPolicy && (registerImage != null || registerPdf != null) && (!registeredWithTaxes || vatImage != null || vatPdf != null))?AppColors.buttonGreenColor:Colors.grey
                          ),
                          child: Center(child: AppText('حفظ المعلومات',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
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