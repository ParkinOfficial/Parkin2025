// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:school_bus_app/src/login-api/api_service.dart';
// import 'package:school_bus_app/src/login-api/response_model.dart';
// import 'package:school_bus_app/src/loggers_files/logger.dart';
//
// class LoginVm {
//   final log = logger(LoginVm);
//   bool isAPICallProcess = false;
//
//   // Function to validate the mobile number
//   String? validateNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter mobile number';
//     }
//     if (value.length != 10) {
//       return 'Please enter a valid 10-digit number';
//     }
//     return null;
//   }
//
//   // Function to handle login and OTP API call
//   Future<String?> submitLogin(String mobileNumber) async {
//     try {
//       String? deviceToken = await FirebaseMessaging.instance.getToken();
//       log.i("Device Token: $deviceToken");
//
//       var response = await APIServices.otpLogin(mobileNumber);
//
//       if (response.statusCode == 200) {
//         ResponseModel loginResponse = ResponseModel(response.body);
//         log.d("Login Response: ${loginResponse.toString()}");
//         return null;
//       } else {
//         log.e('already loged in');
//         var errorMessage = "Unknown error";
//         if (response.statusCode == 404) {
//           var responseBody = jsonDecode(response.body);
//           errorMessage = responseBody['detail'] ?? 'Already logged in';
//         }
//         log.e(errorMessage);
//         return errorMessage; // Return error message if login fails
//       }
//     } catch (error) {
//       log.e("Error: $error");
//       return "Network error. Please check your connection.";
//     }
//   }
// }
