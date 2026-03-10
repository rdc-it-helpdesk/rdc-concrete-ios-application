// // import 'package:flutter/material.dart';
// // import 'package:rdc_concrete/screens/accept_driver.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../models/moisture_pojo.dart';
// // import '../services/api_service.dart';
// // import 'current_location.dart';
// //
// // class DriverLogin extends StatelessWidget {
// //   final TextEditingController _mobileNoController = TextEditingController();
// //   final ApiService _apiService = ApiService(); // Create instance
// //
// //   DriverLogin({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final primaryColor = Theme.of(context).primaryColor;
// //     double screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: primaryColor,
// //         centerTitle: true,
// //         title: Text('Driver Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
// //         iconTheme: IconThemeData(color: Colors.white),
// //       ),
// //       resizeToAvoidBottomInset: false,
// //       body: Container(
// //         height: double.infinity,
// //         decoration: BoxDecoration(
// //           color: Colors.black.withOpacity(0.5),
// //           image: DecorationImage(
// //             image: AssetImage("assets/bg_image/RDC.png"),
// //             fit: BoxFit.cover,
// //             colorFilter: ColorFilter.mode(
// //               Colors.black.withOpacity(0.3),
// //               BlendMode.dstATop,
// //             ),
// //           ),
// //         ),
// //         child: Center(
// //           child: Padding(
// //             padding: const EdgeInsets.only(bottom: 20.0),
// //             child: SafeArea(
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.all(20.0),
// //                 child: Center(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //
// //                       const SizedBox(height: 8),
// //                       CustomTextField(
// //                         controller: _mobileNoController,
// //                         label: "Enter Mobile Number",
// //                         isPassword: false,
// //                       ),
// //                       const SizedBox(height: 24),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Expanded(
// //                             child: ElevatedButton(
// //                               onPressed: () async {
// //                                 String uname = _mobileNoController.text.trim();
// //
// //
// //                                 if (uname.isEmpty) {
// //                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                                     content: Text("Please enter both mobile number"),
// //                                   ));
// //                                   return;
// //                                 }
// //
// //                                 // 🔹 Call API Login
// //                                 // MoisturePojo? user = await _apiService.login(uname);
// //                                 //
// //                                 // if (user != null) {
// //                                 //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //                                 //   await prefs.setString("Role", user.role ?? "");
// //                                 //   await prefs.setString("rdcrole", user.role ?? "");
// //                                 //
// //                                 //   print("Login Successful! Role: ${user.role}");
// //                                 //   if (!context.mounted) return;
// //                                 //
// //                                 //
// //                                 //   WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter engine is ready
// //                                 //
// //                                 //   SharedPreferences prefs1 = await SharedPreferences.getInstance();
// //                                 //   String s1 = prefs1.getString("Role") ?? "";
// //                                 //   String s11 = prefs1.getString("rdcrole") ?? "";
// //                                 //
// //                                 //   print("Stored Role: $s1");
// //                                 //   print("Stored RDC Role: $s11");
// //                                 //
// //                                 //   if (s1.isEmpty) {
// //                                 //     // You can show a message here if needed
// //                                 //   } else if (s1 == "MATERIALOFFICER" && s11 == "MATERIALOFFICER") {
// //                                 //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CurrentLocation()));
// //                                 //     print("Login Successful! Role: ${user.role}");
// //                                 //     ScaffoldMessenger.of(context).showSnackBar(
// //                                 //       SnackBar(
// //                                 //         content: Text(
// //                                 //           "Welcome ${user.name}",
// //                                 //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //                                 //         ),
// //                                 //         backgroundColor: Colors.green, // ✅ Green background
// //                                 //         behavior: SnackBarBehavior.floating, // ✅ Floating style
// //                                 //       ),
// //                                 //     );
// //                                 //   }  else {
// //                                 //     ScaffoldMessenger.of(context).showSnackBar(
// //                                 //       SnackBar(
// //                                 //         content: Text("Wrong username or password"),
// //                                 //         backgroundColor: Colors.red,
// //                                 //       ),
// //                                 //     );
// //                                 //   }
// //                                 //
// //                                 //
// //                                 //
// //                                 //   // Navigator.push(
// //                                 //   //   context,
// //                                 //   //   MaterialPageRoute(builder: (context) => HomePage()),
// //                                 //   // );
// //                                 // }
// //                                 // else {
// //                                 //   if (!context.mounted) return;
// //                                 //   ScaffoldMessenger.of(context).showSnackBar(
// //                                 //     SnackBar(
// //                                 //       content: Text(
// //                                 //         "Login failed! Please check credentials.",
// //                                 //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //                                 //       ),
// //                                 //       backgroundColor: Colors.red,
// //                                 //       behavior: SnackBarBehavior.floating,
// //                                 //     ),
// //                                 //   );
// //                                 // }
// //                                 //
// //                               },
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Colors.green,
// //                                 padding: EdgeInsets.symmetric(vertical: 12),
// //                               ),
// //                               child: Text(
// //                                 "Login",
// //                                 style: TextStyle(fontSize: 18, color: Colors.white),
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 10),
// //                           Expanded(
// //                             child: ElevatedButton(
// //                               onPressed: () {
// //                                 Navigator.pop(context); // Moves back to the previous screen
// //                               },
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Colors.red.shade400,
// //                                 padding: EdgeInsets.symmetric(vertical: 12),
// //                               ),
// //                               child: Text(
// //                                 "Cancel",
// //                                 style: TextStyle(fontSize: 18, color: Colors.white),
// //                               ),
// //                             ),
// //                           ),
// //
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class CustomTextField extends StatelessWidget {
// //   final TextEditingController controller;
// //   final String label;
// //   final bool isPassword;
// //
// //   const CustomTextField({super.key, required this.controller, required this.label, required this.isPassword});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return TextField(
// //       controller: controller,
// //       obscureText: isPassword,
// //       keyboardType: isPassword ? TextInputType.text : TextInputType.phone,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         filled: true,
// //         fillColor: Colors.white,
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //           borderSide: BorderSide(color: Colors.green.shade300, width: 2),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //           borderSide: BorderSide(color: Colors.green.shade600, width: 2),
// //         ),
// //       ),
// //       style: TextStyle(fontSize: 16, color: Colors.black),
// //     );
// //   }
// // }
//
// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// import 'package:rdc_concrete/models/driverdt_otp_pojo.dart';
//
// import 'package:google_fonts/google_fonts.dart';
//
// // import 'package:rdc_concrete/screens/vendor_home_page.dart';
// // import 'package:sms_retriever/sms_retriever.dart';
//
// import '../core/network/api_client.dart';
// import '../services/order_info_api_service.dart';
// import '../services/otp_api_service.dart';
// import 'driver_home_page.dart';
// // import 'change_password.dart';
//
// class DriverLogin extends StatefulWidget {
//   // final TextEditingController _mobileNoController = TextEditingController();
//   //final ApiService _apiService = ApiService(); // Create instance
//   @override
//   State<DriverLogin> createState() => _DriverLogin();
//
//   const DriverLogin({super.key});
// }
//
// class _DriverLogin extends State<DriverLogin> {
//   late String? id, profileName,sitename;
//
//   final TextEditingController _mobileNoController = TextEditingController();
//   TextEditingController otp1Controller = TextEditingController();
//   TextEditingController otp2Controller = TextEditingController();
//   TextEditingController otp3Controller = TextEditingController();
//   TextEditingController otp4Controller = TextEditingController();
//   List<Map<String, dynamic>> orderDetails = [];
//   String otpStringVal = '';
//   String mobileString = '';
//   StringBuffer otp11 = StringBuffer();
//   bool isVisible = false;
//   List<Active> activeMoList = []; // Store active transactions
//   List<Cancel> canceledMOList = []; // Store active transactions
//   List<Complete> completeMOList = []; // Store active transactions
//   void _validatedriver() async {
//     String mobile = _mobileNoController.text;
//     if (mobile.length != 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please enter Mobile Number"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//     loginUser(mobile);
//   }
//   // Future<void> loginUser (String mobile) async {
//   //   OrderInfoApiService orderInfoApiService = OrderInfoApiService();
//   //
//   //   // Call the API to log in the driver
//   //   DriverDT? driverDT = await orderInfoApiService.logindriver(mobile);
//   //
//   //   // Log the entire DriverDT object for debugging
//   //   print("DriverDT: ${driverDT}"); // Log the entire object
//   //
//   //   // Check if driverDT is not null
//   //   if (driverDT != null) {
//   //     // Ensure that driverid and drivername are being set correctly
//   //     id = driverDT.driverid; // Ensure this is the correct type (int)
//   //     profileName = driverDT.drivername;
//   //
//   //     // Log the values to verify they are set correctly
//   //     print("Driver ID: ${id}");
//   //     print("Profile Name: ${profileName}");
//   //
//   //     // Generate a random OTP
//   //     Random random = Random();
//   //     int randomNumber = random.nextInt(9000) + 1000; // Generates a number between 1000 and 9999
//   //
//   //     // Update the state with the OTP and mobile number
//   //     setState(() {
//   //       otpStringVal = randomNumber.toString();
//   //       otp11.write(randomNumber);
//   //       isVisible = true; // Show the OTP line
//   //       mobileString = mobile; // Store the mobile number
//   //     });
//   //
//   //     // Send the OTP to the mobile number
//   //     sendOtp(mobileString, otp11.toString());
//   //   } else {
//   //     // Handle the case where driverDT is null
//   //     print("driverDT is null");
//   //     if (!mounted) return; // Check if the widget is still mounted
//   //
//   //     // Show a Snackbar to inform the user
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text("Login failed! Please try again."),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //   }
//   // }
//   Future<void> loginUser(String mobile) async {
//     final dio = ApiClient.getDio();
//     final service = OrderInfoApiService(dio);
//    // OrderInfoApiService orderInfoApiService = OrderInfoApiService();
//     DriverDT? driverDT = await service.logindriver(mobile);
//     // String? id=driverDT?.driverid.toString();
//   //  print("idddddriver${driverDT}");
//     if (driverDT?.status != 0) {
//
//       //  print("hoooooooooooo");
//       id = driverDT?.driverid.toString();
//       // role = driverDT?.role.toString();
//       activeMoList=driverDT!.active!.toList();
//       completeMOList=driverDT.complete!.toList();
//       canceledMOList=driverDT.cancel!.toList();
//
//
//       //print("idddddriver${id}");
//
//       profileName = driverDT.drivername.toString();
//
//       //print("profileName${profileName}");
//
//       Random random = Random();
//       int randomNumber =
//           random.nextInt(9000) +
//           1000; // Generates a number between 1000 and 9999
//       setState(() {
//         otpStringVal = randomNumber.toString();
//         otp11.write(randomNumber);
//         isVisible = true; // Show the OTP line
//         mobileString = mobile; // Replace with actual mobile number
//       });
//
//       sendOtp(mobileString, otp11.toString());
//     } else {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Try again !, Connection Timeout!"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   // void startSmartUserConsent() async {
//   //   try {
//   //     // Start listening for SMS
//   //     String? smsConsent = (SmsRetriever.startListening) as String?;
//   //
//   //     if (smsConsent != null) {
//   //       // print("SMS consent started successfully: $smsConsent");
//   //     }
//   //   } catch (e) {
//   //     //print("Error starting SMS consent: $e");
//   //   }
//   // }
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
//       DriverDT? response = await otpApiService.thisorder(
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
//       //print("Response received: ${response}");
//
//       // Continue with your logic...
//     } catch (e) {
//       //print("Error occurred while sending OTP: $e");
//     }
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
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     double screenWidth = MediaQuery.of(context).size.width;
//     EdgeInsetsGeometry padding =
//         screenWidth > 600
//             ? EdgeInsets.symmetric(horizontal: 100)
//             : EdgeInsets.symmetric(horizontal: 20);
//
//     return Scaffold(
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
//         child: SafeArea(
//           child: Padding(
//             padding: padding,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(255, 255, 255, 0.9),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromRGBO(
//                             primaryColor.g.toInt(),
//                             primaryColor.g.toInt(),
//                             primaryColor.g.toInt(),
//                             0.3,
//                           ),
//                           spreadRadius: 1.5,
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.drive_eta, // Change icon as needed
//                       size: 48,
//                       color: primaryColor,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(
//                         20,
//                       ), // Padding inside the card
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (!isVisible) ...[
//                             Text(
//                               "Driver Login",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w600,
//                                 color: primaryColor,
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "Sign in to continue",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             CustomTextField(
//                               controller: _mobileNoController,
//                               label: "Enter Mobile Number",
//                               isPassword: false,
//                             ),
//                             SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     onPressed: () async {
//                                       _validatedriver();
//                                     },
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
//                           ],
//                           if (isVisible) ...[
//                             otpInputWidget(
//                               context: context,
//                               onVerify: () {
//                                 // Compare entered OTP with generated one
//                                 String enteredOtp =
//                                     otp11
//                                         .toString(); // (Or gather from the 4 boxes if needed)
//                                 if (enteredOtp == otpStringVal) {
//                                   // Redirect to VendorHomePage or whatever is next
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => DriverHomePage(id,profileName),
//                                     ),
//                                   );
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
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget otpInputWidget({
//     required BuildContext context,
//     required VoidCallback onVerify,
//     required bool isVisible,
//   }) {
//     return Column(
//       children: [
//         if (isVisible) ...[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildOtpTextField(controller: otp1Controller),
//               _buildOtpTextField(controller: otp2Controller),
//               _buildOtpTextField(controller: otp3Controller),
//               _buildOtpTextField(controller: otp4Controller),
//             ],
//           ),
//           SizedBox(height: 20),
//           CustomElevatedButton(
//             onPressed: () {
//               String enteredOtp =
//                   otp1Controller.text +
//                   otp2Controller.text +
//                   otp3Controller.text +
//                   otp4Controller.text;
//
//               if (enteredOtp == otpStringVal) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DriverHomePage(id,profileName),
//                   ),
//                 );
//                 //Get.offAll(VendorHomePage(uid: int.tryParse(id)));
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("Incorrect OTP"),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             text: "Verify OTP",
//             backgroundColor: Colors.green,
//             width: MediaQuery.of(context).size.width * 0.5,
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildOtpTextField({required TextEditingController controller}) {
//     return SizedBox(
//       width: 50,
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           counterText: '',
//         ),
//         maxLength: 1,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 20),
//       ),
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
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final bool isPassword;
//
//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.isPassword,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
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
