import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:trainrsid/user_screen/user_view.dart';

import '../admin_screen/admin_view.dart';
import '../components/custom_decoration.dart';
import '../model/RegisterModel.dart';
import '../utility/colors_constant.dart';
import '../utility/constant_class.dart';
import 'login_service.dart';

class LoginController extends GetxController {
  RoundedLoadingButtonController loginButtonController =
      RoundedLoadingButtonController();

  var emailPhoneController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  var isPasswordHidden = true.obs;

  onLogin() async {
    await doLogin();
  }

  onForgetPassword() async {
    var forgetPasswordTextController = TextEditingController();
    var forgetPasswordButtonController = RoundedLoadingButtonController();
    Get.dialog(
      AlertDialog(
        title: Text(
          "Forget Password",
          style: Get.textTheme.bodyMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: forgetPasswordTextController,
              decoration: CustomInputDecoration(
                'Enter your email',
                const Icon(
                  Icons.date_range,
                  color: Colors.white,
                ),
              ),
              autofocus: false,
              style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RoundedLoadingButton(
              height: 40,
              color: ColorsConstant.orange,
              borderRadius: 10,
              controller: forgetPasswordButtonController,
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                forgetPasswordButtonController.reset();
                AppConstants.displayErrorSnackbar("Under Development",
                    title: "Inform");
              },
              child: Text(
                'Okay',
                style: Get.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.backgroundColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doLogin() async {
    var service = LoginService();
    Map<String, dynamic> result = await service.login(FormData({
      "username": emailPhoneController.value.text.trim(),
      "password": passwordController.value.text,
    }));

    if (result["success"] == 1) {
      RegisterModel registerModel = RegisterModel.fromJson(result["data"]);
      if (registerModel.success!) {
        if (registerModel.userModel!.roleId == ROLE.ADMIN.index) {
          await AppConstants.setAuthHeader(registerModel);
          AppConstants.displaySuccessfulSnackbar(registerModel.message!);
          Get.offAll(() => AdminView());
        } else {
          if (registerModel.userModel!.status == STATUS.APPROVED.index) {
            await AppConstants.setAuthHeader(registerModel);
            AppConstants.displaySuccessfulSnackbar(registerModel.message!);
            Get.offAll(() => UserView());
          } else if (registerModel.userModel!.status == STATUS.PENDING.index) {
            AppConstants.displayErrorSnackbar(
                registerModel.userModel!.message ?? "",
                title: "Request Pending");
          } else {
            AppConstants.displayErrorSnackbar(
                registerModel.userModel!.message ?? "",
                title: "Request Rejected");
          }
        }
      } else {
        if (registerModel.error == null) {
          AppConstants.displayErrorSnackbar(registerModel.message!);
        } else {
          AppConstants.displayErrorSnackbar(registerModel.error!,
              title: registerModel.message!);
        }
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }

    loginButtonController.reset();
  }
}
