import 'dart:convert';
import 'dart:io';
import 'package:bhamma_delivery_boy/screen/document_verification/widget/buildImagePickerOption.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../api/api_consts.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class TrcVerificationScreen extends StatefulWidget {
  const TrcVerificationScreen({super.key});

  @override
  State<TrcVerificationScreen> createState() => _TrcVerificationScreenState();
}

class _TrcVerificationScreenState extends State<TrcVerificationScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final List<File?> _selectedImages = [
    null,
    null,
    null
  ]; // Stores images [Front, Back, Selfie]

  Future<void> _pickImage(int index) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "TRC Verification",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            onPressed: () {
              Navigator.pop(context);
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
                  const SizedBox(height: 10),

                  /// **Card Number**
                  CustomTextFormField(
                    controller: cardNumberController,
                    hintText: "Enter Card Number",
                    labelText: "Card Number",
                    textInputType: TextInputType.number,
                    suffix:
                        const Icon(Icons.check_circle, color: DefaultColor.mainColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter card number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  /// **Issue Date and Expiry Date**
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                issueDateController.text =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: CustomTextFormField(
                              controller: issueDateController,
                              hintText: "DD/MM/YY",
                              labelText: "Issue Date",
                              textInputType: TextInputType.none,
                              suffix: const Icon(Icons.calendar_month_outlined,
                                  color: DefaultColor.mainColor),
                              isReadOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter issue date";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                expiryDateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: CustomTextFormField(
                              controller: expiryDateController,
                              hintText: "DD/MM/YY",
                              labelText: "Expiry Date",
                              textInputType: TextInputType.none,
                              suffix: const Icon(Icons.calendar_month_outlined,
                                  color: DefaultColor.mainColor),
                              isReadOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter expiry date";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                 // SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  // DottedBorder(
                  //   //borderType: BorderType.RRect,
                  //   radius: Radius.circular(12), // ✅ For v2.0.0, use 'radius'
                  //   dashPattern: [9, 5],
                  //   color: Colors.red,
                  //   strokeWidth: 2,
                  //   // borderType: BorderType.RRect,
                  //   // radius: const Radius.circular(12),
                  //   // dashPattern: [9, 5],
                  //   // color: DefaultColor.red,
                  //   // strokeWidth: 2,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(20),
                  //     width: MediaQuery.of(context).size.width,
                  //     decoration: BoxDecoration(
                  //         color: DefaultColor.red.withOpacity(0.9),
                  //         borderRadius: BorderRadius.circular(12)),
                  //     child: Column(
                  //       children: [
                  //         const Text('TRC Photo',
                  //             style: TextStyle(color: Colors.white)),
                  //         const SizedBox(height: 10),
                  //         InkWell(
                  //           onTap: () => showImagePickerBottomSheet(context),
                  //           child: Container(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 25, vertical: 10),
                  //             decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(12),
                  //                 border:
                  //                     Border.all(color: DefaultColor.white)),
                  //             child: const Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Icon(Icons.camera_alt_outlined,
                  //                     color: Colors.white70),
                  //                 SizedBox(width: 10),
                  //                 Text("Take Photo",
                  //                     style: TextStyle(
                  //                         color: DefaultColor.white,
                  //                         fontSize: 16)),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(height: 20),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: List.generate(
                  //               3, (index) => _buildPreviewImage(index)),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  /// **Next Button**
                  CustomElevatedButton(
                    text: "Next",
                    buttonTextStyle: const TextStyle(fontSize: 16),
                    onPressed: () {
                      submitTrcData();
                      // Navigator.pushNamed(context, "/submit_doc");
                      //}
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildPreviewImage(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: _selectedImages[index] != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(_selectedImages[index]!,
                  width: 80, height: 80, fit: BoxFit.cover),
            )
          : Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.image, color: Colors.grey, size: 40),
            ),
    );
  }

  void showImagePickerBottomSheet(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor:
          isDarkMode ? const Color.fromARGB(255, 25, 26, 27) : Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color.fromARGB(255, 250, 250, 250)
                      : const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Choose an Option",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              buildImagePickerOption(
                  context, "Front Image", Icons.image, Colors.redAccent, () {
                _pickImage(0);
              }),
              buildImagePickerOption(context, "Back Image",
                  Icons.image_outlined, Colors.orangeAccent, () {
                _pickImage(1);
              }),
              buildImagePickerOption(context, "Selfie",
                  Icons.camera_alt_outlined, Colors.pinkAccent, () {
                _pickImage(2);
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> submitTrcData() async {
    print("Submitting TRC Data... $_selectedImages");
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      ToastManager.showToast(
        msg: "Please fill all required fields",
        color: DefaultColor.mainColor,
        context: context,
      );
      return;
    }
    if (_selectedImages.contains(null)) {
      ToastManager.showToast(
        msg: "Please upload all required Images",
        color: DefaultColor.mainColor,
        context: context,
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = await prefs.getInt('user_id');
    var url = Uri.parse('$baseUrl$updateDeliveryBoyDetails/$userId');
    print("Request URL: $url");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "multipart/form-data",
    });

    request.fields['card_number'] = cardNumberController.text;
    request.fields['card_issue_date'] = issueDateController.text;
    request.fields['card_expiry_date'] = expiryDateController.text;

    // Add profile image
    if (_selectedImages[2] != null) {
      var profileImage = await http.MultipartFile.fromPath(
        'profile_image',
        _selectedImages[2]!.path,
      );
      request.files.add(profileImage);
      print(
          "Profile Image: field=profile_image, path=${_selectedImages[2]!.path}, size=${await _selectedImages[2]!.length() / 1024} KB");
    }

    // Add TRC images (front & back)
    for (int i = 0; i < 2; i++) {
      if (_selectedImages[i] != null) {
        var trcImage = await http.MultipartFile.fromPath(
          'trc_images[]', // Use array-like syntax for TRC images
          _selectedImages[i]!.path,
        );
        request.files.add(trcImage);
        print(
            "TRC Image [$i]: field=trc_images[], path=${_selectedImages[i]!.path}, size=${await _selectedImages[i]!.length() / 1024} KB");
      }
    }

    // Log request details
    print("Request Fields: ${request.fields}");
    print("Request Files: ${request.files.map((file) => file.field).toList()}");

    // Send Request
    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      // Print Full Response
      print("Response Code: ${response.statusCode}");
      print("Response Body: $responseData");

      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        print("Success: ${jsonResponse['message']}");
        Navigator.pushNamed(context, "/submit_doc");
        ToastManager.showToast(
          msg: "Uploaded Successfully!",
          color: DefaultColor.green,
          context: context,
        );
      } else {
        print("Error: ${jsonResponse['error']}");
        ToastManager.showToast(
          msg: jsonResponse['error'] ?? "Upload Failed!",
          color: DefaultColor.mainColor,
          context: context,
        );
      }
    } catch (e) {
      print("Exception: $e");
      String errorMsg = "Something went wrong!";
      if (e is SocketException) {
        errorMsg = "Network error. Please check your connection.";
      } else if (e is FormatException) {
        errorMsg = "Invalid response from server.";
      }
      ToastManager.showToast(
        msg: errorMsg,
        color: DefaultColor.mainColor,
        context: context,
      );
    }
  }
}
