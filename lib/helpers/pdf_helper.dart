import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../utility/constant_class.dart';

class PDFHelper {
  static Future<void> exportToPDF({
    required int noOfColumns,
    required String title,
    required List<String> headings,
    required List<List<String>> rowData,
  }) async {
    var storagePermissionStatus = await Permission.storage.status;
    // var manageExternalStoragePermissionStatus =
    //     await Permission.manageExternalStorage.status;
    var photosStatus = await Permission.photos.status;
    var videoStatus = await Permission.videos.status;
    // var audioStatus = await Permission.audio.status;

    var checkForGranulerPermissionGranted =
        (photosStatus.isGranted && videoStatus.isDenied
        //&& audioStatus.isDenied
        );

    //Get Application Name
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;

    int sdkIntVersion = 0;
    if (Platform.isAndroid) {
      sdkIntVersion = androidInfo.version.sdkInt;
    }

    bool isAndroidSDKRequirementMetPie = sdkIntVersion > 29;
    bool isAndroidSDKRequirementMet13 = sdkIntVersion > 32;

    print(
        "Print SDKIntVersion: ${sdkIntVersion} | ${isAndroidSDKRequirementMet13}");
    print("Storage Permission: ${storagePermissionStatus}");
    // print(
    // "ManageExternal Storage Permission: ${manageExternalStoragePermissionStatus}");
    print("Photos Permission: ${photosStatus}");
    print("Video Permission: ${videoStatus}");

    if (isAndroidSDKRequirementMet13
        ? !checkForGranulerPermissionGranted
        : isAndroidSDKRequirementMetPie
            ? (!storagePermissionStatus.isGranted
                //  &&
                //     !manageExternalStoragePermissionStatus.isGranted
                )
            : !storagePermissionStatus.isGranted) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statusStorage = await [
        Permission.storage,
        Permission.photos,
        Permission.videos
      ].request();
      debugPrint(statusStorage[Permission.storage].toString());

      // if (isAndroidSDKRequirementMetPie) {
      //   Map<Permission, PermissionStatus> statusManageExternalStorage = await [
      //     Permission.manageExternalStorage,
      //   ].request();

      //   debugPrint(statusManageExternalStorage[Permission.storage].toString());
      // }
    }

    storagePermissionStatus = await Permission.storage.status;
    // manageExternalStoragePermissionStatus =
    //     await Permission.manageExternalStorage.status;
    photosStatus = await Permission.photos.status;
    videoStatus = await Permission.videos.status;
    // var audioStatus = await Permission.audio.status;

    checkForGranulerPermissionGranted =
        (photosStatus.isGranted && videoStatus.isDenied
        //&& audioStatus.isDenied
        );

    try {
      // if (isAndroidSDKRequirementMet13
      //     ? checkForGranulerPermissionGranted
      //     : isAndroidSDKRequirementMetPie
      //         ? (storagePermissionStatus.isGranted &&
      //             manageExternalStoragePermissionStatus.isGranted)
      //         : storagePermissionStatus.isGranted) {
      //Create a new PDF document
      PdfDocument document = PdfDocument();

//Create a PdfGrid class
      PdfGrid grid = PdfGrid();

//Add the columns to the grid
      grid.columns.add(count: noOfColumns);

//Add header to the grid
      grid.headers.add(2);

      PdfGridRow headerTitle = grid.headers[0];
      headerTitle.cells[0].value = title;
      headerTitle.cells[0].columnSpan = noOfColumns;
      headerTitle.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(
          PdfFontFamily.helvetica,
          12,
          style: PdfFontStyle.bold,
        ),
      );

      //Add the rows to the grid
      PdfGridRow header = grid.headers[1];
      for (var i = 0; i < noOfColumns; i++) {
        header.cells[i].value = headings[i];
      }

      header.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.black,
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(
          PdfFontFamily.helvetica,
          style: PdfFontStyle.bold,
          6,
        ),
      );

      //Add rows to grid
      PdfGridRow row = grid.rows.add();

      int columnIndex = 0;
      for (var element in rowData) {
        for (var i = 0; i < noOfColumns; i++) {
          row.cells[i].value = element[columnIndex++];
        }
        row = grid.rows.add();
        columnIndex = 0;
      }

      //Set the grid style
      grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(
          PdfFontFamily.helvetica,
          6,
        ),
      );

      //Draw the grid
      grid.draw(
        page: document.pages.add(),
        bounds: const Rect.fromLTWH(0, 0, 0, 0),
      );

      final directory =
          await getApplicationDocumentsDirectory(); //getExternalStorageDirectory();

      var dirValues = directory.path.split(Platform.pathSeparator);
      var appDir =
          "/storage/emulated/0/Download${Platform.pathSeparator}$appName";

      // for (var i = 0; i < dirValues.length - 4; i++) {
      //   appDir += dirValues[i];
      //   appDir += Platform.pathSeparator;
      // }
      // appDir +=
      //     "${Platform.pathSeparator}$appName${Platform.pathSeparator}"; //"${appDir}Download${Platform.pathSeparator}";
      // appDir += "exported-pdf";

      if (!await Directory(appDir).exists()) {
        var dir = await Directory(appDir).create(recursive: true);
        appDir = dir.path;
      }

      //Get directory path
      final path = appDir;
      // directory.path;

      debugPrint("Path dir: ${path}");

      //Create an empty file to write PDF data
      File file = File(
          '$path/sunlit_rfid_${DateTime.now().microsecondsSinceEpoch}.pdf');

      //Write PDF data
      await file.writeAsBytes(await document.save(), flush: true);
      document.dispose();
      AppConstants.displaySuccessfulSnackbar(
        "PDF Exported Successfully in '/Download${Platform.pathSeparator}$appName'",
        duration: const Duration(seconds: 5),
      );
      // } else {
      //   ConstantClass.displayErrorSnackbar("Storage Permission Required");
      //   Map<Permission, PermissionStatus> statusStorage = await [
      //     Permission.storage,
      //   ].request();

      //   if (isAndroidSDKRequirementMetPie) {
      //     Map<Permission, PermissionStatus> statusManageExternalStorage = await [
      //       Permission.manageExternalStorage,
      //     ].request();
      //   }
      // }
    } catch (e) {
      AppConstants.displayErrorSnackbar("Storage Permission Required");
    }
  }
}
