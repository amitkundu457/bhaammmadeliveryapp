import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../api/api_service.dart';
import '../../../utils/default_colors.dart';
import 'verfy_Otp.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  State<VerifyPhoneNumberScreen> createState() => _VerfyPhoneNumberScreen();
}

class _VerfyPhoneNumberScreen extends State<VerifyPhoneNumberScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColor.white,
      // appBar: AppBar(
      //   title: Text("Verify your phone number",
      //       style: TextStyle(
      //           color: Theme.of(context).colorScheme.onSurfaceVariant)),
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios_new,
      //         color: Theme.of(context)
      //             .colorScheme
      //             .onSurfaceVariant), // Back Arrow Icon
      //     onPressed: () {
      //       Navigator.pop(context); // Navigate Back to Previous Screen
      //     },
      //   ),
      // ),
      body: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
               //   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Center(
                    child: CircleAvatar(
                      radius: 70, // ya minRadius / maxRadius bhi chalega
                      backgroundColor: DefaultColor.white,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/bhamma.jpg",
                          width: 100, // ✅ Width control
                          height: 140, // ✅ Height control
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  const Text(
                    "We have sent a verification code to your phone number. Please enter the code to verify your phone number.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                  IntlPhoneField(
                    controller: phoneController,   // ✅ Add this
                    flagsButtonPadding: const EdgeInsets.all(10),
                    dropdownIconPosition: IconPosition.trailing,
                    dropdownIcon: const Icon(Icons.arrow_drop_down,
                        color: DefaultColor.border),
                    decoration: InputDecoration(
                      labelText: 'phone_number',
                      labelStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: DefaultColor.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: DefaultColor.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: DefaultColor.border, width: 2),
                      ),
                      counterText: "",
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      debugPrint("Full Phone: ${phone.completeNumber}");
                      debugPrint("Only Number: ${phone.number}");
                    },
                  ),
        
                  const SizedBox(height: 30),
        
                  /// **Reset Password Button**
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: () async {
                          final rawPhone = phoneController.text.trim();

                          if (rawPhone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(rawPhone)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please enter a valid 10-digit phone number")),
                            );
                            return;
                          }

                          final phone = rawPhone;debugPrint("Sending phone: $phone");

                          final response = await ApiService.sendOtp(phone);

                          if (response["success"] == true) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OtpPhoneScreen(number: phone),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response["data"]["message"] ?? "Failed to send OTP")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DefaultColor.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Send",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(fontSize: 16)),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16,
                            color: DefaultColor.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // CustomElevatedButton(
                  //   text: "Send",
                  //   buttonTextStyle: const TextStyle(fontSize: 16),
                  //   onPressed: () {
                  //     if (_formKey.currentState!.validate()) {
                  //       Navigator.pushNamed(context, "/otpphone");
                  //     }
                  //   },
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
