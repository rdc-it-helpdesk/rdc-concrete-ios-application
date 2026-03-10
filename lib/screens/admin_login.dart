// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rdc_concrete/services/api_service.dart';
// import 'package:rdc_concrete/models/moisture_pojo.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../utils/session_manager.dart';
// import 'home_page.dart';
//
// class AdminLogin extends StatefulWidget {
//   const AdminLogin({super.key});
//
//   @override
//   State<AdminLogin> createState() => _AdminLoginState();
// }
//
// class _AdminLoginState extends State<AdminLogin>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final ApiService apiService = ApiService();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   bool _isLoading = false;
//   bool _isObscured = true;
//
//   late final AnimationController _animationController = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 800),
//   );
//
//   late final Animation<double> _fadeAnimation = Tween<double>(
//     begin: 0.0,
//     end: 1.0,
//   ).animate(
//     CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController.forward();
//     // SessionManager.checkAutoLogoutOnce();
//     // SessionManager.scheduleMidnightLogout(context);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _handleLogin() async {
//     String uname = _emailController.text.trim();
//     String upass = _passwordController.text.trim();
//
//     if (uname.isEmpty || upass.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter both username and password")),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     MoisturePojo? response = await apiService.login(uname, upass);
//     if (!mounted) return;
//     setState(() => _isLoading = false);
//
//     if (response != null) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString("Role", response.role);
//       await prefs.setString("rdcrole", response.role);
//       if (!mounted) return;
//       if (response.role == "ADMIN") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) => HomePage(
//                   role: response.role,
//                   sitename: response.sitename,
//                   locationid: response.locationid,
//                   uprofileid: response.userid,
//                   uname: response.name,
//                 ),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Welcome ${response.name}"),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Wrong username or password"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Login failed! Please check credentials."),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(0, 0, 0, 0.5),
//               image: DecorationImage(
//                 image: AssetImage("assets/bg_image/RDC.png"),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Color.fromRGBO(0, 0, 0, 0.3),
//                   BlendMode.dstATop,
//                 ),
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Center(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Color.fromRGBO(255, 255, 255, 0.9),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(
//                                 primaryColor.g.toInt(),
//                                 primaryColor.g.toInt(),
//                                 primaryColor.g.toInt(),
//                                 0.3,
//                               ),
//                               spreadRadius: 1.5,
//                               blurRadius: 10,
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           Icons.admin_panel_settings,
//                           size: 48,
//                           color: primaryColor,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 32,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Color.fromRGBO(255, 255, 255, 0.9),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(
//                                 primaryColor.g.toInt(),
//                                 primaryColor.g.toInt(),
//                                 primaryColor.g.toInt(),
//                                 0.3,
//                               ),
//                               spreadRadius: 1,
//                               blurRadius: 15,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 "Admin Login",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.w600,
//                                   color: primaryColor,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                               Text(
//                                 "Sign in to continue",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   color: Colors.grey[600],
//                                   height: 1.5,
//                                 ),
//                               ),
//                               const SizedBox(height: 32),
//                               _buildInputField(
//                                 label: "Email Address",
//                                 controller: _emailController,
//                                 hint: "Email Address",
//                                 icon: Icons.email_outlined,
//                                 isPassword: false,
//                               ),
//                               const SizedBox(height: 20),
//                               _buildInputField(
//                                 label: "Password",
//                                 controller: _passwordController,
//                                 hint: "Password",
//                                 icon: Icons.lock_outline,
//                                 isPassword: true,
//                               ),
//                               const SizedBox(height: 24),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 54,
//                                 child: ElevatedButton(
//                                   onPressed: _isLoading ? null : _handleLogin,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: primaryColor,
//                                     foregroundColor: Colors.white,
//                                     elevation: 2,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 12,
//                                     ),
//                                   ),
//                                   child:
//                                       _isLoading
//                                           ? const SizedBox(
//                                             width: 24,
//                                             height: 24,
//                                             child: CircularProgressIndicator(
//                                               color: Colors.white,
//                                               strokeWidth: 2.5,
//                                             ),
//                                           )
//                                           : Text(
//                                             'SIGN IN',
//                                             style: GoogleFonts.poppins(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                               letterSpacing: 1.2,
//                                             ),
//                                           ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       // Text(
//                       //   "Need help? Contact support",
//                       //   style: GoogleFonts.poppins(
//                       //     fontSize: 14,
//                       //     color: Colors.black87,
//                       //     fontWeight: FontWeight.w500,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required bool isPassword,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword ? _isObscured : false,
//       style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
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
//         prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
//         suffixIcon:
//             isPassword
//                 ? IconButton(
//                   icon: Icon(
//                     _isObscured ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey[600],
//                     size: 22,
//                   ),
//                   onPressed: () => setState(() => _isObscured = !_isObscured),
//                 )
//                 : null,
//       ),
//     );
//   }
// }
// Updated admin_login.dart
// Add the call to SessionManager.saveSession() after successful login and before navigation.
// I've added it inside the if (response.role == "ADMIN") block.
// Do the same for other login screens (e.g., driver_login.dart, mo_login.dart, etc.) if they exist.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rdc_concrete/services/api_service.dart';
import 'package:rdc_concrete/models/moisture_pojo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/session_manager.dart';
import 'home_page.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isObscured = true;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
  );

  @override
  void initState() {
    super.initState();
    _animationController.forward();
    // SessionManager.checkAutoLogoutOnce();
    // SessionManager.scheduleMidnightLogout(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _handleLogin() async {

    final BuildContext ctx = context;

    final String uname = _emailController.text.trim();
    final String upass = _passwordController.text.trim();

    if (uname.isEmpty || upass.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    // --------------------------------------------------------------
    // 3. Show loading
    // --------------------------------------------------------------
    setState(() => _isLoading = true);

    // --------------------------------------------------------------
    // 4. Call API – first await
    // --------------------------------------------------------------
    final MoisturePojo? response = await apiService.login(uname, upass);

    // ---- widget may have been disposed while waiting for the network ----
    if (!ctx.mounted) return;

    // --------------------------------------------------------------
    // 5. Hide loading
    // --------------------------------------------------------------
    setState(() => _isLoading = false);

    // --------------------------------------------------------------
    // 6. No response → generic error
    // --------------------------------------------------------------
    if (response == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Login failed! Please check credentials.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // --------------------------------------------------------------
    // 7. Save SharedPreferences – second await
    // --------------------------------------------------------------
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Role', response.role);
    await prefs.setString('rdcrole', response.role);

    // ---- check again after the async writes ----
    if (!ctx.mounted) return;

    // --------------------------------------------------------------
    // 8. ADMIN → save session + navigate
    // --------------------------------------------------------------
    if (response.role == 'ADMIN') {
      await SessionManager.saveSession(
        role: response.role,
        sitename: response.sitename,
        uname: response.name,
        locationid: response.locationid,
        uprofileid: response.userid,
      );

      // still mounted?
      if (!ctx.mounted) return;

      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
          builder: (_) => HomePage(
            role: response.role,
            sitename: response.sitename,
            locationid: response.locationid,
            uprofileid: response.userid,
            uname: response.name,
          ),
        ),
      );

      // Welcome snack-bar (shown on the *new* screen)
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Welcome ${response.name}'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    // --------------------------------------------------------------
    // 9. Non-ADMIN → wrong credentials message
    // --------------------------------------------------------------
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Wrong username or password'),
        backgroundColor: Colors.red,
      ),
    );
  }
  // void _handleLogin() async {
  //
  //   String uname = _emailController.text.trim();
  //   String upass = _passwordController.text.trim();
  //
  //   if (uname.isEmpty || upass.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please enter both username and password")),
  //     );
  //     return;
  //   }
  //
  //   setState(() => _isLoading = true);
  //
  //   MoisturePojo? response = await apiService.login(uname, upass);
  //   if (!mounted) return;
  //   setState(() => _isLoading = false);
  //
  //   if (response != null) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString("Role", response.role);
  //     await prefs.setString("rdcrole", response.role);
  //     if (!mounted) return;
  //     if (response.role == "ADMIN") {
  //       // Save session data here
  //       await SessionManager.saveSession(
  //         role: response.role,
  //         sitename: response.sitename,
  //         uname: response.name,
  //         locationid: response.locationid,
  //         uprofileid: response.userid,
  //       );
  //
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder:
  //               (context) => HomePage(
  //             role: response.role,
  //             sitename: response.sitename,
  //             locationid: response.locationid,
  //             uprofileid: response.userid,
  //             uname: response.name,
  //           ),
  //         ),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Welcome ${response.name}"),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Wrong username or password"),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Login failed! Please check credentials."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          Icons.admin_panel_settings,
                          size: 48,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(
                                primaryColor.g.toInt(),
                                primaryColor.g.toInt(),
                                primaryColor.g.toInt(),
                                0.3,
                              ),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Admin Login",
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                "Sign in to continue",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildInputField(
                                label: "Email Address",
                                controller: _emailController,
                                hint: "Email Address",
                                icon: Icons.email_outlined,
                                isPassword: false,
                              ),
                              const SizedBox(height: 20),
                              _buildInputField(
                                label: "Password",
                                controller: _passwordController,
                                hint: "Password",
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child:
                                  _isLoading
                                      ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                      : Text(
                                    'SIGN IN',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Text(
                      //   "Need help? Contact support",
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 14,
                      //     color: Colors.black87,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isObscured : false,
      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
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
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
        suffixIcon:
        isPassword
            ? IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
            size: 22,
          ),
          onPressed: () => setState(() => _isObscured = !_isObscured),
        )
            : null,
      ),
    );
  }
// ... (rest of the code remains the same)
}