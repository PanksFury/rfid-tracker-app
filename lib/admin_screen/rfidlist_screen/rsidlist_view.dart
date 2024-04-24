import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../components/WidgetsItems.dart';
import '../../components/custom_decoration.dart';
import '../../utility/DateUtility.dart';
import 'rsidlist_controller.dart';

class RFIDListView extends GetView<RFIDListController> {
  @override
  var controller = Get.put(RFIDListController());

  final GlobalKey _menuKeyLimit = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: Get.theme.primaryColor,
          appBar: AppBar(
            title: Text(
              "RFID List",
              style: Get.textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              /* controller.isLoading.value
                  ? const SizedBox()
                  : controller.rsidList.value.isEmpty
                      ? const SizedBox()
                      : controller.isExporting.value
                          ? Container(
                              margin: const EdgeInsets.all(10),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              onPressed: () => controller.exportToPDF(),
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                            ), */
              controller.isLoading.value
                  ? const SizedBox()
                  : controller.rsidList.value.isEmpty
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () => controller.filterDialog(context),
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
              controller.isLoading.value
                  ? const SizedBox()
                  : controller.rsidList.value.isEmpty
                      ? const SizedBox()
                      : PopupMenuButton(
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
                            await controller.getRSIDs();
                            controller.isLoading.value = false;
                          },
                        ),
            ],
          ),
          body: SafeArea(
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      Future.delayed(
                        const Duration(seconds: 1),
                        () async {
                          controller.isLoading.value = true;
                          await controller.getRSIDs();
                          controller.isLoading.value = false;
                        },
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: controller.isPageLoading.value
                              ? Get.height * 0.78
                              : Get.height * 0.88,
                          child: controller.rsidList.value.isEmpty
                              ? Center(
                                  child: Text(
                                    "No Data Found",
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: controller.scrollController,
                                  // physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller.rsidList.value.length,
                                  itemBuilder: (context, index) {
                                    var data = controller.rsidList.value[index];
                                    return WidgetItems.rsidListNew(data);
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
                        // ListView(),

                        // SingleChildScrollView(
                        //   // physics: const BouncingScrollPhysics(),
                        //   child: Column(
                        //     children: [

                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
          )),
    );
  }
}
