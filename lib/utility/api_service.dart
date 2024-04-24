import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constant_class.dart';

///A Global configured class to run api services with less code and work more.
///This class is consist of POST, GET method with it.
///Created by Anmol limje on 03-Nov-2022
class APIService extends GetConnect {
  ///Return Response in result['data'] and isSuccess or not in result['success']
  Future<Map<String, dynamic>> postData(String url, FormData formData,
      {Map<String, String>? headers,
      bool isLog = true,
      int statusCodeCondition = HttpStatus.ok}) async {
    Map<String, dynamic> result = {};

    if (isLog) {
      debugPrint("API: $url");
      log("API: $url");
      log("INPUT: ${formData.fields}");
    }

    try {
      httpClient.timeout = AppConstants.timeoutDuration;
      final response = await post(
        url,
        formData,
        headers: headers,
      );
      if (isLog) {
        log("RESPONSE: ${response.body}");
        debugPrint("RESPONSE: ${response.body}");
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == statusCodeCondition) {
        result["data"] = response.body; //jsonDecode() Already in json
        result["success"] = 1;
        return result;
      } else {
        result["success"] = 0;
        return result;
      }
    } catch (exp) {
      result["success"] = 0;
      return result;
    }
  }

  Future<Map<String, dynamic>> postDataJson(
      String url, Map<String, dynamic> jsonData,
      {Map<String, String>? headers, bool isLog = true}) async {
    Map<String, dynamic> result = {};

    if (isLog) {
      debugPrint("*****************");
      log("INPUT: $jsonData");
    }

    try {
      httpClient.timeout = AppConstants.timeoutDuration;
      final response = await post(
        url,
        jsonEncode(jsonData),
        headers: headers,
      );
      if (isLog) {
        log("RESPONSE: ${response.body}");
        debugPrint("*****************");
      }

      if (response.statusCode == HttpStatus.ok) {
        result["data"] = response.body; //jsonDecode() Already in json
        result["success"] = 1;
        return result;
      } else {
        result["success"] = 0;
        return result;
      }
    } catch (exp) {
      result["success"] = 0;
      return result;
    }
  }

  ///Return Response in result['data'] and isSuccess or not in result['success']
  Future<Map<String, dynamic>> getData(String url, Map<String, dynamic> query,
      {Map<String, String>? headers, bool isLog = true}) async {
    Map<String, dynamic> result = {};

    if (isLog) {
      debugPrint("*****************");
      log("API: $url");
      log("INPUT: $query");
    }

    try {
      httpClient.timeout = AppConstants.timeoutDuration;
      final response = await get(
        url,
        query: query,
        headers: headers,
      );
      if (isLog) {
        log("RESPONSE: ${response.body}");
        debugPrint("*****************");
      }

      if (response.statusCode == HttpStatus.ok) {
        result["data"] = response.body; //jsonDecode() Already in json
        result["success"] = 1;
        return result;
      } else {
        result["success"] = 0;
        return result;
      }
    } catch (exp) {
      log("Exception: $exp");
      result["success"] = 0;
      return result;
    }
  }

  ///Return Response in result['data'] and isSuccess or not in result['success']
  Future<Map<String, dynamic>> putData(String url, FormData formData,
      {Map<String, String>? headers,
      bool isLog = true,
      int statusCodeCondition = HttpStatus.ok,
      String? contentType}) async {
    Map<String, dynamic> result = {};

    if (isLog) {
      debugPrint("*****************");
      log("API: $url");
      log("INPUT: ${formData.fields}");
    }

    try {
      httpClient.timeout = AppConstants.timeoutDuration;
      final response = await put(
        url,
        formData,
        headers: headers,
        contentType: contentType,
      );
      if (isLog) {
        log("RESPONSE: ${response.body}");
        debugPrint("*****************");
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == statusCodeCondition) {
        result["data"] = response.body; //jsonDecode() Already in json
        result["success"] = 1;
        return result;
      } else {
        result["success"] = 0;
        return result;
      }
    } catch (exp) {
      result["success"] = 0;
      return result;
    }
  }

  ///Return Response in result['data'] and isSuccess or not in result['success']
  Future<Map<String, dynamic>> putDataJson(
      String url, Map<String, dynamic> jsonData,
      {Map<String, String>? headers,
      bool isLog = true,
      int statusCodeCondition = HttpStatus.ok,
      String? contentType}) async {
    Map<String, dynamic> result = {};

    if (isLog) {
      debugPrint("*****************");
      log("API: $url");
      log("INPUT: ${jsonData}");
    }

    try {
      httpClient.timeout = AppConstants.timeoutDuration;
      final response = await put(
        url,
        jsonData,
        headers: headers,
        contentType: contentType,
      );
      if (isLog) {
        log("RESPONSE: ${response.body}");
        debugPrint("*****************");
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == statusCodeCondition) {
        result["data"] = response.body; //jsonDecode() Already in json
        result["success"] = 1;
        return result;
      } else {
        result["success"] = 0;
        return result;
      }
    } catch (exp) {
      result["success"] = 0;
      return result;
    }
  }
}
