import 'dart:convert';
//import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/utils/baseurl.dart';
import 'package:todo_app/utils/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/utils/shared_prefs.dart';
import '../widgets/loader.dart';

class LoginController extends GetxController {
  late TextEditingController emailController, passwordController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkUser();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  checkUser() async {
    var user = SharedPrefs().getUser();
    if (user == null) {
      Get.toNamed(GetRoutes.home);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }

  checklogin() {
    if (emailController.text.isEmpty ||
        GetUtils.isEmail(emailController.text) == false) {
      customSnakbar("Error", "A valid email is required", "error");
    } else if (passwordController.text.isEmpty) {
      customSnakbar("Error", "Password is required", "error");
    } else {
      Get.showOverlay(
          asyncFunction: () => login(), loadingWidget: const Loader());
    }
  }

  login() async {
    var respons = await http.post(Uri.parse("${baseurl}index.php"), body: {
      "email": emailController.text,
      "password": passwordController.text
    });
    var res = await json.decode(respons.body);
    if (res["success"]) {
      customSnakbar("Success", res["message"], "success");
      User user = User.fromJson(res["user"]);
      await SharedPrefs().storeUser(json.encode(user));
      Get.offAllNamed(GetRoutes.home);
    } else {
      customSnakbar("Error", res["message"], "error");
    }
  }
}
