import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_consts.dart';
import '../../api/api_helper.dart';
import '../../models/dropdown_model.dart';
import '../../models/profile_details.dart';
import '../../utils/custom_toast.dart';
import '../../utils/default_colors.dart';
import '../../widgets/buttom_manu.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController nifNumberController = TextEditingController();

  int? userId;
  String? selectVehicle;
  String? vehicleId;
  List<String> vehicleNames = [];
  List<DropdownModel>? vehicleModel;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  int selectedIndex = 2; // Adjusted to a likely valid index (0, 1, or 2)
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  ProfileDetails? profileDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([loadVehicle(), getDetails()]);
    } catch (e) {
      ToastManager.showToast(
        msg: 'Failed to initialize page: $e',
        color: Colors.red,
        context: context,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadVehicle() async {
    try {
      vehicleModel = await ApiHandler.fetchVehicle();
      setState(() {
        vehicleNames =
            vehicleModel!
                .map((vehicle) => vehicle.name ?? '')
                .toSet() // Remove duplicates
                .toList();
        print("Show vehicle list: $vehicleNames");
      });
    } catch (e) {
      print('Failed to fetch vehicles: $e');
      ToastManager.showToast(
        msg: 'Failed to load vehicles: $e',
        color: Colors.red,
        context: context,
      );
    }
  }

  String? getVehicleId(String vehicleName) {
    try {
      var vehicle = vehicleModel!.firstWhere(
        (vehicle) => vehicle.name == vehicleName,
        orElse: () => DropdownModel(id: null, name: null),
      );
      return vehicle.id?.toString();
    } catch (e) {
      print("Error finding vehicle ID for $vehicleName: $e");
      return null;
    }
  }

  String? getVehicleName(String? vehicleId) {
    if (vehicleId == null) return null;
    try {
      var vehicle = vehicleModel?.firstWhere(
        (vehicle) => vehicle.id.toString() == vehicleId,
        orElse: () => DropdownModel(id: null, name: 'Unknown'),
      );
      return vehicle?.name;
    } catch (e) {
      print("Error finding vehicle name for $vehicleId: $e");
      return null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('login_token');
    if (token == null) {
      ToastManager.showToast(
        msg: 'No login token found. Please log in.',
        color: Colors.red,
        context: context,
      );
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      return;
    }
    try {
      profileDetails = await ApiHandler.getDeliveryBoydetails(token);
      setState(() {
        emailController.text = profileDetails!.user!.email?.toString() ?? '';
        vehicleNumberController.text = profileDetails!.vehicleNumber?.toString() ?? '';
        nifNumberController.text = profileDetails!.nifNumber?.toString() ?? '';
        addressController.text = profileDetails!.address?.toString() ?? '';
        phoneNumberController.text = profileDetails!.phone?.toString() ?? '';
        userId = profileDetails!.userId;
        vehicleId = profileDetails!.vehicleTypeId;
        selectVehicle = getVehicleName(vehicleId);
        if (selectVehicle != null && !vehicleNames.contains(selectVehicle)) {
          selectVehicle = vehicleNames.isNotEmpty ? vehicleNames.first : null;
        }
      });
    } catch (e) {
      print("Error loading profile: $e");
      ToastManager.showToast(
        msg: 'Failed to load profile: $e',
        color: Colors.red,
        context: context,
      );
    }
  }

  // Handler for pull-to-refresh
  Future<void> _handleRefresh() async {
    print("Refresh triggered");
    await _initializePage(); // Refresh vehicle list and profile details
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    vehicleNumberController.dispose();
    nifNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
          body: Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: DefaultColor.mainColor,
              size: 50,
            ),
          ),
        )
        : SafeArea(
          child: Scaffold(
            bottomNavigationBar: BottomMenu(
              selectedIndex: selectedIndex,
              onClicked: onClicked,
            ),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(180), // 🔼 Increased from 160 to 190
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 25,
                ),
                decoration: const BoxDecoration(
                  color: DefaultColor.mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Profile",
                        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                          color: DefaultColor.white,
                        ) ??
                            const TextStyle(
                              color: DefaultColor.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipOval(
                            child: _selectedImage != null
                                ? Image.file(
                              _selectedImage!,
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                            )
                                : CustomImageView(
                              height: 65,
                              width: 65,
                              fit: BoxFit.fill,
                              imagePath:
                              (profileDetails?.profileImage?.isNotEmpty ?? false)
                                  ? imageUrl + profileDetails!.profileImage.toString()
                                  : 'assets/images/p_image.jpeg',
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileDetails?.user?.name?.toString() ?? 'Loading...',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: DefaultColor.white,
                                ) ??
                                    const TextStyle(
                                      color: DefaultColor.white,
                                      fontSize: 22,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                profileDetails?.user?.email?.toString() ?? 'N/A',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: DefaultColor.white,
                                ) ??
                                    const TextStyle(
                                      color: DefaultColor.white,
                                      fontSize: 12,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 7),
                        InkWell(
                          onTap: _pickImage,
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: DefaultColor.mainColor,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Ensure scrollability
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: phoneNumberController,
                          hintText: "Phone number",
                          labelText: "Phone number",
                          textInputType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "Email address",
                          labelText: "Email address",
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: addressController,
                          hintText: "Address",
                          labelText: "Address",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        CustomDropDown(
                          hintText: 'Vehicle Type',
                          labelText: 'Vehicle Type',
                          items: vehicleNames,
                          value: selectVehicle,
                          onChanged:
                              vehicleNames.isEmpty
                                  ? null
                                  : (value) {
                                    setState(() {
                                      selectVehicle = value;
                                      vehicleId = getVehicleId(value!);
                                      print("Selected vehicle ID: $vehicleId");
                                    });
                                  },
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: vehicleNumberController,
                          hintText: "Vehicle Number",
                          labelText: "Vehicle Number",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: nifNumberController,
                          hintText: "Aadhar number",
                          labelText: "Aadhar number",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
                        CustomElevatedButton(
                          text: "Update Profile",
                          buttonTextStyle: const TextStyle(fontSize: 16),
                          onPressed: () async {
                            if (phoneNumberController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                addressController.text.isEmpty ||
                                vehicleNumberController.text.isEmpty ||
                                nifNumberController.text.isEmpty ||
                                selectVehicle == null) {
                              ToastManager.showToast(
                                msg: "Please fill all fields",
                                color: Colors.red,
                                context: context,
                              );
                              return;
                            }
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var token = await prefs.getString('login_token');
                            if (token == null) {
                              ToastManager.showToast(
                                msg: "No login token found. Please log in.",
                                color: Colors.red,
                                context: context,
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/login",
                                (route) => false,
                              );
                              return;
                            }
                            var result = await ApiHandler.updateProfile(
                              userId!.toString(),
                              token,
                              phoneNumberController.text,
                              emailController.text,
                              addressController.text,
                              vehicleId?.toString() ?? '',
                              vehicleNumberController.text,
                              nifNumberController.text,
                              _selectedImage,
                              context,
                            );
                            if (result == "success") {
                              ToastManager.showToast(
                                msg: "Profile Updated Successfully",
                                color: DefaultColor.green,
                                context: context,
                              );
                              Navigator.pop(context); // Return to ProfileScreen
                            } else {
                              ToastManager.showToast(
                                msg: "Failed to update profile",
                                color: Colors.red,
                                context: context,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ), // Extra padding to avoid overflow
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
