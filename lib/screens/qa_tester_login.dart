// import 'package:flutter/material.dart';
// import 'package:rdc_concrete/screens/qa_home_screen.dart';
// import 'package:rdc_concrete/services/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../models/moisture_pojo.dart';
// import '../utils/session_manager.dart';
//
// class QaTesterLogin extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final ApiService _apiService = ApiService();
//
//   QaTesterLogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     double screenWidth = MediaQuery.of(context).size.width;
//     EdgeInsetsGeometry padding =
//     screenWidth > 600
//         ? EdgeInsets.symmetric(horizontal: 100)
//         : EdgeInsets.symmetric(horizontal: 20);
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
//         child: Padding(
//           padding: padding,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(255, 255, 255, 0.9),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
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
//                   child: Icon(
//                     Icons.edit_note_sharp,
//                     size: 48,
//                     color: primaryColor,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Card(
//                   elevation: 8,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(height: 20),
//                         Text(
//                           "QA Tester Login",
//                           style: GoogleFonts.poppins(
//                             fontSize: 28,
//                             fontWeight: FontWeight.w600,
//                             color: primaryColor,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Sign in to continue",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         CustomTextField(
//                           controller: _emailController,
//                           label: "Enter email address",
//                           isPassword: false,
//                         ),
//                         SizedBox(height: 20),
//                         CustomTextField(
//                           controller: _passwordController,
//                           label: "Enter password",
//                           isPassword: true,
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () async {
//                                   String uname = _emailController.text.trim();
//                                   String upass = _passwordController.text.trim();
//
//                                   if (uname.isEmpty || upass.isEmpty) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                           "Please enter both email and password",
//                                         ),
//                                       ),
//                                     );
//                                     return;
//                                   }
//
//                                   MoisturePojo? user = await _apiService.login(
//                                     uname,
//                                     upass,
//                                   );
//
//                                   if (user != null) {
//                                     SharedPreferences prefs =
//                                     await SharedPreferences.getInstance();
//                                     await prefs.setString("Role", user.role);
//                                     await prefs.setString("rdcrole", user.role);
//
//                                     if (!context.mounted) return;
//
//                                     SharedPreferences prefs1 =
//                                     await SharedPreferences.getInstance();
//                                     String s1 = prefs1.getString("Role") ?? "";
//                                     String s11 =
//                                         prefs1.getString("rdcrole") ?? "";
//                                     await SessionManager.saveSession(
//                                       role: user.role ?? "QA TESTER",
//                                       sitename: user.sitename ?? "Unknown Site",
//                                       uname: user.name ?? "Unknown User",
//                                       locationid: user.locationid ?? 0,
//                                       uprofileid: user.userid ?? 0,
//                                       umobile: user.usermobile,
//
//                                     );
//                                     if (context.mounted) {
//                                       if (s1 == "QA TESTER" && s11 == "QA TESTER") {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => QaHomeScreen(
//                                               uid: user.userid,
//                                               role: user.role,
//                                               uname: user.name,
//                                               sitename: user.sitename,
//                                               locationid: user.locationid,
//                                               umobile: user.usermobile,
//                                             ),
//                                           ),
//                                         );
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                           SnackBar(
//                                             content: Text(
//                                               "Welcome ${user.name}",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             backgroundColor: Colors.green,
//                                             behavior: SnackBarBehavior.floating,
//                                           ),
//                                         );
//                                       } else {
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                           SnackBar(
//                                             content: Text("Wrong username or password"),
//                                             backgroundColor: Colors.red,
//                                           ),
//                                         );
//                                       }
//                                     }
//                                   } else {
//                                     if (!context.mounted) return;
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                           "Login failed! Please check credentials.",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         backgroundColor: Colors.red,
//                                         behavior: SnackBarBehavior.floating,
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   padding: EdgeInsets.symmetric(vertical: 12),
//                                 ),
//                                 child: Text(
//                                   "Login",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
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
// // Updated CustomTextField with show/hide eye icon
// class CustomTextField extends StatefulWidget {
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
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _obscureText = true;
//
//   @override
//   void initState() {
//     super.initState();
//     if (!widget.isPassword) _obscureText = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: widget.controller,
//       obscureText: _obscureText,
//       decoration: InputDecoration(
//         labelText: widget.label,
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
//         suffixIcon: widget.isPassword
//             ? IconButton(
//           icon: Icon(
//             _obscureText ? Icons.visibility_off : Icons.visibility,
//             color: Colors.grey[600],
//           ),
//           onPressed: () {
//             setState(() {
//               _obscureText = !_obscureText;
//             });
//           },
//         )
//             : null,
//       ),
//       style: TextStyle(fontSize: 16, color: Colors.black),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:rdc_concrete/screens/qa_home_screen.dart';
import 'package:rdc_concrete/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/moisture_pojo.dart';
import '../utils/session_manager.dart';
//import 'select_profile.dart'; // Assuming this is the initial screen

class QaTesterLogin extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  QaTesterLogin({super.key});

  // Check for existing session on app start
  static Future<bool> checkSession(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("Role");
    String? umobile = prefs.getString("umobile");
    String? uname = prefs.getString("uname");
    String? sitename = prefs.getString("sitename");
    int? locationid = prefs.getInt("locationid");
    int? uprofileid = prefs.getInt("uprofileid");

    if (role == "QA TESTER" && umobile != null && uname != null) {
      // Valid session found, navigate to QaHomeScreen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QaHomeScreen(
              uid: uprofileid,
              role: role,
              uname: uname,
              sitename: sitename,
              locationid: locationid,
              umobile: umobile,
            ),
          ),
        );
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;
    EdgeInsetsGeometry padding =
    screenWidth > 600 ? EdgeInsets.symmetric(horizontal: 100) : EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
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
                  child: Icon(
                    Icons.edit_note_sharp,
                    size: 48,
                    color: primaryColor,
                  ),
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
                        SizedBox(height: 20),
                        Text(
                          "QA Tester Login",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Sign in to continue",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailController,
                          label: "Enter email address",
                          isPassword: false,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          label: "Enter password",
                          isPassword: true,
                        ),
                        SizedBox(height: 20),
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
                                        content: Text("Please enter both email and password"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    MoisturePojo? user = await _apiService.login(uname, upass);
                                    if (user != null && user.role == "QA TESTER") {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setString("Role", user.role);
                                      await prefs.setString("rdcrole", user.role );
                                      await prefs.setString("umobile", user.usermobile);
                                      await prefs.setString("uname", user.name);
                                      await prefs.setString("sitename", user.sitename );
                                      await prefs.setInt("locationid", user.locationid);
                                      await prefs.setInt("uprofileid", user.userid );

                                      await SessionManager.saveSession(
                                        role: user.role,
                                        sitename: user.sitename ,
                                        uname: user.name ,
                                        locationid: user.locationid,
                                        uprofileid: user.userid ,
                                        umobile: user.usermobile,
                                      );

                                      if (context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => QaHomeScreen(
                                              uid: user.userid,
                                              role: user.role,
                                              uname: user.name,
                                              sitename: user.sitename,
                                              locationid: user.locationid,
                                              umobile: user.usermobile,
                                            ),
                                          ),
                                        );
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
                                            content: Text("Invalid credentials or role"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Login failed: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
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
    );
  }
}

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