import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:todo_app/controllers/login_controller.dart';
import 'package:todo_app/widgets/custom_button.dart';
import 'package:todo_app/widgets/custom_textfield.dart';

import '../routes.dart';

class Login_screen extends StatelessWidget {
  Login_screen({Key? key}) : super(key: key);

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GetBuilder<LoginController>(
            builder: (controller) {
              return Column(
                children:  [
                  const SizedBox(height: 130,),
                  const Text(
                      "My TODO",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 54,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  CustomTextField(
                    hint:"Email" ,
                    controller: controller.emailController,
                  ),
                  const SizedBox(height: 30,),
                  CustomTextField(
                    hint:"Password" ,
                    obscureText: true,
                    controller: controller.passwordController,
                  ),
                  const SizedBox(height: 30,),
                  CustomButton(label: 'Login',
                    onPressed: (){
                    controller.checklogin();
                    },
                  ),
                  const SizedBox(height: 20,),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Color(0xff949494),
                      ),
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                        ),
                        TextSpan(
                          text: "Sign up",
                          recognizer: TapGestureRecognizer()..onTap=(){
                            Get.toNamed(GetRoutes.signup);
                        },
                          style: const TextStyle(
                            color: Color(0xff1d3b78),
                            fontWeight: FontWeight.w600,
                        ),
                        ),
                      ],
                    ),
                    textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                    softWrap: false,
                  ),

                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
