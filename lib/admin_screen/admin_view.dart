import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trainrsid/utility/colors_constant.dart';

import '../splash_screen/splash_view.dart';
import '../utility/constant_class.dart';
import 'admin_controller.dart';
import 'rfidlist_screen/rsidlist_controller.dart';
import 'rfidlist_screen/rsidlist_view.dart';
import 'userlist_screen/userlist_view.dart';

class AdminView extends GetView<AdminController> {
  @override
  var controller = Get.put(AdminController());

  AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.splashColor,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    // height: Get.height * 0.3,
                    // margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Image.asset(
                      "assets/images/banner.jpeg",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: Get.width,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green;
                        }
                        return ColorsConstant.orange;
                      }),
                    ),
                    onPressed: () {
                      Get.to(() => UserListView());
                    },
                    icon: const Icon(
                      Icons.note_add_sharp,
                      size: 24.0,
                    ),
                    label: Text(
                      'Search and Modify User'.toUpperCase(),
                      style: Get.textTheme.titleSmall!
                          .copyWith(color: Colors.white),
                    ), // <-- Text
                  ),
                ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green;
                        }
                        return ColorsConstant.orange;
                      }),
                    ),
                    onPressed: () => Get.to(() => RFIDListView()),
                    icon: const Icon(
                      Icons.analytics_sharp,
                      size: 24.0,
                    ),
                    label: Text(
                      'DATA REPORT',
                      style: Get.textTheme.titleSmall!
                          .copyWith(color: Colors.white),
                    ), // <-- Text
                  ),
                ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green;
                        }
                        return ColorsConstant.orange;
                      }),
                    ),
                    // onPressed: () => Get.to(() => RFIDListView()),
                    onPressed: () {
                      controller.filterDialog();
                    },
                    icon: const Icon(
                      Icons.track_changes,
                      size: 24.0,
                    ),
                    label: Text(
                      'TRACK RFID',
                      style: Get.textTheme.titleSmall!
                          .copyWith(color: Colors.white),
                    ), // <-- Text
                  ),
                ),
                Container(
                  width: 150,
                  margin: const EdgeInsets.only(top: 50),
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green;
                        }
                        return ColorsConstant.orange;
                      }),
                    ),
                    onPressed: () async {
                      AppConstants.displaySuccessfulSnackbar(
                          "Logout Successfully");
                      await GetStorage().erase();
                      Get.offAll(() => SplashView(), arguments: true);
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 24.0,
                    ),
                    label: Text(
                      'Logout',
                      style: Get.textTheme.bodySmall!
                          .copyWith(color: Colors.white),
                    ), // <-- Text
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
