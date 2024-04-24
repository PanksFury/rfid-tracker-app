// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admin_screen/rfidlist_screen/rsidlist_view.dart';
import '../model/RSIDListModel.dart';
import '../model/StationCodes.dart';
import '../model/StationZones.dart';
import '../model/UserModel.dart';
import '../signup_screen/signup_view.dart';
import '../user_screen/add_rfid_screen/add_rsid_view.dart';
import '../utility/colors_constant.dart';
import '../utility/constant_class.dart';
import '../utility/map_utility.dart';

class WidgetItems {
  static Widget userList(UserModel userModel,
      {required Function(STATUS status) onRequest}) {
    var status = STATUS.values[userModel.status ?? 2];
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text:
                          '${userModel.firstName ?? ''} ${userModel.lastName ?? ''}',
                      style: Get.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: status == STATUS.APPROVED
                          ? Colors.green.shade400
                          : status == STATUS.PENDING
                              ? Colors.green.shade900
                              : status == STATUS.REJECTED
                                  ? Colors.red.shade600
                                  : ColorsConstant.suspend,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status.name,
                      style: Get.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              //View RFIDs
              GestureDetector(
                onTap: () {
                  Get.to(() => RFIDListView(), arguments: {
                    "userID": userModel.id,
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "View RFID",
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
                top: 10,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () => onRequest(STATUS.REJECTED),
                        color: Colors.red.shade600,
                        child: Text(
                          "Reject",
                          style: Get.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => Get.to(() => SignupView(), arguments: {
                          "isReadOnly": false,
                          "isEdit": true,
                          "isAdmin": true,
                          "data": userModel,
                        }),
                        color: Get.theme.primaryColor,
                        child: Text(
                          "View",
                          style: Get.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => onRequest(STATUS.APPROVED),
                        color: Colors.green.shade400,
                        child: Text(
                          "Approve",
                          style: Get.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 2,
                  ),
                  MaterialButton(
                    minWidth: Get.width,
                    onPressed: () => onRequest(STATUS.SUSPENDED),
                    color: ColorsConstant.suspend,
                    child: Text(
                      "Suspend",
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @Deprecated("Use rsidListNew() Instead")
  static Widget rsidList(RSIDDataModel rsidModel) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: RichText(
            text: TextSpan(
              text: rsidModel.rsid ?? '',
              style: Get.textTheme.bodySmall!.copyWith(),
              children: <TextSpan>[
                TextSpan(
                  text: " (${rsidModel.currentLocation})",
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
                top: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    child: Text(
                      "Station Backward -> ${rsidModel.stationBackward}",
                      textAlign: TextAlign.left,
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      "Station Forward -> ${rsidModel.stationForward}",
                      textAlign: TextAlign.left,
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget rsidListNew(RSIDDataModel rsidModel) {
    return GestureDetector(
      onTap: () => Get.to(() => AddRFIDView(), arguments: {
        "isReadOnly": true,
        "data": rsidModel,
      }),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
              top: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        rsidModel.rsid ?? '',
                        style: Get.textTheme.bodySmall!.copyWith(),
                      ),
                    ),
                    Text(
                      rsidModel.createdAt ?? "",
                      style: Get.textTheme.bodySmall!.copyWith(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            size: 10,
                          ),
                          Expanded(
                            child: Text(
                              rsidModel.stationBackward ?? "",
                              textAlign: TextAlign.left,
                              style: Get.textTheme.bodySmall!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              rsidModel.stationForward ?? "",
                              textAlign: TextAlign.right,
                              style: Get.textTheme.bodySmall!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: Get.width,
                  child: MaterialButton(
                    onPressed: () => MapUtils.redirect(
                        latitude: rsidModel.latitude!,
                        longitude: rsidModel.longitude!),
                    color: ColorsConstant.primary,
                    child: Text(
                      "Get Direction",
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget stationCodeItem(List<StationCode> stationCodeList,
      {required Function(StationCode code) onTapCallback}) {
    return ListView.builder(
      itemCount: stationCodeList.length,
      itemBuilder: (BuildContext context, int index) {
        var code = stationCodeList[index];
        debugPrint("CODE: ${code.name}");
        return ListTile(
          title: Text(
            code.name ?? "",
            style: Get.textTheme.bodySmall,
          ),
          onTap: () => onTapCallback(code),
        );
      },
    );
  }

  static Widget stationZoneItem(List<ZonalHeadquarter> zoneList,
      {required Function(ZonalHeadquarter zoneHeadquarter, StationZone zone)
          onTapCallback}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: zoneList.length,
      itemBuilder: (BuildContext context, int index) {
        var zones = zoneList[index];
        return Container(
          child: ExpansionTile(
            title: Text(
              zones.name ?? "",
              style: Get.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: zones.stationZones!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var zone = zones.stationZones![index];

                  return ListTile(
                    title: Text(
                      zone.name ?? "",
                      style: Get.textTheme.bodySmall,
                    ),
                    onTap: () => onTapCallback(zones, zone),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
