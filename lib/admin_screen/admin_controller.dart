import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../components/custom_decoration.dart';
import '../utility/DateUtility.dart';
import '../utility/colors_constant.dart';
import 'rfidlist_screen/rsidlist_view.dart';

class AdminController extends GetxController {
  RoundedLoadingButtonController logoutButtonController =
      RoundedLoadingButtonController();

  void filterDialog() {
    var fromDateController = TextEditingController().obs;
    var toDateController = TextEditingController().obs;
    DateTime? selectedFromDate;
    DateTime? selectedToDate;
    String? selectedCity;
    var searchButtonController = RoundedLoadingButtonController();
    Get.dialog(
      Obx(
        () => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Filter"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onTap: () async {
                  DateTime date = DateTime.parse("1969-07-20");

                  FocusScope.of(Get.context!).requestFocus(FocusNode());

                  final selecteddate = await showDatePicker(
                    context: Get.context!,
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

                  FocusScope.of(Get.context!).requestFocus(FocusNode());

                  final selecteddate = await showDatePicker(
                    context: Get.context!,
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
                  Get.back();
                  Get.to(() => RFIDListView(), arguments: {
                    "selectedFromDate": selectedFromDate,
                    "selectedToDate": selectedToDate,
                    "selectedCity": selectedCity,
                  });
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
}
