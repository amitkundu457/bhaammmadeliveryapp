import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../../api/api_consts.dart';
import '../../api/api_helper.dart';
import '../../models/order_details_model.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/buttom_manu.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import 'order_tracking_screen.dart';
import 'otv_set_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int selectedIndex = 1;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? phone;
  OrderDetailsModel? orderDetailsModel;
  bool isDelivered = false;
  // Timer-related variables
  Timer? _timer;
  int _remainingSeconds = 300; // 2 minutes = 120 seconds
  bool _isTimerRunning = false;
  DateTime? _timerStartTime;
  String? _localStatus; // Local status: null, reached, timer_completed

  void onClicked(int index) {
    if (selectedIndex != index) {
      setState(() => selectedIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    _loadTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStartTime = prefs.getString('timer_start_${widget.orderId}');
    final savedLocalStatus = prefs.getString('local_status_${widget.orderId}');
    final savedRemainingSeconds =
        prefs.getInt('timer_remaining_${widget.orderId}');

    print(
        "Loading timer state: startTime=$savedStartTime, localStatus=$savedLocalStatus, remaining=$savedRemainingSeconds");

    setState(() {
      _localStatus = savedLocalStatus;
    });

    if (savedStartTime != null &&
        savedLocalStatus == 'reached' &&
        savedRemainingSeconds != null) {
      final startTime = DateTime.parse(savedStartTime);
      final elapsed = DateTime.now().difference(startTime).inSeconds;
      final remaining = savedRemainingSeconds - elapsed;

      print("Elapsed: $elapsed seconds, Remaining: $remaining seconds");

      if (remaining > 0) {
        setState(() {
          _remainingSeconds = remaining;
          _isTimerRunning = true;
          _timerStartTime = startTime;
        });
        _resumeTimer();
      } else {
        // Timer has already completed
        await prefs.setString(
            'local_status_${widget.orderId}', 'timer_completed');
        setState(() {
          _isTimerRunning = false;
          _timerStartTime = null;
          _remainingSeconds = 0;
          _localStatus = 'timer_completed';
        });
        print("Timer completed, setting local status to timer_completed");
      }
    } else if (savedLocalStatus == 'timer_completed') {
      setState(() {
        _isTimerRunning = false;
        _timerStartTime = null;
        _remainingSeconds = 0;
        _localStatus = 'timer_completed';
      });
      print("Restored timer_completed status");
    }
  }

  Future<void> _startTimer() async {
    final prefs = await SharedPreferences.getInstance();
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      _isTimerRunning = true;
      _timerStartTime = DateTime.now();
      _remainingSeconds = 120;
      _localStatus = 'reached';
    });

    // Save timer state
    await prefs.setString(
        'timer_start_${widget.orderId}', _timerStartTime!.toIso8601String());
    await prefs.setString('local_status_${widget.orderId}', 'reached');
    await prefs.setInt('timer_remaining_${widget.orderId}', _remainingSeconds);

    print(
        "Timer started: startTime=${_timerStartTime}, remaining=$_remainingSeconds");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          prefs.setInt('timer_remaining_${widget.orderId}', _remainingSeconds);
          print("Timer tick: remaining=$_remainingSeconds");
        } else {
          timer.cancel();
          _isTimerRunning = false;
          _timerStartTime = null;
          _localStatus = 'timer_completed';
          prefs.setString('local_status_${widget.orderId}', 'timer_completed');
          prefs.remove('timer_start_${widget.orderId}');
          prefs.remove('timer_remaining_${widget.orderId}');
          print("Timer completed");
        }
      });
    });
  }

  Future<void> _resumeTimer() async {
    final prefs = await SharedPreferences.getInstance();
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      _isTimerRunning = true;
    });

    print("Resuming timer: remaining=$_remainingSeconds");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          prefs.setInt('timer_remaining_${widget.orderId}', _remainingSeconds);
          print("Timer tick: remaining=$_remainingSeconds");
        } else {
          timer.cancel();
          _isTimerRunning = false;
          _timerStartTime = null;
          _localStatus = 'timer_completed';
          prefs.setString('local_status_${widget.orderId}', 'timer_completed');
          prefs.remove('timer_start_${widget.orderId}');
          prefs.remove('timer_remaining_${widget.orderId}');
          print("Timer completed");
        }
      });
    });
  }

  Future<void> getDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
    });

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          hasError = true;
          errorMessage = "No internet connection. Please check your network.";
        });
        return;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('login_token');

      if (token == null || token.isEmpty) {
        setState(() {
          hasError = true;
          errorMessage = "Authentication error. Please log in again.";
        });
        return;
      }

      final result = await ApiHandler.fetchOrderDetails(token, widget.orderId);
      if (result == null) {
        setState(() {
          hasError = true;
          errorMessage = "Failed to load order details. Please try again.";
        });
        return;
      }

      setState(() {
        orderDetailsModel = result;
        phone = orderDetailsModel?.deliveryRequests?.first.purchase?.customer
                ?.customerdetails?.phone ??
            '';
        print("Order details: ${jsonEncode(orderDetailsModel)}");
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = "Error fetching order details: $e";
      });
      print("Error while fetching details: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(
        selectedIndex: selectedIndex,
        onClicked: onClicked,
      ),
      appBar: AppBar(
        title: const Text("Order Details", style: TextStyle(color: DefaultColor.mainColor)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: DefaultColor.mainColor,
                  size: 50,
                ),
              )
            : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage ?? "An error occurred",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          text: "Retry",
                          onPressed: getDetails,
                        ),
                      ],
                    ),
                  )
                : orderDetailsModel == null ||
                        orderDetailsModel!.deliveryRequests == null ||
                        orderDetailsModel!.deliveryRequests!.isEmpty
                    ? const Center(
                        child: Text(
                          "No order details available",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : _buildOrderDetails(context),
      ),
    );
  }
  Widget _buildOrderDetails(BuildContext context) {
    final purchase = orderDetailsModel!.deliveryRequests![0].purchase;
    final customer = purchase?.customer;
    final address = customer?.address?.first;
    final customerDetails = customer?.customerdetails;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (purchase?.purchaseItems != null &&
                      purchase!.purchaseItems!.isNotEmpty)
                    ...purchase.purchaseItems!.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            e.productDetails?.featureImage != null
                                ? Image.network(
                              imageUrlstorage + e.productDetails!.featureImage!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.image_sharp,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Icon(
                                    Icons.image_sharp,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.productDetails?.title ?? 'No Title',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    e.productDetails?.shortDescription ??
                                        "Description not available",
                                    maxLines: 2,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "Quantity: ${e.quantity ?? 0}",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${e.price ?? 0}₹',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Invoice:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildCustomerDetail1('Order ID:', widget.orderId.toString(),
                      DefaultColor.black, context),
                  _buildCustomerDetail1(
                      'Total No Of Produce:',
                      purchase?.purchaseItems?.length.toString() ?? '0',
                      DefaultColor.black,
                      context),
                  _buildCustomerDetail1('Order Amount:',
                      '${purchase?.total ?? 0} ₹', DefaultColor.black, context),
                  const SizedBox(height: 20),
                  const Text(
                    'Customer Details:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildCustomerDetail('Name:', customerDetails?.name ?? 'N/A',
                      DefaultColor.black.withOpacity(0.5), context),
                  _buildCustomerDetail(
                      'Address:',
                      address != null
                          ? "${address.houseBuilding ?? ''} ${address.roadAreaColony ?? ''} ${address.city ?? ''}"
                          : 'N/A',
                      DefaultColor.black.withOpacity(0.5),
                      context),
                  _buildCustomerDetail('Pin code:', address?.pincode ?? 'N/A',
                      DefaultColor.black.withOpacity(0.5), context),
                  _buildCustomerDetail(
                      'Contact:',
                      customerDetails?.phone ?? 'N/A',
                      DefaultColor.black.withOpacity(0.5),
                      context,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Special Instruction:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: DefaultColor.mainColor,
                                  fontSize: 16),
                            ),
                            Text(
                              purchase?.insDes ?? 'No instructionss',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, PageTransition(
                              duration: const Duration(milliseconds: 350),
                              reverseDuration:
                                  const Duration(milliseconds: 350),
                              type: PageTransitionType.fade,
                              child: OrderTrackingPage(
                                name: customerDetails?.name ?? 'N/A',
                                address: address != null
                                    ? "${address.houseBuilding ?? ''} ${address.roadAreaColony ?? ''} ${address.city ?? ''}"
                                    : 'N/A',
                                phone: phone ?? 'N/A',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: DefaultColor.border, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CustomImageView(
                              radius: BorderRadius.circular(10),
                              imagePath: "assets/images/map.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Display timer if running
                  if (_isTimerRunning && _remainingSeconds > 0)
                    Center(
                      child: Text(
                        'Time Remaining: ${_formatTime(_remainingSeconds)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.phone, color: Colors.green),
                  onPressed: phone != null && phone!.isNotEmpty ? _launchPhone : null,
                ),
                const Text('Call'),
              ],
            ),
            // Column(
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.message, color: Colors.blue),
            //       onPressed: () {},
            //     ),
            //     const Text('Chat'),
            //   ],
            // ),
            // Column(
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.report_problem, color: Colors.red),
            //       onPressed: () {
            //         // DisputePage
            //         Navigator.push(context, PageTransition(
            //               duration: const Duration(milliseconds: 150),
            //               reverseDuration: const Duration(milliseconds: 150),
            //               type: PageTransitionType.fade,
            //               child: DisputePage(
            //                 orderId: widget.orderId.toString(),
            //                 check: 1,
            //               ),
            //             )
            //         );
            //       },
            //     ),
            //     const Text('Issue'),
            //   ],
            // ),
          ],
        ),
        // Button logic based on delivery status and local status
        if (orderDetailsModel!.deliveryRequests![0].deliveryStatus == "")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: CustomElevatedButton(
              text: "Picked Up",
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('login_token');

                try {
                  //   await ApiHandler.updateDeliveryStatus(token, widget.orderId, 'pickedup');
                  var result = await ApiHandler.delivePickedup(
                      "pickedup", widget.orderId, token!, context);
                  if (result == "success") {
                    ToastManager.showToast(
                      msg: "Order Pickedup",
                      color: DefaultColor.green,
                      context: context,
                    );
                  }

                  setState(() {
                    orderDetailsModel!.deliveryRequests![0].deliveryStatus =
                        'pickedup';
                    _localStatus = 'pickedup';
                  });
                  await prefs.setString(
                      'local_status_${widget.orderId}', 'pickedup');
                  print("Delivery Status: pickedup");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update status: $e")),
                  );
                }
              },
            ),
          )
        else if (orderDetailsModel!.deliveryRequests![0].deliveryStatus ==
                "pickedup" &&
            _localStatus != 'reached' &&
            _localStatus != 'timer_completed')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: CustomElevatedButton(
              text: "Reached Customer",
              onPressed: () async {
                await _startTimer();
                print("Local Status: reached");
                setState(() {
                  isDelivered = true;
                });
              },
            ),
          )
        else if (_localStatus == "timer_completed")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child:
                // CustomElevatedButton(
                //   text: "Delivered Forcefully",
                //   onPressed: () async {
                //     final prefs = await SharedPreferences.getInstance();
                //     final token = prefs.getString('login_token');
                //     if (token == null) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //             content:
                //                 Text("Authentication error. Please log in again.")),
                //       );
                //       return;
                //     }
                //     try {
                //       //  await ApiHandler.updateDeliveryStatus(token, widget.orderId, 'delivered');
                //       setState(() {
                //         orderDetailsModel!.deliveryRequests![0].deliveryStatus =
                //             'delivered';
                //         _localStatus = null; // Reset local status
                //       });
                //       await prefs.remove('local_status_${widget.orderId}');
                //       await prefs.remove('timer_start_${widget.orderId}');
                //       await prefs.remove('timer_remaining_${widget.orderId}');
                //      // Navigator.pushNamed(context, "/otp");

                //       print("Delivery Status: delivered");
                //     } catch (e) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text("Failed to update status: $e")),
                //       );
                //     }
                //   },
                // ),
                CustomElevatedButton(
              text: "Delivered Forcefully",
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('login_token');

                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Authentication error. Please log in again.")),
                  );
                  return;
                }
                try {
                  // Step 1: Pick image from camera
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);

                  if (pickedFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No image captured.")),
                    );
                    return;
                  }

                  File imageFile = File(pickedFile.path);

                  // Step 2: Send image and update status
                  setState(() {
                    orderDetailsModel!.deliveryRequests![0].deliveryStatus = 'delivered';
                    _localStatus = null;
                  });

                  await prefs.remove('local_status_${widget.orderId}');
                  await prefs.remove('timer_start_${widget.orderId}');
                  await prefs.remove('timer_remaining_${widget.orderId}');

                  // Step 3: Send to server
                  final request = http.MultipartRequest(
                    'POST',
                    Uri.parse('$baseUrl$proof'), // replace with your endpoint
                  );
                  request.headers['Authorization'] = 'Bearer $token';
                  request.fields['order_id'] = widget.orderId.toString();
                  request.files.add(await http.MultipartFile.fromPath(
                    'image',
                    imageFile.path,
                    filename: path.basename(imageFile.path),
                  ));
                  var result = await ApiHandler.delivePickedup("delivered", widget.orderId, token, context);
                  final response = await request.send();
                  print("response: ${response.statusCode}");
                  if (response.statusCode == 200) {
                    ToastManager.showToast(
                      msg: "Delivery photo uploaded successfully.",
                      color: DefaultColor.green,
                      context: context,
                    );
                  } else {}

                  print("Delivery Status: delivered");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed: $e")),
                  );
                }
              },
            ),
          ),
        orderDetailsModel!.deliveryRequests![0].deliveryStatus == 'pickedup' && isDelivered == true
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: CustomElevatedButton(
                  text: "Delivered",
                  onPressed: () async {
                    try {
                      // ✅ Local state update
                      setState(() {
                        orderDetailsModel!.deliveryRequests![0].deliveryStatus = 'delivered';
                        _localStatus = null; // Reset local status
                      });

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('local_status_${widget.orderId}');
                      await prefs.remove('timer_start_${widget.orderId}');
                      await prefs.remove('timer_remaining_${widget.orderId}');

                      // ✅ API Call
                      final token = prefs.getString('login_token');
                      var result = await ApiHandler.delivePickedup(
                        "delivered",
                        int.parse(widget.orderId.toString()),
                        token!,
                        context,
                      );
                      print("result: $result");

                      if (result == "success") {
                        // ✅ Toast
                        ToastManager.showToast(
                          msg: "Delivered Successfully",
                          color: DefaultColor.green,
                          context: context,
                        );

                        // ✅navigate order screen
                        Navigator.restorablePushReplacementNamed(context, "/order");
                      } else {
                        ToastManager.showToast(
                          msg: "Failed to update delivery",
                          color: DefaultColor.black,
                          context: context,
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },

                  // onPressed: () async {
                  //   // final prefs = await SharedPreferences.getInstance();
                  //   // final token = prefs.getString('login_token');
                  //
                  //   try {
                  //     //  await ApiHandler.updateDeliveryStatus(token, widget.orderId, 'delivered');
                  //     // var result = await ApiHandler.delivePickedup(
                  //     //     "delivered", widget.orderId, token!, context);
                  //     // print("result: $result");
                  //     // if (result == "success") {
                  //     //   ToastManager.showToast(
                  //     //     msg: "Order Delivered",
                  //     //     color: DefaultColor.green,
                  //     //     context: context,
                  //     //   );
                  //     // }
                  //     setState(() {
                  //       orderDetailsModel!.deliveryRequests![0].deliveryStatus = 'delivered';
                  //       _localStatus = null; // Reset local status
                  //     });
                  //     final prefs = await SharedPreferences.getInstance();
                  //     await prefs.remove('local_status_${widget.orderId}');
                  //     await prefs.remove('timer_start_${widget.orderId}');
                  //     await prefs.remove('timer_remaining_${widget.orderId}');
                  //     //  Navigator.pushNamed(context, "/otp");
                  //     Navigator.pushReplacement(
                  //         context,
                  //         PageTransition(
                  //           duration: const Duration(milliseconds: 150),
                  //           reverseDuration: const Duration(milliseconds: 150),
                  //           type: PageTransitionType.fade,
                  //           child: OtpScreen(
                  //             orderId: widget.orderId.toString(),
                  //           ),
                  //         ));
                  //     print("Delivery Status: delivered");
                  //   } catch (e) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text("Failed to update status: $e")),
                  //     );
                  //   }
                  // },
                ),
              )
            : Container(),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Widget _buildCustomerDetail(String title, String value, Color valueColor, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 14),
          children: [
            TextSpan(
              text: '$title   ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: valueColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetail1(String title, String value, Color valueColor, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _launchPhone() async {
    if (phone == null || phone!.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (!await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open dialer")),
      );
    }
  }
}
