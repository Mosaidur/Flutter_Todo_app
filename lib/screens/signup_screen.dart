import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:todo_app/controllers/signup_controller.dart';

import '../routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

final signupController = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GetBuilder<SignupController>(
            // in this builder: (controller) use to
            // access the value from signup_controller.dart file
              builder: (controller) {
              return Column(
                children:  [
                  const SizedBox(height: 50,),
                  const Text(
                    "My TODO",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 54,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 50,),
                  CustomTextField(
                    hint:"Name" ,
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 30,),
                  CustomTextField(
                    hint:"Address" ,
                    controller: controller.addressController,
                  ),
                  const SizedBox(height: 30,),
                  CustomTextField(
                    hint:"Contact" ,
                    controller: controller.contactController,
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
                  CustomTextField(
                    hint:"Confirm Password" ,
                    obscureText: true,
                    // controller: this is come from custrom_textfield widgets
                    //controller. comes from GetBuilder<SignupController> widgets
                    controller: controller.confirmPasswordController,
                  ),
                  const SizedBox(height: 30,),
                  CustomButton(label: 'Signup',onPressed: (){
                    controller.checkSignup();
                  },),
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
                          text: "Already have an account? ",
                        ),
                        TextSpan(
                          text: "Login",
                          recognizer: TapGestureRecognizer()..onTap=(){
                            Get.toNamed(GetRoutes.login);
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


