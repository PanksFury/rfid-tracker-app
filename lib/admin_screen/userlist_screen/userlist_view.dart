import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trainrsid/utility/constant_class.dart';

import '../../components/WidgetsItems.dart';
import '../../signup_screen/signup_view.dart';
import '../../utility/colors_constant.dart';
import '../../utility/view_utility.dart';
import 'userlist_controller.dart';

// ignore: must_be_immutable
class UserListView extends GetView<UserListController> {
  @override
  var controller = Get.put(UserListController());

  final GlobalKey _menuKeyStatus = GlobalKey();
  final GlobalKey _menuKeyLimit = GlobalKey();

  UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        title: Text(
          "User List",
          style: Get.textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              controller.isLoading.value = true;
              controller.currentPage.value = 1;
              await controller.getUsers();
              controller.isLoading.value = false;
            },
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
          ),
          PopupMenuButton(
            key: _menuKeyStatus,
            icon: const Icon(Icons.sort),
            tooltip: "Sort By",
            itemBuilder: (_) => <PopupMenuItem<STATUS>>[
              PopupMenuItem<STATUS>(
                value: STATUS.ALL,
                child: Text(
                  "ALL",
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontWeight: controller.selectedStatus == STATUS.ALL
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem<STATUS>(
                value: STATUS.APPROVED,
                child: Text(
                  "Approved",
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontWeight: controller.selectedStatus == STATUS.APPROVED
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem<STATUS>(
                value: STATUS.PENDING,
                child: Text(
                  "Pending",
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontWeight: controller.selectedStatus == STATUS.PENDING
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem<STATUS>(
                value: STATUS.REJECTED,
                child: Text(
                  "Rejected",
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontWeight: controller.selectedStatus == STATUS.REJECTED
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem<STATUS>(
                value: STATUS.SUSPENDED,
                child: Text(
                  "Suspended",
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: ColorsConstant.suspend,
                    fontWeight: controller.selectedStatus == STATUS.SUSPENDED
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
            onSelected: (value) async {
              controller.selectedStatus = value;
              controller.isLoading.value = true;
              controller.currentPage.value = 1;
              await controller.getUsers();
              controller.isLoading.value = false;
            },
          ),
          PopupMenuButton(
            key: _menuKeyLimit,
            tooltip: "Data Limit",
            itemBuilder: (_) => <PopupMenuItem<int>>[
              PopupMenuItem<int>(
                value: 25,
                child: Text(
                  "Limit 25",
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontWeight: controller.selectedLimit == 25
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 50,
                child: Text("Limit 50",
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontWeight: controller.selectedLimit == 50
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
              ),
              PopupMenuItem<int>(
                value: 100,
                child: Text("Limit 100",
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontWeight: controller.selectedLimit == 100
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
              ),
            ],
            onSelected: (value) async {
              controller.selectedLimit = value;
              controller.currentPage.value = 1;
              controller.isLoading.value = true;
              await controller.getUsers();
              controller.isLoading.value = false;
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SignupView(), arguments: {
            "isReadOnly": false,
            "isAdmin": true,
          });
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: ColorsConstant.primary,
          size: 30,
        ),
      ),
      body: Obx(
        () => SafeArea(
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : controller.userList.isEmpty
                  ? Center(
                      child: Text(
                        "No user found for status '${ViewUtility.toTitleCase(controller.selectedStatus.name)}'",
                        style: Get.textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        Future.delayed(
                          const Duration(seconds: 1),
                          () async {
                            controller.isLoading.value = true;
                            controller.getUsers();
                            controller.isLoading.value = false;
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          ListView(),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: controller.isPageLoading.value
                                      ? Get.height * 0.80
                                      : Get.height * 0.87,
                                  child: ListView.builder(
                                    controller: controller.scrollController,
                                    // physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.userList.length,
                                    itemBuilder: (context, index) {
                                      var userData = controller.userList[index];
                                      return WidgetItems.userList(
                                        userData,
                                        onRequest: (status) {
                                          controller.doRequest(
                                              status, userData);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: controller.isPageLoading.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
