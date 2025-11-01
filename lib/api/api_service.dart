import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/WithdrawalModel.dart';
import '../utils/custom_toast.dart';
import '../utils/default_colors.dart';
import 'api_consts.dart';
import 'api_helper.dart';

class ApiService {

  static Map<String, String> _getHeadersForPost(String? token) {
    return {
      'Authorization': 'Bearer $token',
    };
  }

  static Map<String, String> _getHeadersForGet(String? token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Make a post request
  static Future<dynamic> makePostRequest(
    String url,
    Map<String, dynamic> body, {
    String? token,
    BuildContext? context,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: _getHeadersForPost(token),
        body: body,
      );

      print("abcd ${response.body}");
      var data = jsonDecode(response.body);
      print("data is $data");
      if (response.statusCode == 200) {
        print("1");
        return data;
      } else {
        print("2");
        if (context != null) {
          ToastManager.showToast(
            msg: data['message'],
            color: DefaultColor.mainColor,
            context: context,
          );
        }
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> makePostRequestSC201(
    String url,
    Map<String, dynamic> body, {
    String? token,
    BuildContext? context,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: _getHeadersForPost(token),
        body: body,
      );

      print("abcd ${response.body}");
      var data = jsonDecode(response.body);
      print("data is $data");
      if (response.statusCode == 201) {
        return data;
      } else {
        if (context != null) {
          ToastManager.showToast(
            msg: data['message'],
            color: DefaultColor.mainColor,
            context: context,
          );
        }
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> makePostRequestJsonEncodeWithoutToken(
    String url,
    Map<String, dynamic> body, {
    BuildContext? context,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: body,
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        var decodedBody = jsonDecode(response.body);
        print(decodedBody["error"]);

        return null;
      }
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  static Future<dynamic> signup(
    String url,
    Map<String, dynamic> body, {
    BuildContext? context,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: body,
      );

      var data = jsonDecode(response.body);
      print("aasasa $data");

      if (response.statusCode == 201) {
        print(response.body);
        return data;
      } else {
        var decodedBody = jsonDecode(response.body);
        print("aaaaa ${decodedBody["errors"]['email']}");
        ToastManager.showToast(
          msg: decodedBody["errors"]['email'][0],
          color: DefaultColor.mainColor,
          context: context,
        );
        return null;
      }
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  // Make a post request with json encoded body
  static Future<dynamic> makePostRequestJsonEncode(
    String url,
    Map<String, dynamic> body, {
    String? token,
    BuildContext? context,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: _getHeadersForPost(token),
        body: jsonEncode(body),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(response.body);
        return data;
      } else {
        print(response.body);
        if (context != null) {
          ToastManager.showToast(
            msg: data['message'],
            color: DefaultColor.mainColor,
            context: context,
          );
        }
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

// Make a get request
  static Future<dynamic> makeGetRequest(
    String url, {
    String? token,
  }) async {
    try {
      var response = await http.get(Uri.parse(url), headers: _getHeadersForGet(token));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Make a delete request
  static Future<dynamic> makeDeleteRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
    BuildContext? context,
  }) async {
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: _getHeadersForPost(token),
        body: body, // http.delete will handle null body appropriately
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        if (context != null) {
          ToastManager.showToast(
            msg: data['message'],
            color: DefaultColor.mainColor,
            context: context,
          );
        }
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Wallet Summary API call
  static Future<Map<String, dynamic>?> getWalletSummary(String token) async {
    print("✅ Inside getWalletSummary function");
    try {
      final response = await http.get(
        Uri.parse(walletSummary),
        headers: _getHeadersForGet(token),
      );

      // ✅ Move logs HERE (AFTER the request)
      print("✅ Calling Wallet API");
      print("📡 URL: $walletSummary");
      print("🔐 Token: $token");
      print("📦 Status: ${response.statusCode}");
      print("📄 Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("❌ Wallet summary error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ getWalletSummary error: $e");
      return null;
    }
  }

  // Send Withdraw Request
  static Future<Map<String, dynamic>?> sendWithdrawRequest(String token, double amount, BuildContext context) async {
    try {
      print("🔐 Token: $token");
      print("💰 Amount: $amount");

      final response = await http.post(
        Uri.parse(sendWithdraw),
        headers: _getHeadersForPost(token),
        body: {'amount': amount.toString()},
      );

      print("📤 Request sent to: $sendWithdraw");
      print("📩 Response Status: ${response.statusCode}");
      print("📩 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Withdraw request success: $data");
        return data;
      } else {
        ToastManager.showToast(
          msg: data['message'] ?? "Failed to send request",
          context: context,
          color: DefaultColor.mainColor,
        );
        return null;
      }
    } catch (e) {
      debugPrint("❌ sendWithdrawRequest error: $e");
      return null;
    }
  }

  static Future<List<WithdrawalModel>> fetchWithdrawals(String token) async {
    try {
      final response = await http.get(
        Uri.parse(pendingWid),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => WithdrawalModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load withdrawals");
      }
    } catch (e) {
      print("Error fetching withdrawals: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = "$baseUrl$sendotp";
    final body = {"phone": phone};

    final response = await ApiHandler.post(url, body);
    return response;
  }

  /// ✅ Verify OTP
  // static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
  //   final url = "$baseUrl$verifyotp";   // yaha apna endpoint lagao
  //   final body = {"phone": phone, "otp": otp};
  //
  //   final response = await ApiHandler.post(url, body);
  //   return response;
  // }
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = "$baseUrl$verifyotp";   // yaha apna endpoint lagao
    final body = {"phone": phone, "otp": otp};

    final response = await ApiHandler.post(url, body);

    if (response["success"] == true) {
      // agar response me access_token mila to SharedPreferences me save karo
      final token = response["data"]["token"];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("login_token", token);
        debugPrint("✅ Access token saved: $token");
      }
    }

    return response;
  }


}
