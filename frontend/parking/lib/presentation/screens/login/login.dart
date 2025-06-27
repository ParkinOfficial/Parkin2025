import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import 'package:parking/data/api/api_service.dart'; // Ensure this contains `String login = "https://your-api/login";`
import 'package:parking/presentation/screens/otp/otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  late Country selectedCountry;
  bool isLoading = false;

  final Map<String, int> phoneLengths = {
    'IN': 10,
    'US': 10,
    'UK': 10,
    'AE': 9,
    'PK': 10,
    // Add more countries as needed
  };

  final String verifyLogin = login; // from api_service.dart

  @override
  void initState() {
    super.initState();
    selectedCountry = CountryService().getAll().firstWhere(
          (country) => country.countryCode == 'IN',
      orElse: () => CountryService().getAll().first,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _checkPhoneNumberExists(String phoneNumber) async {
    final phoneCode = selectedCountry.phoneCode;

    print("📲 Calling API: $verifyLogin");
    print("📦 Request body: {mobile_number: $phoneNumber, phone_code: $phoneCode}");

    final response = await http.post(
      Uri.parse(verifyLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobile_number': phoneNumber,
        'phone_code': phoneCode,
      }),
    );

    print("📩 Response status: ${response.statusCode}");
    print("📩 Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return true;
    } else {
      throw Exception('Failed to check phone number');
    }
  }

  Future<void> _validateAndProceed() async {
    final rawPhone = phoneController.text.trim();
    final countryCode = selectedCountry.countryCode;
    final expectedLength = phoneLengths[countryCode] ?? 6;

    if (rawPhone.isEmpty || rawPhone.length != expectedLength) {
      _showSnackBar("Enter a valid ${selectedCountry.name} number");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final exists = await _checkPhoneNumberExists(rawPhone);
      print(exists);
      if (exists) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen(phoneCode: selectedCountry.phoneCode,mobileNumber: rawPhone)),
        );
      } else {
        _showSnackBar("Phone number not registered");
      }
    } catch (e) {
      print("❌ Exception: $e");
      _showSnackBar("Error checking phone number");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Image.asset('assets/ic_log.png', width: 86, height: 64),
                    SizedBox(height: 20),
                    Text(
                      "What's your contact ?",
                      style: TextStyle(
                        fontFamily: 'MontserratBold',
                        fontSize: 16,
                        color: Color(0xFF2F2E2E),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Enter your phone number for verification',
                      style: TextStyle(
                        fontFamily: 'MontserratRegular',
                        fontSize: 11,
                        color: Color(0xFF2F2E2E),
                      ),
                    ),
                    SizedBox(height: 10),

                    /// Phone input container
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (Country country) {
                                  setState(() {
                                    selectedCountry = country;
                                  });
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Text(selectedCountry.flagEmoji, style: TextStyle(fontSize: 20)),
                                SizedBox(width: 6),
                                Text(
                                  '+${selectedCountry.phoneCode}',
                                  style: TextStyle(
                                    fontFamily: 'RobotoBold',
                                    fontSize: 12,
                                    color: Color(0xFF2F2E2E),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              maxLength: phoneLengths[selectedCountry.countryCode] ?? 10,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontFamily: 'RobotoBold',
                                fontSize: 12,
                                color: Color(0xFF2F2E2E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 75,
              left: 20,
              right: 20,
              child: Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'MontserratMedium',
                  fontSize: 9,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width * 0.5 - 160,
              child: SizedBox(
                width: 320,
                child: ElevatedButton(
                  onPressed: _validateAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6200EE),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'MontserratBold',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
