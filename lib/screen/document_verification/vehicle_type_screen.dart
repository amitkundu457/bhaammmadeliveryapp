// import "package:flutter/material.dart";
// import "package:shared_preferences/shared_preferences.dart";
//
// import "../../api/api_helper.dart";
// import "../../models/dropdown_model.dart";
// import "../../utils/custom_toast.dart";
// import "../../utils/default_colors.dart";
// import "../../widgets/customDropdown.dart";
// import "../../widgets/custom_elevated_button.dart";
// import "../../widgets/custom_text_form_field.dart";
//
// class VehicleTypeScreen extends StatefulWidget {
//   const VehicleTypeScreen({super.key});
//
//   @override
//   State<VehicleTypeScreen> createState() => _VehicleTypeScreenState();
// }
//
// class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? selectVehicle;
//   var vehicleId;
//   List<String> vehicleNames = [];
//   List<DropdownModel>? vehicleModel;
//   final TextEditingController vehicleNumberController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     loadVehicle();
//   }
//
//   Future<void> loadVehicle() async {
//     try {
//       vehicleModel = await ApiHandler.fetchVehicle();
//       setState(() {
//         vehicleNames = vehicleModel!
//             .map((vehicle) {
//               String name = vehicle.name ?? '';
//
//               return name;
//             })
//             .toSet() // Remove duplicates
//             .toList();
//         print("Show vehicle list: $vehicleNames");
//       });
//     } catch (e) {
//       print('Failed to fetch vehicles: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load vehicles: $e')),
//       );
//     }
//   }
//
//   String? getVehicleId(String vehicleName) {
//     var vehicle =
//         vehicleModel!.firstWhere((vehicle) => vehicle.name == vehicleName);
//     return vehicle.id.toString();
//   }
//
//   // String? getVehicleName(String vehicleId) {
//   //   var vehicle = vehicleModel?.firstWhere(
//   //     (vehicle) => vehicle.id.toString() == vehicleId,
//   //     orElse: () => DropdownModel(id: null, name: 'Unknown'),
//   //   );
//   //   return vehicle?.name;
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Select Vehicle Type",
//             style: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurfaceVariant),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios_new,
//                 color: Theme.of(context).colorScheme.onSurfaceVariant),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//             child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Form(
//                     key: _formKey,
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           const SizedBox(height: 10),
//                           CustomDropDown(
//                             hintText: 'Vehicle Type',
//                             labelText: 'Vehicle Type',
//                             // value: selectedValue,
//                             items: vehicleNames,
//                             value: selectVehicle,
//                             onChanged: (value) {
//                               setState(() {
//                                 selectVehicle = value;
//                                 vehicleId = getVehicleId(value!);
//                                 print(vehicleId);
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 25),
//                           // Vehicle number
//                           CustomTextFormField(
//                             controller: vehicleNumberController,
//                             hintText: "Vehicle Number",
//                             labelText: "Vehicle Number",
//                             textInputType: TextInputType.text,
//                           ),
//
//                           const SizedBox(height: 25),
//                           CustomElevatedButton(
//                             text: "Confirm",
//                             buttonTextStyle: const TextStyle(fontSize: 16),
//                             onPressed: () async {
//                               print("hello");
//                               final SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();
//                               var token = await prefs.getString('login_token');
//                               var userId = await prefs.getInt('user_id');
//
//                               var result = await ApiHandler.updateVehicleDetails(
//                                       vehicleId.toString(),
//                                       vehicleNumberController.text.toString(),
//                                       token!.toString(),
//                                       userId!.toString(),
//                                       context,
//                                   );
//                               if (result == "success") {
//                                 Navigator.pushNamed(context, "/submit_doc");
//                                 ToastManager.showToast(
//                                   msg: "Vehicle Updated successfully",
//                                   color: DefaultColor.green,
//                                   context: context,
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                     ),
//                 ),
//             ),
//         ),
//     );
//   }
// }

import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../api/api_helper.dart";
import "../../models/dropdown_model.dart";
import "../../utils/custom_toast.dart";
import "../../utils/default_colors.dart";
import "../../widgets/customDropdown.dart";
import "../../widgets/custom_elevated_button.dart";
import "../../widgets/custom_text_form_field.dart";

class VehicleTypeScreen extends StatefulWidget {
  const VehicleTypeScreen({super.key});

  @override
  State<VehicleTypeScreen> createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectVehicle;
  var vehicleId;
  List<String> vehicleNames = [];
  List<DropdownModel>? vehicleModel;
  final TextEditingController vehicleNumberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _vehicleImage;

  @override
  void initState() {
    super.initState();
    loadVehicle();
  }

  Future<void> loadVehicle() async {
    try {
      vehicleModel = await ApiHandler.fetchVehicle();
      setState(() {
        vehicleNames = vehicleModel!
            .map((vehicle) => vehicle.name ?? '')
            .toSet()
            .toList();
      });
    } catch (e) {
      print('Failed to fetch vehicles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load vehicles: $e')),
      );
    }
  }

  String? getVehicleId(String vehicleName) {
    var vehicle =
    vehicleModel!.firstWhere((vehicle) => vehicle.name == vehicleName);
    return vehicle.id.toString();
  }

  Future<void> pickVehicleImage() async {
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
          _vehicleImage = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Vehicle Type",
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
                CustomDropDown(
                  hintText: 'Vehicle Type',
                  labelText: 'Vehicle Type',
                  items: vehicleNames,
                  value: selectVehicle,
                  onChanged: (value) {
                    setState(() {
                      selectVehicle = value;
                      vehicleId = getVehicleId(value!);
                    });
                  },
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  controller: vehicleNumberController,
                  hintText: "Vehicle Number",
                  labelText: "Vehicle Number",
                ),
                const SizedBox(height: 25),

                // Vehicle Image Picker
                Text("Upload Vehicle RC Photo", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                InkWell(
                  onTap: pickVehicleImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: _vehicleImage != null
                        ? Image.file(_vehicleImage!, fit: BoxFit.cover)
                        : const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 25),
                CustomElevatedButton(
                  text: "Confirm",
                  buttonTextStyle: const TextStyle(fontSize: 16),
                  onPressed: () async {
                    if (_vehicleImage == null) {
                      ToastManager.showToast(
                        msg: "Please upload vehicle RC image",
                        color: DefaultColor.mainColor,
                        context: context,
                      );
                      return;
                    }

                    final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    var token = prefs.getString('login_token');
                    var userId = prefs.getInt('user_id');

                    var result = await ApiHandler.updateVehicleDetails(
                      vehicleId.toString(),
                      vehicleNumberController.text.toString(),
                      token!.toString(),
                      userId!.toString(),
                      context,
                      vehicleImage: _vehicleImage, // Send image to API
                    );

                    if (result == "success") {
                      Navigator.pushNamed(context, "/submit_doc");
                      ToastManager.showToast(
                        msg: "Vehicle Updated successfully",
                        color: DefaultColor.green,
                        context: context,
                      );
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