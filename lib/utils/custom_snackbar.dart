import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

customSnakbar(title, message, type ){

  Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: type == "error"? Colors.red:Colors.green,
      colorText:Colors.white,
  );
}