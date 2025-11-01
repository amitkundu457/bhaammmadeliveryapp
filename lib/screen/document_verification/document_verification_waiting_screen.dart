import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_helper.dart';
import '../../models/profile_details.dart';
import '../../utils/default_colors.dart';

class DocumentVerificationWaitingPage extends StatefulWidget {
  const DocumentVerificationWaitingPage({super.key});

  @override
  State<DocumentVerificationWaitingPage> createState() =>
      _DocumentVerificationWaitingPageState();
}

class _DocumentVerificationWaitingPageState
    extends State<DocumentVerificationWaitingPage> {
  ProfileDetails? profileDetails;
  bool isLoading = true;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      getDetails();
    });
  }

  Future<void> getDetails() async {
    print("Fetching details...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('login_token');
    try {
      profileDetails = await ApiHandler.getDeliveryBoydetails(token!);

      if (profileDetails!.user!.status == 1 && profileDetails!.bankName == "") {
        _timer?.cancel(); // Stop polling
        Navigator.pushNamedAndRemoveUntil(
            context, "/bank_details", (route) => false);
      }
    } catch (e) {
      // Optionally log or handle error
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Document Verification",
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurfaceVariant),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// **Clock Icon**
            const Icon(
              Icons.access_time_filled,
              size: 80,
              color: DefaultColor.mainColor,
            ),
            const SizedBox(height: 30),

            /// **Verification Message**
            Text(
              "Verification in Progress",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            /// **Description**
            Text(
              "Your document verification may take up to 24 hours to complete. You will be notified once the process is done.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            /// **Go Back Button**
            // ElevatedButton(
            //   onPressed: () {

            //     Navigator.pushNamed(context, "/bank_details");
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: DefaultColor.red,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   child: const Text(
            //     "Go Back",
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.white,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
