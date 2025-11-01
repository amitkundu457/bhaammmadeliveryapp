import 'dart:convert';
import 'package:bhamma_delivery_boy/screen/orders/widgets/custom_order_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_consts.dart';
import '../../api/api_helper.dart';
import '../../models/assign_order_model.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/buttom_manu.dart';
import '../../widgets/custom_image_view.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int selectedIndex = 1;
  var token;
  var delivered = "";
  var accept = "";
  bool isLoading = true;
  AssignOrderModel? assignOrderModel;
  void onClicked(int index) {
    if (selectedIndex != index) {
      setState(() => selectedIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();

  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString('login_token');
    try {
      assignOrderModel = await ApiHandler.fetchAssignOrder(token!);
      print("this result is ${jsonEncode(assignOrderModel)}");

      final pendingOrders = assignOrderModel?.deliveryRequests
          ?.where((request) =>
              request.status == "accepted" &&
              (request.deliveryStatus == "delivered"))
          .toList();
      final pendingOrders1 = assignOrderModel?.deliveryRequests
          ?.where((request) =>
              request.status == "accepted" &&
              (request.deliveryStatus == null || request.deliveryStatus == ""))
          .toList();

      delivered = pendingOrders?.length.toString() ?? "0";
      accept = pendingOrders1?.length.toString() ?? "0";
    } catch (e) {
      isLoading = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // void toggleExpanded() {
  //   setState(() => isExpanded = !isExpanded);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomMenu(
          selectedIndex: selectedIndex,
          onClicked: onClicked,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileSection(),
              const SizedBox(height: 25),
              _buildOrderStatusSection(),
              const SizedBox(height: 25),
              isLoading
                  ? LoadingAnimationWidget.dotsTriangle(
                      color: DefaultColor.mainColor,
                      size: 50,
                    )
                  : _buildOrderList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    final pendingOrders = assignOrderModel?.deliveryRequests
        ?.where((request) => request.status == "pending")
        .toList();

    if (pendingOrders == null || pendingOrders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 100,
                color: Color(0xFFBDBDBD),
              ),
              const SizedBox(height: 20),
              const Text(
                "No Orders Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "You're all caught up for now!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingOrders.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final order = pendingOrders[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/order_details",
                arguments: order.orderId);
          },
          child: CustomOrderCard(
            orderNumber: order.orderId.toString(),
            sellerName: "Seller Name",
            customerName: order.purchase?.customer!.customerdetails!.name ?? "",
            locationS: "Seller Location",
            locationC:
                "${order.purchase?.customer?.address?[0].houseBuilding ?? ""} "
                "${order.purchase?.customer?.address?[0].roadAreaColony ?? ""} "
                "${order.purchase?.customer?.address?[0].pincode ?? ""}",
             //assignedDate:order.purchase?.purchaseItems?[0].createdAt.toString()??"",
            assignedDate: (order.purchase?.purchaseItems != null &&
                    order.purchase!.purchaseItems!.isNotEmpty)
                ? order.purchase!.purchaseItems![0].createdAt.toString()
                : "",
            onAccept: () => _handleAccept(order.orderId!, token),
            onReject: () => _handleReject(order.orderId!, token),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: DefaultColor.mainColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      child: isLoading
          ? Container(
              height: 60,
            )
          : Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Change border color if needed
                      width: 2, // Adjust border width
                    ),
                  ),
                  child: ClipOval(
                    // Ensures the image stays circular
                    child: CustomImageView(
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                        imagePath: imageUrl + assignOrderModel!.profileImage.toString()),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignOrderModel!.deliveryman!.name ?? "No Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      assignOrderModel!.deliveryman!.email ?? "No Name",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.pink),
                  onPressed: () {
                    Navigator.pushNamed(context, "/notification");
                  },
                )
              ],
            ),
    );
  }

  Widget _buildOrderStatusSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/order_assigned");
            },
            child: _buildOrderStatusTile(
              icon: Icons.delivery_dining,
              label: 'Accepted',
              count: accept,
              color: DefaultColor.mainColor,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/order_delivered");
            },
            child: _buildOrderStatusTile(
              icon: Icons.card_giftcard,
              label: 'Delivered',
              count: delivered,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusTile({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAccept(int orderId, String token) async {
    var result =
        await ApiHandler.deliveryResponse("accepted", orderId, token, context);
    if (result == "success") {
      setState(() {
        ToastManager.showToast(
          msg: "Order Accepted",
          color: DefaultColor.green,
          context: context,
        );
        getDetails();
      });
    }
  }

  void _handleReject(orderId, token) async {
    var result =
        await ApiHandler.deliveryResponse("declined", orderId, token, context);
    if (result == "success") {
      setState(() {
        ToastManager.showToast(
          msg: "Order Declined",
          color: DefaultColor.mainColor,
          context: context,
        );
        getDetails();
      });
    }
  }
}
