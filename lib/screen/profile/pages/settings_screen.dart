import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_helper.dart';
import '../../../models/dropdown_model.dart';
import '../../../utils/default_colors.dart';
import '../../../widgets/custom_elevated_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = "English";
  bool isDarkMode = false;

  List<String> languageOptions = ["English", "Spanish", "French", "German"];

  String? selectedShift;
  var shiftId;
  List<String> shiftNames = [];
  List<DropdownModel>? shiftModel;
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

    await loadshift();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedShift = prefs.getString("saved_shift_name");

    if (shiftNames.isNotEmpty) {
      if (savedShift != null && shiftNames.contains(savedShift)) {
        selectedShift = savedShift;
        shiftId = getshiftId(savedShift);
      } else {
        selectedShift = shiftNames.first;
        shiftId = getshiftId(selectedShift!);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadshift() async {
    try {
      shiftModel = await ApiHandler.fetchShift();

      setState(() {
        shiftNames = shiftModel!.map((shift) => shift.name ?? '').toList();
        print("Show shift list: $shiftNames");
      });
    } catch (e) {
      print('Failed to fetch shifts: $e');
    }
  }

  String? getshiftId(String shiftName) {
    var shift = shiftModel!.firstWhere((shift) => shift.name == shiftName);
    return shift.id.toString();
  }

  String? getshiftName(String shiftId) {
    var shift = shiftModel?.firstWhere(
      (shift) => shift.id.toString() == shiftId,
      orElse: () => DropdownModel(id: null, name: 'Unknown'),
    );
    return shift?.name;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text("Settings", style: TextStyle(color: DefaultColor.mainColor)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                color: DefaultColor.mainColor,
                size: 50,
              ))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeading("Flexible Shift Management"),
                    if (selectedShift != null)
                      _buildDropdown(selectedShift!, shiftNames, (value) {
                        setState(() {
                          selectedShift = value!;
                          shiftId = getshiftId(value);
                          print("Selected shiftId: $shiftId");
                        });
                      }),
                    const SizedBox(height: 40),
                    _buildHeading("Language Setting"),
                    _buildDropdown(selectedLanguage, languageOptions, (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    }),
                    const SizedBox(height: 40),
                    _buildHeading("App Mode Setting"),
                    _buildDarkModeToggle(),
                    const Spacer(),
                    CustomElevatedButton(
                      text: "Save",
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var token = await prefs.getString('login_token');
      
                        // Save shift name and ID locally
                        await prefs.setString("saved_shift_name", selectedShift!);
                        await prefs.setString("saved_shift_id", shiftId);
      
                        var result = await ApiHandler.shiftChange(
                            shiftId, token!, context);
                        print("Result: $result");
      
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result == "success"
                                ? "Shift Changed Successfully"
                                : "Failed to Change Shift"),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDropdown(String selectedValue, List<String> options,
      ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: DefaultColor.mainColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: DefaultColor.mainColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Dark Mode"),
          Transform.scale(
            scale: 0.6,
            child: Switch(
              value: AdaptiveTheme.of(context).mode.isDark,
              onChanged: (value) {
                if (value) {
                  AdaptiveTheme.of(context).setDark();
                } else {
                  AdaptiveTheme.of(context).setLight();
                }
              },
              activeColor: DefaultColor.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
