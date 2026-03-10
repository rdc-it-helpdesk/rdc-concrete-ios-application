// import 'package:flutter/material.dart';
//
// import 'package:rdc_concrete/component/drawer.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:rdc_concrete/screens/transaction_summary.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
//
// import '../models/vendordt.dart';
// import '../services/fetch_location_api_service.dart';
//
// import '../models/fetch_location_pojo.dart';
// import '../services/vendor_info_api_service.dart';
// import '../utils/session_manager.dart';
// import 'mapped_po_list.dart';
//
// class VendorHomePage extends StatefulWidget {
//   final int? uid;
//   final int? locationid;
//   final int? uprofileid;
//   final String? uname;
//   final String? role;
//   const VendorHomePage({
//     super.key,
//     this.uid,
//     this.uname,
//     this.role,
//     this.locationid,
//     this.uprofileid,
//   });
//
//   @override
//   State<VendorHomePage> createState() => _VendorHomePageState();
// }
//
// class _VendorHomePageState extends State<VendorHomePage> {
//   String? selectedLocationItem;
//   List<LocationList> locations = [];
//   int orderCount = 0;
//   bool isLoading = true;
//   String? selectedItem;
//   String? vendorLocation; // Variable to store vendor location
//   List<String> spinnerItems = ['Select Location'];
//  // Vendordt? vendorData;
//   List<PO> poItems1 = [];
//   @override
//   void initState() {
//     super.initState();
//
//     fetchVendorData();
//     //SessionManager.checkAutoLogoutOnce();
//     SessionManager.scheduleMidnightLogout(context);
//   }
//
//   Vendordt? vendorData;
//   PO? vendorData1;
//   List<Vendordt> poItems = [];
//
//   Future<void> fetchVendorData() async {
//     String id = widget.uid.toString();
//     VendorService vendorService = VendorService();
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       vendorData = await vendorService.vendordata(id);
//       if (!mounted) return;
//
//       if (vendorData != null) {
//         // Extract unique sitenames from po list
//         final List<String> uniqueSiteNames = vendorData!.po
//             .map((po) => po.sitename)
//             .where((sitename) => sitename.isNotEmpty)
//             .toSet()
//             .toList();
//
//         // Store the first sitename in SharedPreferences (or adjust based on your logic)
//         final prefs = await SharedPreferences.getInstance();
//         if (uniqueSiteNames.isNotEmpty) {
//           await prefs.setString('sitename', uniqueSiteNames.first);
//           //print("Stored sitename in SharedPreferences: ${uniqueSiteNames.first}");
//         } else {
//           await prefs.remove('sitename');
//           //print("Cleared sitename from SharedPreferences");
//         }
//
//         setState(() {
//           spinnerItems = ['Select Location', ...uniqueSiteNames];
//           selectedItem = uniqueSiteNames.isNotEmpty ? uniqueSiteNames.first : 'Select Location';
//           poItems1 = vendorData?.po ?? [];
//           orderCount = uniqueSiteNames.isNotEmpty
//               ? poItems1.where((po) => po.sitename == selectedItem).length
//               : 0;
//         });
//       } else {
//         setState(() {
//           spinnerItems = ['Select Location'];
//           selectedItem = 'Select Location';
//           poItems = [];
//           orderCount = 0;
//         });
//       }
//     } catch (e) {
//       //print("Error fetching vendor data: $e");
//       setState(() {
//         spinnerItems = ['Select Location'];
//         selectedItem = 'Select Location';
//         poItems = [];
//         orderCount = 0;
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//
//     // Define the drawer items
//     final drawerItems = [
//
//       DrawerItem(
//         title: "Transaction Summary",
//         icon: Icons.summarize_outlined,
//         screen: TransactionSummary(),
//       ),
//
//       DrawerItem(
//         title: "Share",
//         icon: Icons.share,
//         onTap: () {
//           //print('share tile pressed.');
//           Share.share(
//             'Check out this amazing app: [https://example.com/RDC Concrete_application]',
//           );
//         },
//       ),
//       DrawerItem(title: "Logout", icon: Icons.logout, screen: SelectProfile()),
//       DrawerItem(
//
//       ),
//       DrawerItem(
//
//       ),
//       DrawerItem(
//
//       ),
//     ];
//     // return WillPopScope(
//     //   onWillPop: () async {
//     //     return false; // Prevents back navigation
//     //   },
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         title: const Text(
//           'Vendor',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(0, 0, 0, 0.5),
//               image: DecorationImage(
//                 image: const AssetImage('assets/bg_image/RDC.png'),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Color.fromRGBO(0, 0, 0, 0.3),
//                   BlendMode.dstATop,
//                 ),
//               ),
//             ),
//           ),
//           RefreshIndicator(
//             onRefresh: () async {},
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
//
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 15),
//                         _buildSpinner(),
//                         const SizedBox(height: 15),
//
//                         /// Show Order List only if a location is selected
//                         if (selectedItem != null) ...[
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             //       itemCount: orderCount, // Dynamically setting count
//                             itemCount:
//                                 vendorData?.po.length, // Dynamically setting count
//                             itemBuilder: (context, index) {
//                               var poItem = vendorData?.po[index];
//                               String availableQty =
//                                   poItem?.availableqty.toString() ?? "0";
//                               String itemName =
//                                   poItem?.itemname ??
//                                   "Unknown Item"; // Fallback if null
//                               String ponumber =
//                                   poItem?.ponumber ?? "Unknown PO Number";
//                               //String  unitPrice =poItem?.unitPrice??"0.0";
//                               //double unitPrice= (poItem?.unitPrice??"0.0") as double;
//                               String unitPriceString =
//                                   poItem?.unitPrice ??
//                                   "0.0"; // Fallback if null
//                               double unitPrice =
//                                   double.tryParse(unitPriceString) ??
//                                   0.0; // Fallback if null
//                               String siteName =
//                                   poItem?.sitename ??
//                                   "Unknown Site"; // Fallback to "Unknown Site" if null
//
//                               return Card(
//                                 color: Colors.white,
//                                 elevation: 5,
//                                 margin: const EdgeInsets.symmetric(
//                                   vertical: 3,
//                                   horizontal: 4,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(7),
//                                 ),
//                                 child: ListTile(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                   ),
//                                   title: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         " $itemName ($ponumber) ",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           backgroundColor:
//                                               Colors
//                                                   .green
//                                                   .shade100, // Set background color
//                                         ),
//                                       ),
//                                       // const Text("PO: 405873", style: TextStyle(fontWeight: FontWeight.bold)),
//                                     ],
//                                   ),
//                                   subtitle: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // const Row(
//                                       //   children: [
//                                       //     Text("Naveen Enterprise"),
//                                       //   ],
//                                       // ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 "${poItem?.needbydt}",
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 8),
//                                               Text(
//                                                 "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}",
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.currency_rupee,
//                                                 color: Color(0xFF0EB154),
//                                               ),
//                                               Text(
//                                                 //'${unitPrice.toString()}/kg'
//                                                 '${unitPrice.toStringAsFixed(2)}/kg',
//                                              //   '${unitPrice.toStringAsFixed(2)}/kg',
//
//                                               ), // Display unit price
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           // Text("${siteName}"),
//                                           Text(
//                                             siteName, // Fallback if siteName is null
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "$availableQty KG",
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.normal,
//                                               color:
//                                                   Colors
//                                                       .black, // Adjust for visibility
//                                             ),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder:
//                                                       (context) => MappedPoList(
//                                                         ponumberid:
//                                                             poItem!.ponumberid,
//                                                         uid: widget.uid,
//                                                         role: widget.role,
//                                                         locationid:
//                                                             widget.locationid,
//                                                         uname: widget.uname,
//                                                         uprofileid:
//                                                             widget.uprofileid,
//                                                       ),
//                                                 ),
//                                               );
//                                             },
//                                             style: TextButton.styleFrom(
//                                               padding: EdgeInsets.zero,
//                                               tapTargetSize:
//                                                   MaterialTapTargetSize
//                                                       .shrinkWrap,
//                                             ),
//                                             child: Text(
//                                               "GO",
//                                               style: TextStyle(
//                                                 color: primaryColor,
//                                                 fontSize: 24,
//                                                 decoration:
//                                                     TextDecoration.underline,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//     // );
//   }
//
//   Widget _buildSpinner() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromRGBO(158, 158, 158, 0.3),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       child: DropdownButtonFormField<String>(
//         value: selectedItem,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: "Select Location",
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//         isExpanded: true,
//         onChanged: (String? newValue) {
//           if (newValue != null && newValue != 'Select Location') {
//             setState(() {
//               selectedItem = newValue;
//               orderCount = poItems1.where((po) => po.sitename == newValue).length;
//             });
//           } else {
//             setState(() {
//               selectedItem = 'Select Location';
//               orderCount = 0;
//             });
//           }
//         },
//         items: spinnerItems.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//         icon: Icon(Icons.location_on, color: Colors.green),
//         style: TextStyle(color: Colors.black, fontSize: 16),
//         dropdownColor: Colors.white,
//         itemHeight: 50,
//       ),
//     );
//   }
//
// }
//

//main
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:rdc_concrete/component/drawer.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:rdc_concrete/screens/transaction_summary.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
// import '../models/vendordt.dart';
// import '../services/fetch_location_api_service.dart';
// import '../models/fetch_location_pojo.dart';
// import '../services/vendor_info_api_service.dart';
// import '../utils/session_manager.dart';
// import 'mapped_po_list.dart';
//
// class VendorHomePage extends StatefulWidget {
//   final int? uid;
//   final int? locationid;
//   final int? uprofileid;
//   final String? uname;
//   final String? role;
//   final String? sitename;
//   const VendorHomePage({
//     super.key,
//     this.uid,
//     this.uname,
//     this.role,
//     this.locationid,
//     this.uprofileid,
//     this.sitename,
//   });
//
//   @override
//   State<VendorHomePage> createState() => _VendorHomePageState();
// }
//
// class _VendorHomePageState extends State<VendorHomePage> {
//   String? selectedLocationItem;
//   List<LocationList> locations = [];
//   int orderCount = 0;
//   bool isLoading = true;
//   String? selectedItem;
//   String? vendorLocation;
//   List<String> spinnerItems = ['Select Location'];
//   Vendordt? vendorData;
//   List<PO> poItems1 = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchVendorData();
//     SessionManager.scheduleMidnightLogout(context);
//   }
//
//   Future<void> fetchVendorData() async {
//     String id = widget.uid.toString();
//     VendorService vendorService = VendorService();
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       vendorData = await vendorService.vendordata(id);
//       if (!mounted) return;
//
//       if (vendorData != null) {
//         // Extract unique sitenames from po list
//         final List<String> uniqueSiteNames = vendorData!.po
//             .map((po) => po.sitename)
//             .where((sitename) => sitename.isNotEmpty)
//             .toSet()
//             .toList();
//
//
//
//         // Store the first sitename in SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         if (uniqueSiteNames.isNotEmpty) {
//           await prefs.setString('sitename', uniqueSiteNames.first);
//           //print("Stored sitename in SharedPreferences: ${uniqueSiteNames.first}");
//         } else {
//           await prefs.remove('sitename');
//           //print("Cleared sitename from SharedPreferences");
//         }
//
//         setState(() {
//           spinnerItems = ['Select Location', ...uniqueSiteNames];
//           selectedItem = uniqueSiteNames.isNotEmpty ? uniqueSiteNames.first : 'Select Location';
//           poItems1 = vendorData?.po ?? [];
//           orderCount = uniqueSiteNames.isNotEmpty
//               ? poItems1.where((po) => po.sitename == selectedItem).length
//               : 0;
//         });
//       } else {
//         setState(() {
//           spinnerItems = ['Select Location'];
//           selectedItem = 'Select Location';
//           poItems1 = [];
//           orderCount = 0;
//         });
//       }
//     } catch (e) {
//       //print("Error fetching vendor data: $e");
//       setState(() {
//         spinnerItems = ['Select Location'];
//         selectedItem = 'Select Location';
//         poItems1 = [];
//         orderCount = 0;
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   Widget _buildSpinner() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromRGBO(158, 158, 158, 0.3),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       child: DropdownButtonFormField<String>(
//         value: selectedItem,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: "Select Location",
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//         isExpanded: true,
//         onChanged: (String? newValue) async {
//           if (newValue != null) {
//             final prefs = await SharedPreferences.getInstance();
//             if (newValue != 'Select Location') {
//               await prefs.setString('sitename', newValue);
//               setState(() {
//                 selectedItem = newValue;
//                 orderCount = poItems1.where((po) => po.sitename == newValue).length;
//               });
//             } else {
//               await prefs.remove('sitename');
//               setState(() {
//                 selectedItem = 'Select Location';
//                 orderCount = 0;
//               });
//             }
//           }
//         },
//         items: spinnerItems.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//         icon: Icon(Icons.location_on, color: Colors.green),
//         style: TextStyle(color: Colors.black, fontSize: 16),
//         dropdownColor: Colors.white,
//         itemHeight: 50,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//
//     final drawerItems = [
//       DrawerItem(
//         title: "Transaction Summary",
//         icon: Icons.summarize_outlined,
//         screen: TransactionSummary(),
//       ),
//       // DrawerItem(
//       //   title: "Share",
//       //   icon: Icons.share,
//       //   onTap: () {
//       //     Share.share('Check out this amazing app: [https://example.com/RDC Concrete_application]');
//       //   },
//       // ),
//       // DrawerItem(title: "Logout", icon: Icons.logout, screen: SelectProfile()),
//       DrawerItem(
//         title: "Logout",
//         icon: Icons.logout,
//         onTap: () async {
//           // Clear SharedPreferences to log out the user
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.clear();
//           // Navigate to SelectProfile screen
//           Get.offAll(() => const SelectProfile());
//         },
//       ),
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         title: const Text(
//           'Vendor',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(0, 0, 0, 0.5),
//               image: DecorationImage(
//                 image: const AssetImage('assets/bg_image/RDC.png'),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Color.fromRGBO(0, 0, 0, 0.3),
//                   BlendMode.dstATop,
//                 ),
//               ),
//             ),
//           ),
//           // RefreshIndicator(
//           //   onRefresh: fetchVendorData,
//           //   child: SingleChildScrollView(
//           //     child: Column(
//           //       children: [
//           //         Padding(
//           //           padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
//           //           child: Column(
//           //             children: [
//           //               const SizedBox(height: 15),
//           //               _buildSpinner(),
//           //               const SizedBox(height: 15),
//           //               if (selectedItem != null && selectedItem != 'Select Location') ...[
//           //                 ListView.builder(
//           //                   shrinkWrap: true,
//           //                   physics: const NeverScrollableScrollPhysics(),
//           //                   itemCount: poItems1.where((po) => po.sitename == selectedItem).length,
//           //                   itemBuilder: (context, index) {
//           //                     var poItem = poItems1.where((po) => po.sitename == selectedItem).toList()[index];
//           //                     String availableQty = poItem.availableqty.toString();
//           //                     String itemName = poItem.itemname ?? "Unknown Item";
//           //                     String ponumber = poItem.ponumber ?? "Unknown PO Number";
//           //                     String unitPriceString = poItem.unitPrice ?? "0.0";
//           //                     double unitPrice = double.tryParse(unitPriceString) ?? 0.0;
//           //                     String siteName = poItem.sitename ?? "Unknown Site";
//           //
//           //                     return Card(
//           //                       color: Colors.white,
//           //                       elevation: 5,
//           //                       margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
//           //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
//           //                       child: ListTile(
//           //                         contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//           //                         title: Column(
//           //                           crossAxisAlignment: CrossAxisAlignment.start,
//           //                           children: [
//           //                             Text(
//           //                               "$itemName ($ponumber)",
//           //                               style: TextStyle(
//           //                                 fontWeight: FontWeight.bold,
//           //                                 backgroundColor: Colors.green.shade100,
//           //                               ),
//           //                             ),
//           //                           ],
//           //                         ),
//           //                         subtitle: Column(
//           //                           crossAxisAlignment: CrossAxisAlignment.start,
//           //                           children: [
//           //                             Row(
//           //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //                               children: [
//           //                                 Row(
//           //                                   children: [
//           //                                     Text(
//           //                                       "${poItem.needbydt}",
//           //                                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//           //                                     ),
//           //                                     const SizedBox(width: 8),
//           //                                     Text(
//           //                                       "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}",
//           //                                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//           //                                     ),
//           //                                   ],
//           //                                 ),
//           //                                 Row(
//           //                                   children: [
//           //                                     Icon(Icons.currency_rupee, color: Color(0xFF0EB154)),
//           //                                     Text('${unitPrice.toStringAsFixed(2)}/kg'),
//           //                                   ],
//           //                                 ),
//           //                               ],
//           //                             ),
//           //                             Row(
//           //                               children: [
//           //                                 Text(
//           //                                   siteName,
//           //                                   style: const TextStyle(fontWeight: FontWeight.bold),
//           //                                 ),
//           //                               ],
//           //                             ),
//           //                             Row(
//           //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //                               children: [
//           //                                 Text(
//           //                                   "$availableQty KG",
//           //                                   style: TextStyle(
//           //                                     fontSize: 15,
//           //                                     fontWeight: FontWeight.normal,
//           //                                     color: Colors.black,
//           //                                   ),
//           //                                 ),
//           //                                 TextButton(
//           //                                   onPressed: () {
//           //                                     Navigator.push(
//           //                                       context,
//           //                                       MaterialPageRoute(
//           //                                         builder: (context) => MappedPoList(
//           //                                           ponumberid: poItem.ponumberid,
//           //                                           uid: widget.uid,
//           //                                           role: widget.role,
//           //                                           locationid: widget.locationid,
//           //                                           uname: widget.uname,
//           //                                           uprofileid: widget.uprofileid,
//           //
//           //                                         ),
//           //                                       ),
//           //                                     );
//           //                                   },
//           //                                   style: TextButton.styleFrom(
//           //                                     padding: EdgeInsets.zero,
//           //                                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           //                                   ),
//           //                                   child: Text(
//           //                                     "GO",
//           //                                     style: TextStyle(
//           //                                       color: primaryColor,
//           //                                       fontSize: 24,
//           //                                       decoration: TextDecoration.underline,
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                               ],
//           //                             ),
//           //                           ],
//           //                         ),
//           //                       ),
//           //                     );
//           //                   },
//           //                 ),
//           //               ],
//           //             ],
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           RefreshIndicator(
//             onRefresh: fetchVendorData,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 15),
//                         _buildSpinner(),
//                         const SizedBox(height: 15),
//                         if (selectedItem != null && selectedItem != 'Select Location') ...[
//                           // Replacing ListView.builder with Column
//                           Column(
//                             children: poItems1
//                                 .where((po) => po.sitename == selectedItem)
//                                 .map((poItem) {
//                               String availableQty = poItem.availableqty.toString();
//                               String itemName = poItem.itemname ?? "Unknown Item";
//                               String ponumber = poItem.ponumber ?? "Unknown PO Number";
//                               String unitPriceString = poItem.unitPrice ?? "0.0";
//                               double unitPrice = double.tryParse(unitPriceString) ?? 0.0;
//                               String siteName = poItem.sitename ?? "Unknown Site";
//
//                               return Card(
//                                 color: Colors.white,
//                                 elevation: 5,
//                                 margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(7)),
//                                 child: ListTile(
//                                   contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                                   title: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "$itemName ($ponumber)",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           backgroundColor: Colors.green.shade100,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 "${poItem.needbydt}",
//                                                 style: const TextStyle(
//                                                     fontSize: 12, color: Colors.grey),
//                                               ),
//                                               const SizedBox(width: 8),
//                                               Text(
//                                                 "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}",
//                                                 style: const TextStyle(
//                                                     fontSize: 12, color: Colors.grey),
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Icon(Icons.currency_rupee, color: Color(0xFF0EB154)),
//                                               Text('${unitPrice.toStringAsFixed(2)}/kg'),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             siteName,
//                                             style: const TextStyle(fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "$availableQty KG",
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.normal,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => MappedPoList(
//                                                     ponumberid: poItem.ponumberid,
//                                                     uid: widget.uid,
//                                                     role: widget.role,
//                                                     locationid: widget.locationid,
//                                                     uname: widget.uname,
//                                                     uprofileid: widget.uprofileid,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             style: TextButton.styleFrom(
//                                               padding: EdgeInsets.zero,
//                                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                                             ),
//                                             child: Text(
//                                               "GO",
//                                               style: TextStyle(
//                                                 color: primaryColor,
//                                                 fontSize: 24,
//                                                 decoration: TextDecoration.underline,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//
//         ],
//       ),
//     );
//   }
// }



//main
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:rdc_concrete/component/drawer.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:rdc_concrete/screens/transaction_summary.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
// import '../models/vendordt.dart';
// import '../services/fetch_location_api_service.dart';
// import '../models/fetch_location_pojo.dart';
// import '../services/vendor_info_api_service.dart';
// import '../utils/session_manager.dart';
// import 'mapped_po_list.dart';
//
// class VendorHomePage extends StatefulWidget {
//   final int? uid;
//   final int? locationid;
//   final int? uprofileid;
//   final String? uname;
//   final String? role;
//   final String? sitename;
//   const VendorHomePage({
//     super.key,
//     this.uid,
//     this.uname,
//     this.role,
//     this.locationid,
//     this.uprofileid,
//     this.sitename,
//   });
//
//   @override
//   State<VendorHomePage> createState() => _VendorHomePageState();
// }
//
// class _VendorHomePageState extends State<VendorHomePage> {
//   String? selectedLocationItem;
//   List<LocationList> locations = [];
//   int orderCount = 0;
//   bool isLoading = true;
//   String? selectedItem;
//   String? vendorLocation;
//   List<String> spinnerItems = ['Select Location'];
//   Vendordt? vendorData;
//   List<PO> poItems1 = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchVendorData();
//     SessionManager.scheduleMidnightLogout(context);
//   }
//
//   Future<void> fetchVendorData() async {
//     String id = widget.uid.toString();
//     VendorService vendorService = VendorService();
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       vendorData = await vendorService.vendordata(id);
//       if (!mounted) return;
//
//       if (vendorData != null) {
//         // Extract unique sitenames from po list
//         final List<String> uniqueSiteNames = vendorData!.po
//             .map((po) => po.sitename)
//             .where((sitename) => sitename.isNotEmpty)
//             .toSet()
//             .toList();
//
//         // Do not set SharedPreferences automatically; let user select
//         // Optionally, if you want to load a previously saved sitename from prefs as default (but not widget.sitename)
//         // final prefs = await SharedPreferences.getInstance();
//         // String? savedSiteName = prefs.getString('sitename');
//         // selectedItem = uniqueSiteNames.contains(savedSiteName) ? savedSiteName : 'Select Location';
//
//         setState(() {
//           spinnerItems = ['Select Location', ...uniqueSiteNames];
//           // Always default to 'Select Location' on load
//           selectedItem = widget.sitename;
//           poItems1 = vendorData?.po ?? [];
//           orderCount = 0; // No orders shown by default
//         });
//       } else {
//         _resetDropdown();
//         // setState(() {
//         //   spinnerItems = ['Select Location'];
//         //   selectedItem = widget.sitename;
//         //   poItems1 = [];
//         //   orderCount = 0;
//         // });
//       }
//     } catch (e) {
//       _resetDropdown();
//       // setState(() {
//       //   spinnerItems = ['Select Location'];
//       //   selectedItem = widget.sitename;
//       //   poItems1 = [];
//       //   orderCount = 0;
//       // });
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }void _resetDropdown() {
//     setState(() {
//       spinnerItems = ['Select Location'];
//       selectedItem = 'Select Location';
//       poItems1 = [];
//       orderCount = 0;
//     });
//   }
//
//   Widget _buildSpinner() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Color.fromRGBO(158, 158, 158, 0.3),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       child: DropdownButtonFormField<String>(
//         value: selectedItem,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           hintText: "Select Location",
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//         isExpanded: true,
//         onChanged: (String? newValue) async {
//           if (newValue == null) return;
//
//           final prefs = await SharedPreferences.getInstance();
//
//           if (newValue == 'Select Location') {
//             await prefs.remove('sitename');
//             setState(() {
//               selectedItem = newValue;
//               orderCount = 0;
//             });
//           } else {
//             await prefs.setString('sitename', newValue);
//             setState(() {
//               selectedItem = newValue;
//               orderCount = poItems1
//                   .where((po) => (po.sitename?.trim() ?? '') == newValue)
//                   .length;
//             });
//           }
//         },
//         items: spinnerItems.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//         icon: const Icon(Icons.location_on, color: Colors.green),
//         style: const TextStyle(color: Colors.black, fontSize: 16),
//         dropdownColor: Colors.white,
//         itemHeight: 50,
//       ),
//     );
//   }
//   // Widget _buildSpinner() {
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       borderRadius: BorderRadius.circular(8),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Color.fromRGBO(158, 158, 158, 0.3),
//   //           spreadRadius: 1,
//   //           blurRadius: 3,
//   //           offset: Offset(0, 2),
//   //         ),
//   //       ],
//   //     ),
//   //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//   //     child: DropdownButtonFormField<String>(
//   //       value: selectedItem,
//   //       decoration: InputDecoration(
//   //         border: InputBorder.none,
//   //         hintText: "Select Location",
//   //         hintStyle: TextStyle(color: Colors.grey),
//   //       ),
//   //       isExpanded: true,
//   //       onChanged: (String? newValue) async {
//   //         if (newValue != null) {
//   //           final prefs = await SharedPreferences.getInstance();
//   //           if (newValue != 'Select Location') {
//   //             // Save the selected location to SharedPreferences
//   //             await prefs.setString('sitename', newValue);
//   //             setState(() {
//   //               selectedItem = newValue;
//   //               orderCount = poItems1.where((po) => po.sitename == newValue).length;
//   //             });
//   //           } else {
//   //             // When 'Select Location' is chosen, stay on 'Select Location' and clear prefs
//   //             await prefs.remove('sitename');
//   //             setState(() {
//   //               selectedItem = widget.sitename;
//   //               orderCount = 0;
//   //             });
//   //           }
//   //         }
//   //       },
//   //       items: spinnerItems.map((String item) {
//   //         return DropdownMenuItem<String>(
//   //           value: item,
//   //           child: Text(item),
//   //         );
//   //       }).toList(),
//   //       icon: Icon(Icons.location_on, color: Colors.green),
//   //       style: TextStyle(color: Colors.black, fontSize: 16),
//   //       dropdownColor: Colors.white,
//   //       itemHeight: 50,
//   //     ),
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//
//     final drawerItems = [
//       DrawerItem(
//         title: "Transaction Summary",
//         icon: Icons.summarize_outlined,
//         screen: TransactionSummary(),
//       ),
//       DrawerItem(
//         title: "Logout",
//         icon: Icons.logout,
//         onTap: () async {
//           // Clear SharedPreferences to log out the user
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.clear();
//           // Navigate to SelectProfile screen
//           Get.offAll(() => const SelectProfile());
//         },
//       ),
//     ];
//
//     return WillPopScope(
//       onWillPop: () async {
//         // Pass widget.sitename back to the previous screen (unchanged)
//         Navigator.pop(context, widget.sitename);
//         return false; // Prevent default back navigation
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: primaryColor,
//           centerTitle: true,
//           title: const Text(
//             'Vendor',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           iconTheme: const IconThemeData(color: Colors.white),
//         ),
//         drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(0, 0, 0, 0.5),
//                 image: DecorationImage(
//                   image: const AssetImage('assets/bg_image/RDC.png'),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                     Color.fromRGBO(0, 0, 0, 0.3),
//                     BlendMode.dstATop,
//                   ),
//                 ),
//               ),
//             ),
//             isLoading
//                 ? Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//               ),
//             )
//                 : RefreshIndicator(
//               onRefresh: fetchVendorData,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 15),
//                           _buildSpinner(),
//                           const SizedBox(height: 15),
//                           // Show items only if a specific location is selected (not 'Select Location')
//                           if (selectedItem != null && selectedItem != 'Select Location') ...[
//                             Column(
//                               children: poItems1
//                                   .where((po) => po.sitename == selectedItem)
//                                   .map((poItem) {
//                                 String availableQty = poItem.availableqty.toString();
//                                 String itemName = poItem.itemname ?? "Unknown Item";
//                                 String ponumber = poItem.ponumber ?? "Unknown PO Number";
//                                 String unitPriceString = poItem.unitPrice ?? "0.0";
//                                 double unitPrice = double.tryParse(unitPriceString) ?? 0.0;
//                                 String siteName = poItem.sitename ?? "Unknown Site";
//
//                                 return Card(
//                                   color: Colors.white,
//                                   elevation: 5,
//                                   margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(7)),
//                                   child: ListTile(
//                                     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                                     title: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "$itemName ($ponumber)",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             backgroundColor: Colors.green.shade100,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     subtitle: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "${poItem.needbydt}",
//                                                   style: const TextStyle(
//                                                       fontSize: 12, color: Colors.grey),
//                                                 ),
//                                                 const SizedBox(width: 8),
//                                                 Text(
//                                                   "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}",
//                                                   style: const TextStyle(
//                                                       fontSize: 12, color: Colors.grey),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Icon(Icons.currency_rupee, color: Color(0xFF0EB154)),
//                                                 Text('${unitPrice.toStringAsFixed(2)}/kg'),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               siteName,
//                                               style: const TextStyle(fontWeight: FontWeight.bold),
//                                             ),
//                                           ],
//                                         ),
//
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "$availableQty KG",
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             TextButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) => MappedPoList(
//                                                       ponumberid: poItem.ponumberid,
//                                                       uid: widget.uid,
//                                                       role: widget.role,
//                                                       locationid: widget.locationid,
//                                                       uname: widget.uname,
//                                                       uprofileid: widget.uprofileid,
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               style: TextButton.styleFrom(
//                                                 padding: EdgeInsets.zero,
//                                                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                                               ),
//                                               child: Text(
//                                                 "GO",
//                                                 style: TextStyle(
//                                                   color: primaryColor,
//                                                   fontSize: 24,
//                                                   decoration: TextDecoration.underline,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rdc_concrete/component/drawer.dart';
import 'package:rdc_concrete/screens/select_profile.dart';
import 'package:rdc_concrete/screens/transaction_summary.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import '../models/vendordt.dart';
import '../models/fetch_location_pojo.dart';
import '../services/vendor_info_api_service.dart';
import '../utils/session_manager.dart';
import 'mapped_po_list.dart';

class VendorHomePage extends StatefulWidget {
  final int? uid;
  final int? locationid;
  final int? uprofileid;
  final String? uname;
  final String? role;
  final String? sitename;

  const VendorHomePage({
    super.key,
    this.uid,
    this.uname,
    this.role,
    this.locationid,
    this.uprofileid,
    this.sitename,
  });

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  String? selectedLocationItem;
  List<LocationList> locations = [];
  int orderCount = 0;
  bool isLoading = true;
  String? selectedItem;
  String? vendorLocation;
  List<String> spinnerItems = ['Select Location'];
  Vendordt? vendorData;
  List<PO> poItems1 = [];

  @override
  void initState() {
    super.initState();
    fetchVendorData();
    SessionManager.scheduleMidnightLogout(context);
  }

  // -----------------------------------------------------------------------
  // FETCH VENDOR DATA – builds a **unique** dropdown list and picks a safe
  // initial value.
  // -----------------------------------------------------------------------
  Future<void> fetchVendorData() async {
    // Capture context early
    final BuildContext ctx = context;
    if (!mounted) return;

    final String id = widget.uid.toString();
    final VendorService vendorService = VendorService();

    setState(() => isLoading = true);

    try {
      vendorData = await vendorService.vendordata(id);

      if (!ctx.mounted) return;

      if (vendorData != null) {
        // ---- 1. Unique site names (trimmed) --------------------------------
        final Set<String> uniqueSet = vendorData!.po
            .map((po) => po.sitename.trim())
            .where((s) => s.isNotEmpty)
            .toSet();

        final List<String> uniqueSiteNames = uniqueSet.toList();

        // ---- 2. Dropdown items (placeholder + unique sites) -----------------
        final List<String> items = ['Select Location', ...uniqueSiteNames];

        // ---- 3. Safe initial value -----------------------------------------
        String initialValue = 'Select Location';
        if (widget.sitename != null && uniqueSet.contains(widget.sitename!.trim())) {
          initialValue = widget.sitename!.trim();
        }

        setState(() {
          spinnerItems = items;
          selectedItem = initialValue;
          poItems1 = vendorData?.po ?? [];
          orderCount = (initialValue == 'Select Location')
              ? 0
              : poItems1.where((po) => (po.sitename.trim()) == initialValue).length;
        });
      } else {
        _resetDropdown();
      }
    } catch (e) {
      _resetDropdown();
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _resetDropdown() {
    setState(() {
      spinnerItems = ['Select Location'];
      selectedItem = 'Select Location';
      poItems1 = [];
      orderCount = 0;
    });
  }

  // -----------------------------------------------------------------------
  // DROPDOWN WIDGET
  // -----------------------------------------------------------------------
  Widget _buildSpinner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(158, 158, 158, 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: DropdownButtonFormField<String>(
        initialValue: selectedItem,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Select Location",
          hintStyle: TextStyle(color: Colors.grey),
        ),
        isExpanded: true,
        onChanged: (String? newValue) async {
          if (newValue == null) return;

          final BuildContext ctx = context;
          if (!ctx.mounted) return;

          final prefs = await SharedPreferences.getInstance();

          if (newValue == 'Select Location') {
            await prefs.remove('sitename');
            setState(() {
              selectedItem = newValue;
              orderCount = 0;
            });
          } else {
            await prefs.setString('sitename', newValue);
            setState(() {
              selectedItem = newValue;
              orderCount = poItems1
                  .where((po) => (po.sitename.trim()) == newValue)
                  .length;
            });
          }
        },
        items: spinnerItems.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        icon: const Icon(Icons.location_on, color: Colors.green),
        style: const TextStyle(color: Colors.black, fontSize: 16),
        dropdownColor: Colors.white,
        itemHeight: 50,
      ),
    );
  }

  // -----------------------------------------------------------------------
  // BUILD
  // -----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final drawerItems = [
      DrawerItem(
        title: "Transaction Summary",
        icon: Icons.summarize_outlined,
        screen: TransactionSummary(),
      ),
      DrawerItem(
        title: "Logout",
        icon: Icons.logout,
        onTap: () async {
          final BuildContext ctx = context;
          if (!ctx.mounted) return;

          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Get.offAll(() => const SelectProfile());
        },
      ),
    ];

    return PopScope(
      canPop: false, // Prevent default back
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final BuildContext ctx = context;
        if (!ctx.mounted) return;

        Navigator.pop(ctx, widget.sitename);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: const Text(
            'Vendor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
        body: Stack(
          children: [
            // background image
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                image: DecorationImage(
                  image: const AssetImage('assets/bg_image/RDC.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    const Color.fromRGBO(0, 0, 0, 0.3),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),

            // loading indicator
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              )
            else
              RefreshIndicator(
                onRefresh: fetchVendorData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            _buildSpinner(),
                            const SizedBox(height: 15),

                            // ------------------- PO LIST -------------------
                            if (selectedItem != null && selectedItem != 'Select Location') ...[
                              Column(
                                children: poItems1
                                    .where((po) => (po.sitename.trim()) == selectedItem)
                                    .map((poItem) {
                                  final String availableQty = poItem.availableqty.toString();
                                  final String itemName = poItem.itemname;
                                  final String ponumber = poItem.ponumber;
                                  final String unitPriceString = poItem.unitPrice;
                                  final double unitPrice = double.tryParse(unitPriceString) ?? 0.0;
                                  final String siteName = poItem.sitename;

                                  return Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$itemName ($ponumber)",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.green.shade100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // date & time
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    poItem.needbydt,
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}",
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.currency_rupee, color: Color(0xFF0EB154)),
                                                  Text('${unitPrice.toStringAsFixed(2)}/kg'),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // site name
                                          Row(
                                            children: [
                                              Text(
                                                siteName,
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          // qty & GO button
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "$availableQty KG",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  final BuildContext ctx = context;
                                                  if (!ctx.mounted) return;

                                                  Navigator.push(
                                                    ctx,
                                                    MaterialPageRoute(
                                                      builder: (context) => MappedPoList(
                                                        ponumberid: poItem.ponumberid,
                                                        uid: widget.uid,
                                                        role: widget.role,
                                                        locationid: widget.locationid,
                                                        uname: widget.uname,
                                                        uprofileid: widget.uprofileid,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                child: Text(
                                                  "GO",
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 24,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// import 'package:rdc_concrete/component/drawer.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:rdc_concrete/screens/transaction_summary.dart';
// // import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
// import '../models/vendordt.dart';
// // import '../services/fetch_location_api_service.dart';
// import '../models/fetch_location_pojo.dart';
// import '../services/vendor_info_api_service.dart';
// import '../utils/session_manager.dart';
// import 'mapped_po_list.dart';
//
// class VendorHomePage extends StatefulWidget {
//   final int? uid;
//   final int? locationid;
//   final int? uprofileid;
//   final String? uname;
//   final String? role;
//   final String? sitename;
//
//   const VendorHomePage({
//     super.key,
//     this.uid,
//     this.uname,
//     this.role,
//     this.locationid,
//     this.uprofileid,
//     this.sitename,
//   });
//
//   @override
//   State<VendorHomePage> createState() => _VendorHomePageState();
// }
//
// class _VendorHomePageState extends State<VendorHomePage> {
//   String? selectedLocationItem;
//   List<LocationList> locations = [];
//   int orderCount = 0;
//   bool isLoading = true;
//   String? selectedItem;
//   String? vendorLocation;
//   List<String> spinnerItems = ['Select Location'];
//   Vendordt? vendorData;
//   List<PO> poItems1 = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchVendorData();
//     SessionManager.scheduleMidnightLogout(context);
//   }
//
//   // -----------------------------------------------------------------------
//   //  FETCH VENDOR DATA – builds a **unique** dropdown list and picks a safe
//   //  initial value.
//   // -----------------------------------------------------------------------
//   Future<void> fetchVendorData() async {
//     final String id = widget.uid.toString();
//     final VendorService vendorService = VendorService();
//
//     setState(() => isLoading = true);
//
//     try {
//       vendorData = await vendorService.vendordata(id);
//       if (!mounted) return;
//
//       if (vendorData != null) {
//         // ---- 1. Unique site names (trimmed) --------------------------------
//         final Set<String> uniqueSet = vendorData!.po
//             .map((po) => po.sitename.trim())
//             .where((s) => s.isNotEmpty)
//             .toSet();
//
//         final List<String> uniqueSiteNames = uniqueSet.toList();
//
//         // ---- 2. Dropdown items (placeholder + unique sites) -----------------
//         final List<String> items = ['Select Location', ...uniqueSiteNames];
//
//         // ---- 3. Safe initial value -----------------------------------------
//         String initialValue = 'Select Location';
//
//         // Use widget.sitename **only** when it really exists in the list
//         if (widget.sitename != null &&
//             uniqueSet.contains(widget.sitename!.trim())) {
//           initialValue = widget.sitename!.trim();
//         }
//
//         setState(() {
//           spinnerItems = items;
//           selectedItem = initialValue; // guaranteed to be in spinnerItems
//           poItems1 = vendorData?.po ?? [];
//           orderCount = (initialValue == 'Select Location')
//               ? 0
//               : poItems1
//               .where((po) => (po.sitename.trim()) == initialValue)
//               .length;
//         });
//       } else {
//         _resetDropdown();
//       }
//     } catch (e) {
//       _resetDropdown();
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }
//
//   void _resetDropdown() {
//     setState(() {
//       spinnerItems = ['Select Location'];
//       selectedItem = 'Select Location';
//       poItems1 = [];
//       orderCount = 0;
//     });
//   }
//
//   // -----------------------------------------------------------------------
//   //  DROPDOWN WIDGET
//   // -----------------------------------------------------------------------
//   Widget _buildSpinner() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Color.fromRGBO(158, 158, 158, 0.3),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       child: DropdownButtonFormField<String>(
//         initialValue: selectedItem,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           hintText: "Select Location",
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//         isExpanded: true,
//         onChanged: (String? newValue) async {
//           if (newValue == null) return;
//
//           final prefs = await SharedPreferences.getInstance();
//
//           if (newValue == 'Select Location') {
//             await prefs.remove('sitename');
//             setState(() {
//               selectedItem = newValue;
//               orderCount = 0;
//             });
//           } else {
//             await prefs.setString('sitename', newValue);
//             setState(() {
//               selectedItem = newValue;
//               orderCount = poItems1
//                   .where((po) => (po.sitename.trim()) == newValue)
//                   .length;
//             });
//           }
//         },
//         items: spinnerItems.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//         icon: const Icon(Icons.location_on, color: Colors.green),
//         style: const TextStyle(color: Colors.black, fontSize: 16),
//         dropdownColor: Colors.white,
//         itemHeight: 50,
//       ),
//     );
//   }
//
//   // -----------------------------------------------------------------------
//   //  BUILD
//   // -----------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//
//     final drawerItems = [
//       DrawerItem(
//         title: "Transaction Summary",
//         icon: Icons.summarize_outlined,
//         screen: TransactionSummary(),
//       ),
//       DrawerItem(
//         title: "Logout",
//         icon: Icons.logout,
//         onTap: () async {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.clear();
//           Get.offAll(() => const SelectProfile());
//         },
//       ),
//     ];
//
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context, widget.sitename);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: primaryColor,
//           centerTitle: true,
//           title: const Text(
//             'Vendor',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           iconTheme: const IconThemeData(color: Colors.white),
//         ),
//         drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
//         body: Stack(
//           children: [
//             // background image
//             Container(
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 color: const Color.fromRGBO(0, 0, 0, 0.5),
//                 image: DecorationImage(
//                   image: const AssetImage('assets/bg_image/RDC.png'),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                     const Color.fromRGBO(0, 0, 0, 0.3),
//                     BlendMode.dstATop,
//                   ),
//                 ),
//               ),
//             ),
//
//             // loading indicator
//             if (isLoading)
//               Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                 ),
//               )
//             else
//               RefreshIndicator(
//                 onRefresh: fetchVendorData,
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 15),
//                             _buildSpinner(),
//                             const SizedBox(height: 15),
//
//                             // ------------------- PO LIST -------------------
//                             if (selectedItem != null &&
//                                 selectedItem != 'Select Location') ...[
//                               Column(
//                                 children: poItems1
//                                     .where((po) =>
//                                 (po.sitename.trim()) ==
//                                     selectedItem)
//                                     .map((poItem) {
//                                   final String availableQty =
//                                   poItem.availableqty.toString();
//                                   final String itemName =
//                                       poItem.itemname;
//                                   final String ponumber =
//                                       poItem.ponumber;
//                                   final String unitPriceString =
//                                       poItem.unitPrice;
//                                   final double unitPrice =
//                                       double.tryParse(unitPriceString) ?? 0.0;
//                                   final String siteName =
//                                       poItem.sitename;
//
//                                   return Card(
//                                     color: Colors.white,
//                                     elevation: 5,
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 3, horizontal: 4),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(7)),
//                                     child: ListTile(
//                                       contentPadding:
//                                       const EdgeInsets.symmetric(
//                                           horizontal: 16),
//                                       title: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "$itemName ($ponumber)",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               backgroundColor:
//                                               Colors.green.shade100,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       subtitle: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           // date & time
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     poItem.needbydt,
//                                                     style: const TextStyle(
//                                                         fontSize: 12,
//                                                         color: Colors.grey),
//                                                   ),
//                                                   const SizedBox(width: 8),
//                                                   Text(
//                                                     "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}",
//                                                     style: const TextStyle(
//                                                         fontSize: 12,
//                                                         color: Colors.grey),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   const Icon(Icons.currency_rupee,
//                                                       color: Color(0xFF0EB154)),
//                                                   Text(
//                                                       '${unitPrice.toStringAsFixed(2)}/kg'),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           // site name
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 siteName,
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.bold),
//                                               ),
//                                             ],
//                                           ),
//                                           // qty & GO button
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 "$availableQty KG",
//                                                 style: const TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.normal,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           MappedPoList(
//                                                             ponumberid:
//                                                             poItem.ponumberid,
//                                                             uid: widget.uid,
//                                                             role: widget.role,
//                                                             locationid:
//                                                             widget.locationid,
//                                                             uname: widget.uname,
//                                                             uprofileid:
//                                                             widget.uprofileid,
//                                                           ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 style: TextButton.styleFrom(
//                                                   padding: EdgeInsets.zero,
//                                                   tapTargetSize:
//                                                   MaterialTapTargetSize
//                                                       .shrinkWrap,
//                                                 ),
//                                                 child: Text(
//                                                   "GO",
//                                                   style: TextStyle(
//                                                     color: primaryColor,
//                                                     fontSize: 24,
//                                                     decoration: TextDecoration
//                                                         .underline,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
