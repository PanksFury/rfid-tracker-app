// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../utility/colors_constant.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  var controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    controller.checkForLogin();
    return Scaffold(
      // backgroundColor: Get.theme.splashColor,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Splash"),
      // ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.2),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: Get.height * 0.2,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.fitHeight,
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
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(top: Get.height * 0.25),
                    child: controller.isDisplayLoginSignup.value
                        ? Column(
                            children: [
                              SizedBox(
                                width: 150,
                                child: RoundedLoadingButton(
                                  height: 40,
                                  color: ColorsConstant.orange,
                                  borderRadius: 30,
                                  controller: controller.signupButton,
                                  onPressed: () => controller.onSignUp(),
                                  child: Text(
                                    'Sign Up',
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 150,
                                child: RoundedLoadingButton(
                                  height: 40,
                                  color: Get.theme.backgroundColor,
                                  borderRadius: 30,
                                  controller: controller.loginButton,
                                  onPressed: () => controller.onLogin(),
                                  child: Text(
                                    'Login',
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsConstant.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
