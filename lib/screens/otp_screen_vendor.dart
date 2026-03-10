// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:rdc_concrete/screens/vendor_home_page.dart';


class OtpScreenVendor extends StatefulWidget {
  final String userType;
  const OtpScreenVendor({super.key, required this.userType});

  @override
  State<OtpScreenVendor> createState() => _OtpScreenVendor();
}
class _OtpScreenVendor extends State<OtpScreenVendor> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  String otpStringVal = '1234'; // Example OTP, replace with actual OTP
  late String id;

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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          otpInputWidget(
                            context: context,
                            onVerify: () {
                              String enteredOtp = otp1Controller.text +
                                  otp2Controller.text +
                                  otp3Controller.text +
                                  otp4Controller.text;

                              if (enteredOtp == otpStringVal) {
                                Get.offAll(VendorHomePage(uid: int.tryParse(id)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Incorrect OTP"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            isVisible: true, // Set to true to show OTP fields
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
    );
  }
  Widget otpInputWidget({required BuildContext context, required VoidCallback onVerify, required bool isVisible}) {

    return Column(

      children: [
        if(isVisible)...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOtpTextField(controller: otp1Controller),
              _buildOtpTextField(controller: otp2Controller),
              _buildOtpTextField(controller: otp3Controller),
              _buildOtpTextField(controller: otp4Controller),
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
                Get.offAll(VendorHomePage(uid: int.tryParse(id)));
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

}

Widget _buildOtpTextField({required TextEditingController controller}) {
  return SizedBox(
    width: 50,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        counterText: '',
      ),
      maxLength: 1,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),
  );
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