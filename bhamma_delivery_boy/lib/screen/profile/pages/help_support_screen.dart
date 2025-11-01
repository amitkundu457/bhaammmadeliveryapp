import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/api_helper.dart';
import '../../../utils/default_colors.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String? email;
  String? phone;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHelpSupport();
  }

  Future<void> getHelpSupport() async {
    try {
      var response = await ApiHandler.fetchHelpSupport();
      setState(() {
        email = response?.data?.email ?? '';
        phone = response?.data?.number ?? '';
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching support data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _launchEmail() async {
    if (email == null || email!.isEmpty) return;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      // queryParameters: {
      //   'subject': '',
      //   'body': '',
      // },
    );

    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not open email app');
    }
  }

  void _launchPhone() async {
    if (phone == null || phone!.isEmpty) return;

    final Uri phoneUri = Uri(scheme: 'tel', path: phone);

    if (!await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not open dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Help & Support",
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
            : Padding(
                padding: const EdgeInsets.all(11.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/hs.png',
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Contact us through email",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You can send us an email through",
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      if (email != null && email!.isNotEmpty)
                        InkWell(
                          onTap: _launchEmail,
                          child: Text(
                            email!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        "Typically, the support team will send you feedback in ",
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const Text(
                        "2 hours.",
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Contact us through phone",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Contact us through our customer care number",
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      if (phone != null && phone!.isNotEmpty)
                        InkWell(
                          onTap: _launchPhone,
                          child: Text(
                            phone!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        "Talk with our ",
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const Text(
                        "customer support executive",
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(Icons.email, "Email", _launchEmail),
                           SizedBox(width: width.width * 0.01),
                          _buildActionButton(Icons.phone, "Call", _launchPhone),
                          // SizedBox(width: width.width * 0.01),
                          // _buildActionButton(Icons.chat, "Chat", () {}),
                        ],
                      )

                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: DefaultColor.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
