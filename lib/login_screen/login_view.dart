// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../components/custom_decoration.dart';
import '../signup_screen/signup_view.dart';
import '../utility/colors_constant.dart';
import '../utility/constant_class.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  var controller = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: Get.width * 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "MIRIFICAL INFRA",
                    style: Get.textTheme.titleMedium!.copyWith(
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "RFID Tracking",
                    style: Get.textTheme.titleMedium!.copyWith(
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Login",
                    style: Get.textTheme.titleSmall!.copyWith(
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.emailPhoneController.value,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.username],
                          validator: (username) {
                            if (username!.isEmpty) {
                              return "Email/Phone No required";
                            }

                            return null;
                          },
                          decoration: CustomInputDecoration(
                            'Email/Phone No',
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          autofocus: false,
                          style: Get.textTheme.bodySmall!
                              .copyWith(color: Colors.white),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.passwordController.value,
                          obscureText: controller.isPasswordHidden.value,
                          validator: (passwordText) {
                            if (passwordText == null) {
                              return 'Enter password is not valid';
                            }
                            if (passwordText.length <
                                AppConstants.passwordLength) {
                              return "Password should be ${AppConstants.passwordLength} digit atleast";
                            }
                            return null;
                          },
                          decoration: CustomInputDecorationForPassword(
                            'Password',
                            controller.isPasswordHidden,
                            const Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            ),
                          ),
                          autofocus: false,
                          style: Get.textTheme.bodySmall!
                              .copyWith(color: Colors.white),
                          onFieldSubmitted: (value) {
                            controller.loginButtonController.start();
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 200,
                          child: RoundedLoadingButton(
                            height: 40,
                            color: ColorsConstant.orange,
                            borderRadius: 30,
                            controller: controller.loginButtonController,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await controller.onLogin();
                              }
                              controller.loginButtonController.reset();
                            },
                            child: Text(
                              'Login',
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.backgroundColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => controller.onForgetPassword(),
                          child: Text(
                            "Forget Password?",
                            style: Get.textTheme.bodySmall!.copyWith(
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => Get.to(() => SignupView(), arguments: {
                            "isReadOnly": false,
                          }),
                          child: Text(
                            "Register Now",
                            style: Get.textTheme.bodySmall!.copyWith(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Text(
                        //   "Tracking Guide",
                        //   style: Get.textTheme.bodySmall!.copyWith(
                        //     color: Colors.white,
                        //     // fontWeight: FontWeight.bold,
                        //     fontSize: 12,
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   "Terms and Condition",
                        //   style: Get.textTheme.bodySmall!.copyWith(
                        //     color: Colors.white,
                        //     // fontWeight: FontWeight.bold,
                        //     fontSize: 12,
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
