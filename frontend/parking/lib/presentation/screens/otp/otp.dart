// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:snippet_coder_utils/FormHelper.dart';
// import '../../../main.dart';
// import '../../dialog-global/dialog-box.dart';
// import '../../loggers_files/logger.dart';
// import '../../login-models/api_service.dart';
// import '../home-screen/announcement-screen/announcement_Screen.dart';
// import '../landing-screen/landing_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class OptScreen extends StatefulWidget {
//   static String routeName = 'OptScreen';
//   final String? mobileNo;
//   const OptScreen({super.key, this.mobileNo});
//
//   @override
//   State<OptScreen> createState() => _OptScreenState();
// }
//
// class _OptScreenState extends State<OptScreen> {
//   String? _currentToken;
//
//   final log = logger(OptScreen);
//   bool enableResendBtn = false;
//   String? _otpCode;
//   final int _otpCodeLength = 4;
//   bool _enableButton = true;
//   late FocusNode myFocusNode;
//   bool isAPICallProcess = false;
//
//   @override
//   void initState() {
//     super.initState();
//     myFocusNode = FocusNode();
//     myFocusNode.requestFocus();
//     setupPushNotification();
//     setupBackgroundHandler();
//   }
//
//   void setupPushNotification() async {
//     final fcm = FirebaseMessaging.instance;
//
//     final notificationSettings = await fcm.requestPermission();
//     if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.authorized) {
//       final token = await fcm.getToken();
//       if (kDebugMode) {
//         print('Device token: $token');
//       }
//
//       if (token != null && token != _currentToken) {
//         setState(() {
//           _currentToken = token;
//         });
//         if (widget.mobileNo != null) {
//           if (kDebugMode) {
//             print(
//                 "Sending mobile number: ${widget.mobileNo} with token: $token");
//           }
//           await APIServices.storeDeviceToken(widget.mobileNo!, token);
//         } else {
//           if (kDebugMode) {
//             print('Mobile number is missing');
//           }
//         }
//       }
//     } else {
//       debugPrint('User declined or has not accepted notification permissions');
//     }
//     // FirebaseMessaging messaging = FirebaseMessaging.instance;
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNotificationTap();
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print(
//             'Received a message in foreground: ${message.notification?.title}');
//       }
//
//       // Only show a local notification if the app is in the foreground
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
//   bool isOnSpecificScreen(BuildContext context) {
//     String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
//     return currentRoute == '/AnnouncementScreen' ||
//         currentRoute == '/HomeScreen';
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
//     Navigator.pushNamed(context, AnnouncementScreen.routeName);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: ProgressHUD(
//           inAsyncCall: isAPICallProcess,
//           opacity: 0.3,
//           key: UniqueKey(),
//           child: otpVerify(),
//         ),
//       ),
//     );
//   }
//
//   Widget otpVerify() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 9.w),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/images/otp.png',
//             height: 20.h,
//             fit: BoxFit.contain,
//           ),
//           SizedBox(height: 2.h),
//           Text(
//             "OTP Verification",
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 0.5.h),
//           Text(
//             "Enter OTP code sent to you mobile \n+91-${widget.mobileNo}",
//             maxLines: 2,
//             style: TextStyle(
//               fontSize: 12.sp,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           PinFieldAutoFill(
//             decoration: UnderlineDecoration(
//               textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
//               colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
//             ),
//             currentCode: _otpCode,
//             codeLength: _otpCodeLength,
//             onCodeSubmitted: (code) {},
//             onCodeChanged: (code) {
//               log.i(code);
//               if (code!.length == _otpCodeLength) {
//                 _otpCode = code;
//                 _enableButton = true;
//                 FocusScope.of(context).requestFocus(FocusNode());
//               } else {
//                 _enableButton = false;
//               }
//             },
//           ),
//           SizedBox(height: 20.sp),
//           FormHelper.submitButton(
//             "Submit",
//                 () {
//               if (_enableButton) {
//                 _verifyOTP();
//               } else {
//                 GlobalDialogs.showErrorDialogForApi(
//                     context, 'Enter Full Number');
//               }
//             },
//             borderRadius: 2.h,
//             width: 35.w,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _verifyOTP() {
//     setState(() {
//       isAPICallProcess = true; // Show the CircularProgressIndicator
//     });
//
//     // Here the two of the following are been verified number, otp
//     APIServices.verifyOTP(widget.mobileNo!, _otpCode!).then((response) async {
//       setState(() {
//         isAPICallProcess = false; // Hide the CircularProgressIndicator
//       });
//       if (response.statusCode == 200) {
//         await goToLandingScreen(); // Navigate to the landing screen
//       } else {
//         // Navigate to ErrorScreen for incorrect OTP
//         GlobalDialogs.showErrorDialogForApi(context, 'retry');
//       }
//     }).catchError((error) {
//       setState(() {
//         isAPICallProcess = false; // Hide the CircularProgressIndicator
//       });
//       // Navigate to ErrorScreen for network error
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('invalid OTP')),
//         );
//       }
//     });
//   }
//
//   Future<void> goToLandingScreen() async {
//     try {
//       // Ensure the token is saved correctly
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);
//       await prefs.setString('accessToken', APIServices.session_Token!);
//       await prefs.setString('mobileNo', widget.mobileNo!);
//       if (kDebugMode) {
//         print('Access Token: ${APIServices.session_Token}');
//       }
//
//       log.i('Access Token: ${APIServices.session_Token}');
//       await APIServices.getChildInfo(); // Fetch student data
//
//       //this is for just to know that the student info have got
//       log.i('student info fetched successfully');
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//             builder: (context) => LandingScreen(
//               mobileNo: widget.mobileNo,
//             )),
//             (Route<dynamic> route) => false,
//       );
//     } catch (error) {
//       log.e(error);
//       GlobalDialogs.showErrorDialogForApi(context, 'Please try again.');
//     }
//   }
//
//   @override
//   void dispose() {
//     myFocusNode.dispose();
//     super.dispose();
//   }
// }
//
// class ProgressHUD extends StatelessWidget {
//   final Widget child;
//   final bool inAsyncCall;
//   final double opacity;
//
//   const ProgressHUD({
//     super.key,
//     required this.child,
//     required this.inAsyncCall,
//     required this.opacity,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         child,
//         if (inAsyncCall)
//           Opacity(
//             opacity: opacity,
//             child: const ModalBarrier(dismissible: false, color: Colors.black),
//           ),
//         if (inAsyncCall)
//           Container(
//             color: Colors.black.withOpacity(0.3), // Transparent overlay
//             child: const Center(
//               child: CircularProgressIndicator(), // Show loader
//             ),
//           ),
//       ],
//     );
//   }
// }
//
// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll("#", "");
//     if (hexColor.length == 6) {
//       hexColor = "FF$hexColor";
//     }
//     return int.parse(hexColor, radix: 16);
//   }
//
//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:sizer/sizer.dart';
// // import 'package:sms_autofill/sms_autofill.dart';
// // import 'package:snippet_coder_utils/FormHelper.dart';
// // import '../../dialog-global/dialog-box.dart';
// // import 'otp_vm.dart';
// //
// // class OptScreen extends StatefulWidget {
// //   static String routeName = 'OptScreen';
// //   final String? mobileNo;
// //   const OptScreen({super.key, this.mobileNo});
// //
// //   @override
// //   State<OptScreen> createState() => _OptScreenState();
// // }
// //
// // class _OptScreenState extends State<OptScreen> {
// //   late otpVm _otpVM;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _otpVM = otpVm();
// //     _otpVM.setupPushNotification(widget.mobileNo);
// //     _otpVM.setupBackgroundHandler();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ChangeNotifierProvider.value(
// //       value: _otpVM,
// //       child: SafeArea(
// //         child: Scaffold(
// //           body: ProgressHUD(
// //             inAsyncCall: _otpVM.isCallProcess,
// //             opacity: 0.3,
// //             key: UniqueKey(),
// //             child: otpVerify(),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget otpVerify() {
// //     return Consumer<otpVm>(
// //       builder: (context, otpVm, child) {
// //         return Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 9.w),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Image.asset(
// //                 'assets/images/otp.png',
// //                 height: 20.h,
// //                 fit: BoxFit.contain,
// //               ),
// //               SizedBox(height: 2.h),
// //               Text(
// //                 "OTP Verification",
// //                 style: TextStyle(
// //                   fontSize: 18.sp,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               SizedBox(height: 0.5.h),
// //               Text(
// //                 "Enter OTP code sent to you mobile \n+91-${widget.mobileNo}",
// //                 maxLines: 2,
// //                 style: TextStyle(
// //                   fontSize: 12.sp,
// //                 ),
// //                 textAlign: TextAlign.center,
// //               ),
// //               PinFieldAutoFill(
// //                 decoration: UnderlineDecoration(
// //                   textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
// //                   colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
// //                 ),
// //                 currentCode: otpVm.otpCode,
// //                 codeLength: otpVm.otpCodeLength,
// //                 onCodeSubmitted: (code) {},
// //                 onCodeChanged: (code) {
// //                   otpVm.updateOtpCode(code!);
// //                 },
// //               ),
// //               SizedBox(height: 20.sp),
// //               FormHelper.submitButton(
// //                 "Submit",
// //                     () {
// //                   if (otpVm.enableButton) {
// //                     otpVm.verifyOTP(widget.mobileNo, context);
// //                   } else {
// //                     GlobalDialogs.showErrorDialogForApi(context, 'Enter Full Number');
// //                   }
// //                 },
// //                 borderRadius: 2.h,
// //                 width: 35.w,
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // class ProgressHUD extends StatelessWidget {
// //   final Widget child;
// //   final bool inAsyncCall;
// //   final double opacity;
// //
// //   const ProgressHUD({
// //     super.key,
// //     required this.child,
// //     required this.inAsyncCall,
// //     required this.opacity,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         child,
// //         if (inAsyncCall)
// //           Opacity(
// //             opacity: opacity,
// //             child: const ModalBarrier(dismissible: false, color: Colors.black),
// //           ),
// //         if (inAsyncCall)
// //           Container(
// //             color: Colors.black.withOpacity(0.3), // Transparent overlay
// //             child: const Center(
// //               child: CircularProgressIndicator(), // Show loader
// //             ),
// //           ),
// //       ],
// //     );
// //   }
// // }