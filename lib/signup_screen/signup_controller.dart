import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:trainrsid/model/RegisterModel.dart';

import '../admin_screen/userlist_screen/userlist_controller.dart';
import '../components/custom_decoration.dart';
import '../login_screen/login_view.dart';
import '../model/UserListModel.dart';
import '../model/UserModel.dart';
import '../utility/colors_constant.dart';
import '../utility/constant_class.dart';
import 'signup_service.dart';

// ignore: camel_case_types, constant_identifier_names
enum SIGNUP_ENUM { READONLY, EDIT, ADD }

class SignupController extends GetxController {
  RoundedLoadingButtonController signupButtonController =
      RoundedLoadingButtonController();

  RoundedLoadingButtonController verifyMobileButtonController =
      RoundedLoadingButtonController();

  var usernameController = TextEditingController().obs;
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var mobileNoController = TextEditingController().obs;
  var otpController = TextEditingController().obs;
  var companyNameController = TextEditingController().obs;
  var companyAddressController = TextEditingController().obs;
  var companyEmailIdController = TextEditingController().obs;
  var roleController = TextEditingController().obs;
  // var productTypeController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var confirmPassword = TextEditingController().obs;

  var isPasswordHide = true.obs;
  var isPasswordConfirmHide = true.obs;

  var isTermsAndConditionChecked = false.obs;
  var isVerifyOTP = true.obs; //Set to false once otp is done

  var roles = ["Professor", "Principle"];
  // var productType = ["A Product", "B Product"];

  var isReadOnly = false.obs;
  var editUserModel = UserModel();
  var isLoading = true.obs;
  var isEdit = false.obs;
  var isAdmin = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    var data = Get.arguments;
    isReadOnly.value = data["isReadOnly"] ?? false;
    isEdit.value = data["isEdit"] ?? false;
    isAdmin.value = data["isAdmin"] ?? false;
    if (isReadOnly.value || isEdit.value) {
      isVerifyOTP.value = true;
      if (isReadOnly.value) {
        editUserModel = data["data"];
        populateEdit(editUserModel);
      }
      if (isEdit.value) {
        editUserModel = data["data"];
        print("GOT ID: ${editUserModel.id}");
      }
      await getUserById();
    }
    isLoading.value = false;
  }

  Future<void> sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${mobileNoController.value.text}',
      verificationCompleted: (PhoneAuthCredential credential) {
        verifyMobileButtonController.reset();
        AppConstants.displaySuccessfulSnackbar("Verification Completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        verifyMobileButtonController.reset();
        if (e.code == 'invalid-phone-number') {
          AppConstants.displayErrorSnackbar(
              'The provided phone number is not valid.');
          return;
        }
        debugPrint("VERIFICATION FAILED: ${e.message}");
        AppConstants.displayErrorSnackbar(e.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        verifyMobileButtonController.reset();
        print("TOKEN: $resendToken, $verificationId");
        AppConstants.displaySuccessfulSnackbar("Code Sent Successfully");
        RoundedLoadingButtonController verifyOTPController =
            RoundedLoadingButtonController();
        Get.dialog(
          AlertDialog(
            title: Text(
              "Verify OTP",
              style: Get.textTheme.bodyMedium!.copyWith(
                color: ColorsConstant.primary,
              ),
            ),
            content: TextFormField(
              controller: otpController.value,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.telephoneNumber],
              maxLength: 6,
              decoration: CustomInputDecoration(
                'Your OTP',
                const Icon(
                  Icons.numbers,
                  color: Colors.white,
                ),
              ),
              autofocus: false,
              style: Get.textTheme.bodyMedium!.copyWith(color: Colors.white),
              textInputAction: TextInputAction.next,
            ),
            actions: [
              RoundedLoadingButton(
                color: ColorsConstant.orange,
                borderRadius: 30,
                controller: verifyOTPController,
                onPressed: () async {
                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;

                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: otpController.value.text);

                    await auth.signInWithCredential(credential);
                    isVerifyOTP.value = true;
                    otpController.value.text = "";
                    Get.back();
                  } catch (e) {
                    AppConstants.displayErrorSnackbar(e.toString());
                  }
                  verifyOTPController.reset();
                },
                child: Text(
                  'Verify',
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verifyMobileButtonController.reset();
        // ConstantClass.displayErrorSnackbar("SMS timeout");
      },
    );
  }

  void populateEdit(UserModel data) {
    editUserModel = data;
    firstNameController.value.text = editUserModel.firstName ?? "";
    lastNameController.value.text = editUserModel.lastName ?? "";
    emailController.value.text = editUserModel.email ?? "";
    mobileNoController.value.text = editUserModel.mobile ?? "";
    companyNameController.value.text = editUserModel.companyName ?? "";
    companyAddressController.value.text = editUserModel.companyAddress ?? "";
    companyEmailIdController.value.text = editUserModel.companyEmail ?? "";
    roleController.value.text = editUserModel.roleInCompany ?? "";
  }

  Future<void> onSignup() async {
    if (isEdit.value) {
      await updateUser();
    } else {
      await doRegister();
    }
  }

  Future<void> doRegister() async {
    var service = SignupService();
    Map<String, dynamic> result = await service.register(FormData({
      "firstname": firstNameController.value.text.trim(),
      "lastname": lastNameController.value.text.trim(),
      "email": emailController.value.text.trim(),
      "mobile": mobileNoController.value.text.trim(),
      "password": passwordController.value.text,
      "company_name": companyNameController.value.text.trim(),
      "company_address": companyAddressController.value.text.trim(),
      "company_email_id": companyEmailIdController.value.text.trim(),
      "role_in_company": roleController.value.text.trim(),
    }));

    signupButtonController.reset();
    if (result["success"] == 1) {
      RegisterModel registerModel = RegisterModel.fromJson(result["data"]);
      if (registerModel.success!) {
        if (isAdmin.value) {
          Get.back();
          var userController = Get.put(UserListController());
          userController.currentPage.value = 1;
          userController.isLoading.value = true;
          await userController.getUsers();
          userController.isLoading.value = false;
        } else {
          Get.to(() => LoginView());
        }

        AppConstants.displaySuccessfulSnackbar(registerModel.message!);
      } else {
        AppConstants.displayErrorSnackbar(registerModel.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
  }

  Future<void> getUserById() async {
    var service = SignupService();
    Map<String, dynamic> result = await service.getUserById(editUserModel.id!);

    if (result["success"] == 1) {
      UserListModel userData = UserListModel.fromSingleJson(result["data"]);
      if (userData.success!) {
        print("${userData.userData.toJson()}");
        populateEdit(userData.userData);
        // ConstantClass.displaySuccessfulSnackbar(userData.message!);
      } else {
        AppConstants.displayErrorSnackbar(userData.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
  }

  Future<void> updateUser() async {
    var service = SignupService();
    Map<String, dynamic> rawData = {
      "firstname": firstNameController.value.text.trim(),
      "lastname": lastNameController.value.text.trim(),
      // "email": emailController.value.text.trim(),
      "mobile": mobileNoController.value.text.trim(),
      // "password": passwordController.value.text,
      "company_name": companyNameController.value.text.trim(),
      "company_address": companyAddressController.value.text.trim(),
      "company_email_id": companyEmailIdController.value.text.trim(),
      "role_in_company": roleController.value.text.trim(),
    };

    if (isAdmin.value) {
      //only admin can update email and mobile
      rawData["email"] = emailController.value.text.trim();
      rawData["mobile"] = mobileNoController.value.text.trim();
    }

    Map<String, dynamic> result =
        await service.updateUser(editUserModel.id!, rawData);

    if (result["success"] == 1) {
      UserListModel userData = UserListModel.fromSingleJson(result["data"]);
      if (userData.success!) {
        print("${userData.userData.toJson()}");
        populateEdit(userData.userData);
        AppConstants.displaySuccessfulSnackbar(userData.message!);
        AppConstants.setAuthHeader(
          RegisterModel(userModel: userData.userData),
        );
      } else {
        AppConstants.displayErrorSnackbar(userData.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
  }
}
