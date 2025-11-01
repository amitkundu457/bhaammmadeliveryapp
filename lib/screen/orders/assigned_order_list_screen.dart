import 'dart:convert';
import 'package:bhamma_delivery_boy/screen/orders/widgets/custom_order_card.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/api_helper.dart';
import '../../models/assign_order_model.dart';
import '../../utils/default_colors.dart';
import '../../widgets/buttom_manu.dart';

class AssignedOrdersPage extends StatefulWidget {
  const AssignedOrdersPage({super.key});

  @override
  State<AssignedOrdersPage> createState() => _AssignedOrdersPageState();
}

class _AssignedOrdersPageState extends State<AssignedOrdersPage> {
  int selectedIndex = 1;
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
    setState(() {
      isLoading = true; // Set loading state at the start
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('login_token');
    try {
      if (token != null) {
        assignOrderModel = await ApiHandler.fetchAssignOrder(token);
        print("Fetched orders: ${jsonEncode(assignOrderModel)}");
      } else {
        print("No token found");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication error: No token found")),
        );
      }
    } catch (e) {
      print("Error fetching orders: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load orders: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handler for pull-to-refresh
  Future<void> _handleRefresh() async {
    print("Refresh triggered");
    await getDetails(); // Call getDetails to refresh data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(
        selectedIndex: selectedIndex,
        onClicked: onClicked,
      ),
      appBar: AppBar(
        title: const Text(
          "Assigned Orders",
          style: TextStyle(color: DefaultColor.mainColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
          onPressed: () {
            Navigator.pop(context); // Navigate Back to Previous Screen
          },
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: RefreshIndicator(
          onRefresh: _handleRefresh, // Bind the refresh handler
          color: DefaultColor.mainColor, // Refresh indicator color
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: DefaultColor.mainColor,
                    size: 50,
                  ),
                )
              : SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Ensure scrollability
                  child: _buildOrderList(),
                ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    final pendingOrders = assignOrderModel?.deliveryRequests
        ?.where((request) =>
            request.status == "accepted" &&
            (request.deliveryStatus == null ||
                request.deliveryStatus == "pickedup"))
        .toList();

    if (pendingOrders == null || pendingOrders.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height - 150,
        child: const Padding(
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
                SizedBox(height: 20),
                Text(
                  "No Orders Found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "You currently have no orders to deliver.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
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
            assignedDate: (order.purchase?.purchaseItems != null &&
                    order.purchase!.purchaseItems!.isNotEmpty)
                ? order.purchase!.purchaseItems![0].createdAt.toString()
                : "",
            isVisible: false,
            phonecall: () {
              final phoneNumber =
                  order.purchase?.customer?.customerdetails?.phone;
              if (phoneNumber != null) {
                _launchPhone(phoneNumber);
              }
            },
          ),
        );
      },
    );
  }

  void _launchPhone(String phone) async {
    if (phone.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (!await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open dialer")),
      );
    }
  }
}
