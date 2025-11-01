// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_helper.dart';
//
// class EarningProvider with ChangeNotifier {
//   bool isLoading = true;
//   String today = "0";
//   String week = "0";
//   String month = "0";
//   String total = "0";
//
//   Future<void> fetchEarnings({
//     String startDate = "2025-06-01",
//     String endDate = "2025-07-03",
//   }) async {
//     isLoading = true;
//     notifyListeners();
//
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('login_token') ?? '';
//
//     final result = await ApiHandler.fetchEarningSummary(
//       token,
//       startDate: startDate,
//       endDate: endDate,
//     );
//
//     today = result["today"] ?? "0";
//     week = result["week"] ?? "0";
//     month = result["month"] ?? "0";
//     total = result["total"] ?? "0";
//
//     isLoading = false;
//     notifyListeners();
//   }
// }
