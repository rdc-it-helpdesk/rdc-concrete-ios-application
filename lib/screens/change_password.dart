import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:rdc_concrete/main.dart';
import 'package:rdc_concrete/models/add_user_pojo.dart';
import 'package:rdc_concrete/screens/select_profile.dart';

import '../services/change_pass_api_service.dart';
import '../utils/session_manager.dart';

class ChangePassword extends StatefulWidget {
  final String uid;
  const ChangePassword({super.key, required this.uid});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isObscured = true;
  @override
  void initState() {
    super.initState();
  //  SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
//print("uiii${widget.uid}");
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Confirm Password is required'),
          backgroundColor: Colors.red,
        ),
      );
      return 'Confirm Password is required';
    } else if (value != _newPassController.text) {
      // Show snackbar when passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return 'Passwords do not match'; // Return error message for validation
    }
    return null;
  }
  Future<void> update() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Start loading
      });

      ChangePassApiService changePassApiService = ChangePassApiService();
      String id = widget.uid;
      String newpass = _newPassController.text;
      SetStatus? updatePass = await changePassApiService.updatepass(id, newpass);

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (updatePass.status == "1") {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password updated"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SelectProfile()),
        );
      } else {
        if (!mounted) return;
        // Handle error case
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final primaryColor = Theme.of(context).primaryColor;
   // final secondaryColor = Colors.teal.shade700;

    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text("Change Password", style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
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

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    // Main login container
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
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
                            mainAxisSize: MainAxisSize.min, // Prevent unnecessary stretching
                            children: [
                              SizedBox(height: 10,),
                              // New Password Input Field
                              _buildInputField(
                                label: "New Password",
                                controller: _newPassController,
                                hint: "New Password",
                                icon: Icons.password,
                                validator: _validatePassword,
                                isPassword: true,
                                errorText: '',
                              ),
                              // Confirm Password Input Field
                              _buildInputField(
                                label: "Confirm Password",
                                controller: _confirmPassController,
                                hint: "Confirm Password",
                                icon: Icons.check_circle,
                                isPassword: true,
                                validator: _validateConfirmPassword,
                                errorText: '',
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Update Button
                                  SizedBox(
                                    width: 100,
                                    height: 45,
                                    child: ElevatedButton(
    onPressed: _isLoading ? null : update,
                                      // onPressed: (){

                                     // },
                                      // onPressed: _isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                          : Text(
                                        'Update',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  // Cancel Button
                                  SizedBox(
                                    width: 100,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      // onPressed: _isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                          : Text(
                                        'Cancel',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2,
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
                    ),
                  ],
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
    required String? errorText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _isObscured : false,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            label: Text(label),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[500],
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.grey[600],
              size: 22,
            ),
            suffixIcon: isPassword
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
          validator: validator, // Add this line to use the validator
        ),
        if (errorText != null) // Show error message if exists
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: Text(
                    errorText,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
      ],
    );
  }
  // Widget _buildInputField({
  //   required TextEditingController controller,
  //   required String label,
  //   required String hint,
  //   required IconData icon,
  //   required bool isPassword,
  //   String? Function(String?)? validator,
  //   required String? errorText,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       TextField(
  //         controller: controller,
  //         obscureText: isPassword ? _isObscured : false,
  //         style: GoogleFonts.poppins(
  //           fontSize: 15,
  //           color: Colors.black87,
  //         ),
  //         decoration: InputDecoration(
  //           label: Text(label),
  //           hintText: hint,
  //           hintStyle: GoogleFonts.poppins(
  //             fontSize: 15,
  //             color: Colors.grey[500],
  //           ),
  //           filled: true,
  //           fillColor: Colors.grey[100],
  //           contentPadding:
  //           const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide.none,
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide(color: Colors.green, width: 1.5),
  //           ),
  //           errorBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: const BorderSide(color: Colors.red, width: 1),
  //           ),
  //           prefixIcon: Icon(
  //             icon,
  //             color: Colors.grey[600],
  //             size: 22,
  //           ),
  //           suffixIcon: isPassword
  //               ? IconButton(
  //             icon: Icon(
  //               _isObscured ? Icons.visibility_off : Icons.visibility,
  //               color: Colors.grey[600],
  //               size: 22,
  //             ),
  //             onPressed: () => setState(() => _isObscured = !_isObscured),
  //           )
  //               : null,
  //         ),
  //
  //         /// /// /// /// /// ///
  //         validator: validator,
  //       ),
  //       if (errorText != null) // Show error message if exists
  //         Padding(
  //           padding: const EdgeInsets.only(top: 5, left: 10),
  //           child: Text(
  //             errorText,
  //             style: TextStyle(color: Colors.red, fontSize: 14),
  //           ),
  //         ),
  //     ],
  //   );
  // }
}
