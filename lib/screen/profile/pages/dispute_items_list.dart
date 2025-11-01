import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../api/api_consts.dart';
import '../../../utils/default_colors.dart';

class DisputeItemsList extends StatefulWidget {
  const DisputeItemsList({super.key});

  @override
  State<DisputeItemsList> createState() => _DisputeItemsListState();
}

class _DisputeItemsListState extends State<DisputeItemsList> {
  bool isLoading = true;
  List<DisputedProduct> disputedProducts = [];

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('login_token');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$dispute'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          disputedProducts =
              data.map((item) => DisputedProduct.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load disputes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching disputes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Dispute Items",
            style: TextStyle(color: DefaultColor.mainColor),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: DefaultColor.mainColor,
                  size: 50,
                ),
              )
            : disputedProducts.isEmpty
                ? Center(
                    child: Text(
                      'No disputes found',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: disputedProducts.length,
                    itemBuilder: (context, index) {
                      final product = disputedProducts[index];
                      return Card(
                        elevation: 0,
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        child: ListTile(
                          leading: Image.network(
                            product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                          title: Text('Order ID: ${product.orderId}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Issue: ${product.issueType}'),
                              SizedBox(height: 4),
                              Text('Description: ${product.description}'),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(),
                                  Text(
                                    '${product.formattedDate}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class DisputedProduct {
  final String imageUrl;
  final String orderId;
  final String issueType;
  final String description;
  final DateTime createdAt;

  DisputedProduct({
    required this.imageUrl,
    required this.orderId,
    required this.issueType,
    required this.description,
    required this.createdAt,
  });

  factory DisputedProduct.fromJson(Map<String, dynamic> json) {
    return DisputedProduct(
      imageUrl: 'https://via.placeholder.com/150',
      orderId: json['order_id'].toString(),
      issueType: json['issue_type'] ?? 'Unknown',
      description: json['description'] ?? 'No description provided',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(createdAt);
  }
}
