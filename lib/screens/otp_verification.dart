import 'package:flutter/material.dart';

import '../utils/session_manager.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  // FocusNodes for each OTP text field
  final FocusNode _otpFocusNode1 = FocusNode();
  final FocusNode _otpFocusNode2 = FocusNode();
  final FocusNode _otpFocusNode3 = FocusNode();
  final FocusNode _otpFocusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    //SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
    // Request focus to open the keyboard when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_otpFocusNode1);
    });
  }

  @override
  void dispose() {
    // Dispose the FocusNodes to avoid memory leaks
    _otpFocusNode1.dispose();
    _otpFocusNode2.dispose();
    _otpFocusNode3.dispose();
    _otpFocusNode4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset(
                        'assets/mainrdc.png', // Your image path
                        width: 200,
                        height: 100,
                      ),
                    ),
                  ),
                  SizedBox(height: 120), // Spacer
                  // TextView - OTP Heading
                  Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: Text(
                      'OTP has been Sent',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // OTP input fields
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // OTP input box 1 with FocusNode
                        _buildOtpTextField(_otpFocusNode1, _otpFocusNode2),
                        // OTP input box 2
                        _buildOtpTextField(_otpFocusNode2, _otpFocusNode3),
                        // OTP input box 3
                        _buildOtpTextField(_otpFocusNode3, _otpFocusNode4),
                        // OTP input box 4
                        _buildOtpTextField(_otpFocusNode4, null),
                      ],
                    ),
                  ),

                  // Verify Button
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: ElevatedButton(
                        onPressed: () {
                          // Add the verify logic here
                          // print('Verify OTP');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 80,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
    );
  }

  // Function to build each OTP TextField
  Widget _buildOtpTextField(
    FocusNode currentFocusNode,
    FocusNode? nextFocusNode,
  ) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        focusNode: currentFocusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
