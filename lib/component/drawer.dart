// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:rdc_concrete/screens/home_page.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:rdc_concrete/screens/user_management.dart';
// import 'package:rdc_concrete/screens/vendor_transactions.dart';
// import 'package:rdc_concrete/screens/wey_bridge.dart';
//
// // Define a class to represent each drawer item
// class DrawerItem {
//   final String title;
//   final IconData icon;
//   final Widget? screen;
//   final VoidCallback? onTap;
//   final Color iconColor;
//
//
//   DrawerItem({required this.title, required this.icon, this.screen, this.onTap,this.iconColor = Colors.green,});
// }
//
// class MyDrawer extends StatelessWidget {
//   final List<DrawerItem> drawerItems;  // Pass a list of drawer items to be shown
//   final String currentVersion= "9.1"; // Add current version parameter
//   final String updateDate= "23 Jan 2025, Thrsaday";
//   final String? username;
//   const MyDrawer({super.key, required this.drawerItems, required this.username,});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Drawer(
//       backgroundColor: Colors.white,
//       child: SingleChildScrollView(
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 250, // Increased height
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/rdclogo.png', fit: BoxFit.cover, height: 120),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Welcome",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                username ?? "Guest",
//                                 // Use username or default to "Guest"
//                                // "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 12,
//                                 ),
//                                 maxLines: 2, // Allow for a maximum of 2 lines
//                                 overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.green, // Set the color to green
//                     thickness: 1, // Optional: Adjust thickness
//
//                   ),
//                 ],
//               ),
//             ),
//
//             ... drawerItems.map((item) {
//               return ListTile(
//                 leading: Icon(item.icon),
//                 iconColor: item.iconColor,
//                 title: Text(item.title),
//                 onTap: () {
//                   Navigator.pop(context); // Close the drawer
//
//                   if (item.onTap != null) {
//                     item.onTap!(); // Execute the custom onTap function (e.g., for Share)
//                   } else if (item.screen != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => item.screen!),
//                     );
//                   }
//                 },
//               );
//             }).toList(),
//             SizedBox(height: 120),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Text(
//                     'Current Version: $currentVersion',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// Future<void> getAppVersion() async {
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   String version = packageInfo.version; // This will give you "1.0.1"
//   print("App Version: $version");
// }
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Define a class to represent each drawer item
class DrawerItem {
  final String? title;
  final IconData? icon;
  final Widget? screen;
  final VoidCallback? onTap;
  final Color iconColor;

  DrawerItem({
    this.title,
    this.icon,
    this.screen,
    this.onTap,
    this.iconColor = Colors.green,
  });
}

class MyDrawer extends StatelessWidget {
  final List<DrawerItem> drawerItems; // Pass a list of drawer items to be shown
  final String currentVersion = "9.1"; // Add current version parameter
  final String updateDate = "23 Jan 2025, Thursday";
  final String? username;

  const MyDrawer({
    super.key,
    required this.drawerItems,
    required this.username,
  });

  Future<String?> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; // This will give you "1.0.1"
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250, // Increased height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/rdclogo.png',
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username ?? "Guest",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.green, thickness: 1),
                ],
              ),
            ),
            ...drawerItems.map((item) {
              return ListTile(
                leading: Icon(item.icon),
                iconColor: item.iconColor,
                title: Text(item.title ?? ""),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  if (item.onTap != null) {
                    item.onTap!(); // Execute the custom onTap function
                  } else if (item.screen != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item.screen!),
                    );
                  }
                },
              );
            }),

            SizedBox(height: 150),
            FutureBuilder<String?>(
              future: getAppVersion(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Current Version: Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error fetching version',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'v ${snapshot.data}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
