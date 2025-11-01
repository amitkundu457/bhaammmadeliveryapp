import 'package:bhamma_delivery_boy/api/api_consts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_helper.dart';
import '../../models/profile_details.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscured = true;

  ProfileDetails? profileDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColor.white,
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
                  //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  const Text("Sign In",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    labelText: "Email",
                    suffix: const Icon(Icons.email, color: DefaultColor.mainColor),
                    textInputType: TextInputType.emailAddress,
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Please enter a valid email address",
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: "Password",
                    labelText: "Password",
                    obscureText: _isObscured,
                    textInputType: TextInputType.visiblePassword,
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      child: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: DefaultColor.mainColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/forgot_password");
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: DefaultColor.mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    text: "Login",
                    buttonTextStyle: const TextStyle(fontSize: 16),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var result = await ApiHandler.logIn(
                            emailController.text.toString(),
                            passwordController.text.toString(),
                            context,
                        );
                        print(result);
                        if (result == "success") {
                          ToastManager.showToast(
                            msg: "Login Success",
                            color: DefaultColor.green,
                            context: context,
                          );
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          var token = await prefs.getString('login_token');
                          profileDetails = await ApiHandler.getDeliveryBoydetails(token!);

                          print("all profile Details are $profileDetails");
                          if (profileDetails!.passportNumber == "" &&
                              profileDetails!.cardNumber == "" &&
                              profileDetails!.licenceNumber == "") {
                            Navigator.pushNamed(context, "/submit_doc");
                          } else if (profileDetails!.user!.status == 0) {
                            Navigator.pushNamed(context, "/document_verification");
                          } else if (profileDetails!.bankName == "") {
                            Navigator.pushNamed(context, "/bank_details");
                          } else {
                            Navigator.pushReplacementNamed(context, "/home");
                          }
                        } else {
                          ToastManager.showToast(
                            msg: "Login Failed! Please Try again...",
                            color: DefaultColor.mainColor,
                            context: context,
                          );
                        }
                      }
                    },
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
                  const SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/verify_phone");
                      },
                      child: const Text(
                        "Login with Phone",
                        style: TextStyle(
                          fontSize: 16,
                          color: DefaultColor.mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CustomImageView(
                  //       imagePath: ImageConstant.facebook,
                  //       height: 45,
                  //       width: 50,
                  //       fit: BoxFit.contain,
                  //     ),
                  //     const SizedBox(width: 10),
                  //     CustomImageView(
                  //       imagePath: ImageConstant.google,
                  //       height: 50,
                  //       width: 50,
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
