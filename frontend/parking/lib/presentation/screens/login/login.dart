// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:school_bus_app/src/loggers_files/logger.dart';
// import 'package:school_bus_app/src/login-models/api_service.dart';
// import 'package:sizer/sizer.dart';
// import '../../dialog-global/dialog-box.dart';
// import '../../error-Screen/error_Screen.dart';
// import '../../login-models/config.dart';
// import '../../login-models/response_model.dart';
// import '../otp-Screen/otp_screen.dart';
// import 'login_vm.dart';
//
// class LoginScreen extends StatefulWidget {
//   static String routeName = "LoginScreen";
//
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final log = logger(LoginScreen);
//   final loginVm = LoginVm();
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
//   bool isAPICallProcess = false;
//   final _numberController = TextEditingController();
//   late String imageUrl;
//   String? errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     imageUrl = "http://i.imgur.com/bOCEVJg.png";
//   }
//
//   @override
//   void dispose() {
//     _numberController.dispose();
//     super.dispose();
//   }
//
//   // void _submit() async {
//   //   if (globalFormKey.currentState?.validate() ?? false) {
//   //     setState(() {
//   //       isAPICallProcess = true;
//   //     });
//   //     log.i("API URL:${Configs.apiURL}");
//   //     try {
//   //       String? deviceToken = await FirebaseMessaging.instance.getToken();
//   //       log.i(deviceToken);
//   //       var response = await APIServices.otpLogin(_numberController.text);
//   //
//   //       await Future.delayed(const Duration(seconds: 1));
//   //       if (mounted) {
//   //         // Check if widget is mounted
//   //         setState(() {
//   //           isAPICallProcess = false;
//   //         });
//   //       }
//   //
//   //       if (response.statusCode == 200) {
//   //         ResponseModel loginResponse = ResponseModel(response.body);
//   //         log.d(loginResponse.toString());
//   //
//   //         // Only navigate if the response is successful
//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => OptScreen(
//   //               mobileNo: _numberController.text,
//   //             ),
//   //           ),
//   //         );
//   //       } else {
//   //         GlobalDialogs.showErrorDialogForApi(context, 'invalid number');
//   //       }
//   //     } catch (error) {
//   //       log.e("the error=$error");
//   //       if (mounted) {
//   //         // Check if widget is mounted
//   //         setState(() {
//   //           isAPICallProcess = false;
//   //         });
//   //       }
//   //       _showErrorScreen('Network error. Please check your connection.');
//   //     }
//   //   }
//   // }
//   void _submit() async {
//     if (globalFormKey.currentState?.validate() ?? false) {
//       setState(() {
//         isAPICallProcess = true;
//       });
//
//       String? result  = await loginVm.submitLogin(_numberController.text);
//
//       setState(() {
//         isAPICallProcess = false;
//       });
//
//       if (result == null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OptScreen(
//               mobileNo: _numberController.text,
//             ),
//           ),
//         );
//       } else {
//         GlobalDialogs.showErrorDialogForApi(context, result);
//       }
//     }
//   }
//   void _showErrorScreen(String errorMessage) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ErrorScreen(
//           errorMessage: errorMessage,
//           onRetry: _submit, // Pass the submit function for retry
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//           body: ProgressHUD(
//             inAsyncCall: isAPICallProcess,
//             opacity: 0.3,
//             child: loginUI(),
//           ),
//         ));
//   }
//
//   Widget loginUI() {
//     return Form(
//       key: globalFormKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CachedNetworkImage(
//             imageUrl: imageUrl,
//             height: 20.h,
//             fit: BoxFit.contain,
//             placeholder: (context, url) =>
//             const CircularProgressIndicator(), // Optional placeholder
//             errorWidget: (context, url, error) =>
//             const Icon(Icons.error), // Error widget
//           ),
//           SizedBox(height: 0.5.h), // Responsive padding
//           const Center(
//             child: Text(
//               "Login With a Mobile Number",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 1.h),
//           const Center(
//             child: Text(
//               "Enter Your valid Mobile number",
//               style: TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           SizedBox(height: 1.5.h),
//           Padding(
//             padding:
//             EdgeInsets.symmetric(horizontal: 5.w), // Responsive padding
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Flexible(
//                   flex: 1,
//                   child: Container(
//                     height: 5.h, // Responsive container height
//                     // width: 50,
//                     margin: EdgeInsets.fromLTRB(
//                         0, 1.h, 1.w, 3.5.h), // Responsive margins
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       border: Border.all(
//                         color: Colors.black,
//                       ),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         "+91",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 2.w), // Add space between the boxes
//                 Flexible(
//                   flex: 5,
//                   child: TextFormField(
//                     maxLines: 1,
//                     maxLength: 10,
//                     controller: _numberController,
//                     style: TextStyle(color: Colors.black, fontSize: 15.sp),
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(5.sp),
//                       hintText: "Mobile Number",
//                       enabledBorder: OutlineInputBorder(
//                         borderSide:
//                         BorderSide(color: Colors.black, width: 1.sp),
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide:
//                         BorderSide(color: Colors.black, width: 1.sp),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:
//                         BorderSide(color: Colors.redAccent, width: 1.sp),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: <TextInputFormatter>[
//                       FilteringTextInputFormatter.digitsOnly,
//                     ],
//                     validator: loginVm.validateNumber,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 0.5.h), // Responsive padding
//           Center(
//             child: ElevatedButton(
//               onPressed: _submit,
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.black,
//                 backgroundColor: HexColor("78D0B1"),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.sp),
//                 ),
//               ),
//               child: const Text("Continue"),
//             ),
//           ),
//           // If there's an error message, display it below the button
//           if (errorMessage != null && errorMessage!.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: Text(
//                 errorMessage!,
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
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
//           const Center(
//             child: CircularProgressIndicator(),
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
