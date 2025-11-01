// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../api/api_helper.dart';
// import '../../../utils/custom_toast.dart';
// import '../../../utils/default_colors.dart';
//
// class DisputePage extends StatefulWidget {
//   final String? orderId;
//   final int? check;
//   const DisputePage({this.orderId, this.check, super.key});
//
//   @override
//   DisputePageState createState() => DisputePageState();
// }
//
// class DisputePageState extends State<DisputePage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final TextEditingController orderIdController = TextEditingController();
//   final TextEditingController descController = TextEditingController();
//   String? selectedReason;
//
//   List<String> reasons = [
//     "Item prepared as requested",
//     "Item not picked up",
//     "Order picked up late",
//     "Order handled improperly",
//     "Others"
//   ];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     orderIdController.text = widget.orderId ?? "";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height =MediaQuery.of(context).size.height;
//     final width =MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Resolution Center for Disputes",
//               style: TextStyle(color: DefaultColor.mainColor)),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 width: width,
//                 height: height,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min, // 👈 important
//                   children: [
//                     // Order ID
//                     TextFormField(
//                       controller: orderIdController,
//                       readOnly: widget.check == 1 ? true : false,
//                       decoration: const InputDecoration(
//                         labelText: "Dispute Order ID",
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(color: DefaultColor.mainColor)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: DefaultColor.mainColor)),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Order ID is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 30),
//
//                     // Details
//                     TextFormField(
//                       controller: descController,
//                       decoration: const InputDecoration(
//                         labelText: "Details",
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(color: DefaultColor.mainColor)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: DefaultColor.mainColor)),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Details are required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 100),
//
//                     const Text(
//                       "Why are you disputing the chargeback?",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//
//                     FormField<String>(
//                       validator: (value) {
//                         if (selectedReason == null || selectedReason!.isEmpty) {
//                           return 'Please select a reason';
//                         }
//                         return null;
//                       },
//                       builder: (FormFieldState<String> state) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 12),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: DefaultColor.mainColor),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton<String>(
//                                   hint: const Text("Reason*",
//                                       style: TextStyle(color: DefaultColor.mainColor)),
//                                   value: selectedReason,
//                                   isExpanded: true,
//                                   items: reasons.map((String reason) {
//                                     return DropdownMenuItem<String>(
//                                       value: reason,
//                                       child: Text(reason),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedReason = value;
//                                       state.didChange(value);
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                             if (state.hasError)
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 12, top: 5),
//                                 child: Text(
//                                   state.errorText!,
//                                   style: const TextStyle(
//                                       color: Colors.redAccent, fontSize: 12),
//                                 ),
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                     SizedBox(height: height * 0.3,),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.grey.shade300,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text("CANCEL",
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 final SharedPreferences prefs =
//                                     await SharedPreferences.getInstance();
//                                 var token = await prefs.getString('login_token');
//
//                                 var result = await ApiHandler.updateDisput(
//                                   orderIdController.text.trim(),
//                                   descController.text.trim(),
//                                   selectedReason!,
//                                   token!,
//                                   context,
//                                 );
//
//                                 if (result == "success") {
//                                   ToastManager.showToast(
//                                     msg: "Dispute received. Reviewing it now.",
//                                     color: DefaultColor.green,
//                                     context: context,
//                                   );
//                                   Navigator.pop(context);
//                                 }
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: DefaultColor.mainColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text("DISPUTE",
//                                 style: TextStyle(color: Colors.white)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
