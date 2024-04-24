import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:trainrsid/utility/constant_class.dart';

import '../../components/custom_decoration.dart';
import '../../model/RegisterModel.dart';
import '../../model/UserListModel.dart';
import '../../model/UserModel.dart';
import '../../utility/colors_constant.dart';
import 'userlist_service.dart';

class UserListController extends GetxController {
  var userList = List<UserModel>.of([]).obs;
  var isLoading = true.obs;
  var currentPage = 1.obs;
  var isPageLoading = false.obs;

  var selectedStatus = STATUS.PENDING;
  var selectedLimit = 25;

  var statusMessageController = TextEditingController().obs;
  RoundedLoadingButtonController sendRequestMessageButtonController =
      RoundedLoadingButtonController();

  ScrollController scrollController = ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    initScroll();
    await getUsers();
    isLoading.value = false;
  }

  initScroll() async {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        print("scroll check :: Invoked Next Page ${currentPage.value}");
        if (userList.length >= (selectedLimit * currentPage.value)) {
          currentPage.value++;
          await getUsers();
        }
      }
    });
  }

  void doRequest(STATUS status, UserModel userData) {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Why ${status.name}?",
          style: Get.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: statusMessageController.value,
                decoration: CustomInputDecoration(
                  'Reason for ${status.name}',
                  null,
                ),
                autofocus: true,
                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 30),
              RoundedLoadingButton(
                width: 80,
                height: 40,
                color: ColorsConstant.orange,
                borderRadius: 30,
                controller: sendRequestMessageButtonController,
                onPressed: () async {
                  if (statusMessageController.value.text.isEmpty) {
                    AppConstants.displayValidationErrorSnackbar(
                        "Please enter reason");
                    sendRequestMessageButtonController.reset();
                    return;
                  }
                  if (status == STATUS.APPROVED ||
                      status == STATUS.REJECTED ||
                      status == STATUS.SUSPENDED) {
                    await makeRequest(
                        userData, status, statusMessageController.value.text);
                  }
                  sendRequestMessageButtonController.reset();
                },
                child: Text(
                  'Ok',
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makeRequest(
      UserModel userData, STATUS status, String message) async {
    isLoading.value = true;
    var service = UserListService();

    Map<String, dynamic> result = await service.makeStatusRequest(FormData({
      "status": status.index,
      "user_id": userData.id,
      "message": message,
    }));

    if (result["success"] == 1) {
      RegisterModel userData = RegisterModel.fromJson(result["data"]);
      if (userData.success!) {
        Get.back();
        statusMessageController.value.text = "";
        AppConstants.displaySuccessfulSnackbar(userData.message!);
        await getUsers();
      } else {
        AppConstants.displayErrorSnackbar(userData.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
    isLoading.value = false;
  }

  Future<void> getUsers() async {
    if (currentPage.value > 1) {
      isPageLoading.value = true;
    }

    if (currentPage.value == 1) {
      userList.clear();
    }

    var service = UserListService();
    Map<String, dynamic> rawData = {
      "page_no": currentPage.value.toString(),
      "limit": selectedLimit.toString(),
    };
    if (selectedStatus != STATUS.ALL) {
      rawData["status"] = selectedStatus.index.toString();
    }
    Map<String, dynamic> result = await service.getUserList(rawData);

    if (result["success"] == 1) {
      UserListModel userListModel = UserListModel.fromJson(result["data"]);
      if (userListModel.success!) {
        if (userListModel.userList.isNotEmpty) {
          userList.value += userListModel.userList;
        } else {
          if (currentPage.value > 1) {
            currentPage.value--;
          }
        }
        // log("DATA: ${userList.value.toJson()}");
      } else {
        AppConstants.displayErrorSnackbar(userListModel.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }

    if (currentPage.value > 1) {
      isPageLoading.value = false;
    }
    isPageLoading.value = false;
  }
}
