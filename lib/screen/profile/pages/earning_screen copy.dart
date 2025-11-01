// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../../../utils/default_colors.dart';
//
// class EarningStatementPage extends StatefulWidget {
//   const EarningStatementPage({super.key});
//
//   @override
//   State<EarningStatementPage> createState() => _EarningStatementPageState();
// }
//
// class _EarningStatementPageState extends State<EarningStatementPage> {
//   String selectedTab = "All";
//
//   String today = "0", week = "0", month = "0", total = "0", custom = "0";
//   DateTime? fromDate, toDate;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEarnings();
//   }
//
//   Future<void> fetchEarnings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('login_token') ?? '';
//
//     if (token.isEmpty) {
//       setState(() => isLoading = false);
//       return;
//     }
//
//     try {
//       final now = DateTime.now();
//       final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//       final startOfMonth = DateTime(now.year, now.month, 1);
//       final startOfAll = DateTime(2020);
//
//       String formatDate(DateTime d) =>
//           "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//
//       final urls = {
//         "today": 'https://bhamma.equi.website/api/dailySummary?start_date=${formatDate(now)}&end_date=${formatDate(now)}',
//         "week": 'https://bhamma.equi.website/api/dailySummary?start_date=${formatDate(startOfWeek)}&end_date=${formatDate(now)}',
//         "month": 'https://bhamma.equi.website/api/dailySummary?start_date=${formatDate(startOfMonth)}&end_date=${formatDate(now)}',
//         "total": 'https://bhamma.equi.website/api/dailySummary?start_date=${formatDate(startOfAll)}&end_date=${formatDate(now)}',
//       };
//
//       final headers = {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       };
//
//       final responses = await Future.wait([
//         http.get(Uri.parse(urls['today']!), headers: headers),
//         http.get(Uri.parse(urls['week']!), headers: headers),
//         http.get(Uri.parse(urls['month']!), headers: headers),
//         http.get(Uri.parse(urls['total']!), headers: headers),
//       ]);
//
//       setState(() {
//         today = json.decode(responses[0].body)['total_earning']?.toString() ?? "0";
//         week = json.decode(responses[1].body)['total_earning']?.toString() ?? "0";
//         month = json.decode(responses[2].body)['total_earning']?.toString() ?? "0";
//         total = json.decode(responses[3].body)['total_earning']?.toString() ?? "0";
//         isLoading = false;
//       });
//
//       if (selectedTab == "Custom" && fromDate != null && toDate != null) {
//         await fetchCustomEarning(token, formatDate(fromDate!), formatDate(toDate!));
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         today = week = month = total = custom = "0";
//       });
//     }
//   }
//
//   Future<void> fetchCustomEarning(String token, String from, String to) async {
//     final response = await http.get(
//       Uri.parse('https://bhamma.equi.website/api/dailySummary?start_date=$from&end_date=$to'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );
//     final decoded = json.decode(response.body);
//     setState(() {
//       custom = decoded['total_earning']?.toString() ?? "0";
//     });
//   }
//
//   Future<void> pickDateRange() async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       initialDateRange: fromDate != null && toDate != null
//           ? DateTimeRange(start: fromDate!, end: toDate!)
//           : null,
//     );
//
//     if (picked != null) {
//       setState(() {
//         fromDate = picked.start;
//         toDate = picked.end;
//         selectedTab = "Custom";
//         isLoading = true;
//       });
//       await fetchEarnings();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("My Earning", style: TextStyle(color: DefaultColor.mainColor)),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
//             onPressed: () => Navigator.pop(context),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.date_range, color: DefaultColor.mainColor),
//               onPressed: pickDateRange,
//             ),
//           ],
//         ),
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildTabContainer("All"),
//                     const SizedBox(width: 10),
//                     _buildTabContainer("Today's"),
//                     const SizedBox(width: 10),
//                     _buildTabContainer("This week"),
//                     const SizedBox(width: 10),
//                     _buildTabContainer("This month"),
//                     const SizedBox(width: 10),
//                     _buildTabContainer("Custom"),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(child: _buildEarningContent()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContainer(String title) {
//     bool isSelected = selectedTab == title;
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return GestureDetector(
//       onTap: () async {
//         setState(() {
//           selectedTab = title;
//           isLoading = true;
//         });
//         await fetchEarnings();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         decoration: BoxDecoration(
//           color: isSelected ? DefaultColor.mainColor : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: DefaultColor.mainColor),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isSelected
//                 ? (isDarkMode ? Colors.black54 : Colors.white)
//                 : (isDarkMode ? Colors.white : Colors.black54),
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEarningContent() {
//     String title = "";
//     String amount = "";
//
//     switch (selectedTab) {
//       case "Today's":
//         title = "Today's Earnings";
//         amount = today;
//         break;
//       case "This week":
//         title = "This Week's Earnings";
//         amount = week;
//         break;
//       case "This month":
//         title = "This Month's Earnings";
//         amount = month;
//         break;
//       case "Custom":
//         if (fromDate != null && toDate != null) {
//           title = "Custom Date Earnings\n(${formatDate(fromDate!)} to ${formatDate(toDate!)})";
//         } else {
//           title = "Please select a custom date range";
//         }
//         amount = custom;
//         break;
//       default:
//         title = "Total Earnings";
//         amount = total;
//     }
//
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: isDarkMode ? Colors.white70 : Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             "₹$amount",
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: DefaultColor.mainColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String formatDate(DateTime date) {
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }
// }
//


// 📁 File: lib/screens/earning_statement_page.dart
