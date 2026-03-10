// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:rdc_concrete/screens/vendor_home_page.dart';
//
// import 'package:rdc_concrete/services/vendor_api_service.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:sms_autofill/sms_autofill.dart';
// // import 'package:sms_retriever/sms_retriever.dart';
// // import 'package:sms_retriever/sms_retriever.dart';
//
// import '../component/sharedpref.dart';
// import '../models/driverdt_otp_pojo.dart';
// import '../models/vendordt.dart';
// import '../services/otp_api_service.dart';
// import 'change_password.dart';
//
// class ValidateVendor extends StatefulWidget {
//   final String userType;
//   const ValidateVendor({super.key, required this.userType});
//
//   @override
//   State<ValidateVendor> createState() => _ValidateVendorState();
// }
//
// class _ValidateVendorState extends State<ValidateVendor> {
//   bool _obscurePassword = true;
//   final _formKey = GlobalKey<FormState>();
//
//   final FocusNode _otpFocusNode1 = FocusNode();
//   final FocusNode _otpFocusNode2 = FocusNode();
//   final FocusNode _otpFocusNode3 = FocusNode();
//   final FocusNode _otpFocusNode4 = FocusNode();
//
//   final TextEditingController numberController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   TextEditingController otp1Controller = TextEditingController();
//   TextEditingController otp2Controller = TextEditingController();
//   TextEditingController otp3Controller = TextEditingController();
//   TextEditingController otp4Controller = TextEditingController();
//
//   late String vsapid;
//   String otpStringVal = '';
//   String mobileString = '';
//   bool optValue = false;
//   bool isVisible = false;
//   bool isLoading = false;
//   bool isVendorValidated = false; // Controls UI state
//   late String id, rdcsitename, profilemname, firstCheck, locid;
//   StringBuffer otp11 = StringBuffer();
//   @override
//   void dispose() {
//     // Dispose of the FocusNodes when the widget is removed from the widget tree
//     _otpFocusNode1.dispose();
//     _otpFocusNode2.dispose();
//     _otpFocusNode3.dispose();
//     _otpFocusNode4.dispose();
//     super.dispose();
//   }
//
//   void _validateVendor() async {
//     if (numberController.text.trim().isNotEmpty) {
//       if (numberController.text.length <= 2) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Please enter Vendor Number"),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }
//
//       await Future.delayed(Duration(seconds: 1)); // Simulate API Call
//
//       setState(() {
//         isVendorValidated = true; // Show other fields after validation
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please enter Vendor Number"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _loginVendorvalidation() async {
//     vsapid = numberController.text.trim();
//     String mobile = mobileController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (mobile.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please enter Mobile No. and Password"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     if (mobile.length != 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please enter Mobile Number"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     if (password.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please Enter Correct Password !"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     loginvendor(mobile, password);
//   }
//
//   Future<DriverDT?> sendOtp(String userMobile, String otp) async {
//     // startSmartUserConsent();
//     //print("hiiii");
//     String message = "OTP for weighbridge software login $otp -RDC Concrete";
//     String username = "RDCCON";
//     String password = "123456";
//     String type = "TEXT";
//     String sender = "RDCCON";
//     OtpApiService otpApiService = OtpApiService();
//     //Vendordt? vendor = await vendorService.loginVendor(mobile, vsapid, password);
//     try {
//       //print("Sending OTP to $userMobile");
//       DriverDT response = await otpApiService.thisorder(
//         username: username,
//         password: password,
//         type: type,
//         sender: sender,
//         mobile: userMobile,
//         message: message,
//       );
//       if (response.status == 1) {
//
//       } else {
//         //print("No response received from the server.");
//       }
//           //print("Response received: ${response}");
//
//       // Continue with your logic...
//     } catch (e) {
//       //print("Error occurred while sending OTP: $e");
//     }
//
//     // try {
//     //   DriverDT? response = await otpApiService.thisorder(
//     //     username: username,
//     //     password: password,
//     //     type: type,
//     //     sender: sender,
//     //     mobile: userMobile,
//     //     message: message,
//     //   );
//     //   print("responseresponse${response}");
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     SnackBar(
//     //       content: Text("OTP sent successfully to $userMobile"),
//     //       backgroundColor: Colors.green,
//     //     ),
//     //   );
//     //    // Assuming 'status' is the property to check
//     //
//     //
//     //   // if (response.status == 1) {
//     //   //   // OTP sent successfully
//     //   //   // print("OTP sent to $userMobile");
//     //   // } else {
//     //   //   // Handle custom failure
//     //   //   //print("OTP not sent, server response: ${response.status}");
//     //   // }
//     //   // Handle successful response
//     //   //print("OTP sent successfully: ${response.toJson()}");
//     // } catch (e) {
//     //   // Handle error
//     //   //print("Error occurred while sending OTP: $e");
//     // }
//
//     return null;
//   }
//   // void _getAppSignature() async {
//   //   try {
//   //  //   String? signature = await SmsAutoFill().getAppSignature;
//   //     //print("App Signature: $signature");
//   //   } catch (e) {
//   //     //print("Error fetching app signature: $e");
//   //   }
//   // }
//   // void sendSMS(String message, String recipient) {
//   //   SmsSender sender = SmsSender();
//   //   SmsMessage sms = SmsMessage(recipient, message);
//   //   sender.sendSms(sms);
//   // }
//   Future<void> loginvendor(String mobile, String password) async {
//   //  _getAppSignature();
//
//     VendorService vendorService = VendorService();
//     Vendordt? vendor = await vendorService.loginVendor(
//       mobile,
//       vsapid,
//       password,
//     );
//     //final localContext = context;
//     // Check if vendor is null or if the status indicates an error
//     if (vendor == null || vendor.status == 0) {
//       //final localContext = context;
//       if (!mounted) return;
//       // Handle the error case
//       // String errorMessage = vendor?.message ?? "Invalid Credentials, Invalid Mobile Number or password";
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "Invalid Credentials, Invalid Mobile Number or password",
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//
//       return; // Exit the function early
//     }
//
//     // Set variables
//     id = vendor.vendorid.toString();
//     rdcsitename = vendor.vendorlocation;
//     profilemname = vendor.vendoremail;
//     firstCheck = vendor.checkAttempt;
//     locid = vendor.locid.toString();
//
//     try {
//       if (vendor.checkAttempt == "First") {
//       // if (vendor.checkAttempt == "First") {
//         Random random = Random();
//         int randomNumber =
//             random.nextInt(9000) +
//             1000; // Generates a number between 1000 and 9999
//         setState(() {
//           otpStringVal = randomNumber.toString();
//         //  print("otpStringVal"+otpStringVal);
//           otp11.write(randomNumber);
//           isVisible = true; // Show the OTP input fields
//           mobileString =vendor.vendormobile; // Replace with actual mobile number
//         });
//
//         sendOtp(mobileString, otp11.toString());
//
//       } else {
//         // Get current date
//         String myDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         // Store data
//         await prefs.setString('Role', widget.userType);
//         await prefs.setString('rdcsitecode', rdcsitename);
//         await prefs.setString('loc', locid);
//         await prefs.setString('time', myDate);
//         await prefs.setString('rdcrole', 'Vendor');
//
//         SharedPref sharedPref = await SharedPref.getInstance();
//         await sharedPref.storeUser(profilemname, id);
//
//         // Navigate to the next screen using GetX
//         //Get.offAll(VendorHomePage(uid: int.tryParse(id)));
//         Get.offAll(() => VendorHomePage(uid: int.tryParse(id),role:"VENDOR"));
//
//       }
//     } catch (e) {
//       if (!mounted) return;
//       //print("Error saving data: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save data. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       //print("finalllyyyy");
//       // Dismiss loading dialog if applicable
//       if (mounted && Navigator.canPop(context)) {
//       //  Navigator.of(context).pop(); // Close the loading dialog
//       }
//     }
//   }
//
//
//
//   Widget otpInputWidget({required BuildContext context, required VoidCallback onVerify, required bool isVisible}) {
//
//       return Column(
//         children: [
//           if(isVisible)...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildOtpTextField(controller: otp1Controller,focusNode: _otpFocusNode1,nextFocusNode: _otpFocusNode2,),
//                 _buildOtpTextField(controller: otp2Controller,focusNode: _otpFocusNode2,nextFocusNode: _otpFocusNode3,),
//                 _buildOtpTextField(controller: otp3Controller,focusNode: _otpFocusNode3,nextFocusNode: _otpFocusNode4,),
//                 _buildOtpTextField(controller: otp4Controller,focusNode: _otpFocusNode4,
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             CustomElevatedButton(
//               onPressed: () {
//                 String enteredOtp = otp1Controller.text +
//                     otp2Controller.text +
//                     otp3Controller.text +
//                     otp4Controller.text;
//
//                 if (enteredOtp == otpStringVal) {
//                   // Get.offAll(VendorHomePage(uid: int.tryParse(id)));
//                   Get.offAll(ChangePassword(uid:id));
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Incorrect OTP"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               text: "Verify OTP",
//               backgroundColor: Colors.green,
//               width: MediaQuery.of(context).size.width * 0.5,
//             ),
//           ]
//
//         ],
//       );
//
//
//   }
//
//
//   Widget _buildOtpTextField({required TextEditingController controller,  required FocusNode focusNode,
//     FocusNode? nextFocusNode,}) {
//     return SizedBox(
//       width: 50,
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           counterText: '',
//         ),
//         maxLength: 1,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 20),
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             // Move to next focus node if available
//             if (nextFocusNode != null) {
//               FocusScope.of(context).requestFocus(nextFocusNode);
//             } else {
//               FocusScope.of(context).unfocus(); // remove focus after last digit
//             }
//           }
//         },
//       ),
//     );
//   }
//   Widget customTextField({
//     required TextEditingController controller,
//     required String label,
//     String? hint,
//     IconData? icon,
//     List<TextInputFormatter>? inputFormatters,
//     bool isPassword = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword ? _obscurePassword : false,
//       decoration: InputDecoration(
//         label: Text(label),
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.grey[100],
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 18,
//           horizontal: 20,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.green, width: 1.5),
//         ),
//         prefixIcon: icon != null
//             ? Icon(icon, color: Colors.grey[600], size: 22)
//             : null,
//         suffixIcon: isPassword
//             ? IconButton(
//           icon: Icon(
//             _obscurePassword ? Icons.visibility_off : Icons.visibility,
//             color: Colors.grey[600],
//           ),
//           onPressed: () {
//             setState(() {
//               _obscurePassword = !_obscurePassword; // toggle password
//             });
//           },
//         )
//             : null,
//       ),
//       style: TextStyle(fontSize: 16, color: Colors.black),
//       inputFormatters: inputFormatters,
//     );
//   }
//   // Widget customTextField({
//   //   required TextEditingController controller,
//   //   required String label,
//   //   String? hint, // Optional hint text
//   //   IconData? icon, // Optional icon
//   //   List<TextInputFormatter>? inputFormatters, // Allow custom formatters
//   // }) {
//   //   return TextField(
//   //     controller: controller,
//   //     decoration: InputDecoration(
//   //       label: Text(label),
//   //       hintText: hint,
//   //       filled: true,
//   //       fillColor: Colors.grey[100],
//   //       contentPadding: const EdgeInsets.symmetric(
//   //         vertical: 18,
//   //         horizontal: 20,
//   //       ),
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide.none,
//   //       ),
//   //       enabledBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//   //       ),
//   //       focusedBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.green, width: 1.5),
//   //       ),
//   //       prefixIcon:
//   //           icon != null
//   //               ? Icon(icon, color: Colors.grey[600], size: 22)
//   //               : null, // Show icon only if provided
//   //     ),
//   //     style: TextStyle(fontSize: 16, color: Colors.black),
//   //     inputFormatters: inputFormatters, // Apply custom formatters if any
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     EdgeInsetsGeometry padding =
//         screenWidth > 600
//             ? EdgeInsets.symmetric(horizontal: 100)
//             : EdgeInsets.symmetric(horizontal: 20);
//
//     return Scaffold(
//       //   iconTheme: IconThemeData(color: Colors.white),
//       // ),
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(0, 0, 0, 0.5),
//           image: DecorationImage(
//             image: AssetImage("assets/bg_image/RDC.png"),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Color.fromRGBO(0, 0, 0, 0.3),
//               BlendMode.dstATop,
//             ),
//           ),
//         ),
//         child: Padding(
//           padding: padding,
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Move the Icon widget out of the Card
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(255, 255, 255, 0.9),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         // color: primaryColor.withOpacity(0.3),
//                         color: Color.fromRGBO(
//                           primaryColor.g.toInt(),
//                           primaryColor.g.toInt(),
//                           primaryColor.g.toInt(),
//                           0.3,
//                         ),
//                         spreadRadius: 1.5,
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                   child: Icon(Icons.group, size: 48, color: primaryColor),
//                 ),
//                 SizedBox(height: 20), // Space between the icon and the card
//                 // Now the Card widget
//                 Card(
//                   elevation: 8, // Add shadow to the card
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15), // Rounded corners
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(
//                       20,
//                     ), // Padding inside the card
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Vendor Login",
//                             style: GoogleFonts.poppins(
//                               fontSize: 28,
//                               fontWeight: FontWeight.w600,
//                               color: primaryColor,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               bottom: 20.0,
//                             ), // Add bottom padding here
//                             child: Text(
//                               "Sign in to continue",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                           // Show Vendor No. field only if vendor is not validated
//                           if (!isVendorValidated && !isVisible) ...[
//                             customTextField(
//                               controller: numberController,
//                               label: "Vendor No.",
//                               hint: "Enter your vendor number",
//                             ),
//                             SizedBox(height: 20),
//                             isLoading
//                                 ? CircularProgressIndicator()
//                                 : CustomElevatedButton(
//                                   onPressed: _validateVendor,
//                                   text: 'Next',
//                                   backgroundColor: primaryColor,
//                                   width: screenWidth * 0.8,
//                                 ),
//                           ],
//                           // Show Mobile Number and Password fields after validation
//                           if (isVendorValidated && !isVisible) ...[
//                             customTextField(
//                               controller: mobileController,
//                               label: "Mobile Number",
//                               hint: "Enter your mobile number",
//                               icon: Icons.phone,
//                             ),
//                             SizedBox(height: 20),
//                             customTextField(
//                               controller: passwordController,
//                               label: "Password",
//                               hint: "Enter your password",
//                               icon: Icons.lock_outline,
//                               isPassword: true, // important
//                             ),
//                             SizedBox(height: 20),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     onPressed: _loginVendorvalidation,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 12,
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "Login",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 50),
//                           ],
//                           // OTP input widget if visible
//                           if (isVisible)...[
//
//                             otpInputWidget(
//                               context: context,
//                               onVerify: () {
//                                 // Compare entered OTP with generated one
//                                 String enteredOtp = otp11.toString(); // (Or gather from the 4 boxes if needed)
//                                 if (enteredOtp == otpStringVal) {
//                                   // Redirect to VendorHomePage or whatever is next
//                                   Get.offAll(ChangePassword(uid:id));
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text("Incorrect OTP"),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                 }
//                                 // Handle OTP verification logic here
//                               },
//                               isVisible: isVisible,
//                             ),
//                           ]
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final List<TextInputFormatter>? inputFormatters; // Allow custom formatters
//
//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.inputFormatters,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.green.shade300, width: 2),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.green.shade600, width: 2),
//         ),
//       ),
//       style: TextStyle(fontSize: 16, color: Colors.black),
//     );
//   }
// }
//
// class CustomElevatedButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final Color backgroundColor;
//   final double width;
//
//   const CustomElevatedButton({
//     super.key,
//     required this.onPressed,
//     required this.text,
//     required this.backgroundColor,
//     required this.width,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           padding: EdgeInsets.symmetric(vertical: 12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
//             SizedBox(width: 8),
//             Icon(Icons.arrow_forward, color: Colors.white, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
//import 'package:intl/intl.dart';
import 'package:rdc_concrete/screens/vendor_home_page.dart';
import 'package:rdc_concrete/services/vendor_api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../component/sharedpref.dart';
import '../models/driverdt_otp_pojo.dart';
import '../models/vendordt.dart';
import '../services/otp_api_service.dart';
import 'change_password.dart';
import '../utils/session_manager.dart'; // Added import for SessionManager

class ValidateVendor extends StatefulWidget {
  final String userType;
  const ValidateVendor({super.key, required this.userType});

  @override
  State<ValidateVendor> createState() => _ValidateVendorState();
}

class _ValidateVendorState extends State<ValidateVendor> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  final FocusNode _otpFocusNode1 = FocusNode();
  final FocusNode _otpFocusNode2 = FocusNode();
  final FocusNode _otpFocusNode3 = FocusNode();
  final FocusNode _otpFocusNode4 = FocusNode();

  final TextEditingController numberController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  late String vsapid;
  String otpStringVal = '';
  String mobileString = '';
  bool optValue = false;
  bool isVisible = false;
  bool isLoading = false;
  bool isVendorValidated = false;
  late String id, rdcsitename, profilemname, firstCheck, locid;
  StringBuffer otp11 = StringBuffer();

  @override
  void dispose() {
    _otpFocusNode1.dispose();
    _otpFocusNode2.dispose();
    _otpFocusNode3.dispose();
    _otpFocusNode4.dispose();
    numberController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    super.dispose();
  }

  void _validateVendor() async {
    if (numberController.text.trim().isNotEmpty) {
      if (numberController.text.length <= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter Vendor Number"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await Future.delayed(Duration(seconds: 1)); // Simulate API Call

      setState(() {
        isVendorValidated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Vendor Number"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _loginVendorvalidation() async {
    vsapid = numberController.text.trim();
    String mobile = mobileController.text.trim();
    String password = passwordController.text.trim();

    if (mobile.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Mobile No. and Password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Mobile Number"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Correct Password !"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    loginvendor(mobile, password);
  }

  Future<DriverDT?> sendOtp(String userMobile, String otp) async {
    String message = "OTP for weighbridge software login $otp -RDC Concrete";
    String username = "RDCCON";
    String password = "123456";
    String type = "TEXT";
    String sender = "RDCIND";
    String entityId='1101642440000016282';
    String tempId='1107165650191390941';
    OtpApiService otpApiService = OtpApiService();
    try {
      DriverDT response = await otpApiService.thisorder(
        username: username,
        password: password,
        type: type,
        sender: sender,
        entityId:entityId,
        tempId:tempId,
        mobile: userMobile,
        message: message,
      );
      if (response.status == 1) {
        // Optionally show success message
      } else {
        // Optionally handle failure
      }
    } catch (e) {
      // Optionally handle error
    }
    return null;
  }

  Future<void> loginvendor(String mobile, String password) async {
    VendorService vendorService = VendorService();
    Vendordt? vendor = await vendorService.loginVendor(
      mobile,
      vsapid,
      password,
    );

    if (vendor == null || vendor.status == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Invalid Credentials, Invalid Mobile Number or password",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Set variables
    id = vendor.vendorid.toString();
    rdcsitename = vendor.vendorlocation;
    profilemname = vendor.vendoremail ;
    firstCheck = vendor.checkAttempt;
    locid = vendor.locid.toString();

    try {
      if (vendor.checkAttempt == "First") {
        Random random = Random();
        int randomNumber = random.nextInt(9000) + 1000;
        setState(() {
          otpStringVal = randomNumber.toString();
          otp11.write(randomNumber.toString());
          isVisible = true;
          mobileString = vendor.vendormobile;
        });
        sendOtp(mobileString, otp11.toString());
      } else {
        // Use SessionManager to save session
        await SessionManager.saveSession(
          role: "VENDOR",
          sitename: rdcsitename,
          uname: profilemname,
          locationid: int.parse(locid),
          uprofileid: int.parse(id),
        );

        // Navigate to VendorHomePage with all required parameters
        Get.offAll(() => VendorHomePage(
          uid: int.parse(id),
          sitename: rdcsitename,
          uname: profilemname,
          locationid: int.parse(locid),
          uprofileid: int.parse(id),
          role: "VENDOR",
        ));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget otpInputWidget({
    required BuildContext context,
    required VoidCallback onVerify,
    required bool isVisible,
  }) {
    return Column(
      children: [
        if (isVisible) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOtpTextField(
                controller: otp1Controller,
                focusNode: _otpFocusNode1,
                nextFocusNode: _otpFocusNode2,
              ),
              _buildOtpTextField(
                controller: otp2Controller,
                focusNode: _otpFocusNode2,
                nextFocusNode: _otpFocusNode3,
              ),
              _buildOtpTextField(
                controller: otp3Controller,
                focusNode: _otpFocusNode3,
                nextFocusNode: _otpFocusNode4,
              ),
              _buildOtpTextField(
                controller: otp4Controller,
                focusNode: _otpFocusNode4,
              ),
            ],
          ),
          SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: () {
              String enteredOtp = otp1Controller.text +
                  otp2Controller.text +
                  otp3Controller.text +
                  otp4Controller.text;

              if (enteredOtp == otpStringVal) {
                // Pass necessary parameters to ChangePassword
                Get.offAll(() => ChangePassword(
                  uid: id,
                  // sitename: rdcsitename,
                  // uname: profilemname,
                  // locationid: locid,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Incorrect OTP"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            text: "Verify OTP",
            backgroundColor: Colors.green,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        ]
      ],
    );
  }

  Widget _buildOtpTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
  }) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: '',
        ),
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          }
        },
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    List<TextInputFormatter>? inputFormatters,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green, width: 1.5),
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.grey[600], size: 22)
            : null,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null,
      ),
      style: TextStyle(fontSize: 16, color: Colors.black),
      inputFormatters: inputFormatters,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry padding = screenWidth > 600
        ? EdgeInsets.symmetric(horizontal: 100)
        : EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          image: DecorationImage(
            image: AssetImage("assets/bg_image/RDC.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromRGBO(0, 0, 0, 0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: padding,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(
                          primaryColor.g.toInt(),
                          primaryColor.g.toInt(),
                          primaryColor.g.toInt(),
                          0.3,
                        ),
                        spreadRadius: 1.5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(Icons.group, size: 48, color: primaryColor),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Vendor Login",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Sign in to continue",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ),
                          if (!isVendorValidated && !isVisible) ...[
                            customTextField(
                              controller: numberController,
                              label: "Vendor No.",
                              hint: "Enter your vendor number",
                            ),
                            SizedBox(height: 20),
                            isLoading
                                ? CircularProgressIndicator()
                                : CustomElevatedButton(
                              onPressed: _validateVendor,
                              text: 'Next',
                              backgroundColor: primaryColor,
                              width: screenWidth * 0.8,
                            ),
                          ],
                          if (isVendorValidated && !isVisible) ...[
                            customTextField(
                              controller: mobileController,
                              label: "Mobile Number",
                              hint: "Enter your mobile number",
                              icon: Icons.phone,
                            ),
                            SizedBox(height: 20),
                            customTextField(
                              controller: passwordController,
                              label: "Password",
                              hint: "Enter your password",
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _loginVendorvalidation,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                          ],
                          if (isVisible) ...[
                            otpInputWidget(
                              context: context,
                              onVerify: () {}, // Empty since handled in button's onPressed
                              isVisible: isVisible,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
      ),
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final double width;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}