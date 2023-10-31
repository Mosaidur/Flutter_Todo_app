import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
//import 'package:http/http.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/utils/baseurl.dart';
import 'package:todo_app/utils/custom_snackbar.dart';

import '../widgets/loader.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  late TextEditingController nameController,
      contactController,
      addressController,
      emailController,
      passwordController,
      confirmPasswordController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    nameController = TextEditingController();
    contactController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  checkSignup() {
    if (nameController.text.isEmpty) {
      customSnakbar("Error", "Name is required", "error");
    } else if (addressController.text.isEmpty) {
      customSnakbar("Error", "Address is required", "error");
    } else if (contactController.text.isEmpty) {
      customSnakbar("Error", "Contact number is required", "error");
    } else if (emailController.text.isEmpty ||
        GetUtils.isEmail(emailController.text) == false) {
      customSnakbar("Error", "A Valid email is required", "error");
    } else if (passwordController.text.isEmpty) {
      customSnakbar("Error", "Password is required", "error");
    } else if (passwordController.text != confirmPasswordController.text) {
      customSnakbar("Error", "Password does not match", "error");
    } else {
      Get.showOverlay(asyncFunction: () => signup(), loadingWidget: const Loader());
    }
  }

  signup() async {
    var response = await http.post(Uri.parse("${baseurl}signup.php"), body: {
      "name": nameController.text,
      "contact": contactController.text,
      "address": addressController.text,
      "email": emailController.text,
      "password": passwordController.text
    });
    var res = await json.decode(response.body);
    if (res["success"]) {
      customSnakbar("Success", res["message"], "success");
      Get.offAllNamed(GetRoutes.login);
    } else {
      customSnakbar("Error", res["message"], "error");
    }
  }
}
