// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:trainrsid/utility/constant_class.dart';

import '../components/custom_decoration.dart';
import '../utility/colors_constant.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  @override
  var controller = Get.put(SignupController());

  final _formKey = GlobalKey<FormState>();

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: (!controller.isReadOnly.value &&
                              !controller.isEdit.value),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Welcome To",
                              style: Get.textTheme.titleMedium!.copyWith(
                                // color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: (!controller.isReadOnly.value &&
                                !controller.isEdit.value),
                            child: const SizedBox(height: 10)),
                        Visibility(
                          visible: (!controller.isReadOnly.value &&
                              !controller.isEdit.value),
                          child: Text(
                            "MIRIFICAL INFRA",
                            style: Get.textTheme.titleLarge!.copyWith(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.isEdit.value
                              ? "Your Profile"
                              : controller.isReadOnly.value
                                  ? "Agent Details"
                                  : "Register Now",
                          style: Get.textTheme.titleMedium!.copyWith(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // TextFormField(
                              //   controller: controller.usernameController.value,
                              //   keyboardType: TextInputType.name,
                              //   autofillHints: const [AutofillHints.username],
                              //   validator: (username) {
                              //     if (username!.isEmpty) {
                              //       return "Username is required";
                              //     }

                              //     return null;
                              //   },
                              //   decoration: CustomInputDecoration(
                              //     'Username',
                              //     const Icon(
                              //       Icons.person,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   autofocus: false,
                              //   style: Get.textTheme.bodySmall!
                              //       .copyWith(color: Colors.white),
                              //   textInputAction: TextInputAction.next,
                              // ),
                              // const SizedBox(height: 20),
                              TextFormField(
                                readOnly: controller.isReadOnly.value,
                                controller:
                                    controller.firstNameController.value,
                                keyboardType: TextInputType.name,
                                autofillHints: const [AutofillHints.username],
                                validator: (username) {
                                  if (username!.isEmpty) {
                                    return "First name is required";
                                  }

                                  return null;
                                },
                                decoration: CustomInputDecoration(
                                  'First Name',
                                  const Icon(
                                    Icons.label_important,
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
                                readOnly: controller.isReadOnly.value,
                                controller: controller.lastNameController.value,
                                keyboardType: TextInputType.name,
                                autofillHints: const [AutofillHints.username],
                                validator: (username) {
                                  if (username!.isEmpty) {
                                    return "Last name is required";
                                  }

                                  return null;
                                },
                                decoration: CustomInputDecoration(
                                  'Last Name',
                                  const Icon(
                                    Icons.label,
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
                                onTap: () {
                                  if (controller.isEdit.value &&
                                      !controller.isAdmin.value) {
                                    AppConstants.displayValidationErrorSnackbar(
                                        "You can't edit this fields");
                                  }
                                },
                                readOnly: (controller.isEdit.value &&
                                        !controller.isAdmin.value)
                                    ? true
                                    : controller.isReadOnly.value,
                                controller: controller.emailController.value,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                validator: (username) {
                                  if (username!.isEmpty) {
                                    return "Email Id is required";
                                  }

                                  return null;
                                },
                                decoration: CustomInputDecoration(
                                  'Email Id',
                                  const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                ),
                                autofocus: false,
                                style: Get.textTheme.bodySmall!
                                    .copyWith(color: Colors.white),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      // onTap: () {
                                      //   if (controller.isEdit.value &&
                                      //       !controller.isAdmin.value) {
                                      //     ConstantClass
                                      //         .displayValidationErrorSnackbar(
                                      //             "You can't edit this fields");
                                      //   }
                                      // },
                                      // readOnly: (controller.isEdit.value &&
                                      //         !controller.isAdmin.value)
                                      //     ? true
                                      //     : controller.isReadOnly.value,
                                      readOnly: controller.isReadOnly.value,
                                      controller:
                                          controller.mobileNoController.value,
                                      keyboardType: TextInputType.number,
                                      autofillHints: const [
                                        AutofillHints.telephoneNumber
                                      ],
                                      maxLength: 10,
                                      validator: (username) {
                                        if (username!.isEmpty) {
                                          return "Mobile no is required";
                                        }

                                        return null;
                                      },
                                      // onChanged: (value) =>
                                      //     controller.isVerifyOTP.value = false,
                                      decoration: CustomInputDecoration(
                                        'Mobile No',
                                        const Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // .copyWith(
                                      //   suffixIcon: Icon(
                                      //     controller.isVerifyOTP.value
                                      //         ? Icons.verified
                                      //         : Icons.report,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                      autofocus: false,
                                      style: Get.textTheme.bodySmall!
                                          .copyWith(color: Colors.white),
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  // Visibility(
                                  //   visible: controller.isEdit.value
                                  //       ? true
                                  //       : !controller.isReadOnly.value,
                                  //   child: Expanded(
                                  //     flex: 2,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(8.0),
                                  //       child: RoundedLoadingButton(
                                  //         color: ColorsConstant.orange,
                                  //         borderRadius: 30,
                                  //         controller: controller
                                  //             .verifyMobileButtonController,
                                  //         onPressed: () async {
                                  //           await controller.sendOTP();
                                  //         },
                                  //         child: Text(
                                  //           'Verify',
                                  //           style: Get.textTheme.bodySmall!
                                  //               .copyWith(
                                  //             fontWeight: FontWeight.bold,
                                  //             color: Get.theme.backgroundColor,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                readOnly: controller.isReadOnly.value,
                                controller:
                                    controller.companyNameController.value,
                                keyboardType: TextInputType.name,
                                autofillHints: const [AutofillHints.name],
                                validator: (username) {
                                  if (username!.isEmpty) {
                                    return "Company Name is required";
                                  }

                                  return null;
                                },
                                decoration: CustomInputDecoration(
                                  'Company Name',
                                  const Icon(
                                    Icons.abc,
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
                                readOnly: controller.isReadOnly.value,
                                controller:
                                    controller.companyAddressController.value,
                                keyboardType: TextInputType.streetAddress,
                                autofillHints: const [
                                  AutofillHints.streetAddressLevel1
                                ],
                                validator: (username) {
                                  if (username!.isEmpty) {
                                    return "Company Address is required";
                                  }

                                  return null;
                                },
                                decoration: CustomInputDecoration(
                                  'Company Address',
                                  const Icon(
                                    Icons.location_on,
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
                                readOnly: controller.isReadOnly.value,
                                controller:
                                    controller.companyEmailIdController.value,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                validator: (username) {
                                  if (username!.isEmpty) {
                                    return "Company Email Id is required";
                                  }

                                  return null;
                                },
                                decoration: CustomInputDecoration(
                                  'Company Email Id',
                                  const Icon(
                                    Icons.email,
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
                                readOnly: controller.isReadOnly.value,
                                controller: controller.roleController.value,
                                keyboardType: TextInputType.name,
                                autofillHints: const [AutofillHints.name],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Role is Required";
                                  }

                                  return null;
                                },
                                decoration: CustomInputDecoration(
                                  "Your Role in Company",
                                  const Icon(
                                    Icons.abc,
                                    color: Colors.white,
                                  ),
                                ),
                                autofocus: false,
                                style: Get.textTheme.bodySmall!
                                    .copyWith(color: Colors.white),
                                textInputAction: TextInputAction.next,
                              ),
                              Visibility(
                                  visible: (!controller.isReadOnly.value &&
                                      !controller.isEdit.value),
                                  child: const SizedBox(height: 20)),
                              Visibility(
                                visible: (!controller.isReadOnly.value &&
                                    !controller.isEdit.value),
                                child: TextFormField(
                                  controller:
                                      controller.passwordController.value,
                                  obscureText: controller.isPasswordHide.value,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Password is Required";
                                    }

                                    return null;
                                  },
                                  decoration: CustomInputDecorationForPassword(
                                    'Password',
                                    controller.isPasswordHide,
                                    const Icon(
                                      Icons.password,
                                      color: Colors.white,
                                    ),
                                  ),
                                  autofocus: false,
                                  style: Get.textTheme.bodySmall!
                                      .copyWith(color: Colors.white),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Visibility(
                                  visible: (!controller.isReadOnly.value &&
                                      !controller.isEdit.value),
                                  child: const SizedBox(height: 20)),
                              Visibility(
                                visible: (!controller.isReadOnly.value &&
                                    !controller.isEdit.value),
                                child: TextFormField(
                                  controller: controller.confirmPassword.value,
                                  obscureText:
                                      controller.isPasswordConfirmHide.value,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Confirm Password is Required";
                                    }

                                    return null;
                                  },
                                  decoration: CustomInputDecorationForPassword(
                                    'Confirm Password',
                                    controller.isPasswordConfirmHide,
                                    const Icon(
                                      Icons.password,
                                      color: Colors.white,
                                    ),
                                  ),
                                  autofocus: false,
                                  style: Get.textTheme.bodySmall!
                                      .copyWith(color: Colors.white),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),

                              // DropdownButton<String>(
                              //   isExpanded: true,
                              //   style: Get.textTheme.bodyMedium!.copyWith(
                              //     color: Colors.white,
                              //   ),
                              //   value: controller.roleController.value.text.isEmpty
                              //       ? null
                              //       : controller.roleController.value.text,
                              //   onChanged: (value) {
                              //     controller.roleController.value.text = value!;
                              //   },
                              //   hint: Text(
                              //     "Select Your Role",
                              //     style: Get.textTheme.bodySmall!.copyWith(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   items: List.generate(
                              //     controller.roles.length,
                              //     (index) {
                              //       var data = controller.roles[index];
                              //       return DropdownMenuItem(
                              //         value: data,
                              //         child: Text(
                              //           data,
                              //           style: Get.textTheme.bodyMedium!.copyWith(
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(height: 20),
                              // DropdownButton<String>(
                              //   isExpanded: true,
                              //   style: Get.textTheme.bodyMedium!.copyWith(
                              //     color: Colors.black,
                              //   ),
                              //   value: controller
                              //           .productTypeController.value.text.isEmpty
                              //       ? null
                              //       : controller.productTypeController.value.text,
                              //   onChanged: (value) {
                              //     controller.productTypeController.value.text =
                              //         value!;
                              //   },
                              //   hint: Text(
                              //     "Select Your Product Type",
                              //     style: Get.textTheme.bodySmall!.copyWith(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   items: List.generate(
                              //     controller.productType.length,
                              //     (index) {
                              //       var data = controller.productType[index];
                              //       return DropdownMenuItem(
                              //         value: data,
                              //         child: Text(
                              //           data,
                              //           style: Get.textTheme.bodyMedium!.copyWith(
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              Visibility(
                                  visible: (!controller.isReadOnly.value &&
                                      !controller.isEdit.value),
                                  child: const SizedBox(height: 20)),
                              Visibility(
                                visible: (!controller.isReadOnly.value &&
                                    !controller.isEdit.value),
                                child: CheckboxListTile(
                                  title: Text(
                                    "I have read all terms and condition & agree with all company policy",
                                    textAlign: TextAlign.justify,
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), //    <-- label
                                  checkColor: Colors.white,
                                  value: controller
                                      .isTermsAndConditionChecked.value,
                                  onChanged: (newValue) {
                                    controller.isTermsAndConditionChecked
                                        .value = newValue!;
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Visibility(
                                visible: controller.isEdit.value
                                    ? true
                                    : !controller.isReadOnly.value,
                                child: SizedBox(
                                  width: 200,
                                  child: RoundedLoadingButton(
                                    height: 40,
                                    color: ColorsConstant.orange,
                                    borderRadius: 30,
                                    controller:
                                        controller.signupButtonController,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (controller.isEdit.value) {
                                          await controller.onSignup();
                                        } else {
                                          if (!controller.isVerifyOTP.value) {
                                            AppConstants
                                                .displayValidationErrorSnackbar(
                                                    "Please verify mobile no");
                                            return;
                                          }
                                          if (controller.passwordController
                                                  .value.text !=
                                              controller
                                                  .confirmPassword.value.text) {
                                            AppConstants
                                                .displayValidationErrorSnackbar(
                                                    "Password not matched.");
                                            controller.signupButtonController
                                                .reset();
                                            return;
                                          }
                                          if (controller
                                              .isTermsAndConditionChecked
                                              .value) {
                                            controller.onSignup();
                                          } else {
                                            AppConstants
                                                .displayValidationErrorSnackbar(
                                                    "Please check terms and condition");
                                          }
                                        }
                                      }
                                      controller.signupButtonController.reset();
                                    },
                                    child: Text(
                                      controller.isEdit.value
                                          ? 'Update'
                                          : 'Register Now',
                                      style: Get.textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
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
