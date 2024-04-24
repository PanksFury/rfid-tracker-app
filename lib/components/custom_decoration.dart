// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/colors_constant.dart';

/// Get the custom input decoration for textformfield
InputDecoration CustomInputDecoration(String hintText, Icon? icon,
    {String? labelText, Icon? suffixIcon}) {
  return InputDecoration(
    suffixIcon: suffixIcon,
    prefixIcon: icon,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: const BorderSide(color: Colors.white, width: 1.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      // borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    labelText: labelText,
    hintText: hintText,
    errorStyle: Get.textTheme.bodySmall!.copyWith(color: Colors.amber),
    fillColor: ColorsConstant.primary,
    filled: true,
    counterText: "",
    hintStyle: Get.textTheme.bodySmall!.copyWith(
      color: Colors.grey.shade300,
      fontWeight: FontWeight.w500,
    ),
    labelStyle: Get.textTheme.bodySmall!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}

/// Get the custom input decoration for textformfield
InputDecoration CustomInputDecorationForPassword(
    String hintText, dynamic isPasswordHidden, Icon icon,
    {String? labelText}) {
  return InputDecoration(
    prefixIcon: icon,
    suffixIcon: InkWell(
      onTap: () {
        isPasswordHidden.value = !isPasswordHidden.value;
      },
      child: Icon(
        isPasswordHidden.value ? Icons.visibility : Icons.visibility_off,
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: const BorderSide(color: Colors.white, width: 1.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    hintText: hintText,
    labelText: labelText,
    errorStyle: Get.textTheme.bodySmall!.copyWith(color: Colors.amber),
    fillColor: ColorsConstant.primary,
    filled: true,
    hintStyle: Get.textTheme.bodySmall!.copyWith(
      color: Colors.grey.shade300,
      fontWeight: FontWeight.w500,
    ),
    labelStyle: Get.textTheme.bodySmall!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}
