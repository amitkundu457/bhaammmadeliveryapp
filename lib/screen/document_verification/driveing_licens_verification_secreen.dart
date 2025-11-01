// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui' as BorderType;
// import 'package:bhamma_delivery_boy/screen/document_verification/widget/buildImagePickerOption.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../api/api_consts.dart';
// import '../../utils/custom_toast.dart';
// import '../../utils/default_colors.dart';
// import '../../widgets/customDropdown.dart';
// import '../../widgets/custom_elevated_button.dart';
// import '../../widgets/custom_text_form_field.dart';
//
// class DriveingLicensVerificationSecreen extends StatefulWidget {
//   const DriveingLicensVerificationSecreen({super.key});
//
//   @override
//   State<DriveingLicensVerificationSecreen> createState() =>
//       DriveingLicensVerificationSecreenState();
// }
//
// class DriveingLicensVerificationSecreenState
//     extends State<DriveingLicensVerificationSecreen> {
//   TextEditingController numberController = TextEditingController();
//   TextEditingController expiryController = TextEditingController();
//   TextEditingController issueController = TextEditingController();
//
//   String? selectedLicenceCatageory;
//   String? selectedIssuingAuthority;
//
//   final ImagePicker _picker = ImagePicker();
//   final _formKey = GlobalKey<FormState>();
//
//   List<File?> _selectedImages = [
//     null,
//     null,
//     null
//   ]; // Stores images [Front, Back, Selfie]
//
//   Future<void> _pickImage(int index) async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImages[index] = File(pickedFile.path);
//       });
//     }
//   }
//
//
//   List<String> licenseList = [];
//   List<String> licenseAuthList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLicenseCategories();
//     fetchLicenseAuthCategories();
//   }
//
//   Future<void> fetchLicenseCategories() async {
//     const url = baseUrl + license;
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         licenseList = List<String>.from(data.map((item) => item['name'].toString()));
//       });
//     } else {
//       print('Failed to load license categories');
//     }
//   }
//   Future<void> fetchLicenseAuthCategories() async {
//     final response = await http.get(Uri.parse('$baseUrl$licenseauth'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         licenseAuthList = List<String>.from(data.map((item) => item['name'].toString()));
//       });
//     } else {
//       print('Failed to load licenseAuth categories');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: DefaultColor.mainColor,
//           foregroundColor: DefaultColor.white,
//           title: Text("Driving Licence Verification",
//               // style: TextStyle(
//               //     color: Theme.of(context).colorScheme.onSurfaceVariant,
//               // )
//           ),
//           centerTitle: true,
//           leading: BackButton( color: Colors.white,)
//           // IconButton(
//           //   icon: Icon(Icons.arrow_back_ios_new,
//           //       color: Theme.of(context)
//           //           .colorScheme
//           //           .onSurfaceVariant), // Back Arrow Icon
//           //   onPressed: () {
//           //     Navigator.pop(context); // Navigate Back to Previous Screen
//           //   },
//           // ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                   CustomTextFormField(
//                     controller: numberController,
//                     hintText: "Enter Licence number",
//                     labelText: "Licence number",
//                     //textInputType: TextInputType.number,
//                     suffix:
//                         const Icon(Icons.check_circle, color: DefaultColor.mainColor),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please Enter Licence number";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: InkWell(
//                           onTap: () async {
//                             DateTime? pickedDate = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1900),
//                               lastDate: DateTime(2100),
//                             );
//                             if (pickedDate != null) {
//                               setState(() {
//                                 issueController.text =
//                                     "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//                               });
//                             }
//                           },
//                           child: IgnorePointer(
//                             // Prevent interaction with TextFormField itself
//                             child: CustomTextFormField(
//                               controller: issueController,
//                               hintText: "Issue Date",
//                               labelText: "Issue Date",
//                               textInputType: TextInputType.none,
//                               suffix: const Icon(Icons.calendar_month_outlined,
//                                   color: DefaultColor.mainColor),
//                               isReadOnly: true,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return "Please Enter Issue Date";
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Expanded(
//                         child: InkWell(
//                           onTap: () async {
//                             DateTime? pickedDate = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1900),
//                               lastDate: DateTime(2100),
//                             );
//                             if (pickedDate != null) {
//                               setState(() {
//                                 expiryController.text =
//                                     "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//                               });
//                             }
//                           },
//                           child: IgnorePointer(
//                             child: CustomTextFormField(
//                               controller: expiryController,
//                               hintText: "Expiry Date",
//                               labelText: "Expiry Date",
//                               textInputType: TextInputType.none,
//                               suffix: const Icon(Icons.calendar_month_outlined,
//                                   color: DefaultColor.mainColor),
//                               isReadOnly: true,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return "Please Enter Expiry Date";
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 20),
//                   // Inside your build method
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       licenseList.isEmpty
//                           ? SizedBox(
//                         height: 60,
//                         child: Center(child: CircularProgressIndicator()),
//                       )
//                           : CustomDropDown(
//                         hintText: 'Licence Catageory',
//                         labelText: 'Licence Catageory',
//                         items: licenseList,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedLicenceCatageory = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       licenseAuthList.isEmpty
//                           ? SizedBox(
//                         height: 60,
//                         child: Center(child: CircularProgressIndicator()),
//                       )
//                           : CustomDropDown(
//                         hintText: 'Issuing Authority',
//                         labelText: 'Issuing Authority',
//                         items: licenseAuthList,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedIssuingAuthority = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   // Column(
//                   //   children: [
//                   //     licenseList.isEmpty
//                   //         ? CircularProgressIndicator()
//                   //         : CustomDropDown(
//                   //       hintText: 'Licence Catageory',
//                   //       labelText: 'Licence Catageory',
//                   //       items: licenseList,
//                   //       onChanged: (value) {
//                   //         setState(() {
//                   //           selectedLicenceCatageory = value;
//                   //         });
//                   //       },
//                   //     ),
//                   //     const SizedBox(height: 20),
//                   //     licenseList.isEmpty
//                   //        ? CircularProgressIndicator()
//                   //         : CustomDropDown(
//                   //       hintText: 'Issuing Authority',
//                   //       labelText: 'Issuing Authority',
//                   //       items: licenseAuthList,
//                   //       onChanged: (value) {
//                   //         setState(() {
//                   //           selectedIssuingAuthority = value;
//                   //         });
//                   //       },
//                   //      ),
//                   //   ],
//                   // ),
//                   // CustomDropDown(
//                   //   hintText: 'Issuing Authority',
//                   //   labelText: 'Issuing Authority',
//                   //   items: const ["aaa1", "bbb1", "ccc1"],
//                   //   onChanged: (value) {
//                   //     setState(() {
//                   //       selectedIssuingAuthority = value;
//                   //     });
//                   //   },
//                   // ),
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.1),
//
//                   DottedBorder(
//                     // borderType: BorderType.RRect,
//                     // radius: const Radius.circular(12),
//                     // dashPattern: [9, 5],
//                     // color: DefaultColor.red,
//                     // strokeWidth: 2,
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           color: DefaultColor.mainColor.withOpacity(0.9),
//                           borderRadius: BorderRadius.circular(12)),
//                       child: Column(
//                         children: [
//                           const Text('Driving Licence Photo', style: TextStyle(color: Colors.white)),
//                           const SizedBox(height: 10),
//                           InkWell(
//                             onTap: () => showImagePickerBottomSheet(context),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 25, vertical: 10),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   border:
//                                       Border.all(color: DefaultColor.white)),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.camera_alt_outlined,
//                                       color: Colors.white70),
//                                   SizedBox(width: 10),
//                                   Text("Take Photo",
//                                       style: TextStyle(
//                                           color: DefaultColor.white,
//                                           fontSize: 16,
//                                      )
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(3, (index) => _buildPreviewImage(index)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//
//                   /// **Reset Password Button**
//                   CustomElevatedButton(
//                     text: "Next",
//                     buttonTextStyle: const TextStyle(fontSize: 16),
//                     onPressed: () {
//                       submitLicenseData();
//
//                       print(_selectedImages);
//                       print(_selectedImages.map((file) => file?.path).toList());
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Widget _buildPreviewImage(int index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: _selectedImages[index] != null
//           ? ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.file(_selectedImages[index]!,
//                   width: 80, height: 80, fit: BoxFit.cover),
//             )
//           : Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10)),
//               child: const Icon(Icons.image, color: Colors.grey, size: 40),
//             ),
//     );
//   }
//
//   void showImagePickerBottomSheet(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor:
//           isDarkMode ? const Color.fromARGB(255, 25, 26, 27) : Colors.white,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? const Color.fromARGB(255, 250, 250, 250)
//                       : const Color.fromARGB(255, 0, 0, 0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const Text(
//                 "Choose an Option",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               buildImagePickerOption(
//                   context, "Front Image", Icons.image, Colors.redAccent, () {
//                 _pickImage(0);
//               }),
//               buildImagePickerOption(context, "Back Image",
//                   Icons.image_outlined, Colors.orangeAccent, () {
//                 _pickImage(1);
//               }),
//               buildImagePickerOption(context, "Selfie",
//                   Icons.camera_alt_outlined, Colors.pinkAccent, () {
//                 _pickImage(2);
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//  Future<void> submitLicenseData() async {
//   print("Submitting License Data... $_selectedImages");
//   if (!_formKey.currentState!.validate()) {
//     print("Form validation failed");
//     ToastManager.showToast(
//       msg: "Please fill all required fields",
//       color: DefaultColor.mainColor,
//       context: context,
//     );
//     return;
//   }
//
//   if (selectedLicenceCatageory == null || selectedLicenceCatageory!.isEmpty) {
//     ToastManager.showToast(
//       msg: "Please select a Licence Category",
//       color: DefaultColor.mainColor,
//       context: context,
//     );
//     return;
//   }
//
//   if (selectedIssuingAuthority == null || selectedIssuingAuthority!.isEmpty) {
//     ToastManager.showToast(
//       msg: "Please select an Issuing Authority",
//       color: DefaultColor.mainColor,
//       context: context,
//     );
//     return;
//   }
//
//   if (_selectedImages.contains(null)) {
//     ToastManager.showToast(
//       msg: "Please upload all required Images",
//       color: DefaultColor.mainColor,
//       context: context,
//     );
//     return;
//   }
//
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   var userId = await prefs.getInt('user_id');
//   var url = Uri.parse('$baseUrl$updateDeliveryBoyDetails/$userId');
//   print(url);
//   var request = http.MultipartRequest('POST', url);
//   request.headers.addAll({
//     "Accept": "application/json",
//     "Content-Type": "multipart/form-data",
//   });
//
//   request.fields['licence_number'] = numberController.text;
//   request.fields['licence_issue_date'] = issueController.text;
//   request.fields['licence_expiry_date'] = expiryController.text;
//   request.fields['licence_category'] = selectedLicenceCatageory ?? '';
//   request.fields['licence_issuing_authority'] = selectedIssuingAuthority ?? '';
//
//   // Add profile image
//   if (_selectedImages[2] != null) {
//     request.files.add(await http.MultipartFile.fromPath(
//       'profile_image',
//       _selectedImages[2]!.path,
//     ));
//   }
//
//   // Add licence images (front & back) with array-like field name
//   for (int i = 0; i < 2; i++) {
//     if (_selectedImages[i] != null) {
//       var licenceImage = await http.MultipartFile.fromPath(
//         'licence_images[]', // Use array-like syntax
//         _selectedImages[i]!.path,
//       );
//       request.files.add(licenceImage);
//       print(
//           "Licence Image [$i]: field=licence_images[], path=${_selectedImages[i]!.path}, size=${await _selectedImages[i]!.length() / 1024} KB");
//     }
//   }
//
//   // Send Request
//   try {
//     var response = await request.send();
//     var responseData = await response.stream.bytesToString();
//
//     // Print Full Response
//     print("Response Code: ${response.statusCode}");
//     print("Response Body: $responseData");
//
//     var jsonResponse = jsonDecode(responseData);
//
//     if (response.statusCode == 200) {
//       print("Success: ${jsonResponse['message']}");
//
//       Navigator.pushNamed(context, "/submit_doc");
//       ToastManager.showToast(
//         msg: "Uploaded Successfully!",
//         color: DefaultColor.green,
//         context: context,
//       );
//     } else {
//       print("Error: ${jsonResponse['error']}");
//       ToastManager.showToast(
//         msg: jsonResponse['error'] ?? "Upload Failed!",
//         color: DefaultColor.mainColor,
//         context: context,
//       );
//     }
//   } catch (e) {
//     print("Exception: $e");
//     ToastManager.showToast(
//       msg: "Something went wrong!",
//       color: DefaultColor.mainColor,
//       context: context,
//     );
//   }
// }
// }


import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_consts.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class DriveingLicensVerificationSecreen extends StatefulWidget {
  const DriveingLicensVerificationSecreen({super.key});

  @override
  State<DriveingLicensVerificationSecreen> createState() =>
      DriveingLicensVerificationSecreenState();
}

class DriveingLicensVerificationSecreenState
    extends State<DriveingLicensVerificationSecreen> {
  TextEditingController numberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController issueController = TextEditingController();

  String? selectedLicenceCatageory;
  String? selectedIssuingAuthority;

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  List<File?> _selectedImages = [null, null, null]; // [Front, Back, Selfie]

  Future<void> _pickImage(int index) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImages[index] = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DefaultColor.mainColor,
        foregroundColor: DefaultColor.white,
        title: const Text("Driving Licence Verification"),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
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
                CustomTextFormField(
                  controller: numberController,
                  hintText: "Enter Licence number",
                  labelText: "Licence number",
                  suffix: const Icon(Icons.check_circle, color: DefaultColor.mainColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Licence number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                              issueController.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                        child: IgnorePointer(
                          child: CustomTextFormField(
                            controller: issueController,
                            hintText: "Issue Date",
                            labelText: "Issue Date",
                            textInputType: TextInputType.none,
                            suffix: const Icon(Icons.calendar_month_outlined,
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
                              expiryController.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                        child: IgnorePointer(
                          child: CustomTextFormField(
                            controller: expiryController,
                            hintText: "Expiry Date",
                            labelText: "Expiry Date",
                            textInputType: TextInputType.none,
                            suffix: const Icon(Icons.calendar_month_outlined,
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
                const SizedBox(height: 30),

                // --- DROPDOWNS COMMENTED ---
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     CustomDropDown(
                //       hintText: 'Licence Catageory',
                //       labelText: 'Licence Catageory',
                //       items: licenseList,
                //       onChanged: (value) {
                //         setState(() {
                //           selectedLicenceCatageory = value;
                //         });
                //       },
                //     ),
                //     const SizedBox(height: 20),
                //     CustomDropDown(
                //       hintText: 'Issuing Authority',
                //       labelText: 'Issuing Authority',
                //       items: licenseAuthList,
                //       onChanged: (value) {
                //         setState(() {
                //           selectedIssuingAuthority = value;
                //         });
                //       },
                //     ),
                //   ],
                // ),

                DottedBorder(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: DefaultColor.mainColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Text('Driving Licence Photo', style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () => showImagePickerBottomSheet(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: DefaultColor.white)),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.camera_alt_outlined, color: Colors.white70),
                                SizedBox(width: 10),
                                Text("Take Photo",
                                    style: TextStyle(
                                        color: DefaultColor.white,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) => _buildPreviewImage(index)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                CustomElevatedButton(
                  text: "Next",
                  buttonTextStyle: const TextStyle(fontSize: 16),
                  onPressed: () {
                    submitLicenseData();
                  },
                )
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDarkMode ? const Color.fromARGB(255, 25, 26, 27) : Colors.white,
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
                  color: isDarkMode ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Choose an Option",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Front Image"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text("Back Image"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Selfie"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(2);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submitLicenseData() async {
    if (!_formKey.currentState!.validate()) {
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
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "multipart/form-data",
    });

    request.fields['licence_number'] = numberController.text;
    request.fields['licence_issue_date'] = issueController.text;
    request.fields['licence_expiry_date'] = expiryController.text;

    // Add profile image (selfie)
    if (_selectedImages[2] != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        _selectedImages[2]!.path,
      ));
    }

    // Add licence images (front & back)
    for (int i = 0; i < 2; i++) {
      if (_selectedImages[i] != null) {
        var licenceImage = await http.MultipartFile.fromPath(
          'licence_images[]',
          _selectedImages[i]!.path,
        );
        request.files.add(licenceImage);
      }
    }

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/submit_doc");
        ToastManager.showToast(
          msg: "Uploaded Successfully!",
          color: DefaultColor.green,
          context: context,
        );
      } else {
        ToastManager.showToast(
          msg: jsonResponse['error'] ?? "Upload Failed!",
          color: DefaultColor.mainColor,
          context: context,
        );
      }
    } catch (e) {
      ToastManager.showToast(
        msg: "Something went wrong!",
        color: DefaultColor.mainColor,
        context: context,
      );
    }
  }
}