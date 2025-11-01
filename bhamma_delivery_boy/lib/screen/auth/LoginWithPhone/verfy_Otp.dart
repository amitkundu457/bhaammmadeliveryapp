import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../api/api_service.dart';
import '../../../utils/default_colors.dart';
import '../../home_screen.dart';

class OtpPhoneScreen extends StatefulWidget {
  final number;
  const OtpPhoneScreen({required this.number});

  @override
  State<OtpPhoneScreen> createState() => _OtpPhoneScreenState();
}

class _OtpPhoneScreenState extends State<OtpPhoneScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isResendEnabled = false;
  int countdown = 60;

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DefaultColor.mainColor,
        foregroundColor: Colors.white,
        title: Text(
          "OTP Verification",
          style: TextStyle(
            //  color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.08,
          vertical: height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter the OTP sent to your mobile number",
              style: TextStyle(
                fontSize: width * 0.045,
              ),
            ),
            SizedBox(height: height * 0.05),

            // OTP Input
            Center(
              child: Pinput(
                length: 6,
                controller: otpController,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  width: width * 0.12,
                  height: width * 0.12,
                  textStyle: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.04),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: height * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DefaultColor.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final otp = otpController.text.trim();

                  if (otp.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter 6-digit OTP")),
                    );
                    return;
                  }

                  final response = await ApiService.verifyOtp(widget.number, otp);

                  if (response["success"] == true) {
                    // ✅ Token already saved in SharedPreferences
                    Navigator.pushNamed(context, "/home");
                  } else {
                    final msg = response["data"]["message"] ?? "Invalid OTP";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  }
                },
                child: Text(
                  "Confirm",
                  style: TextStyle(fontSize: width * 0.045,color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),

            // Resend OTP
            Center(
              child: isResendEnabled
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive OTP?",
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isResendEnabled = false;
                        countdown = 60;
                      });
                      startCountdown();
                    },
                    child: TextButton(
                      onPressed: () async {
                        final rawPhone = widget.number.toString().trim();

                        if (rawPhone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(rawPhone)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a valid 10-digit phone number")),
                          );
                          return;
                        }

                        final response = await ApiService.sendOtp(rawPhone);

                        if (response["success"] == true) {
                          // ✅ Resend OTP success → reset timer
                          setState(() {
                            isResendEnabled = false;
                            countdown = 60;
                          });
                          startCountdown();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("OTP resent successfully")),
                          );
                        } else {
                          // ❌ Error → show snackbar only
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response["data"]["message"] ?? "Failed to resend OTP")),
                          );
                        }
                      },
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              )
                  : Text(
                "Resend OTP in ${countdown}s",
                style: TextStyle(
                  fontSize: width * 0.04,
                  color:
                  Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
