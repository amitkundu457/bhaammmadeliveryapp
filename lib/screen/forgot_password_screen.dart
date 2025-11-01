import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_helper.dart';
import '../utils/custom_toast.dart';
import '../utils/default_colors.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password",
            style: TextStyle(color: DefaultColor.mainColor)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: DefaultColor.mainColor), // Back Arrow Icon
          onPressed: () {
            Navigator.pop(context); // Navigate Back to Previous Screen
          },
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                const Text(
                  "Enter your registered email address. We will send you a link to reset your password.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                /// **Email Field**
                CustomTextFormField(
                  controller: emailController,
                  hintText: "Enter your email",
                  labelText: "Email",
                  textInputType: TextInputType.emailAddress,
                  suffix: const Icon(Icons.email, color: DefaultColor.mainColor),
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email address",
                ),
                const SizedBox(height: 30),

                /// **Reset Password Button**
                CustomElevatedButton(
                  text: "Send",
                  buttonTextStyle: const TextStyle(fontSize: 16),
                  onPressed: () async {
                    // final SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();
                    // var token = await prefs.getString('login_token');
                    if (_formKey.currentState!.validate()) {
                      var result = await ApiHandler.forgotpassword(
                          emailController.text.toString(), context);

                      if (result == "success") {
                        ToastManager.showToast(
                          msg: "We have emailed your password reset link",
                          color: DefaultColor.green,
                          context: context,
                        );
                      }

                      // Navigator.pushNamed(context, "/change_password");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
