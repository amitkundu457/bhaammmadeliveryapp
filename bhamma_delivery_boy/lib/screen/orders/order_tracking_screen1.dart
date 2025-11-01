// import 'package:flutter/material.dart';
//
// import '../../utils/default_colors.dart';
// import '../../widgets/custom_image_view.dart';
// class OrderTrackingPage extends StatelessWidget {
//   const OrderTrackingPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Stack(
//         children: [
//           const _MapSection(),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: AppBar(
//               backgroundColor: const Color.fromARGB(48, 0, 0, 0),
//         title:
//             const Text("Order tracking", style: TextStyle(color: DefaultColor.mainColor)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),),
//           const Align(
//             alignment: Alignment.bottomCenter,
//             child: _InfoCard(),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MapSection extends StatelessWidget {
//   const _MapSection();
//
//   @override
//   Widget build(BuildContext context) {
//     return
//
//         const SizedBox(
//
//           height: double.infinity,
//           width: double.infinity,
//           child: CustomImageView(
//             imagePath: "assets/images/map.png",
//           ),
//         );
//   }
// }
//
// class _InfoCard extends StatelessWidget {
//   const _InfoCard();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//         decoration: BoxDecoration(
//           color: DefaultColor.mainColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //const Icon(Icons.access_time, color: Colors.white),
//                 SizedBox(width: 8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '2:10 pm',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Delivery time',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//                 Spacer(),
//                 Icon(Icons.location_on, color: Colors.white),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Rua São Salvador 117 kolkata 20002',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         'Delivery place',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Divider(
//               color: DefaultColor.border.withOpacity(0.5),
//             ),
//             const SizedBox(height: 35),
//             Row(
//               children: [
//                 const CircleAvatar(
//                   backgroundImage: AssetImage('assets/images/profile.png'),
//                   radius: 24,
//                 ),
//                 const SizedBox(width: 12),
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Rene Elizabeth',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Customer',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 CircleAvatar(
//                   radius: 24, // Adjust size as needed
//
//                   backgroundColor:
//                       Colors.white.withOpacity(0.1), // Background color
//                   child: IconButton(
//                     icon: const Icon(Icons.phone, color: Colors.white),
//                     onPressed: () {
//                       // Handle call action
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
