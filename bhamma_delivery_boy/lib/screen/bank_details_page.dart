
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_helper.dart';
import '../models/dropdown_model.dart';
import '../models/profile_details.dart';
import '../utils/custom_toast.dart';
import '../utils/default_colors.dart';
import '../widgets/customDropdown.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  BankDetailsPageState createState() => BankDetailsPageState();
}

class BankDetailsPageState extends State<BankDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController holderNameController = TextEditingController();
  TextEditingController holderAccountNumberController = TextEditingController();
  TextEditingController ibanController = TextEditingController();

  String? selectBank;
  var bankId;
  List<String> bankNames = [];
  List<DropdownModel>? bankModel;

  ProfileDetails? profileDetails;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadbank();
  }

  Future<void> loadbank() async {
    try {
      bankModel = await ApiHandler.fetchBank();

      setState(() {
        bankNames = bankModel!.map((bank) => bank.name ?? '').toList();
        print("Show bank list: $bankNames");
      });
    } catch (e) {
      print('Failed to fetch vehicles: $e');
    }
  }

  String? getBankId(String bankName) {
    var bank = bankModel!.firstWhere((bank) => bank.name == bankName);
    return bank.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bank details for payment processing",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
              children: [
                /// **Bank Name Dropdown**
                CustomDropDown(
                  hintText: 'Bank name',
                  labelText: 'Bank name',
                  items: bankNames,
                  value: selectBank,
                  onChanged: (value) {
                    setState(() {
                      selectBank = value;
                      bankId = getBankId(value!);
                      print(bankId);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a bank';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
        
                /// **Holder Name Form Field**
                CustomTextFormField(
                  controller: holderNameController,
                  hintText: 'Enter Holder Name',
                  labelText: 'Holder name',
                  textInputType: TextInputType.text,
                  suffix: const Icon(
                    Icons.person,
                    color: DefaultColor.mainColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter holder name';
                    }
                    return null;
                  },
                ),const SizedBox(height: 20),
        
                /// **Holder Acount Number Field**
                CustomTextFormField(
                  controller: holderAccountNumberController,
                  hintText: 'Enter Account Number',
                  labelText: 'Enter Account Number',
                  textInputType: TextInputType.number,
                  suffix: const Icon(
                    Icons.person,
                    color: DefaultColor.mainColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter holder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                /// **IBAN Text Field**
                CustomTextFormField(
                  controller: ibanController,
                  hintText: 'Enter Your Bank IFSC Code',
                  labelText: 'IFSC CODE',
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter IBAN';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                /// **Next Button**
                CustomElevatedButton(
                  text: "Next",
                  buttonTextStyle: const TextStyle(fontSize: 16),
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = await prefs.getString('login_token');
                    int? userId = await prefs.getInt("user_id");
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
        
                      var result = await ApiHandler.updateBankDetails(
                          selectBank.toString(),
                          holderNameController.text.toString(),
                          ibanController.text.toString(),
                          token.toString(),
                          userId.toString(),
                          context);
        
                      if (result == "success") {
                        ToastManager.showToast(
                          msg: "Bank Details Update Successfull",
                          color: DefaultColor.green,
                          context: context,
                        );
                        Navigator.pushNamed(context, "/home");
                      }
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
