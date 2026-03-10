// import 'dart:async';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:rdc_concrete/screens/admin_login.dart';
// import 'package:rdc_concrete/screens/driver_login.dart';
// import 'package:rdc_concrete/screens/mo_login.dart';
// import 'package:rdc_concrete/screens/qa_tester_login.dart';
// import 'package:rdc_concrete/screens/validate_vendor.dart';
//
// import '../models/version_check_pojo.dart';
// import '../services/version_check_api_service.dart';
// import 'download_apk.dart';
//
// class SelectProfile extends StatefulWidget {
//   const SelectProfile({super.key});
//
//   @override
//   State<SelectProfile> createState() => _SelectProfile();
// }
//
// class _SelectProfile extends State<SelectProfile> {
//   String userTypevendor = "Vendor";
//   String userTypeMO = "MATERIALOFFICER";
//   String userTypeDriver = "Driver";
//   String userTypeQalityTester = "QA TESTER";
//   String userTypeQalityADMIN = "ADMIN";
//   String currentversion = "9.1";
//   String myupdate = "";
//   bool updateAvailable = false;
//   String? pathoflick;
//
//   @override
//   void initState() {
//     super.initState();
//     // Timer.periodic(Duration(seconds: 2), (Timer timer) {
//     //   checkUpdateVersion();
//     //   print('Timer executed every 2 seconds');
//     //   // You can stop the timer after a certain condition
//     //
//     // });
//   }
//
//   Future<void> checkUpdateVersion() async {
//     // final prefs = await SharedPreferences.getInstance();
//     // String? userId = prefs.getString('loggedInUser Id');
//     // Adjust according to your SharedPreferences key
//     //String? userId =widget.u
//     //String deviceId = 'YOUR_DEVICE_ID'; // You can use a package to get the device ID
//     //String currentVersion = 'YOUR_CURRENT_VERSION'; // Get your current app version
//
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     String deviceId;
//
//     if (Theme.of(context).platform == TargetPlatform.android) {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       deviceId = androidInfo.id; // Use 'id' instead of 'androidId'
//     } else {
//       deviceId = 'Unsupported platform';
//     }
//     //print("deviceIdddddd${deviceId}");
//     VersionCheckService versionCheckService = VersionCheckService();
//     try {
//       CheckVersion? response = await versionCheckService.getVersionCheck(
//         "1",
//         deviceId,
//         currentversion,
//       );
//       if (response != null) {
//         if (currentversion == response.currentV) {
//           //print("hiiieieiieie");
//           //loading dis
//         } else {
//           if (!mounted) return;
//           //print("haaaaa");
//           // myUpdate = response.vFile;
//           // updateAvailable = true;
//           // pathOfLink = response.vFile;
//           //
//           // // Show error dialog or update dialog
//           // showErrorDialog(response.currentV, response.updateAt);
//           myupdate = response.vFile;
//           updateAvailable = true;
//           pathoflick = response.vFile;
//           //  Showerrordialog(response.body().getCurrent_v(), response.body().getUpdate_at());
//           showErrorDialog(context, response.currentV, response.updateAt);
//           //loading dis
//         }
//       }
//     } catch (e) {
//       // Handle error
//       //print('Error checking version: $e');
//     }
//   }
//
//   void showErrorDialog(BuildContext context, String version, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.transparent,
//           // Make the background transparent
//           content: Container(
//             decoration: BoxDecoration(
//               color: Colors.white, // Set the background color of the dialog
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Icon
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   //  child: Image.asset('assets/ic_error.png'), // Replace with your error icon
//                 ),
//                 // Title
//                 Text(
//                   "New Version Available $version. Please Update",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 // Message
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Text(message, textAlign: TextAlign.center),
//                 ),
//                 SizedBox(height: 20),
//                 // Update Button
//                 ElevatedButton(
//                   onPressed: () async {
//                     //print("objectttttttttt");
//                     String url =
//                         "http://4.227.130.126/rdc01/rdcappdownload.php"; // Your APK URL
//                     String fileName = "App Update"; // Desired file name
//
//                     // Create an instance of DownloadApk
//                     DownloadApk downloadApk = DownloadApk(context, (message) {
//                       ScaffoldMessenger.of(
//                         context,
//                       ).showSnackBar(SnackBar(content: Text(message)));
//                     });
//
//                     // Start downloading the APK
//                     await downloadApk.startDownloadingApk(url, fileName);
//                     if (context.mounted) {
//                       Navigator.of(context).pop();
//                     }
//                     // Close the dialog after starting the download
//                   },
//                   child: Text("UPDATE"),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Example download function
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text(
//           'Select Your Profile',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
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
//
//         // decoration: BoxDecoration(
//         //   image: DecorationImage(
//         //       image: const AssetImage('assets/bg_image/RDC.png'),
//         //       fit: BoxFit.cover),
//         // ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: ListView(
//             children: [
//               // const SizedBox(height: 30),
//               // const Text(
//               //   'Select Your Profile',
//               //   style: TextStyle(
//               //     fontSize: 24,
//               //     fontWeight: FontWeight.bold,
//               //     color: Colors.black,
//               //   ),
//               //   textAlign: TextAlign.center,
//               // ),
//               const SizedBox(height: 30),
//               GridView.count(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 20,
//                 crossAxisSpacing: 20,
//                 children: [
//                   _buildProfileCard(
//                     context,
//                     'Vendor',
//                     _buildAvatarWithBorder(Icons.groups),
//                     Colors.white,
//                     () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) =>
//                                   ValidateVendor(userType: userTypevendor),
//                         ),
//                       );
//                       //print('Vendor card clicked.');
//                     },
//                   ),
//                   _buildProfileCard(
//                     context,
//                     'QA Tester',
//                     _buildAvatarWithBorder(Icons.edit_note_sharp),
//                     Colors.white,
//                     () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => QaTesterLogin(),
//                         ),
//                       );
//                       //print('QA Tester card clicked.');
//                     },
//                   ),
//
//                   // _buildProfileCard(
//                   //   context,
//                   //   'Driver',
//                   //   _buildAvatarWithBorder(Icons.drive_eta),
//                   //   Colors.white,
//                   //   () {
//                   //     Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(builder: (context) => DriverLogin()),
//                   //     );
//                   //     //print('Driver card clicked.');
//                   //   },
//                   // ),
//                   _buildProfileCard(
//                     context,
//                     'MO',
//                     _buildAvatarWithBorder(Icons.list_alt),
//                     Colors.white,
//                     () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => MoLogin()),
//                       );
//                       //print('MO card clicked.');
//                     },
//                   ),
//                   _buildProfileCard(
//                     context,
//                     'Admin',
//                     _buildAvatarWithBorder(Icons.admin_panel_settings),
//                     Colors.white,
//                     () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => AdminLogin()),
//                         // MaterialPageRoute(builder: (context) => AdminLogin()),
//                       );
//                       //print('Driver card clicked.');
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // SizedBox(
//               //   // height: MediaQuery.of(context).size.height * 0.2,
//               //   height: 170,
//               //   width: MediaQuery.of(context).size.width * 0.8,
//               //   child: _buildProfileCard(
//               //     context,
//               //     'Admin',
//               //     _buildAvatarWithBorder(Icons.admin_panel_settings),
//               //     Colors.white,
//               //     () {
//               //       Navigator.push(
//               //         context,
//               //         MaterialPageRoute(builder: (context) => AdminLogin()),
//               //       );
//               //       //print('Admin card clicked.');
//               //     },
//               //     isWide: true,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Function to create CircleAvatar with border
//   Widget _buildAvatarWithBorder(IconData icon) {
//     return Container(
//       padding: EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: Colors.grey, // White border color
//           width: 2, // Border width
//         ),
//       ),
//       child: CircleAvatar(
//         // backgroundColor: Colors.green,
//         backgroundColor: Color(0xFF0EB154),
//         radius: 30,
//         child: Icon(icon, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildProfileCard(
//     BuildContext context,
//     String title,
//     Widget icon, // Accepts a Widget for icon
//     Color color,
//     VoidCallback onTap, {
//     bool isWide = false,
//   }) {
//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             // gradient: LinearGradient(
//             //   begin: Alignment.topLeft,
//             //   end: Alignment.bottomRight,
//             //   colors: [
//             //     color.withOpacity(0.8),
//             //     color,
//             //   ],
//             // ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               icon, // Using the passed CircleAvatar widget
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0EB154),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// Updated select_profile.dart
// Add a check in initState to see if there's a valid session.
// If yes, navigate directly to HomePage with saved data.

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:rdc_concrete/screens/admin_login.dart';
//import 'package:rdc_concrete/screens/driver_login.dart';
import 'package:rdc_concrete/screens/mo_login.dart';
import 'package:rdc_concrete/screens/qa_home_screen.dart';
import 'package:rdc_concrete/screens/qa_tester_login.dart';
import 'package:rdc_concrete/screens/validate_vendor.dart';
import 'package:rdc_concrete/screens/vendor_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/version_check_pojo.dart';
import '../services/version_check_api_service.dart';
import 'download_apk.dart';
import '../utils/session_manager.dart'; // Ensure this is imported
import 'home_page.dart';
import 'mo_home_page.dart'; // Import HomePage

class SelectProfile extends StatefulWidget {
  const SelectProfile({super.key});

  @override
  State<SelectProfile> createState() => _SelectProfile();
}

class _SelectProfile extends State<SelectProfile> {
  String userTypevendor = "Vendor";
  String userTypeMO = "MATERIALOFFICER";
  String userTypeDriver = "Driver";
  String userTypeQalityTester = "QA TESTER";
  String userTypeQalityADMIN = "ADMIN";
  String currentversion = "9.1";
  String myupdate = "";
  bool updateAvailable = false;
  String? pathoflick;

  @override
  void initState() {
    super.initState();
    //_checkSessionAndNavigate(); // Check session on init
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkForceUpdate();          // 🔒 STEP 1: Force update
      await _checkSessionAndNavigate();   // ▶️ STEP 2: Normal flow
    });


    // Timer.periodic(Duration(seconds: 2), (Timer timer) {
    //   checkUpdateVersion();
    //   print('Timer executed every 2 seconds');
    //   // You can stop the timer after a certain condition
    //
    // });
  }

  Future<void> _checkForceUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable &&
          updateInfo.immediateUpdateAllowed) {

        // 🚨 FORCE UPDATE (User cannot skip)
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      debugPrint("Force update check failed: $e");
    }
  }

  Future<void> _checkSessionAndNavigate() async {
    // --------------------------------------------------------------
    // 1. CAPTURE context BEFORE any async work
    // --------------------------------------------------------------
    final BuildContext ctx = context;

    // Early exit if widget is already disposed
    if (!mounted) return;

    // --------------------------------------------------------------
    // 2. Check session validity
    // --------------------------------------------------------------
    final bool hasSession = await SessionManager.hasValidSession();
    if (!hasSession) return;

    // --------------------------------------------------------------
    // 3. Load SharedPreferences
    // --------------------------------------------------------------
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read all values
    final String? role = prefs.getString("role");
    final String? sitename = prefs.getString("sitename");
    final String? uname = prefs.getString("uname");
    final int? locationid = prefs.getInt("locationid");
    final int? uprofileid = prefs.getInt("uprofileid");

    // --------------------------------------------------------------
    // 4. Validate required fields
    // --------------------------------------------------------------
    if (role == null ||
        sitename == null ||
        uname == null ||
        locationid == null ||
        uprofileid == null) {
      return;
    }

    // --------------------------------------------------------------
    // 5. Still mounted after all awaits?
    // --------------------------------------------------------------
    if (!ctx.mounted) return;

    // --------------------------------------------------------------
    // 6. Role-based navigation
    // --------------------------------------------------------------
    if (role == "VENDOR") {
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
          builder: (_) => VendorHomePage(
            uid: uprofileid,
            sitename: sitename,
            uname: uname,
            locationid: locationid,
            uprofileid: uprofileid,
            role: role,
          ),
        ),
      );
    } else if (role == "MATERIALOFFICER") {
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
          builder: (_) => MOHomePage(
            role: role,
            sitename: sitename,
            uname: uname,
            locationid: locationid,
            uprofileid: uprofileid,
          ),
        ),
      );
    } else if (role == "QA TESTER") {
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
          builder: (_) => QaHomeScreen(
            uid: uprofileid,
            role: role,
            uname: uname,
            sitename: sitename,
            locationid: locationid,
            umobile: "", // umobile not in session; set empty or fetch later
          ),
        ),
      );
    } else {
      // Default: ADMIN or others
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
          builder: (_) => HomePage(
            role: role,
            sitename: sitename,
            uname: uname,
            locationid: locationid,
            uprofileid: uprofileid,
          ),
        ),
      );
    }
  }
  // Future<void> _checkSessionAndNavigate() async {
  //   bool hasSession = await SessionManager.hasValidSession();
  //   if (hasSession) {
  //     final prefs = await SharedPreferences.getInstance();
  //     String? role = prefs.getString("role");
  //     String? sitename = prefs.getString("sitename");
  //     String? uname = prefs.getString("uname");
  //     int? locationid = prefs.getInt("locationid");
  //     int? uprofileid = prefs.getInt("uprofileid");
  //     //String? umobile = prefs.getString("umobile");
  //
  //     if (role != null &&
  //         sitename != null &&
  //         uname != null &&
  //         locationid != null &&
  //         uprofileid != null) {
  //       if (role == "VENDOR") {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => VendorHomePage(
  //               uid: uprofileid,
  //               sitename: sitename,
  //               uname: uname,
  //               locationid: locationid,
  //               uprofileid: uprofileid,
  //               role: role,
  //             ),
  //           ),
  //         );
  //       } else if (role == "MATERIALOFFICER") {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => MOHomePage(
  //               role: role,
  //               sitename: sitename,
  //               uname: uname,
  //               locationid: locationid,
  //               uprofileid: uprofileid,
  //             ),
  //           ),
  //         );
  //       } else if (role == "QA TESTER") {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => QaHomeScreen(
  //               uid: uprofileid,
  //               role: role,
  //               uname: uname,
  //               sitename: sitename,
  //               locationid: locationid,
  //               umobile: "", // umobile not stored in session; fetch if needed or use empty
  //             ),
  //           ),
  //         );
  //       } else {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => HomePage(
  //               role: role,
  //               sitename: sitename,
  //               uname: uname,
  //               locationid: locationid,
  //               uprofileid: uprofileid,
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }


  Future<void> checkUpdateVersion() async {
    // final prefs = await SharedPreferences.getInstance();
    // String? userId = prefs.getString('loggedInUser Id');
    // Adjust according to your SharedPreferences key
    //String? userId =widget.u
    //String deviceId = 'YOUR_DEVICE_ID'; // You can use a package to get the device ID
    //String currentVersion = 'YOUR_CURRENT_VERSION'; // Get your current app version

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId;

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Use 'id' instead of 'androidId'
    } else {
      deviceId = 'Unsupported platform';
    }
    //print("deviceIdddddd${deviceId}");
    VersionCheckService versionCheckService = VersionCheckService();
    try {
      CheckVersion? response = await versionCheckService.getVersionCheck(
        "1",
        deviceId,
        currentversion,
      );
      if (response != null) {
        if (currentversion == response.currentV) {
          //print("hiiieieiieie");
          //loading dis
        } else {
          if (!mounted) return;
          //print("haaaaa");
          // myUpdate = response.vFile;
          // updateAvailable = true;
          // pathOfLink = response.vFile;
          //
          // // Show error dialog or update dialog
          // showErrorDialog(response.currentV, response.updateAt);
          myupdate = response.vFile;
          updateAvailable = true;
          pathoflick = response.vFile;
          //  Showerrordialog(response.body().getCurrent_v(), response.body().getUpdate_at());
          showErrorDialog(context, response.currentV, response.updateAt);
          //loading dis
        }
      }
    } catch (e) {
      // Handle error
      //print('Error checking version: $e');
    }
  }

  void showErrorDialog(BuildContext context, String version, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          // Make the background transparent
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color of the dialog
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  //  child: Image.asset('assets/ic_error.png'), // Replace with your error icon
                ),
                // Title
                Text(
                  "New Version Available $version. Please Update",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(message, textAlign: TextAlign.center),
                ),
                SizedBox(height: 20),
                // Update Button
                ElevatedButton(
                  onPressed: () async {
                    //print("objectttttttttt");
                    String url =
                        "http://4.227.130.126/rdc01/rdcappdownload.php"; // Your APK URL
                    String fileName = "App Update"; // Desired file name

                    // Create an instance of DownloadApk
                    DownloadApk downloadApk = DownloadApk(context, (message) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    });

                    // Start downloading the APK
                    await downloadApk.startDownloadingApk(url, fileName);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    // Close the dialog after starting the download
                  },
                  child: Text("UPDATE"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Select Your Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
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

        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: const AssetImage('assets/bg_image/RDC.png'),
        //       fit: BoxFit.cover),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // const SizedBox(height: 30),
              // const Text(
              //   'Select Your Profile',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 30),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildProfileCard(
                    context,
                    'Vendor',
                    _buildAvatarWithBorder(Icons.groups),
                    Colors.white,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                              ValidateVendor(userType: userTypevendor),
                        ),
                      );
                      //print('Vendor card clicked.');
                    },
                  ),
                  _buildProfileCard(
                    context,
                    'QA Tester',
                    _buildAvatarWithBorder(Icons.edit_note_sharp),
                    Colors.white,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QaTesterLogin(),
                        ),
                      );
                      //print('QA Tester card clicked.');
                    },
                  ),

                  // _buildProfileCard(
                  //   context,
                  //   'Driver',
                  //   _buildAvatarWithBorder(Icons.drive_eta),
                  //   Colors.white,
                  //   () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => DriverLogin()),
                  //     );
                  //     //print('Driver card clicked.');
                  //   },
                  // ),
                  _buildProfileCard(
                    context,
                    'MO',
                    _buildAvatarWithBorder(Icons.list_alt),
                    Colors.white,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MoLogin()),
                      );
                      //print('MO card clicked.');
                    },
                  ),
                  _buildProfileCard(
                    context,
                    'Admin',
                    _buildAvatarWithBorder(Icons.admin_panel_settings),
                    Colors.white,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminLogin()),
                        // MaterialPageRoute(builder: (context) => AdminLogin()),
                      );
                      //print('Driver card clicked.');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // SizedBox(
              //   // height: MediaQuery.of(context).size.height * 0.2,
              //   height: 170,
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   child: _buildProfileCard(
              //     context,
              //     'Admin',
              //     _buildAvatarWithBorder(Icons.admin_panel_settings),
              //     Colors.white,
              //     () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => AdminLogin()),
              //       );
              //       //print('Admin card clicked.');
              //     },
              //     isWide: true,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarWithBorder(IconData icon) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey, // White border color
          width: 2, // Border width
        ),
      ),
      child: CircleAvatar(
        // backgroundColor: Colors.green,
        backgroundColor: Color(0xFF0EB154),
        radius: 30,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context,
      String title,
      Widget icon, // Accepts a Widget for icon
      Color color,
      VoidCallback onTap) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     color.withOpacity(0.8),
            //     color,
            //   ],
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon, // Using the passed CircleAvatar widget
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0EB154),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }