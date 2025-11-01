//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../api/api_helper.dart';
// import '../../../models/earning_model.dart';
// import '../../../utils/default_colors.dart';
//
// class EarningStatementPage extends StatefulWidget {
//   const EarningStatementPage({super.key});
//
//   @override
//   EarningStatementPageState createState() => EarningStatementPageState();
// }
//
// class EarningStatementPageState extends State<EarningStatementPage> {
//   DateTime? selectedDate;
//   Map<String, dynamic> earningsData = {};
//   bool isLoading = true;
//
//   final List<String> earningKeys = [
//     "total_base_earning",
//     "total_on_time_bonus",
//     "total_high_volume_bonus",
//     "total_other_bonus",
//     "total_incentive",
//     "total_bonus",
//     "total_amount"
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEarnings();
//   }
//
//   Future<void> fetchEarnings({DateTime? date}) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = await prefs.getString('login_token');
//     setState(() => isLoading = true);
//     try {
//       EarningModel wallet =
//           await ApiHandler.fetchEarning(token.toString(), date: date);
//       setState(() {
//         earningsData = {
//           'total_base_earning': wallet.totalBaseEarning,
//           'total_on_time_bonus': wallet.totalOnTimeBonus,
//           'total_high_volume_bonus': wallet.totalHighVolumeBonus,
//           'total_other_bonus': wallet.totalOtherBonus,
//           'total_incentive': wallet.totalIncentive,
//           'total_bonus': wallet.totalBonus,
//           'total_amount': wallet.totalAmount,
//         };
//       });
//     } catch (e) {
//       print("API error: $e");
//       setState(() => earningsData = {});
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2026),
//     );
//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//       });
//       await fetchEarnings(date: picked);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final selectedDateStr = selectedDate != null
//         ? DateFormat('yyyy-MM-dd').format(selectedDate!)
//         : "Till Now";
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Earning Statement",
//             style: TextStyle(color: DefaultColor.mainColor),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
//             onPressed: () => Navigator.pop(context),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.calendar_today, color: DefaultColor.mainColor),
//               onPressed: () => _selectDate(context),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               Text(
//                 "Selected Date: $selectedDateStr",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                   color: isDarkMode ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               isLoading
//                   ? Center(
//                       child: Container(
//                         height: MediaQuery.of(context).size.height - 200,
//                         width: MediaQuery.of(context).size.width,
//                         child: LoadingAnimationWidget.dotsTriangle(
//                           color: DefaultColor.mainColor,
//                           size: 50,
//                         ),
//                       ),
//                     )
//                   : _buildEarningsList()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEarningsList() {
//     return Column(
//       children: [
//         ListView.builder(
//           padding: const EdgeInsets.all(16),
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: earningKeys.length,
//           itemBuilder: (context, index) {
//             final key = earningKeys[index];
//             final value = earningsData[key]?.toString() ?? " 200";
//
//             return Card(
//               elevation: 0,
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               child: ListTile(
//                 title: Text(
//                   key.replaceAll("_", " ").toUpperCase(),
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 trailing: Text(
//                   "$value €",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: DefaultColor.green,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Navigator.pushNamed(context, "/withdraw");
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 126, 60, 138),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 elevation: 5,
//               ),
//               child: const Text(
//                 "Withdrawable Balance",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// 📁 File: lib/screens/earning_statement_page.dart
import 'package:bhamma_delivery_boy/api/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/default_colors.dart';

class EarningStatementPage extends StatefulWidget {
  const EarningStatementPage({super.key});

  @override
  State<EarningStatementPage> createState() => _EarningStatementPageState();
}

class _EarningStatementPageState extends State<EarningStatementPage> {
  String selectedTab = "All";

  String today = "0", week = "0", month = "0", total = "0", custom = "0";
  DateTime? fromDate, toDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEarnings();
  }

  Future<void> fetchEarnings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('login_token') ?? '';

    if (token.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final result = await ApiHandler.fetchAllEarnings(token);
      setState(() {
        today = result['today'] ?? "0";
        week = result['week'] ?? "0";
        month = result['month'] ?? "0";
        total = result['total'] ?? "0";
        isLoading = false;
      });

      if (selectedTab == "Custom" && fromDate != null && toDate != null) {
        final customData = await ApiHandler.fetchCustomEarning(
          token,
          formatDate(fromDate!),
          formatDate(toDate!),
        );
        setState(() => custom = customData);
      }
    } catch (_) {
      setState(() {
        isLoading = false;
        today = week = month = total = custom = "0";
      });
    }
  }

  Future<void> pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
        selectedTab = "Custom";
        isLoading = true;
      });
      await fetchEarnings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Earning", style: TextStyle(color: DefaultColor.mainColor)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.date_range, color: DefaultColor.mainColor),
              onPressed: pickDateRange,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabContainer("All"),
                    const SizedBox(width: 10),
                    _buildTabContainer("Today's"),
                    const SizedBox(width: 10),
                    _buildTabContainer("This week"),
                    const SizedBox(width: 10),
                    _buildTabContainer("This month"),
                    const SizedBox(width: 10),
                    _buildTabContainer("Custom"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildEarningContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContainer(String title) {
    bool isSelected = selectedTab == title;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedTab = title;
          isLoading = true;
        });
        await fetchEarnings();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? DefaultColor.mainColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: DefaultColor.mainColor),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? (isDarkMode ? Colors.black54 : Colors.white)
                : (isDarkMode ? Colors.white : Colors.black54),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEarningContent() {
    String title = "";
    String amount = "";

    switch (selectedTab) {
      case "Today's":
        title = "Today's Earnings";
        amount = today;
        break;
      case "This week":
        title = "This Week's Earnings";
        amount = week;
        break;
      case "This month":
        title = "This Month's Earnings";
        amount = month;
        break;
      case "Custom":
        if (fromDate != null && toDate != null) {
          title = "Custom Date Earnings\n(${formatDate(fromDate!)} to ${formatDate(toDate!)})";
        } else {
          title = "Please select a custom date range";
        }
        amount = custom;
        break;
      default:
        title = "Total Earnings";
        amount = total;
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "₹$amount",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: DefaultColor.mainColor,
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
