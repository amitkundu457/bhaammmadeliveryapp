import 'package:bhamma_delivery_boy/screen/document_verification/passportVerificationScreen.dart';
import 'package:bhamma_delivery_boy/screen/document_verification/trc_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_helper.dart';
import '../../models/profile_details.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'document_verification_waiting_screen.dart';

class SubmitDocScreen extends StatefulWidget {
  const SubmitDocScreen({super.key});

  @override
  State<SubmitDocScreen> createState() => _SubmitDocStateScreen();
}

class _SubmitDocStateScreen extends State<SubmitDocScreen> {
  final TextEditingController nifNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  ProfileDetails? profileDetails;
  bool isLoading = true;
  int? userId;
  var token;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> getDetails() async {
    print("helllooooo");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString('login_token');
    try {
      profileDetails = await ApiHandler.getDeliveryBoydetails(token!);
      print("profileDetails is $profileDetails");
      nifNumberController.text = profileDetails!.nifNumber.toString();
      userId = profileDetails!.userId;
    } catch (e) {
      isLoading = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Submit Document",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ),
          centerTitle: true,
          leading:
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
            ), // Back Arrow Icon
            onPressed: () {
              Navigator.pop(context); // Navigate Back to Previous Screen
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: DefaultColor.mainColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'SUBMIT ID',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        _buildOption(
                          context,
                          title: 'I have Driving Licence',
                          subtitle: 'Popular',
                          onSelect: () {
                            Navigator.pushNamed(
                                context, "/driveing_licens_verification");
                          },
                          isBlackButton: true,
                        ),
                        const SizedBox(height: 12),
                        /// ye code pasport ka hai ok
                        // _buildOption(
                        //   context,
                        //   title: 'I don\'t have Licence',
                        //   subtitle: 'Submit Passport or TRC',
                        //   onSelect: () {
                        //     _showBottomDialog(context);
                        //   },
                        //   isBlackButton: false,
                        // ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    controller: nifNumberController,
                    hintText: "Aadhar number",
                    labelText: "Aadhar number",
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(12), // 👉 max 12 digits allowed
                      FilteringTextInputFormatter.digitsOnly, // 👉 only digits
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Aadhar number cannot be empty";
                      }

                      if (value.length < 12) {
                        return "Aadhar number must be exactly 12 digits";
                      }

                      return null;
                    },
                  ),
                  // CustomTextFormField(
                  //   controller: nifNumberController,
                  //   hintText: "Aadhar number",
                  //   labelText: "Aadhar number",
                  //   textInputType: TextInputType.text,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Aadhar Number cannot be empty";
                  //     }
                  //
                  //     return null;
                  //   },
                  // ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  /// **Reset Password Button**
                  CustomElevatedButton(
                      text: "Confirm",
                      buttonTextStyle: const TextStyle(fontSize: 16),
                      onPressed: () async {
                        print(token);
                        if (_formKey.currentState!.validate()) {
                          if (profileDetails!.passportNumber != "" ||
                              profileDetails!.cardNumber != "" ||
                              profileDetails!.licenceNumber != "") {
                            var result = await ApiHandler.updateNif(
                              nifNumberController.text.toString(),
                              token,
                              userId!.toString(),
                              context,
                            );

                            if (result == "success") {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentVerificationWaitingPage()));
                              // Navigator.pushNamedAndRemoveUntil(
                              //   context,
                              //   "/document_verification",
                              //   (Route<dynamic> route) => false,
                              // );
                            } else {
                              ToastManager.showToast(
                                msg: "Something went wrong!",
                                color: DefaultColor.mainColor,
                                context: context,
                              );
                            }
                          } else {
                            ToastManager.showToast(
                              msg: "Please Upload Your Document",
                              color: DefaultColor.mainColor,
                              context: context,
                            );
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onSelect,
    required bool isBlackButton,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 17, color: Colors.white70),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade300),
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onSelect,
          style: ElevatedButton.styleFrom(
            backgroundColor: isBlackButton ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: isBlackButton ? Colors.black : Colors.grey,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Select  ',
                style: TextStyle(
                  color: isBlackButton ? Colors.white : Colors.black,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isBlackButton ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBottomDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromARGB(255, 25, 26, 27)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Select an Option",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: Duration(milliseconds: 150),
                              reverseDuration: Duration(milliseconds: 150),
                              type: PageTransitionType.fade,
                              child: PassportVerificationScreen(),
                            ),
                          );
                        },
                        child: Text("I have Passport",
                            style: TextStyle(
                              fontSize: 16,
                              color: !isDarkMode
                                  ? const Color.fromARGB(255, 25, 26, 27)
                                  : Colors.white,
                            )),
                      ),
                      Divider(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: Duration(milliseconds: 150),
                              reverseDuration: Duration(milliseconds: 150),
                              type: PageTransitionType.fade,
                              child: TrcVerificationScreen(),
                            ),
                          );
                        },
                        child: Text("I have TRC",
                            style: TextStyle(
                              fontSize: 16,
                              color: !isDarkMode
                                  ? const Color.fromARGB(255, 25, 26, 27)
                                  : Colors.white,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }
}
