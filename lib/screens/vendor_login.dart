import 'package:flutter/material.dart';

import 'package:rdc_concrete/screens/vendor_home_page.dart';

class VendorLogin extends StatefulWidget {
  const VendorLogin({super.key});

  @override
  State<VendorLogin> createState() => _VendorLoginState();
}
class _VendorLoginState extends State<VendorLogin> {
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Vendor Login',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/bg_image/RDC.png",
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.3),
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Mobile Number", style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _mobileNoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter Mobile Number",
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password", style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter Password",
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VendorHomePage()),
                      );
                      _mobileNoController.clear();
                      _passwordController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                      backgroundColor: primaryColor,
                      minimumSize: Size(screenWidth * 0.8, 50),
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _VendorLoginState extends State<VendorLogin> {
//   final TextEditingController _mobileNoController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     double screenWidth = MediaQuery.of(context).size.width;
//     //double screenHeight = MediaQuery.of(context).size.height;
//
//     // EdgeInsetsGeometry padding = screenWidth > 600
//     //     ? EdgeInsets.symmetric(horizontal: 100)
//     //     : EdgeInsets.symmetric(horizontal: 20);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         title: Text(
//           'Vendor Login',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         // title: const Text("Vendor Login", style: TextStyle(fontFamily: 'Smooch', fontSize: 29, fontWeight: FontWeight.w900),),
//       ),
//
//       resizeToAvoidBottomInset:
//           false, // Prevent layout resize when keyboard opens
//
//       body: Container(
//         height:
//             double.infinity, // Use double.infinity to avoid stretching issues
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
//
//         child: SafeArea(
//           // SafeArea ensures no overlap with screen edges
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 120),
//                 Row(
//                   children: [
//                     const Text(
//                       "Mobile Number",
//                       style: TextStyle(fontSize: 16),
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: _mobileNoController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.grey.shade200,
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green),
//                     ),
//                     hintText: "Enter Mobile Number",
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//                 Row(
//                   children: [
//                     const Text(
//                       "Password",
//                       style: TextStyle(fontSize: 16),
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   obscureText: true,
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.grey.shade200,
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green),
//                     ),
//                     hintText: "Enter Password",
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () async {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => VendorHomePage()),
//                     );
//                     _mobileNoController.clear();
//                     _passwordController.clear();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     // backgroundColor: Colors.green,
//                     backgroundColor: primaryColor,
//                     minimumSize: Size(screenWidth * 0.8, 50),
//                   ),
//                   child: Text('Login', style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
