import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api/api_helper.dart';
import '../../models/dropdown_model.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  String? selectZone;
  String? zoneId;
  List<String> ZoneNames = [];
  List<DropdownModel>? zoneModel;

  initState() {
    super.initState();
    loadZone();
  }
  Future<void> loadZone() async {
    try {
      zoneModel = await ApiHandler.fetchZone();
      setState(() {
        ZoneNames =
            zoneModel!.map((vehicle) => vehicle.name ?? '').toSet().toList();
        print("Show zone list: $ZoneNames");
      });
    } catch (e) {
      print('Failed to fetch zone: $e');
      ToastManager.showToast(
        msg: 'Failed to load zone: $e',
        color: Colors.red,
        context: context,
      );
    }
  }

  String? getZoneId(String zoneName) {
    try {
      var zone = zoneModel!.firstWhere(
            (zone) => zone.name == zoneName,
        orElse: () => DropdownModel(id: null, name: null),
      );
      return zone.id?.toString();
    } catch (e) {
      print("Error finding vehicle ID for $zoneName: $e");
      return null;
    }
  }

  String? getZoneName(String? zoneId) {
    if (zoneId == null) return null;
    try {
      var zone = zoneModel?.firstWhere(
            (zone) => zone.id.toString() == zoneId,
        orElse: () => DropdownModel(id: null, name: 'Unknown'),
      );
      return zone?.name;
    } catch (e) {
      print("Error finding vehicle name for $zoneId: $e");
      return null;
    }
  }

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
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

                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 40),

                  /// **Name Field**
                  CustomTextFormField(
                    controller: nameController,
                    hintText: "Enter your name",
                    labelText: "Full Name",
                    suffix: const Icon(Icons.person, color: DefaultColor.mainColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  ///** Number field**
                  CustomTextFormField(
                    controller: contactController,
                    hintText: "Number",
                    labelText: "Enter your Number",
                    textInputType: TextInputType.number, // ✅ Number keyboard
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // ✅ Only digits allowed
                    ],
                    maxLength: 10,
                  ),
                  const SizedBox(height: 20),
                  CustomDropDown(
                    hintText: 'Select Zone',
                    labelText: selectZone == null ? "" : 'Select Zone',
                    items: ZoneNames,
                    value: selectZone,
                    validator: (value) => value == null
                        ? "Please select a zone"
                        : null,
                    onChanged: ZoneNames.isEmpty
                        ? null
                        : (value) {
                      setState(() {
                        selectZone = value;
                        zoneId = getZoneId(value!);
                        print("Selected Zone ID: $zoneId");
                      });
                    },
                  ),
                  /// **Password Field**
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: "Enter your password",
                    labelText: "Password",
                    obscureText: _isObscuredPassword,
                    textInputType: TextInputType.visiblePassword,
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscuredPassword = !_isObscuredPassword;
                        });
                      },
                      child: Icon(
                        _isObscuredPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
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
                  const SizedBox(height: 20),

                  /// **Confirm Password Field**
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    hintText: "Confirm your password",
                    labelText: "Confirm Password",
                    obscureText: _isObscuredConfirmPassword,
                    textInputType: TextInputType.visiblePassword,
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscuredConfirmPassword =
                          !_isObscuredConfirmPassword;
                        });
                      },
                      child: Icon(
                        _isObscuredConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: DefaultColor.mainColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm Password cannot be empty";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  /// **Signup Button**
                  CustomElevatedButton(
                    text: "Sign Up",
                    buttonTextStyle: const TextStyle(fontSize: 16),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var result = await ApiHandler.signUp(
                            nameController.text.toString(),
                            emailController.text.toString(),
                            passwordController.text.toString(),
                            contactController.text.toString(),
                            context);
                        print(result);
                        if (result == "success") {
                          ToastManager.showToast(
                            msg: "SignUp Successfull",
                            color: DefaultColor.green,
                            context: context,
                          );
                          var result = await ApiHandler.logIn(
                              emailController.text.toString(),
                              passwordController.text.toString(),
                              context);
                          if (result == "success") {
                            Navigator.pushNamed(context, "/vehicle_type");
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  /// **Already have an account? Login**
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",
                          style: TextStyle(fontSize: 16)),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 16,
                              color: DefaultColor.mainColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// **Social Login Options**
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
                  //     )
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
