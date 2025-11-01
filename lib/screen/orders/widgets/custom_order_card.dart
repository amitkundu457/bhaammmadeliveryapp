import 'package:flutter/material.dart';
import '../../../utils/default_colors.dart';
import '../../../widgets/custom_image_view.dart';

class CustomOrderCard extends StatefulWidget {
  final String orderNumber;
  final String sellerName;
  final String customerName;
  final String? locationC;
  final String? locationS;
  final String assignedDate;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? phonecall;
  final bool? isVisible;
  final bool? delivered;

  const CustomOrderCard({
    super.key,
    required this.orderNumber,
    required this.sellerName,
    required this.customerName,
    this.locationC,
    this.locationS,
    this.isVisible = true,
    this.delivered = false,
    required this.assignedDate,
    this.onAccept,
    this.onReject,
    this.phonecall,
  });

  @override
  State<CustomOrderCard> createState() => _CustomOrderCardState();
}
class _CustomOrderCardState extends State<CustomOrderCard> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() => isExpanded = !isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            isDarkMode
                ? BoxShadow(
                    blurRadius: 2,
                    color: Colors.grey.shade800,
                    offset: Offset(0, 1),
                    spreadRadius: 1)
                : BoxShadow(
                    blurRadius: 2,
                    color: Color.fromARGB(207, 222, 220, 221),
                    offset: Offset(1, 1),
                  )
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(),
              secondChild: _buildDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          widget.isVisible == false
              ? Padding(
                  padding: const EdgeInsets.only(right: 7.0),
                  child: Icon(Icons.shopping_bag_outlined,
                      size: 40, color: Colors.grey),
                )
              : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.delivered == false ? "Assign to me" : "Delivered",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Order #${widget.orderNumber}",
                style: const TextStyle(color: DefaultColor.mainColor),
              ),
            ],
          ),
          //const Spacer(),
          SizedBox(width: 2,),
          Expanded(child: widget.isVisible == true ? _buildActionButtons() : Container()),
          IconButton(
            icon: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
            onPressed: toggleExpanded,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: widget.onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Accepts'),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: widget.onReject,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetail(
              'Seller', widget.sellerName, widget.locationS!, Colors.blue),
          _buildDetail('Customer', widget.customerName, widget.locationC!,
              Colors.orange),
          const SizedBox(height: 8),
          _buildAssignedDate(),
          const SizedBox(height: 8),
          _buildMapSection(),
          const SizedBox(height: 8),
          widget.isVisible == false ? _buildContactSection() : Container(),
        ],
      ),
    );
  }

  Widget _buildDetail(String title, String name, String location, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color)),
        Text(name),
        Text(location),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAssignedDate() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 16, color: Colors.red),
        const SizedBox(width: 4),
        Text('Assigned: ${widget.assignedDate}'),
      ],
    );
  }

  Widget _buildMapSection() {
    return SizedBox(
        height: 150,
        child: CustomImageView(
            imagePath: "assets/images/map.png", width: double.infinity));
  }

  Widget _buildContactSection() {
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/customer.jpg'),
          radius: 24,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.customerName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Text('Customer', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: () {
            widget.phonecall!();
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.message, color: Colors.red),
        //   onPressed: () {},
        // ),
      ],
    );
  }
}
