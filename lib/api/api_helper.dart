import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/WithdrawalModel.dart';
import '../models/anouncement_model.dart';
import '../models/assign_order_model.dart';
import '../models/dropdown_model.dart';
import '../models/earning_model.dart';
import '../models/feedback_model.dart';
import '../models/help_support.dart';
import '../models/notification_model.dart';
import '../models/order_details_model.dart';
import '../models/profile_details.dart';
import '../models/sos_model.dart';
import '../models/wallet_model.dart';
import '../utils/custom_toast.dart';
import '../utils/default_colors.dart';
import 'api_consts.dart';
import 'api_service.dart';

class ApiHandler {
  static Future logIn(String email, String password, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "email": email,
      "password": password
    };
    var uri = "$baseUrl$login";
    var response = await ApiService.makePostRequestJsonEncodeWithoutToken(
      uri,
      userData,
      context: context,
    );
    print("Token ok $response");
    if (response != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('login_token', response['token']);
      await prefs.setInt('user_id', response['user_id']);
      return "success";
    } else {
      return null;
    }
  }

  static Future signUp(String name, String email, String password,contact, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "password": password,
      "phone":contact
    };
    print(userData);
    var uri = "$baseUrl$registration";

    var response = await ApiService.signup(
      uri,
      userData,
      context: context,
    );
    print("response $response");
    if (response != null) {
      return "success";
    } else {
      return null;
    }
  }

  // static Future<ProfileDetails?> getDeliveryBoydetails(String secretKey) async {
  //   var url = '$baseUrl$getDeliveryBoyDetails';
  //   print("Details API: $url");

  //   var response = await ApiService.makeGetRequest(url, token: secretKey);
  //   print("Raw API Response: ${response.body}");

  //   // if (response is String) {
  //   try {
  //     print("hellllooo123");
  //     response = jsonDecode(response);
  //   } catch (e) {
  //     print("Error decoding JSON: $e");
  //     return null;
  //   }
  //   // }

  //   if (response is List && response.isNotEmpty) {
  //     // Extract the first object from the list
  //     return ProfileDetails.fromJson(response[0]);
  //   } else if (response is Map<String, dynamic>) {
  //     return ProfileDetails.fromJson(
  //         response); // Handle unexpected object response
  //   }

  //   print("Unexpected API response format");
  //   return null;
  // }

  static Future<List<DropdownModel>> fetchVehicle() async {
    var url = "$baseUrl$getVehicleList";
    final response = await ApiService.makeGetRequest(url);

    if (response != null && response is List) {
      return response.map((json) => DropdownModel.fromJson(json)).toList();
    }

    return [];
  }

  static Future<List<DropdownModel>> fetchZone() async {
    var url = "$baseUrl$getZoneList";
    final response = await ApiService.makeGetRequest(url);

    if (response != null && response is List) {
      return response.map((json) => DropdownModel.fromJson(json)).toList();
    }

    return [];
  }

  static Future<ProfileDetails?> getDeliveryBoydetails(String secretKey) async {
    final url = '$baseUrl$getDeliveryBoyDetails';
    print('Fetching delivery boy details from: $url');

    try {
      final response = await ApiService.makeGetRequest(url, token: secretKey);

      // Check if response is null
      if (response == null) {
        print('Failed to fetch details: Response is null');
        return null;
      }

      // Handle List or Map response
      if (response is List && response.isNotEmpty) {
        return ProfileDetails.fromJson(response[0]);
      } else if (response is Map<String, dynamic>) {
        return ProfileDetails.fromJson(response);
      }

      print('Unexpected API response format: $response');
      return null;
    } catch (e) {
      print('Error fetching delivery boy details: $e');
      return null;
    }
  }

  static Future<List<DropdownModel>> fetchBank() async {
    var url = "$baseUrl$getBankList";
    final response = await ApiService.makeGetRequest(url);

    if (response != null && response is List) {
      return response.map((json) => DropdownModel.fromJson(json)).toList();
    }

    return [];
  }

  static Future updateProfile(
      String userId,
      String secretKey,
      String phoneNumber,
      String email,
      String address,
      String vehicleTypeId,
      String vehicleNumber,
      String nIFNumber,
      File? selfieImage,
      BuildContext context) async {
    var url = Uri.parse('$baseUrl$updateDeliveryBoyDetails/$userId');
    print("url is $url");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = "Bearer $secretKey";

    // Add text fields
    request.fields['email'] = email;
    request.fields['vehicle_type_id'] = vehicleTypeId;
    request.fields['vehicle_number'] = vehicleNumber;
    request.fields['nif_number'] = nIFNumber;
    request.fields['phone'] = phoneNumber;
    request.fields['address'] = address;

    // Add image file if exists
    if (selfieImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_image', selfieImage.path),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("Profile updated successfully: $responseData");
        return "success";
      } else {
        print("Failed to update profile. Status Code: ${response.statusCode}");
        print("Error: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Exception while uploading: $e");
      return "error";
    }
  }

  static Future updateVehicleDetails(
      String vehicleTypeId,
      String vehicleNumber,
      String token,
      String userId,
      BuildContext context, {
        File? vehicleImage, // optional image
      }) async {
    var url = Uri.parse('$baseUrl$updateDeliveryBoyDetails/$userId');
    print("url is $url");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = "Bearer $token";

    // Add text fields
    request.fields['vehicle_type_id'] = vehicleTypeId;
    request.fields['vehicle_number'] = vehicleNumber;

    // Add image file if exists
    if (vehicleImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('vehicle_image', vehicleImage.path),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("Vehicle updated successfully: $responseData");
        return "success";
      } else {
        print("Failed to update vehicle. Status Code: ${response.statusCode}");
        print("Error: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Exception while uploading vehicle image: $e");
      return "error";
    }
  }
  // static Future updateVehicleDetails(String vehicleTypeId, String vehicleNumber, String token, String userId, BuildContext context) async {
  //   final Map<String, dynamic> userData = {
  //     "vehicle_type_id": vehicleTypeId,
  //     "vehicle_number": vehicleNumber,
  //   };
  //   print(userData);
  //   var uri = "$baseUrl$updateDeliveryBoyDetails/$userId";
  //   print(uri);
  //   // var response = await ApiService.makePostRequest(
  //   var response = await ApiService.makePostRequest(
  //     uri,
  //     userData,
  //     token: token,
  //     context: context,
  //   );
  //   print("response $response");
  //   if (response != null) {
  //     return "success";
  //   } else {
  //     return null;
  //   }
  // }

  static Future updateBankDetails(String bankName, String holderName, String iban, String token, String userId, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "bank_name": bankName,
      "holder_name": holderName,
      "iban": iban
    };
    print(userData);
    var uri = "$baseUrl$updateDeliveryBoyDetails/$userId";
    print(uri);
    // var response = await ApiService.makePostRequest(
    var response = await ApiService.makePostRequest(
      uri,
      userData,
      token: token,
      context: context,
    );
    print("response $response");
    if (response != null) {
      return "success";
    } else {
      return null;
    }
  }

  static Future updateNif(String nif, String token, String userId, BuildContext context) async {
    final Map<String, dynamic> userData = {"nif_number": nif};
    print(userData);
    var uri = "$baseUrl$updateDeliveryBoyDetails/$userId";
    print(uri);
    // var response = await ApiService.makePostRequest(
    var response = await ApiService.makePostRequest(
      uri,
      userData,
      token: token,
      context: context,
    );
    print("response $response");
    if (response != null) {
      return "success";
    } else {
      return null;
    }
  }

  static Future<List<DropdownModel>> fetchShift() async {
    var url = "$baseUrl$getShift";
    final response = await ApiService.makeGetRequest(url);

    if (response != null && response is List) {
      return response.map((json) => DropdownModel.fromJson(json)).toList();
    }

    return [];
  }

  static Future shiftChange(String shiftId, String token, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "shift_id": shiftId,
    };
    print(userData);
    var uri = "$baseUrl$changeShift";
    print(uri);
    // var response = await ApiService.makePostRequest(
    var response = await ApiService.makePostRequestSC201(
      uri,
      userData,
      token: token,
      context: context,
    );
    print("response $response");
    if (response != null) {
      print("Shift changed successfully: $response");
      return "success";
    } else {
      return null;
    }
  }

  static Future<HelpAndSupport?> fetchHelpSupport() async {
    var url = "$baseUrl$helpSupport";
    final response = await ApiService.makeGetRequest(url);

    if (response != null && response is Map<String, dynamic>) {
      return HelpAndSupport.fromJson(response);
    }

    return null;
  }

  static Future<AssignOrderModel?> fetchAssignOrder(String secretKey) async {
    var url = "$baseUrl$assignOrderList";
    final response = await ApiService.makeGetRequest(url, token: secretKey);

    if (response != null && response is Map<String, dynamic>) {
      return AssignOrderModel.fromJson(response);
    }

    return null;
  }

  static Future<OrderDetailsModel> fetchOrderDetails(String secretKey, int orderId) async {
    var url = "$baseUrl$orderDetails/$orderId";
    final response = await ApiService.makeGetRequest(url, token: secretKey);
    return OrderDetailsModel.fromJson(response);
  }

  static Future deliveryResponse(String status, int orderId, String token, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "status": status,
    };
    print("Status $userData");
    var uri = "$baseUrl$deliveryRespond/$orderId";
    print("Uri data $uri");
    // var response = await ApiService.makePostRequest(
    var response = await ApiService.makePostRequest(
      uri,
      userData,
      token: token,
      context: context,
    );
    print("response Data $response");
    if (response != null) {
      print("successfully: $response");
      return "success";
    } else {
      return null;
    }
  }

  static Future delivePickedup(String status, int orderId, String token, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "status": status,
    };
    print(userData);
    var uri = "$baseUrl$delivePickedupapi/$orderId";
    print(uri);
    // var response = await ApiService.makePostRequest(
    var response = await ApiService.makePostRequest(
      uri,
      userData,
      token: token,
      context: context,
    );
    print("response $response");
    if (response != null) {
      print("successfully: $response");
      return "success";
    } else {
      return null;
    }
  }

  static Future<List<AnnouncementModel>> fetchAnnouncement(String token) async {
    var url = "$baseUrl$announcements";
    final response = await ApiService.makeGetRequest(url, token: token);

    if (response != null && response is List) {
      return response.map((json) => AnnouncementModel.fromJson(json)).toList();
    }

    return [];
  }

  static Future<NotificationModel> fetchNotification(String token) async {
    var url = "$baseUrl$notification";
    final response = await ApiService.makeGetRequest(url, token: token);
    print("response $response");
    return NotificationModel.fromJson(response);
  }

  static Future<List<FeedbackModel>> fetchfeedback(String token) async {
    var url = "$baseUrl$feedback";
    final response = await ApiService.makeGetRequest(url, token: token);

    if (response != null && response is List) {
      return response.map((json) => FeedbackModel.fromJson(json)).toList();
    }

    return [];
  }

  static Future updateDisput(String orderId, String description, String issueType, String token, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "order_id": orderId,
      "description": description,
      "issue_type": issueType
    };
    print(userData);
    var uri = "$baseUrl$dispute";
    print(uri);
    var response = await ApiService.makePostRequest(
      uri,
      userData,
      token: token,
      context: context,
    );
    print("response $response");
    if (response != null) {
      print("hello");
      return "success";
    } else {
      return null;
    }
  }

  static Future<List<SosModel>> fetchSos(String token) async {
    var url = "$baseUrl$sos";
    final response = await ApiService.makeGetRequest(url, token: token);

    if (response != null && response is List) {
      return response.map((json) => SosModel.fromJson(json)).toList();
    }
    return [];
  }

  static Future updateOnlineMode(String isOnline, String token, String userId,BuildContext context) async {
    final Map<String, dynamic> userData = {
      "is_online": isOnline,
    };
    print(userData.runtimeType);
    var uri = "$baseUrl$updateDeliveryBoyDetails/$userId";
    print(uri);
    // var response = await ApiService.makePostRequest(
    var response = await ApiService.makePostRequest(
      uri,
      userData,
      token: token,
      context: context,
    );
    print("response $response");
    if (response != null) {
      return "success";
    } else {
      return null;
    }
  }

  static Future<WalletModel> fetchWallet(String token) async {
    var url = "$baseUrl$deliveryManWallet";
    final response = await ApiService.makeGetRequest(url, token: token);
    return WalletModel.fromJson(response);
  }

  static Future<EarningModel> fetchEarning(String token, {DateTime? date}) async {
    String url = "$baseUrl$earningSummary";

    if (date != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      url += "?date=$formattedDate";
    }

    final response = await ApiService.makeGetRequest(url, token: token);
    return EarningModel.fromJson(response);
  }

  static Future forgotpassword(String email, BuildContext context) async {
    final Map<String, dynamic> userData = {
      "email": email,
    };
    print(userData);
    var uri = "$baseUrl$forgotPassword";
    print(uri);
    // var response = await ApiService.makePostRequest(
    var response = await ApiService.makePostRequestJsonEncodeWithoutToken(
      uri,
      userData,
      // token: token,
      context: context,
    );
    print("response $response");
    if (response != null) {
      print("successfully: $response");
      return "success";
    } else {
      return null;
    }
  }

  static Future<int> fetchAvgRating(String token) async {
    var url = "$baseUrl$reviewAvg";
    final response = await ApiService.makeGetRequest(url, token: token);
    print(response.runtimeType);
    return response;
  }

  static Future<Map<String, dynamic>> fetchEarningSummary({required String token, String startDate = "2025-06-01", String endDate = "2025-07-03",}) async {
    final url = "$baseUrl$earningSummary"; // Example: https://bhamma.equi.website/api/dailySummary

    try {
      final response = await ApiService.makePostRequestJsonEncode(
        url,
        {
          "start_date": startDate,
          "end_date": endDate,
        },
        token: token,
      );

      if (response != null) {
        return {
          "today": response['today'] ?? "0",
          "week": response['week'] ?? "0",
          "month": response['month'] ?? "0",
          "total": response['total'] ?? "0",
        };
      } else {
        print("❌ Earning Summary API returned null");
        return {"today": "0", "week": "0", "month": "0", "total": "0"};
      }
    } catch (e) {
      print("❌ Exception in fetchEarningSummary: $e");
      return {"today": "0", "week": "0", "month": "0", "total": "0"};
    }
  }

  // Add my code it's ok
  static Future<Map<String, String>> fetchAllEarnings(String token) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfAll = DateTime(2020);
    final String _baseUrl = '$baseUrl$dailySummary';

    String formatDate(DateTime d) => "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

    final urls = {
      "today": '$_baseUrl?start_date=${formatDate(now)}&end_date=${formatDate(now)}',
      "week":  '$_baseUrl?start_date=${formatDate(startOfWeek)}&end_date=${formatDate(now)}',
      "month": '$_baseUrl?start_date=${formatDate(startOfMonth)}&end_date=${formatDate(now)}',
      "total": '$_baseUrl?start_date=${formatDate(startOfAll)}&end_date=${formatDate(now)}',
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final responses = await Future.wait([
      http.get(Uri.parse(urls['today']!), headers: headers),
      http.get(Uri.parse(urls['week']!), headers: headers),
      http.get(Uri.parse(urls['month']!), headers: headers),
      http.get(Uri.parse(urls['total']!), headers: headers),
    ]);

    return {
      "today": json.decode(responses[0].body)['total_earning']?.toString() ?? "0",
      "week": json.decode(responses[1].body)['total_earning']?.toString() ?? "0",
      "month": json.decode(responses[2].body)['total_earning']?.toString() ?? "0",
      "total": json.decode(responses[3].body)['total_earning']?.toString() ?? "0",
    };
  }

  static Future<String> fetchCustomEarning(String token, String from, String to) async {
    final response = await http.get(
      Uri.parse('https://bhamma.equi.website/api/dailySummary?start_date=$from&end_date=$to'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    final decoded = json.decode(response.body);
    return decoded['total_earning']?.toString() ?? "0";
  }

  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "data": data};
      }
    } catch (e) {
      return {"success": false, "data": {"message": e.toString()}};
    }
  }

}
