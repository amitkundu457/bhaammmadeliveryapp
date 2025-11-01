import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_helper.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/custom_elevated_button.dart';

class OtpScreen extends StatefulWidget {
  String? orderId;
  OtpScreen({super.key, this.orderId});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  String enteredOtp = "";
  bool isResendEnabled = false;
  int countdown = 30;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
        startCountdown();
      } else {
        setState(() {
          isResendEnabled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "OTP Verification",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant,),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant), // Back Arrow Icon
          onPressed: () {
            Navigator.pop(context); // Navigate Back to Previous Screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the OTP sent to your mobile number",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            Pinput(
              length: 6,
              controller: otpController,
              keyboardType: TextInputType.number,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            CustomElevatedButton(
              text: "Confirm",
              buttonTextStyle: const TextStyle(fontSize: 16),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('login_token');
                var result = await ApiHandler.delivePickedup(
                    "delivered", int.parse(widget.orderId!), token!, context);
                print("result: $result");
                if (result == "success") {
                  ToastManager.showToast(
                    msg: "Order Delivered",
                    color: DefaultColor.green,
                    context: context,
                  );
                  Navigator.restorablePushReplacementNamed(context, "/order");
                }
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            isResendEnabled
                ? Row(
                    children: [
                      Text("Didn't receive OTP?",
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isResendEnabled = false;
                            countdown = 30;
                          });
                          startCountdown();
                        },
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(color: DefaultColor.mainColor),
                        ),
                      ),
                    ],
                  )
                : Text("Resend OTP in ${countdown}s",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
