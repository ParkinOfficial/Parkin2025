// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../main.dart';
// import '../../dataStorage/sharpref.dart';
// import '../../loggers_files/logger.dart';
// import '../../login-api/api_service.dart';
// import '../landing-screen/landing_screen.dart';
// import '../../dialog-global/dialog-box.dart';
//
// class otpVm with ChangeNotifier {
//   final log = logger(otpVm);
//   String? _currentToken;
//   bool enableResendBtn = false;
//   String? _otpCode;
//   final int otpCodeLength = 4;
//   bool _enableButton = true;
//   bool isAPICallProcess = false;
//
//   String? get otpCode => _otpCode;
//   bool get enableButton => _enableButton;
//   bool get isCallProcess => isAPICallProcess;
//
//   void updateOtpCode(String code) {
//     _otpCode = code;
//     _enableButton = code.length == otpCodeLength;
//     notifyListeners();
//   }
//
//   Future<void> setupPushNotification(String? mobileNo) async {
//     final fcm = FirebaseMessaging.instance;
//
//     final notificationSettings = await fcm.requestPermission();
//     if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
//       final token = await fcm.getToken();
//       if (kDebugMode) {
//         print('Device token: $token');
//       }
//
//       if (token != null && token != _currentToken) {
//         _currentToken = token;
//         if (mobileNo != null) {
//           if (kDebugMode) {
//             print("Sending mobile number: $mobileNo with token: $token");
//           }
//           await APIServices.storeDeviceToken(mobileNo, token);
//         } else {
//           if (kDebugMode) {
//             print('Mobile number is missing');
//           }
//         }
//       }
//     } else {
//       debugPrint('User declined or has not accepted notification permissions');
//     }
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNotificationTap();
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print('Received a message in foreground: ${message.notification?.title}');
//       }
//
//       showLocalNotification(
//         message.notification?.title ?? 'No Title',
//         message.notification?.body ?? 'You got a new Announcement',
//       );
//     });
//
//     final initialMessage = await fcm.getInitialMessage();
//     if (initialMessage != null) {
//       _handleNotificationTap();
//     }
//   }
//
//   Future<void> showLocalNotification(String title, String body) async {
//     var androidDetails = const AndroidNotificationDetails(
//       '123',
//       'Announcement',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     var notificationDetails = NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
//
//   Future<void> backgroundMessageHandler(RemoteMessage message) async {
//     if (kDebugMode) {
//       print('Background message received: ${message.notification?.title}');
//     }
//   }
//
//   void setupBackgroundHandler() {
//     FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
//   }
//
//   void _handleNotificationTap() {
//     // Handle notification tap logic here
//   }
//
//   Future<void> verifyOTP(String? mobileNo, BuildContext context) async {
//     isAPICallProcess = true;
//     notifyListeners();
//
//     try {
//       final response = await APIServices.verifyOTP(mobileNo!, _otpCode!);
//       if (response.statusCode == 200) {
//         await goToLandingScreen(mobileNo, context);
//       } else {
//         GlobalDialogs.showErrorDialogForApi(context, 'retry');
//       }
//     } catch (error) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('invalid OTP')),
//         );
//       }
//     } finally {
//       isAPICallProcess = false;
//       notifyListeners();
//     }
//   }
//   // Future<void> verifyOTP(String? mobileNo, BuildContext context) async {
//   //   isAPICallProcess = true;
//   //   notifyListeners();
//   //
//   //   try {
//   //     final response = await APIServices.verifyOTP(mobileNo!, _otpCode!);
//   //     if (response.statusCode == 200) {
//   //       var responseData = jsonDecode(response.body);
//   //
//   //       // Ensure session_token is not null
//   //       String? sessionToken = responseData['session_token'];
//   //       if (sessionToken != null) {
//   //         // Save session token safely
//   //         await SharedPrefsHelper.saveLoginState(true, sessionToken);
//   //
//   //         if (kDebugMode) {
//   //           print('Access Token: $sessionToken');
//   //         }
//   //
//   //         log.i('Access Token: $sessionToken');
//   //         await APIServices.getChildInfo();
//   //
//   //         log.i('Student info fetched successfully');
//   //         Navigator.pushAndRemoveUntil(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => LandingScreen(mobileNo: mobileNo),
//   //           ),
//   //               (Route<dynamic> route) => false,
//   //         );
//   //       } else {
//   //         // Handle case when session_token is null
//   //         if (kDebugMode) {
//   //           print('Error: session_token is null');
//   //         }
//   //         GlobalDialogs.showErrorDialogForApi(context, 'Session token is missing.');
//   //       }
//   //     } else {
//   //       GlobalDialogs.showErrorDialogForApi(context, 'retry');
//   //     }
//   //   } catch (error) {
//   //     if (context.mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('Invalid OTP')),
//   //       );
//   //     }
//   //   } finally {
//   //     isAPICallProcess = false;
//   //     notifyListeners();
//   //   }
//   // }
//
//   Future<void> goToLandingScreen(String mobileNo, BuildContext context) async {
//     try {
//       // final prefs = await SharedPreferences.getInstance();
//       // await prefs.setBool('isLoggedIn', true);
//       // await prefs.setString('accessToken', APIServices.accessToken!);
//       if (APIServices.session_Token == null) {
//         throw Exception('Session token is null');
//       }
//       await SharedPrefsHelper.saveLoginState(true,APIServices.session_Token!);
//
//       log.i('Token: ${APIServices.session_Token}');
//       await APIServices.getChildInfo();
//
//       log.i('student info fetched successfully');
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LandingScreen(
//             mobileNo: mobileNo,
//           ),
//         ),
//             (Route<dynamic> route) => false,
//       );
//     } catch (error) {
//       log.e(error);
//       GlobalDialogs.showErrorDialogForApi(context, 'Please try again.');
//     }
//   }
// }