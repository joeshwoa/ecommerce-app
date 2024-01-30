import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({super.key,
    required this.hintText,
    required this.labelText,
    this.icon,
    this.mycontroller,
    this.obscureText,
    this.maxline,
    this.minline,
    this.validator,
    this.width,
    this.onPressedicon,
    this.initialValue,
    this.enabled,
    this.keyboardType,
    this.onChanged,
  this.focusNode});

  final String hintText;
  final String labelText;
  final IconData? icon;
  final TextEditingController? mycontroller;
  final bool? obscureText;
  final int? maxline;
  final int? minline;
  final double? width;
  final String? Function(String?)? validator;
  final void Function()? onPressedicon;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final bool? enabled;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        onChanged: onChanged??(value){},
        focusNode: focusNode,
        keyboardType: keyboardType,
        enabled: enabled,
        initialValue: initialValue,
        validator: validator ?? (value){return null;},
        maxLines: maxline?? 1,
        minLines: minline?? 1,
        cursorColor: AppColors.mainColor,
        obscureText: obscureText == null || obscureText == false ? false : true,
        controller: mycontroller,
        decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: MAsizes.textNormalSize),
            hintText: hintText,
            label: Container(
                margin: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(labelText)),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            suffixIcon: icon != null ?InkWell(onTap: onPressedicon, child: Icon(icon,color: AppColors.mainColor,)):null,
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),borderSide: const BorderSide(color: AppColors.mainColor,width: 2)),
            labelStyle: const TextStyle(color: AppColors.mainColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),borderSide: const BorderSide(color: AppColors.mainColor)),
        ),
      ),
    );
  }
}
