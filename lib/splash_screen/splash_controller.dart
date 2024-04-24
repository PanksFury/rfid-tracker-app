import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../admin_screen/admin_view.dart';
import '../login_screen/login_view.dart';
import '../model/RegisterModel.dart';
import '../signup_screen/signup_view.dart';
import '../user_screen/user_view.dart';
import '../utility/constant_class.dart';
import 'splash_service.dart';

class SplashController extends GetxController {
  RoundedLoadingButtonController signupButton =
      RoundedLoadingButtonController();
  RoundedLoadingButtonController loginButton = RoundedLoadingButtonController();

  var isDisplayLoginSignup = false.obs;

  var isCheckLoginInvoked = false;

  var isLogout = false;

  @override
  void onInit() {
    super.onInit();
    isLogout = Get.arguments ?? false;
    if (isLogout) {
      isDisplayLoginSignup.value = true;
    } else {
      if (!isCheckLoginInvoked) {
        checkForLogin();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (isLogout) {
      isDisplayLoginSignup.value = true;
    } else {
      if (!isCheckLoginInvoked) {
        checkForLogin();
      }
    }
  }

  void onSignUp() {
    Get.to(() => SignupView(), arguments: {
      "isReadOnly": false,
    });
    signupButton.reset();
  }

  void onLogin() {
    Get.to(() => LoginView());
    loginButton.reset();
  }

  void checkForLogin() async {
    isCheckLoginInvoked = true;
    var box = GetStorage();
    if (!box.hasData(AppConstants.userId)) {
      isDisplayLoginSignup.value = true;
    } else {
      var service = SplashService();
      Map<String, dynamic> result = await service.getUserByToken();

      if (result["success"] == 1) {
        RegisterModel registerModel = RegisterModel.fromJson(result["data"]);
        if (registerModel.success!) {
          isDisplayLoginSignup.value = false;
          if (registerModel.userModel!.status == STATUS.APPROVED.index) {
            await AppConstants.setAuthHeader(registerModel);
            AppConstants.displaySuccessfulSnackbar(registerModel.message!);
            if (registerModel.userModel!.roleId == ROLE.ADMIN.index) {
              Get.offAll(() => AdminView());
            } else {
              Get.offAll(() => UserView());
            }
            return;
          } else if (registerModel.userModel!.status == STATUS.PENDING.index) {
            AppConstants.displayErrorSnackbar(
                "Your request is pending. Please wait until admin approves.",
                title: "Request Pending");
          } else {
            AppConstants.displayErrorSnackbar(
                "Your request is rejected. Please contact admin",
                title: "Request Rejected");
          }
        } else {
          AppConstants.displayErrorSnackbar(registerModel.message!);
        }
      } else {
        AppConstants.displaySomethingWentWrongSnackbar();
      }

      isDisplayLoginSignup.value = true;
    }
  }
}
