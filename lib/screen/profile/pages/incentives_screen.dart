 import 'package:flutter/material.dart';

import '../../../utils/default_colors.dart';

class IncentivesPage extends StatefulWidget {
  const IncentivesPage({super.key});

  @override
  IncentivesPageState createState() => IncentivesPageState();
}

class IncentivesPageState extends State<IncentivesPage> {
  String selectedTab = "All orders"; // Default selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incentives & Bonuses",
            style: TextStyle(color: DefaultColor.mainColor)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Tab Selection Row (Similar to Earning Statement)
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTabContainer("All orders"),
                  const SizedBox(width: 3),
                  const Spacer(),
                  _buildTabContainer("Today's"),
                  const SizedBox(width: 3),
                  const Spacer(),
                  _buildTabContainer("This week"),
                  const Spacer(),
                  const SizedBox(width: 3),
                  _buildTabContainer("This month"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Dynamic Content Based on Selected Tab
            Expanded(child: _getTabContent()),
          ],
        ),
      ),
    );
  }

  // 🔹 Tab Button (Changes Background When Selected)
  Widget _buildTabContainer(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
        decoration: BoxDecoration(
          color: isSelected ? DefaultColor.mainColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: DefaultColor.mainColor),
        ),
        child: Text(
          title,
          style: isDarkMode
              ? TextStyle(
                  color: isSelected ? Colors.black54 : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )
              : TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
        ),
      ),
    );
  }

  // 🔹 Show Different Incentives Based on Selected Tab
  Widget _getTabContent() {
    switch (selectedTab) {
      case "Today's":
        return _buildIncentiveContainer(
            "Today's Incentives", "€120", "€30", "€100", "€250");
      case "This week":
        return _buildIncentiveContainer(
            "This Week's Incentives", "€600", "€150", "€700", "€1450");
      case "This month":
        return _buildIncentiveContainer(
            "This Month's Incentives", "€2400", "€500", "€2500", "€5400");
      default:
        return _buildIncentiveContainer(
            "Total Incentives", "€1000", "€300", "€1200", "€2500");
    }
  }

  // 🔹 Incentives Display Container
  Widget _buildIncentiveContainer(String title, String pending,
      String processing, String completed, String total) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.pink.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _incentiveItem(pending, "Pending"),
                  _incentiveItem(processing, "Processing"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _incentiveItem(completed, "Completed"),
                  _incentiveItem(total, "Total"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 Incentive Item
  Widget _incentiveItem(String amount, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
