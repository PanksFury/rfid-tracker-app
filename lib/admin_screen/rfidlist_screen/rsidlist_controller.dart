import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/custom_decoration.dart';
import '../../helpers/pdf_helper.dart';
import '../../model/RSIDListModel.dart';
import '../../utility/DateUtility.dart';
import '../../utility/colors_constant.dart';
import '../../utility/constant_class.dart';
import 'rsidlist_service.dart';

class RFIDListController extends GetxController {
  var isLoading = false.obs;
  var rsidList = List<RSIDDataModel>.of([]).obs; //RFIDListModel().obs;
  var selectedLimit = 25;
  var currentPage = 1.obs;
  var isPageLoading = false.obs;
  var isExporting = false.obs;

  var fromDateController = TextEditingController().obs;
  var toDateController = TextEditingController().obs;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  String? selectedCity;

  var box = GetStorage();

  ScrollController scrollController = ScrollController();

  int userId = -1;

  @override
  Future<void> onInit() async {
    super.onInit();
    var data = Get.arguments;
    if (data != null) {
      userId = data["userID"] ?? -1;
      selectedFromDate = data["selectedFromDate"];
      selectedToDate = data["selectedToDate"];
      selectedCity = data["selectedCity"];
    }
    isLoading.value = true;
    initScroll();
    await getRSIDs();
    isLoading.value = false;
  }

  initScroll() async {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        print("scroll check :: Invoked Next Page ${currentPage.value}");
        if (rsidList.length >= (selectedLimit * currentPage.value)) {
          print("Hit API");
          currentPage.value++;
          await getRSIDs();
        }
      }
    });
  }

  void filterDialog(BuildContext context) {
    var searchButtonController = RoundedLoadingButtonController();
    Get.dialog(
      Obx(
        () => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Filter"),
              MaterialButton(
                onPressed: () async {
                  selectedFromDate = null;
                  selectedToDate = null;
                  selectedCity = null;
                  currentPage.value = 1;
                  Get.back();
                  isLoading.value = true;
                  await getRSIDs();
                  isLoading.value = false;
                },
                child: Text(
                  "Reset",
                  style: Get.textTheme.bodySmall!.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onTap: () async {
                  DateTime date = DateTime.parse("1969-07-20");

                  FocusScope.of(context).requestFocus(FocusNode());

                  final selecteddate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: date,
                    lastDate: selectedToDate ??
                        DateTime.now().add(
                          const Duration(days: 1000),
                        ),
                  );

                  //yyyy-MM-dd
                  if (selecteddate != null) {
                    selectedFromDate = selecteddate;

                    fromDateController.value.text =
                        DateUtility.getDisplayDate(selecteddate);
                  }
                },
                readOnly: true,
                controller: fromDateController.value,
                decoration: CustomInputDecoration(
                  'From Date',
                  const Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                ),
                autofocus: false,
                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              TextFormField(
                onTap: () async {
                  DateTime date = DateTime.now();

                  FocusScope.of(context).requestFocus(FocusNode());

                  final selecteddate = await showDatePicker(
                    context: context,
                    initialDate: selectedFromDate ?? date,
                    firstDate: selectedFromDate ?? date,
                    lastDate: DateTime.now().add(
                      const Duration(days: 1000),
                    ),
                  );

                  //yyyy-MM-dd
                  if (selecteddate != null) {
                    selectedToDate = selecteddate;

                    toDateController.value.text =
                        DateUtility.getDisplayDate(selecteddate);
                  }
                },
                readOnly: true,
                controller: toDateController.value,
                decoration: CustomInputDecoration(
                  'To Date',
                  const Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                ),
                autofocus: false,
                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: CustomInputDecoration(
                  'Search By City',
                  const Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                ),
                onChanged: (value) {
                  selectedCity = value;
                },
                initialValue: selectedCity ?? "",
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
                controller: searchButtonController,
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  currentPage.value = 1;

                  Get.back();
                  isLoading.value = true;
                  await getRSIDs();
                  isLoading.value = false;
                  searchButtonController.reset();
                },
                child: Text(
                  'Search',
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
      ),
    );
  }

  Future<void> exportToPDF() async {
    isExporting.value = true;
    var headers = [
      "SR.No",
      'RFID',
      'RFID NAME',
      'STATION BW',
      'STATION FW',
      'CURRENT LOCATION',
      'LATTITUDE',
      'LONGITUDE',
      'NOTE',
      "AGNT NAME",
      "AGNT CONTACT.NO",
      "AGNT COMP.NAME"
    ];

    List<List<String>> rowData = [];
    int srNo = 1;
    rsidList.value.forEach((element) {
      rowData.add([
        srNo.toString(),
        element.id!.toString(),
        element.rsid!,
        element.stationBackward!,
        element.stationForward!,
        element.currentLocation!,
        element.latitude!.toString(),
        element.longitude!.toString(),
        element.notes ?? "-",
        element.userModel != null
            ? "${element.userModel!.firstName} ${element.userModel!.lastName}"
            : "",
        (element.userModel != null ? element.userModel!.mobile : "").toString(),
        (element.userModel != null ? element.userModel!.companyName : "")
            .toString()
      ]);
      srNo++;
    });

    await PDFHelper.exportToPDF(
      noOfColumns: headers.length,
      title:
          "Date - ${DateUtility.getDisplayDateDescriptiveFormat(DateTime.now())} ${DateUtility.getDisplayTimeDescriptiveFormat(DateTime.now())}",
      headings: headers,
      rowData: rowData,
    );
    isExporting.value = false;
  }

  Future<void> getRSIDs() async {
    if (currentPage.value > 1) {
      isPageLoading.value = true;
    }

    if (currentPage.value == 1) {
      rsidList.clear();
    }

    var service = RFIDListService();
    Map<String, dynamic> rawData = {
      "page_no": currentPage.value.toString(),
      "limit": selectedLimit.toString(),
      "user_id": userId == -1
          ? await box.read(AppConstants.userId)
          : userId.toString(),
      "from": selectedFromDate == null
          ? ""
          : DateUtility.parseToAPIDateByDate(selectedFromDate!),
      "to": selectedToDate == null
          ? ""
          : DateUtility.parseToAPIDateByDate(selectedToDate!),
      "city": selectedCity ?? "",
    };

    Map<String, dynamic> result = await service.getRsidList(rawData);

    if (result["success"] == 1) {
      RFIDListModel rsidListModel = RFIDListModel.fromJson(result["data"]);
      if (rsidListModel.success!) {
        RFIDListModel _rsidListModel = rsidListModel;
        if (_rsidListModel.rsidList.isNotEmpty) {
          rsidList.value += _rsidListModel.rsidList;
        } else {
          if (currentPage.value > 1) {
            currentPage.value--;
          }
        }
        // log("DATA: ${rsidList.value.toJson()}");
      } else {
        AppConstants.displayErrorSnackbar(rsidListModel.message!);
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
