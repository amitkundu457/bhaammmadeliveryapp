import 'dart:convert';
import 'package:bhamma_delivery_boy/screen/profile/pages/earning_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/bouncing_entrances/bounce_in_down.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_up.dart' show FadeInUp;
import 'package:flutter_switch/flutter_switch.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_consts.dart';
import '../api/api_helper.dart';
import '../models/assign_order_model.dart';
import '../models/profile_details.dart';
import '../models/wallet_model.dart';
import '../utils/default_colors.dart';
import '../widgets/buttom_manu.dart';
import '../widgets/custom_image_view.dart';
import 'orders/assigned_order_list_screen.dart';
import 'orders/delivered_order_list_screen.dart';
import 'orders/order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  ProfileDetails? profileDetails;
  AssignOrderModel? assignOrderModel;
  WalletModel? walletModel;
  bool isOnline = false;
  int? onlineValue;
  int? avgRating;
  var delivered = "";
  var accept = "";
  var assign = "";
  var balance = "";
  bool isLoading = true;

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('login_token');
    try {
      profileDetails = await ApiHandler.getDeliveryBoydetails(token!);

      print("avg rating is $avgRating");

      if (profileDetails!.passportNumber == "" &&
          profileDetails!.cardNumber == "" &&
          profileDetails!.licenceNumber == "") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/submit_doc",
          (route) => false,
        );
      } else if (profileDetails!.user!.status == 0) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/document_verification",
          (route) => false,
        );
      } else if (profileDetails!.bankName == "") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/bank_details",
          (route) => false,
        );
      }

      onlineValue = profileDetails!.isOnline;
      onlineValue == 1 ? isOnline = true : false;
      print("online value $onlineValue");

      assignOrderModel = await ApiHandler.fetchAssignOrder(token);
      print("this result is ${jsonEncode(assignOrderModel)}");

      walletModel = await ApiHandler.fetchWallet(token);
      print("this result is ${jsonEncode(walletModel)}");

      final pendingOrders =
          assignOrderModel?.deliveryRequests
              ?.where(
                (request) =>
                    request.status == "accepted" &&
                    (request.deliveryStatus == "delivered"),
              )
              .toList();
      final pendingOrders1 =
          assignOrderModel?.deliveryRequests
              ?.where(
                (request) =>
                    request.status == "accepted" &&
                    (request.deliveryStatus == null ||
                        request.deliveryStatus == ""),
              )
              .toList();
      final pendingOrders2 =
          assignOrderModel?.deliveryRequests
              ?.where(
                (request) =>
                    request.status == "pending" &&
                    (request.deliveryStatus == null ||
                        request.deliveryStatus == ""),
              )
              .toList();

      delivered = pendingOrders?.length.toString() ?? "0";
      accept = pendingOrders1?.length.toString() ?? "0";
      assign = pendingOrders2?.length.toString() ?? "0";
      balance = walletModel!.totalWallet.toString();
      avgRating = await ApiHandler.fetchAvgRating(token);
    } catch (e) {
      isLoading = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: DefaultColor.mainColor),
        ),
        centerTitle: true,
        //backgroundColor: isOnline ? Colors.green : Colors.red,
        automaticallyImplyLeading: false,
        actions: [
          FlutterSwitch(
            width: 95.0,
            height: 33.0,
            toggleSize: 30.0,
            value: isOnline,
            borderRadius: 20.0,
            padding: 4.0,
            activeColor: Colors.green,
            inactiveColor: DefaultColor.mainColor,
            activeText: "Online",
            inactiveText: "Offline",
            duration: const Duration(milliseconds: 300),
            activeTextColor: Colors.white,
            inactiveTextColor: Colors.white,
            showOnOff: true,
            onToggle: (val) {
              setState(() async {
                isOnline = val;
                onlineValue = val ? 1 : 0;
                print("Online value: $onlineValue"); // optional: for debugging
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                var token = await prefs.getString('login_token');
                int? userId = await prefs.getInt("user_id");

                var result = await ApiHandler.updateOnlineMode(
                  onlineValue!.toString(),
                  token!,
                  userId.toString(),
                  context,
                );
                if (result == "success") {
                  setState(() {
                    showDialog(
                      context: context,
                      builder:
                          (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor:
                                val ? Colors.green[50] : Colors.red[50],
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    val
                                        ? Icons.check_circle_outline
                                        : Icons.error_outline,
                                    color: val ? Colors.green : Colors.red,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    val
                                        ? "You are now Online"
                                        : "You are now Offline",
                                    style: TextStyle(
                                      color:
                                          val
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    );
                  });
                }
                // Auto-close the dialog after 1.5 seconds
                Future.delayed(const Duration(milliseconds: 900), () {
                  Navigator.of(context).pop();
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.pink),
            onPressed: () {
              Navigator.pushNamed(context, "/notification");
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(
        selectedIndex: selectedIndex,
        onClicked: onClicked,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileSection(),
              const SizedBox(height: 30),
              _buildStatGrid(),
              const SizedBox(height: 20),
              _buildWithdrawButton(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProfileSection() {
    return isLoading
        ? Column(
          children: [
            BounceInDown(
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: DefaultColor.mainColor,
                child: CircleAvatar(
                  radius: 47,
                  backgroundImage: AssetImage("assets/images/p_image.jpeg"),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text("", style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            _buildStarRating(0),
          ],
        )
        : Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: DefaultColor.mainColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(65),
                child: CustomImageView(
                  height: 95,
                  width: 95,
                  fit: BoxFit.cover,
                  imagePath: (profileDetails?.profileImage != null &&
                      profileDetails!.profileImage!.isNotEmpty)
                      ? imageUrl + profileDetails!.profileImage!
                      : 'assets/images/hs.png',
                  placeHolder: 'assets/images/hs.png', // ✅ existing image
                ),

              ),
            ),
            Text(
              profileDetails?.user?.name?.toString() ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              profileDetails?.user?.email?.toString() ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            _buildStarRating(avgRating ?? 0),
          ],
        );
  }

  // Widget _buildProfileSection() {
  //   return isLoading
  //       ? Column(
  //           children: [
  //             BounceInDown(
  //               child: const CircleAvatar(
  //                 radius: 50,
  //                 backgroundColor: DefaultColor.mainColor,
  //                 child: CircleAvatar(
  //                   radius: 47,
  //                   backgroundImage: AssetImage("assets/images/p_image.jpeg"),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             const Text(
  //               "",
  //               style: TextStyle(
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const Text(
  //               "",
  //               style: TextStyle(fontSize: 14, color: Colors.grey),
  //             ),
  //             const SizedBox(height: 8),
  //             _buildStarRating(0),
  //           ],
  //         )
  //       : Column(
  //           children: [
  //             CircleAvatar(
  //               radius: 50,
  //               backgroundColor: DefaultColor.mainColor,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(65),
  //                 child: CustomImageView(
  //                   height: 95,
  //                   width: 95,
  //                   fit: BoxFit.cover,
  //                   imagePath:
  //                       (profileDetails?.profileImage?.isNotEmpty ?? false)
  //                           ? imageUrl + profileDetails!.profileImage.toString()
  //                           : 'assets/images/p_image.jpeg',
  //                 ),
  //               ),
  //             ),
  //             Text(
  //               profileDetails?.user?.name?.toString() ?? '',
  //               style: TextStyle(
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             Text(
  //               profileDetails?.user?.email?.toString() ?? '',
  //               style: TextStyle(fontSize: 14, color: Colors.grey),
  //             ),
  //             const SizedBox(height: 8),
  //             _buildStarRating(avgRating ?? 0),
  //           ],
  //         );
  // }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 28,
        );
      }),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildAnimatedStatCard(
          assign,
          "Assigned Order",
          Icons.assignment,
          Colors.purple,
          const OrderScreen(),
        ),
        _buildAnimatedStatCard(
          accept,
          "Accept Delivery",
          Icons.local_shipping,
          Colors.red,
          const AssignedOrdersPage(),
        ),
        _buildAnimatedStatCard(
          delivered.toString(),
          "Total Delivered",
          Icons.check_circle,
          Colors.green,
          const DeliveredOrdersPage(),
        ),
        //_buildAnimatedStatCard("$balance €", "Total Earning", Icons.euro,
        _buildAnimatedStatCard(
          "$balance ₹",
          "Total Earning",
          Icons.currency_rupee,
          Colors.blue,
          const EarningStatementPage(),
        ),
      ],
    );
  }

  Widget _buildAnimatedStatCard(
    String value,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return FadeInUp(
      //  duration: Duration(milliseconds: 500),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              duration: const Duration(milliseconds: 150),
              type: PageTransitionType.fade,
              child: page,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return FadeInUp(
      //  duration: Duration(milliseconds: 600),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/withdraw");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 126, 60, 138),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          child: const Text(
            "Withdrawable Balance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
