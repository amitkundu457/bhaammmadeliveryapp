import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../api/api_consts.dart';
import '../../../utils/default_colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String? privacyHtml;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    const url = baseUrl + privacyTerms;
    try {
      final response = await http.get(Uri.parse(url));
      final jsonData = json.decode(response.body);
      print('Fetched Privacy Policy: ${jsonData['privacy_policy']}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          privacyHtml = jsonData['privacy_policy'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load Privacy Policy';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Privacy Policy",
              style: TextStyle(color: DefaultColor.mainColor)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: DefaultColor.mainColor,
                  size: 50,
                ),
              )
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Html(
                      data: privacyHtml,
                      style: {
                        "body": Style(
                          fontSize: FontSize.medium,
                          lineHeight: LineHeight.number(1.5),
                        ),
                        "h1": Style(color: DefaultColor.mainColor),
                      },
                    ),
                  ),
      ),
    );
  }
}
