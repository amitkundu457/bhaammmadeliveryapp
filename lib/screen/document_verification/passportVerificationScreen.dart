import 'dart:convert';
import 'dart:io';
import 'dart:ui' as BorderType;
import 'package:bhamma_delivery_boy/screen/document_verification/widget/buildImagePickerOption.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../api/api_consts.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class PassportVerificationScreen extends StatefulWidget {
  const PassportVerificationScreen({super.key});

  @override
  State<PassportVerificationScreen> createState() =>
      _PassportVerificationScreenState();
}

class _PassportVerificationScreenState
    extends State<PassportVerificationScreen> {
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedIssuingCountry;
  List<String> countryList = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bhutan",
    "Bolivia",
    "Botswana",
    "Brazil",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Chile",
    "China",
    "Colombia",
    "Costa Rica",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Estonia",
    "Ethiopia",
    "Fiji",
    "Finland",
    "France",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Grenada",
    "Guatemala",
    "Guinea",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kuwait",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Mexico",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nepal",
    "Netherlands",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "North Korea",
    "Norway",
    "Oman",
    "Pakistan",
    "Palestine",
    "Panama",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Qatar",
    "Romania",
    "Russia",
    "Rwanda",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "South Africa",
    "South Korea",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Togo",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "Uruguay",
    "Uzbekistan",
    "Venezuela",
    "Vietnam",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];

  final ImagePicker _picker = ImagePicker();
  List<File?> _selectedImages = [
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
            "Passport Verification",
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
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                    /// **Passport Number**
                    CustomTextFormField(
                      controller: passportNumberController,
                      hintText: "Enter Passport Number",
                      labelText: "Passport Number",
                      textInputType: TextInputType.text,
                      suffix: const Icon(Icons.assignment_ind,
                          color: DefaultColor.mainColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Passport Number";
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
                                hintText: "Issue Date",
                                labelText: "Issue Date",
                                textInputType: TextInputType.none,
                                suffix: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: DefaultColor.mainColor),
                                isReadOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Issue Date";
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
                                  expiryDateController.text =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                });
                              }
                            },
                            child: IgnorePointer(
                              child: CustomTextFormField(
                                controller: expiryDateController,
                                hintText: "Expiry Date",
                                labelText: "Expiry Date",
                                textInputType: TextInputType.none,
                                suffix: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: DefaultColor.mainColor),
                                isReadOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Expiry Date";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// **Issuing Country**
                    CustomDropDown(
                      hintText: 'Select Issuing Country',
                      labelText: 'Issuing Country',
                      items: countryList,
                      onChanged: (value) {
                        setState(() {
                          selectedIssuingCountry = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    /// **Full Name**
                    CustomTextFormField(
                      controller: fullNameController,
                      hintText: "Enter Full Name",
                      labelText: "Full Name",
                      textInputType: TextInputType.text,
                      suffix: const Icon(Icons.person, color: DefaultColor.mainColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Full Name";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    /// **Date of Birth**
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dateOfBirthController.text =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                      child: IgnorePointer(
                        child: CustomTextFormField(
                          controller: dateOfBirthController,
                          hintText: "Date of Birth",
                          labelText: "Date of Birth",
                          textInputType: TextInputType.none,
                          suffix: const Icon(Icons.calendar_month_outlined,
                              color: DefaultColor.mainColor),
                          isReadOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Date of Birth";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                     // SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    // **Take Photo Section**
                    // DottedBorder(
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
                    //         const Text('Passport Photo',
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
                        //Navigator.pushNamed(context, "/submit_doc");
                        submitLicenseData();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        )
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

  Future<void> submitLicenseData() async {
    print("Submitting Passport Data... $_selectedImages");
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      ToastManager.showToast(
        msg: "Please fill all required fields",
        color: DefaultColor.mainColor,
        context: context,
      );
      return;
    }
    if (selectedIssuingCountry == null || selectedIssuingCountry!.isEmpty) {
      ToastManager.showToast(
        msg: "Please select an Issuing Country",
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

    request.fields['passport_number'] = passportNumberController.text;
    request.fields['passport_issue_date'] = issueDateController.text;
    request.fields['passport_expiry_date'] = expiryDateController.text;
    request.fields['passport_issuing_country'] = selectedIssuingCountry ?? '';
    request.fields['full_name'] = fullNameController.text;
    request.fields['date_of_birth'] = dateOfBirthController.text;

    // Add profile image
    if (_selectedImages[2] != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        _selectedImages[2]!.path,
      ));
      print(
          "Profile Image: field=profile_image, path=${_selectedImages[2]!.path}, size=${await _selectedImages[2]!.length() / 1024} KB");
    }

    // Add passport images (front & back)
    for (int i = 0; i < 2; i++) {
      if (_selectedImages[i] != null) {
        var passportImage = await http.MultipartFile.fromPath(
          'passport_images[]', // Use array-like syntax for passport images
          _selectedImages[i]!.path,
        );
        request.files.add(passportImage);
        print(
            "Passport Image [$i]: field=passport_images[], path=${_selectedImages[i]!.path}, size=${await _selectedImages[i]!.length() / 1024} KB");
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
      ToastManager.showToast(
        msg: "Something went wrong!",
        color: DefaultColor.mainColor,
        context: context,
      );
    }
  }
}
