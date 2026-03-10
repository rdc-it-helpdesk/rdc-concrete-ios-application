// // import 'package:flutter/material.dart';
// // import 'package:rdc_concrete/screens/home_page.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../models/moisture_pojo.dart';
// // import '../services/api_service.dart';
// // import 'mo_home_page.dart';
// //
// // class MoLogin extends StatelessWidget {
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final ApiService _apiService = ApiService(); // Create instance
// //
// //
// //   MoLogin({super.key});
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
// //         title: const Text("MO Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
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
// //         child: SafeArea(
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.all(20.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 const SizedBox(height: 120),
// //
// //                 const SizedBox(height: 8),
// //                 CustomTextField(
// //                   controller: _emailController,
// //                   label: "Enter Email Address",
// //                   isPassword: false,
// //                 ),
// //                 const SizedBox(height: 24),
// //
// //                 const SizedBox(height: 8),
// //                 CustomTextField(
// //                   controller: _passwordController,
// //                   label: "Enter Password",
// //                   isPassword: true,
// //                 ),
// //                 const SizedBox(height: 24),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: () async {
// //                           String uname = _emailController.text.trim();
// //                           String upass = _passwordController.text.trim();
// //
// //
// //                           if (uname.isEmpty || upass.isEmpty) {
// //                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                               content: Text("Please enter both email and password"),
// //                             ));
// //                             return;
// //                           }
// //
// //                           MoisturePojo? user = await _apiService.login(uname, upass);
// //
// //                           if (user != null) {
// //                             SharedPreferences prefs = await SharedPreferences.getInstance();
// //                             await prefs.setString("Role", user.role ?? "");
// //                             await prefs.setString("rdcrole", user.role ?? "");
// //
// //                             print("Login Successful! Role: ${user.role}");
// //                             if (!context.mounted) return;
// //
// //
// //                             WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter engine is ready
// //
// //                             SharedPreferences prefs1 = await SharedPreferences.getInstance();
// //                             String s1 = prefs1.getString("Role") ?? "";
// //                             String s11 = prefs1.getString("rdcrole") ?? "";
// //
// //                             print("Stored Role: $s1");
// //                             print("Stored RDC Role: $s11");
// //
// //                             if (s1.isEmpty) {
// //                               // You can show a message here if needed
// //                             } else if (s1 == "MATERIALOFFICER" && s11 == "MATERIALOFFICER") {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(builder: (context) => MOHomePage(role: user.role, sitename:  user.sitename, uname: user.name, locationid:user.locationid ,uprofileid:user.userid)),
// //                               );
// //                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MOHomePage())); temporary commnet
// //                               print("Login Successful! Role: ${user.role}");
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 SnackBar(
// //                                   content: Text(
// //                                     "Welcome ${user.name}",
// //                                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //                                   ),
// //                                   backgroundColor: Colors.green, // ✅ Green background
// //                                   behavior: SnackBarBehavior.floating, // ✅ Floating style
// //                                 ),
// //
// //
// //                               );
// //                             }  else {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 SnackBar(
// //                                   content: Text("Wrong username or password"),
// //                                   backgroundColor: Colors.red,
// //                                 ),
// //                               );
// //                             }
// //
// //
// //
// //                             // Navigator.push(
// //                             //   context,
// //                             //   MaterialPageRoute(builder: (context) => HomePage()),
// //                             // );
// //                           }
// //                           else {
// //                             if (!context.mounted) return;
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               SnackBar(
// //                                 content: Text(
// //                                   "Login failed! Please check credentials.",
// //                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //                                 ),
// //                                 backgroundColor: Colors.red,
// //                                 behavior: SnackBarBehavior.floating,
// //                               ),
// //                             );
// //                           }
// //
// //
// //
// //
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.green,
// //                           padding: EdgeInsets.symmetric(vertical: 12),
// //                         ),
// //                         child: Text(
// //                           "Login",
// //                           style: TextStyle(fontSize: 18, color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(width: 10),
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           Navigator.pop(context); // Moves back to the previous screen
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.red.shade400,
// //                           padding: EdgeInsets.symmetric(vertical: 12),
// //                         ),
// //                         child: Text(
// //                           "Cancel",
// //                           style: TextStyle(fontSize: 18, color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //
// //                   ],
// //                 ),
// //               ],
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
// //       keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
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
// //
// import 'package:flutter/material.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/moisture_pojo.dart';
// import '../services/api_service.dart';
// import 'mo_home_page.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class MoLogin extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final ApiService _apiService = ApiService(); // Create instance
//
//   MoLogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: primaryColor,
//       //   centerTitle: true,
//       //   title: const Text("MO Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
//       //   iconTheme: IconThemeData(color: Colors.white),
//       // ),
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         height: double.infinity,
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
//             padding: EdgeInsets.symmetric(
//               horizontal: screenWidth > 600 ? 100 : 20,
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       // color: Colors.white.withOpacity(0.9),
//                       color: Color.fromRGBO(255, 255, 255, 0.9),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           // color: primaryColor.withOpacity(0.3),
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
//                     child: Icon(Icons.list_alt, size: 48, color: primaryColor),
//                   ),
//                   SizedBox(height: 20),
//                   Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "MO Login",
//                             style: GoogleFonts.poppins(
//                               fontSize: 28,
//                               fontWeight: FontWeight.w600,
//                               color: primaryColor,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             "Sign in to continue",
//                             style: GoogleFonts.poppins(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                               height: 1.5,
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           CustomTextField(
//                             controller: _emailController,
//                             label: "Enter Email Address",
//                             isPassword: false,
//                           ),
//                           SizedBox(height: 24),
//                           CustomTextField(
//                             controller: _passwordController,
//                             label: "Enter Password",
//                             isPassword: true,
//                           ),
//                           SizedBox(height: 24),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () async {
//                                     String uname = _emailController.text.trim();
//                                     String upass =
//                                         _passwordController.text.trim();
//
//                                     if (uname.isEmpty || upass.isEmpty) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                             "Please enter both email and password",
//                                           ),
//                                         ),
//                                       );
//                                       return;
//                                     }
//
//                                     MoisturePojo? user = await _apiService
//                                         .login(uname, upass);
//
//                                     if (user != null) {
//                                       SharedPreferences prefs =
//                                           await SharedPreferences.getInstance();
//                                       await prefs.setString("Role", user.role);
//                                       await prefs.setString(
//                                         "rdcrole",
//                                         user.role,
//                                       );
//
//                                       //print("Login Successful! Role: ${user.role}");
//                                       if (!context.mounted) return;
//
//                                       WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter engine is ready
//
//                                       SharedPreferences prefs1 =
//                                           await SharedPreferences.getInstance();
//                                       String s1 =
//                                           prefs1.getString("Role") ?? "";
//                                       String s11 =
//                                           prefs1.getString("rdcrole") ?? "";
//
//                                       //print("Stored Role: $s1");
//                                       //print("Stored RDC Role: $s11");
//
//                                       if (s1.isEmpty) {
//                                         // You can show a message here if needed
//                                       } else if (s1 == "MATERIALOFFICER" &&
//                                           s11 == "MATERIALOFFICER") {
//                                         if (context.mounted) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                     (context) => MOHomePage(
//                                                     role: user.role,
//                                                     sitename: user.sitename,
//                                                     uname: user.name,
//                                                     locationid: user.locationid,
//                                                     uprofileid: user.userid,
//                                                   ),
//                                             ),
//                                           );
//                                         }
//
//                                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MOHomePage())); temporary commnet
//                                         //print("Login Successful! Role: ${user.role}");
//                                         if (context.mounted) {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: Text(
//                                                 "Welcome ${user.name}",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                               backgroundColor:
//                                                   Colors
//                                                       .green, // ✅ Green background
//                                               behavior:
//                                                   SnackBarBehavior
//                                                       .floating, // ✅ Floating style
//                                             ),
//                                           );
//                                         }
//                                       } else {
//                                         if (context.mounted) {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: Text(
//                                                 "Wrong username or password",
//                                               ),
//                                               backgroundColor: Colors.red,
//                                             ),
//                                           );
//                                         }
//                                       }
//
//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(builder: (context) => HomePage()),
//                                       // );
//                                     } else {
//                                       if (!context.mounted) return;
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                             "Login failed! Please check credentials.",
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           backgroundColor: Colors.red,
//                                           behavior: SnackBarBehavior.floating,
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                     padding: EdgeInsets.symmetric(vertical: 12),
//                                   ),
//                                   child: Text(
//                                     "Login",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // SizedBox(width: 10),
//                               // Expanded(
//                               //   child: ElevatedButton(
//                               //     onPressed: () {
//                               //       Navigator.pop(context); // Moves back to the previous screen
//                               //     },
//                               //     style: ElevatedButton.styleFrom(
//                               //       backgroundColor: Colors.red.shade400,
//                               //       padding: EdgeInsets.symmetric(vertical: 12),
//                               //     ),
//                               //     child: Text(
//                               //       "Cancel",
//                               //       style: TextStyle(fontSize: 18, color: Colors.white),
//                               //     ),
//                               //   ),
//                               // ),
//                             ],
//                           ),
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
//       keyboardType:
//           isPassword ? TextInputType.text : TextInputType.emailAddress,
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/moisture_pojo.dart';
import '../services/api_service.dart';
import '../utils/session_manager.dart';
import 'mo_home_page.dart';

class MoLogin extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService(); // Create instance

  MoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 100 : 20,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Icon(Icons.list_alt, size: 48, color: primaryColor),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "MO Login",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Sign in to continue",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _emailController,
                            label: "Enter Email Address",
                            isPassword: false,
                          ),
                          SizedBox(height: 24),
                          CustomTextField(
                            controller: _passwordController,
                            label: "Enter Password",
                            isPassword: true,
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    String uname = _emailController.text.trim();
                                    String upass = _passwordController.text.trim();

                                    if (uname.isEmpty || upass.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please enter both email and password",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    MoisturePojo? user = await _apiService.login(uname, upass);

                                    if (user != null) {
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      await prefs.setString("Role", user.role);
                                      await prefs.setString("rdcrole", user.role);

                                      if (!context.mounted) return;

                                      SharedPreferences prefs1 =
                                      await SharedPreferences.getInstance();
                                      String s1 = prefs1.getString("Role") ?? "";
                                      String s11 = prefs1.getString("rdcrole") ?? "";

                                      if (s1 == "MATERIALOFFICER" && s11 == "MATERIALOFFICER") {
                                        await SessionManager.saveSession(
                                          role: user.role,
                                          sitename: user.sitename ,
                                          uname: user.name ,
                                          locationid: user.locationid ,
                                          uprofileid: user.userid ,
                                        );
                                        if (context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MOHomePage(
                                                role: user.role,
                                                sitename: user.sitename,
                                                uname: user.name,
                                                locationid: user.locationid,
                                                uprofileid: user.userid,
                                              ),
                                            ),
                                          );
                                        }

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Welcome ${user.name}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Wrong username or password"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Login failed! Please check credentials.",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Updated CustomTextField with show/hide password
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isPassword) _obscureText = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: widget.label,
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
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
