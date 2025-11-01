//
// import 'package:flutter/material.dart';
//
// import '../../../utils/default_colors.dart';
//
// class WithdrawableBalancePage extends StatelessWidget {
//   const WithdrawableBalancePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.white,
//       //   elevation: 0,
//       //   leading: IconButton(
//       //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//       //     onPressed: () {},
//       //   ),
//       //   title: const Text(
//       //     "Withdrawable Balance",
//       //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       //   ),
//       //   centerTitle: true,
//       // ),
//       appBar: AppBar(
//         title:
//             const Text("Withdrawable Balance", style: TextStyle(color: DefaultColor.mainColor)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
//           onPressed: () {
//             Navigator.pop(context); // Navigate Back to Previous Screen
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//
//             // Send Withdraw Request Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink.shade400,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//                 child: const Text(
//                   "Send Withdraw Request",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Financial Summary Cards
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _infoCard("0", "Delivery Charged Earned"),
//                 _infoCard("0", "Withdraw"),
//                 _infoCard("0", "Already Deposited"),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // Date Range Picker
//             _dateRangePicker(),
//
//             const SizedBox(height: 20),
//
//             // Section Title
//             const Text(
//               "Delivery Charged Earned",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget for financial summary cards
//   Widget _infoCard(String amount, String label) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         height: 120,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.pink.shade400,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Text(
//               amount,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 14, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget for Date Range Picker
//   Widget _dateRangePicker() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.pink.shade400,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _datePickerField("dd-mm-yyyy"),
//           const Icon(Icons.arrow_forward, color: Colors.white),
//           _datePickerField("dd-mm-yyyy"),
//           const Icon(Icons.filter_list, color: Colors.white),
//         ],
//       ),
//     );
//   }
//
//   // Widget for individual date input field
//   Widget _datePickerField(String placeholder) {
//     return Row(
//       children: [
//         Text(
//           placeholder,
//           style: const TextStyle(color: Colors.white, fontSize: 14),
//         ),
//         const SizedBox(width: 5),
//         const Icon(Icons.calendar_today, color: Colors.white, size: 18),
//       ],
//     );
//   }
// }