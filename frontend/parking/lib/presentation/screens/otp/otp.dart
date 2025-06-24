import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parking/data/api/api_service.dart';
import 'package:http/http.dart' as http;
class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String phoneCode;

  const OtpScreen({
    Key? key,
    required this.mobileNumber,
    required this.phoneCode,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  final String otpVerifyUrl = otp; // Replace with actual URL

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> verifyOtp(String otp) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$otpVerifyUrl?otp=$otp'),
        headers: {'Content-Type': 'application/json','otp': otp},
        body: jsonEncode({

          'mobile_number': widget.mobileNumber,
          'phone_code': widget.phoneCode,
        }),
      );
      print("📩 Response status: ${response.statusCode}");
      print("📩 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final role = data['role'];

        if (role is String) {
          if (role == 'user') {
            Navigator.pushNamed(context, '/userPage');
          } else if (role == 'owner') {
            Navigator.pushNamed(context, '/ownerPage');
          } else {
            _showSnackBar("Unknown role: $role");
          }
        } else if (role is List && role.contains('user') && role.contains('owner')) {
          Navigator.pushNamed(context, '/roleSelection');
        } else {
          _showSnackBar("Invalid role format");
        }
      } else {
        _showSnackBar("Invalid OTP or server error.");
      }
    } catch (e) {
      print("OTP verification error: $e");
      _showSnackBar("Error verifying OTP.");
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter OTP",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "4-digit OTP",
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final otp = otpController.text.trim();
                    if (otp.length == 4) {
                      verifyOtp(otp);
                    } else {
                      _showSnackBar("Please enter a valid 4-digit OTP");
                    }
                  },
                  child: isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : Text("Next"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
