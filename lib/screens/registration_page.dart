// import 'package:flutter/material.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:rdc_concrete/screens/vendor_login.dart';
//
// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({super.key});
//
//   @override
//   State<RegistrationPage> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegistrationPage> {
//   String _selectedGender = ""; // State for gender selection
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/bg_image/RDC.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 40),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Here’s \nyour first\nstep with \nus!",
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: Image.asset("assets/mainrdc.png", width: 150),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Card(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           _buildTextField("Name"),
//                           _buildTextField("Email"),
//                           _buildTextField(
//                             "Mobile No.",
//                             keyboardType: TextInputType.phone,
//                           ),
//                           _buildGenderSelection(),
//                           _buildTextField("Password", obscureText: true),
//                           _buildTextField(
//                             "Confirm Password",
//                             obscureText: true,
//                           ),
//                           const SizedBox(height: 20),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 12,
//                                 horizontal: 70,
//                               ),
//                             ),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => SelectProfile(),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               "Register",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => VendorLogin(),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               "Already have an account?",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Center(
//                     child: Text(
//                       "Use another Method",
//                       style: TextStyle(color: Colors.black, fontSize: 14),
//                     ),
//                   ),
//                   // const SizedBox(height: 20),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   children: [
//                   //     Image.asset("assets/facebook.png", width: 40),
//                   //     const SizedBox(width: 20),
//                   //     Image.asset("assets/google.png", width: 40),
//                   //   ],
//                   // ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//     String hint, {
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.grey.shade200,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGenderSelection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           _buildGenderRadio("Male"),
//           _buildGenderRadio("Female"),
//           _buildGenderRadio("Other"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGenderRadio(String label) {
//     return Row(
//       children: [
//         Radio(
//           value: label,
//           groupValue: _selectedGender,
//           onChanged: (value) {
//             setState(() {
//               _selectedGender = value.toString();
//             });
//           },
//         ),
//         Text(label, style: const TextStyle(color: Colors.black)),
//       ],
//     );
//   }
// }
