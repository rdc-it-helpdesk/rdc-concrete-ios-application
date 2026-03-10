// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// // import 'package:rdc_concrete/component/custom_elevated_button.dart';
// // import 'package:intl/intl.dart';
// // import 'package:rdc_concrete/screens/additional_info_form.dart';
// // import 'package:rdc_concrete/screens/po_insert_form.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:slide_to_act/slide_to_act.dart';
//
// import '../component/drawer.dart';
// import '../core/network/api_client.dart';
// import '../models/moisture_qa_pojo.dart';
// import '../models/vendor_transaction_pojo.dart';
// import '../services/rdc_suppor_api_service.dart';
// import '../services/vendor_transaction_api_service.dart';
// import '../src/generated/l10n/app_localizations.dart';
// import '../utils/session_manager.dart';
// import 'map_mobile_to_vendor_profile.dart';
// import 'map_tm.dart';
//
// class QaHomeScreen extends StatefulWidget {
//   final int? uid;
//   final int? locationid;
//   //final int? poid;
//   final String? itemname;
//   final String? role;
//   final String? uname;
//   final String? sitename;
//   final String? umobile;
//   const QaHomeScreen({
//     super.key,
//     this.uid,
//     this.itemname,
//     required this.role,
//     this.uname,
//     this.sitename,
//     this.umobile,
//     this.locationid,
//   });
//
//   @override
//   State<QaHomeScreen> createState() => _QaHomeScreen();
// }
//
// class _QaHomeScreen extends State<QaHomeScreen>
//     with SingleTickerProviderStateMixin {
//   bool isExpanded = false;
//   bool isExpandedC = false;
//   bool _isLoading = true;
//   late AnimationController _controller;
//   double progress = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     //SessionManager.checkAutoLogoutOnce();
//     SessionManager.checkAutoLogoutOnce();
//     SessionManager.scheduleMidnightLogout(context);
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(); // Keep rotating
//
//     _simulateLoading();
//     fetchTransactions(widget.umobile.toString());
//   //  fetchTransactions1(widget.uid.toString(), widget.poid.toString());
//
//   }
//
//   void _simulateLoading() {
//     // Simulate data loading process
//     Timer.periodic(Duration(milliseconds: 500), (timer) {
//       if (progress >= 1.0) {
//         timer.cancel();
//         setState(() {
//           _isLoading = false;
//           _controller.stop(); // Stop rotating when loading completes
//         });
//       } else {
//         setState(() {
//           progress += 0.1; // Increment progress
//         });
//       }
//     });
//   }
//
//    List<Activevendor> _activeList = [];
//    List<Completevendor> _completeList = [];
//   List<PendingMoisture> _activeList1 = [];
//   List<CompleteMoisture> _completeList1 = [];
//   Map<int, bool> expandedItems = {};
//   Future<void> fetchTransactions(String id) async {
//     // print("pppp${widget.poid}");
//     setState(() {
//       _isLoading = true;
//     });
//     final dio = ApiClient.getDio();
//     final service = RdcSupportApiService(dio);
//     try {
//       // Pass sitename directly
//       MoisturePojo? data = await service.getMoistureList(id,
//
//       );
//       if (data != null) {
//         //print("Data fetched successfully: ${data.toString()}");
//
//         setState(() {
//           _activeList1 = data.pendingmoisture;
//           _completeList1 = data.completemoisture;
//           _isLoading = false;   // ✅ stop loader only after data comes
//           _controller.stop();
//         });
//       } else {
//         setState(() {
//           _isLoading = false;   // stop loader even if no data
//           _controller.stop();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _controller.stop();
//       });
//     }
//   }
//
//   Future<void> fetchTransactions1(String uid, String poid) async {
//     // print("pppp${widget.poid}");
//     setState(() {
//       _isLoading = true;
//     });
//     final dio = ApiClient.getDio();
//     final service = VendorTransactionService(dio);
//     try {
//       // Pass sitename directly
//       VendorTransactionList? data = await service.fetchVendorTransaction(
//         uid,
//         poid,
//       );
//       if (data != null) {
//         //print("Data fetched successfully: ${data.toString()}");
//
//         setState(() {
//           _activeList = data.activeVendor;
//           _completeList = data.completeVendor;
//           _isLoading = false;
//           _controller.stop();
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _controller.stop();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _controller.stop();
//       });
//     }
//   }
//
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle = TextStyle(fontSize: 21);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text('On Road Orders', style: optionStyle),
//     Text('Complete Orders', style: optionStyle),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final drawerItems = [
//       DrawerItem(
//         title: "Map TM (RFID)",
//         icon: Icons.credit_card_sharp,
//         screen: MapTm(
//           uid: widget.uid,
//           sitename: widget.sitename,
//           locationid: widget.locationid,
//         ),
//       ),
//       DrawerItem(
//         title: AppLocalizations.of(context)!.share,
//         icon: Icons.share,
//         onTap: () {
//           //print('share tile pressed.');
//           Share.share(
//             'Check out this amazing app: [https://example.com/RDC Concrete_application]',
//           );
//         },
//       ),
//       DrawerItem(
//         title: AppLocalizations.of(context)!.logout,
//         icon: Icons.logout,
//         onTap: () async {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.clear();
//           Get.offAll(() => const SelectProfile());
//         },
//       ),
//     ];
//
//     final primaryColor = Theme.of(context).primaryColor;
//
//     return PopScope(
//       canPop: widget.role == "ADMIN" || widget.role == "Admin",
//       // ignore: deprecated_member_use
//       onPopInvoked: (bool didPop) {
//         if (!didPop) {
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //     SnackBar(content: Text("You don't have permission to go back."))
//           // );
//         }
//       },
//     child:Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         title: Text(
//           'RDC Concrete',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
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
//             child: SingleChildScrollView(
//               child: Center(
//                 child:
//                     _selectedIndex == 0
//                         ? buildOnRoadOrdersList()
//                         : _selectedIndex == 1
//                         ? buildCompleteOrdersList()
//                         : _widgetOptions.elementAt(_selectedIndex),
//               ),
//             ),
//           ),
//
//           //tem 18:18 22/09
//           // Positioned.fill(
//           //   top: 85,
//           //   child: SingleChildScrollView(
//           //     child: Center(
//           //       child:
//           //           _selectedIndex == 0
//           //               ? buildOnRoadOrdersList()
//           //               : _selectedIndex == 1
//           //               ? buildCompleteOrdersList()
//           //               // : _selectedIndex == 2
//           //               // ? buildRejectedOrdersList()
//           //               : _widgetOptions.elementAt(_selectedIndex),
//           //     ),
//           //   ),
//           // ),
//           // Positioned(
//           //   top: 8,
//           //   left: 8,
//           //   right: 8,
//           //   child: SizedBox(
//           //     child: Material(
//           //       borderRadius: BorderRadius.circular(25),
//           //       // width: MediaQuery.of(context).size.width * 0.8,
//           //       // width: MediaQuery.of(context).size.width * 0.4,
//           //       child: SlideAction(
//           //         onSubmit: () {
//           //           return Navigator.push(
//           //             context,
//           //             MaterialPageRoute(
//           //               builder:
//           //                   (context) => MapMobileToVendorProfile(
//           //                     sitename: widget.sitename.toString(),
//           //                   ),
//           //             ),
//           //           );
//           //         },
//           //         sliderButtonIconSize: 19,
//           //         sliderRotate: true,
//           //         innerColor: Colors.white,
//           //         outerColor: Colors.green.shade300,
//           //         elevation: 3,
//           //         borderRadius: 25,
//           //         // alignment: Alignment.center,
//           //         child: Text(
//           //           "New PO Available To MAp",
//           //           style: TextStyle(
//           //             color: Colors.white,
//           //             fontWeight: FontWeight.bold,
//           //             fontSize: 16,
//           //           ),
//           //         ),
//           //         //  child: Text('New Vendor Available to Map', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.handshake),
//             label: 'On Road Orders',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Complete Orders',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: primaryColor,
//         onTap: _onItemTapped,
//       ),
//     ),
//     );
//   }
//
//   Widget buildOnRoadOrdersList() {
//     // bool isExpanded = false;
//     final primaryColor = Theme.of(context).primaryColor;
//     if (_isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Colors.green,
//           ), // Set the color to green
//         ),
//       ); // Show loading indicator
//     }
//     return Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: _activeList1.length, // Example item count
//           itemBuilder: (context, index) {
//             final activeList = _activeList1[index];
//             return Card(
//               elevation: 5,
//               margin: EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${activeList.itemname} (${activeList.vehicleno})',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//
//                         // Text('10kg', style: TextStyle(fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                     onTap: () {
//                       setState(() {
//                         int orderId = activeList.orderid ?? 0;
//                         expandedItems[orderId] =
//                             !(expandedItems[orderId] ?? false);
//                       });
//                     },
//                   ),
//
//                   if (expandedItems[activeList.orderid] ?? false)
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         children: [
//                           Divider(thickness: 1, color: Colors.green),
//                           // _buildInfoRow(
//                           //   'Order Status',
//                           //   activeList.orderstatus.toString(),
//                           // ),
//                           //tem
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'PO Number',
//                             activeList.ponumber.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Number 1',
//                             activeList.challanno.toString(),
//                           ),
//                           // SizedBox(height: 8),
//                           // _buildInfoRow(
//                           //   'Chalan Number 2',
//                           //   activeList.ch.toString(),
//                           // ),
//                           //tem
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Vehicle Number',
//                             activeList.vehicleno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Driver Name',
//                             activeList.drivername.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Site Name',
//                             activeList.sitename.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 1',
//                             '${activeList.challanno} kg',
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 2',
//                             '${activeList.netweight} kg',
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Royalty Pass',
//                             activeList.orderid.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Last Action',
//                             activeList.sitename.toString(),
//                           ),
//                           //tem locat
//                           // SizedBox(height: 8),
//                           // _buildInfoRow('MRN No', activeList.mrnno.toString()),
// //tem
//                           SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: 55,
//                                 width: 55,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).primaryColor,
//                                   border: Border.all(color: primaryColor),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 // child: IconButton(
//                                 //   onPressed: () {
//                                 //     // Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalInfoForm( orderid: activeList.orderid.toString(),uid :widget.uid,poid: widget.poid,)));
//                                 //     Navigator.push(context, MaterialPageRoute(builder: (context) => POInsertForm( orderid: activeList.orderid.toString(),uidvendor :widget.uid,poidpodetail: widget.poid, netweight1: activeList.netweight,netweight2:activeList.net1,challan1:activeList.challanno,challan2:activeList.challanNo1,vno:activeList.vehiclenumber,drivername_mobilenum: '${activeList.drivername}(${activeList.drivermobile})',sitename:activeList.sitename ,itemname: widget.itemname,)));
//                                 //   },
//                                 //   icon: Icon(Icons.edit),
//                                 //   color: Colors.white,
//                                 // ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           expandedItems[activeList.orderid] ?? false
//                               ? Icons.expand_less
//                               : Icons.expand_more,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             int orderId = activeList.orderid ?? 0;
//                             expandedItems[orderId] =
//                                 !(expandedItems[orderId] ?? false);
//                             //expandedItems[completedList.orderid] = !(expandedItems[completedList.orderid] ?? false);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget buildCompleteOrdersList() {
//     // bool isExpanded = false;
//     //final primaryColor = Theme.of(context).primaryColor;
//     if (_isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Colors.green,
//           ), // Set the color to green
//         ),
//       ); // Show loading indicator
//     }
//     return Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: _completeList1.length,
//           //  itemCount: 1, // Example item count
//           itemBuilder: (context, index) {
//             final completedList = _completeList1[index];
//             return Card(
//               elevation: 5,
//               margin: EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Text(completedList.itemname.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(
//                           '${completedList.itemname} (${completedList.vehicleno})',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       setState(() {
//                         int orderId = completedList.orderid ?? 0;
//                         expandedItems[orderId] =
//                             !(expandedItems[orderId] ?? false);
//                       });
//                     },
//                   ),
//
//                   if (expandedItems[completedList.orderid] ?? false)
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         children: [
//                           Divider(thickness: 1, color: Colors.green),
//                           _buildInfoRow('Order Status', "Completed"),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'PO Number',
//                             completedList.ponumber.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Number 1',
//                             completedList.challanno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Number 2',
//                             completedList.challanno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Vehicle Number',
//                             completedList.vehicleno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Driver Name',
//                             completedList.drivername.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Site Name',
//                             completedList.sitename.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 1',
//                             completedList.netweight.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 2',
//                             completedList.netweight.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Royalty Pass',
//                             completedList.orderid.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Last Action',
//                             completedList.sitename.toString(),
//                           ),
//                           // SizedBox(height: 8),
//                           // _buildInfoRow(
//                           //   'MRN No',
//                           //   completedList..toString(),
//                           // ),
//                           SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               // Container(
//                               //   height: 55,
//                               //   width: 55,
//                               //   decoration: BoxDecoration(
//                               //       color: Theme.of(context).primaryColor,
//                               //       border: Border.all(color: primaryColor),
//                               //       borderRadius: BorderRadius.circular(12)
//                               //   ),
//                               //   child: IconButton(
//                               //     onPressed: () {},
//                               //     icon: Icon(Icons.edit),
//                               //     color: Colors.white,
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           expandedItems[completedList.orderid] ?? false
//                               ? Icons.expand_less
//                               : Icons.expand_more,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             int orderId = completedList.orderid ?? 0;
//                             expandedItems[orderId] =
//                                 !(expandedItems[orderId] ?? false);
//                             //expandedItems[completedList.orderid] = !(expandedItems[completedList.orderid] ?? false);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(width: 4),
//           Expanded(
//             // Ensures text wraps instead of overflowing
//             child: Text(
//               value,
//               overflow: TextOverflow.ellipsis, // Prevents overflow
//               softWrap: true, // Allows wrapping
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildInfoRow(String title, String value) {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //     children: [
//   //       Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//   //       Text(value),
//   //     ],
//   //   );
//   // }
//
//---------------------------main----------------------------------------
// import 'dart:async';
// import 'dart:convert'; // Added for JSON handling
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// // import 'package:rdc_concrete/component/custom_elevated_button.dart';
// // import 'package:intl/intl.dart';
// // import 'package:rdc_concrete/screens/additional_info_form.dart';
// // import 'package:rdc_concrete/screens/po_insert_form.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:slide_to_act/slide_to_act.dart';
//
// import '../component/drawer.dart';
// import '../core/network/api_client.dart';
// import '../models/moisture_qa_pojo.dart';
// import '../models/vendor_transaction_pojo.dart';
// import '../services/rdc_suppor_api_service.dart';
// import '../services/vendor_transaction_api_service.dart';
// import '../src/generated/l10n/app_localizations.dart';
// import '../utils/session_manager.dart';
// import 'map_mobile_to_vendor_profile.dart';
// import 'map_tm.dart';
//
// class QaHomeScreen extends StatefulWidget {
//   final int? uid;
//   final int? locationid;
//   //final int? poid;
//   final String? itemname;
//   final String? role;
//   final String? uname;
//   final String? sitename;
//   final String? umobile;
//   const QaHomeScreen({
//     super.key,
//     this.uid,
//     this.itemname,
//     required this.role,
//     this.uname,
//     this.sitename,
//     this.umobile,
//     this.locationid,
//   });
//
//   @override
//   State<QaHomeScreen> createState() => _QaHomeScreen();
// }
//
// class _QaHomeScreen extends State<QaHomeScreen>
//     with SingleTickerProviderStateMixin {
//   bool isExpanded = false;
//   bool isExpandedC = false;
//   bool _isLoading = true;
//   late AnimationController _controller;
//   double progress = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     print("12345676543${widget.umobile}");
//     print("12345676543${widget.sitename}");
//     SessionManager.checkAutoLogoutOnce();
//     SessionManager.scheduleMidnightLogout(context);
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(); // Keep rotating
//
//
//     _simulateLoading();
//     fetchTransactions(widget.umobile.toString());
//     // fetchTransactions1(widget.uid.toString(), widget.poid.toString());
//   }
//
//   void _simulateLoading() {
//     // Simulate data loading process
//     Timer.periodic(Duration(milliseconds: 500), (timer) {
//       if (progress >= 1.0) {
//         timer.cancel();
//         setState(() {
//           _isLoading = false;
//           _controller.stop(); // Stop rotating when loading completes
//         });
//       } else {
//         setState(() {
//           progress += 0.1; // Increment progress
//         });
//       }
//     });
//   }
//
//   List<Activevendor> _activeList = [];
//   List<Completevendor> _completeList = [];
//   List<PendingMoisture> _activeList1 = [];
//   List<CompleteMoisture> _completeList1 = [];
//   Map<int, bool> expandedItems = {};
//
//   Future<void> fetchTransactions(String id) async {
//     setState(() {
//       _isLoading = true;
//     });
//     final service = RdcSupportApiService(); // Updated instantiation
//     try {
//       MoisturePojo? data = await service.getMoistureList(id);
//       if (data != null) {
//         setState(() {
//           _activeList1 = data.pendingmoisture;
//           _completeList1 = data.completemoisture;
//           _isLoading = false; // Stop loader after data comes
//           _controller.stop();
//         });
//       } else {
//         setState(() {
//           _isLoading = false; // Stop loader even if no data
//           _controller.stop();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _controller.stop();
//       });
//       // Optionally show error message
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text('Error fetching transactions: $e')),
//       // );
//     }
//   }
//
//   Future<void> fetchTransactions1(String uid, String poid) async {
//     setState(() {
//       _isLoading = true;
//     });
//     final dio = ApiClient.getDio();
//     final service = VendorTransactionService(dio);
//     try {
//       VendorTransactionList? data = await service.fetchVendorTransaction(
//         uid,
//         poid,
//       );
//       if (data != null) {
//         setState(() {
//           _activeList = data.activeVendor;
//           _completeList = data.completeVendor;
//           _isLoading = false;
//           _controller.stop();
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _controller.stop();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _controller.stop();
//       });
//     }
//   }
//
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle = TextStyle(fontSize: 21);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text('On Road Orders', style: optionStyle),
//     Text('Complete Orders', style: optionStyle),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final drawerItems = [
//       DrawerItem(
//         title: "Map TM (RFID)",
//         icon: Icons.credit_card_sharp,
//         screen: MapTm(
//           uid: widget.uid,
//           sitename: widget.sitename,
//           locationid: widget.locationid,
//         ),
//       ),
//       DrawerItem(
//         title: AppLocalizations.of(context)!.share,
//         icon: Icons.share,
//         onTap: () {
//           Share.share(
//             'Check out this amazing app: [https://example.com/RDC Concrete_application]',
//           );
//         },
//       ),
//       DrawerItem(
//         title: AppLocalizations.of(context)!.logout,
//         icon: Icons.logout,
//         onTap: () async {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.clear();
//           Get.offAll(() => const SelectProfile());
//         },
//       ),
//     ];
//
//     final primaryColor = Theme.of(context).primaryColor;
//
//     return PopScope(
//       canPop: widget.role == "ADMIN" || widget.role == "Admin",
//       onPopInvoked: (bool didPop) {
//         if (!didPop) {
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //     SnackBar(content: Text("You don't have permission to go back."))
//           // );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: primaryColor,
//           centerTitle: true,
//           title: Text(
//             'RDC Concrete',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//         drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(0, 0, 0, 0.5),
//                 image: DecorationImage(
//                   image: AssetImage("assets/bg_image/RDC.png"),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                     Color.fromRGBO(0, 0, 0, 0.3),
//                     BlendMode.dstATop,
//                   ),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Center(
//                   child: _selectedIndex == 0
//                       ? buildOnRoadOrdersList()
//                       : _selectedIndex == 1
//                       ? buildCompleteOrdersList()
//                       : _widgetOptions.elementAt(_selectedIndex),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.handshake),
//               label: 'On Road Orders',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.business),
//               label: 'Complete Orders',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: primaryColor,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }
//
//   Widget buildOnRoadOrdersList() {
//     final primaryColor = Theme.of(context).primaryColor;
//     if (_isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Colors.green,
//           ),
//         ),
//       );
//     }
//     return Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: _activeList1.length,
//           itemBuilder: (context, index) {
//             final activeList = _activeList1[index];
//             return Card(
//               elevation: 5,
//               margin: EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${activeList.itemname} (${activeList.vehicleno})',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       setState(() {
//                         int orderId = activeList.orderid ?? 0;
//                         expandedItems[orderId] =
//                         !(expandedItems[orderId] ?? false);
//                       });
//                     },
//                   ),
//                   if (expandedItems[activeList.orderid] ?? false)
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         children: [
//                           Divider(thickness: 1, color: Colors.green),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'PO Number',
//                             activeList.ponumber.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Number 1',
//                             activeList.challanno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Vehicle Number',
//                             activeList.vehicleno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Driver Name',
//                             activeList.drivername.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Site Name',
//                             activeList.sitename.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 1',
//                             '${activeList.challanno} kg',
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 2',
//                             '${activeList.netweight} kg',
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Royalty Pass',
//                             activeList.orderid.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Last Action',
//                             activeList.sitename.toString(),
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: 55,
//                                 width: 55,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).primaryColor,
//                                   border: Border.all(color: primaryColor),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           expandedItems[activeList.orderid] ?? false
//                               ? Icons.expand_less
//                               : Icons.expand_more,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             int orderId = activeList.orderid ?? 0;
//                             expandedItems[orderId] =
//                             !(expandedItems[orderId] ?? false);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget buildCompleteOrdersList() {
//     if (_isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Colors.green,
//           ),
//         ),
//       );
//     }
//     return Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: _completeList1.length,
//           itemBuilder: (context, index) {
//             final completedList = _completeList1[index];
//             return Card(
//               elevation: 5,
//               margin: EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${completedList.itemname} (${completedList.vehicleno})',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       setState(() {
//                         int orderId = completedList.orderid ?? 0;
//                         expandedItems[orderId] =
//                         !(expandedItems[orderId] ?? false);
//                       });
//                     },
//                   ),
//                   if (expandedItems[completedList.orderid] ?? false)
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         children: [
//                           Divider(thickness: 1, color: Colors.green),
//                           _buildInfoRow('Order Status', "Completed"),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'PO Number',
//                             completedList.ponumber.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Number 1',
//                             completedList.challanno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Number 2',
//                             completedList.challanno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Vehicle Number',
//                             completedList.vehicleno.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Driver Name',
//                             completedList.drivername.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Site Name',
//                             completedList.sitename.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 1',
//                             completedList.netweight.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 2',
//                             completedList.netweight.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Royalty Pass',
//                             completedList.orderid.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Last Action',
//                             completedList.sitename.toString(),
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [],
//                           ),
//                         ],
//                       ),
//                     ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           expandedItems[completedList.orderid] ?? false
//                               ? Icons.expand_less
//                               : Icons.expand_more,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             int orderId = completedList.orderid ?? 0;
//                             expandedItems[orderId] =
//                             !(expandedItems[orderId] ?? false);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               value,
//               overflow: TextOverflow.ellipsis,
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:slide_to_act/slide_to_act.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../component/drawer.dart';
// import '../core/network/api_client.dart';
import '../models/moisture_qa_pojo.dart';
//import '../models/vendor_transaction_pojo.dart';
import '../services/rdc_suppor_api_service.dart';
//import '../services/vendor_transaction_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';
//import 'map_mobile_to_vendor_profile.dart';
import 'map_tm.dart';
import 'select_profile.dart';

class QaHomeScreen extends StatefulWidget {
  final int? uid;
  final int? locationid;
  final String? itemname;
  final String? role;
  final String? uname;
  final String? sitename;
  final String? umobile;
  const QaHomeScreen({
    super.key,
    this.uid,
    this.itemname,
    required this.role,
    this.uname,
    this.sitename,
    this.umobile,
    this.locationid,
  });

  @override
  State<QaHomeScreen> createState() => _QaHomeScreen();
}

class _QaHomeScreen extends State<QaHomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String? _umobile;

  //List<Activevendor> _activeList = [];
  // List<Completevendor> _completeList = [];
  List<PendingMoisture> _activeList1 = [];
  List<CompleteMoisture> _completeList1 = [];
  Map<int, bool> expandedItems = {};

  @override
  void initState() {
    super.initState();
    // print("Mobile: ${widget.umobile}");
    // print("Site Name: ${widget.sitename}");
    SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _initializeData();
  }
  Future<void> _initializeData() async {
    // --------------------------------------------------------------
    // 1. Capture context BEFORE any async work
    // --------------------------------------------------------------
    final BuildContext ctx = context;

    // Early exit if widget is already disposed
    if (!mounted) return;

    // --------------------------------------------------------------
    // 2. Load SharedPreferences
    // --------------------------------------------------------------
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _umobile = prefs.getString("umobile") ?? widget.umobile;

    // --------------------------------------------------------------
    // 3. Invalid session → redirect to login
    // --------------------------------------------------------------
    if (_umobile == null || _umobile!.isEmpty) {
      if (!ctx.mounted) return;

      Get.offAll(() => const SelectProfile());
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Session expired. Please log in again.")),
      );
      return;
    }

    // --------------------------------------------------------------
    // 4. Fetch data
    // --------------------------------------------------------------
    await _fetchData();
  }

  Future<void> _fetchData() async {
    // No need to capture context here — we'll pass it from caller or use widget context safely
    setState(() {
      _isLoading = true;
    });

    try {
      await fetchTransactions(_umobile!);
    } catch (e) {
      // --------------------------------------------------------------
      // Use context only if still mounted
      // --------------------------------------------------------------
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data: $e')),
        );
      }
    } finally {
      // --------------------------------------------------------------
      // finally runs even if error occurs — safe to use setState
      // --------------------------------------------------------------
      if (mounted) {
        setState(() {
          _isLoading = false;
          _controller.stop();
        });
        _refreshController.refreshCompleted();
      }
    }
  }
  // Future<void> _initializeData() async {
  //   // Check for saved session data
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _umobile = prefs.getString("umobile") ?? widget.umobile;
  //
  //   if (_umobile == null || _umobile!.isEmpty) {
  //     // Invalid session, redirect to login
  //     if (context.mounted) {
  //       Get.offAll(() => const SelectProfile());
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Session expired. Please log in again.")),
  //       );
  //     }
  //     return;
  //   }
  //
  //   await _fetchData();
  // }
  //
  // Future<void> _fetchData() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     await fetchTransactions(_umobile!);
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error fetching data: $e')),
  //       );
  //     }
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //       _controller.stop();
  //     });
  //     _refreshController.refreshCompleted();
  //   }
  // }

  Future<void> fetchTransactions(String id) async {
    final service = RdcSupportApiService();
    try {
      MoisturePojo? data = await service.getMoistureList(id);
      if (data != null) {
        setState(() {
          _activeList1 = data.pendingmoisture;
          _completeList1 = data.completemoisture;
        });
      }
    } catch (e) {
      throw Exception('Failed to fetch moisture data: $e');
    }
  }

  // Future<void> fetchTransactions1(String uid, String poid) async {
  //   final dio = ApiClient.getDio();
  //   final service = VendorTransactionService(dio);
  //   try {
  //     VendorTransactionList? data = await service.fetchVendorTransaction(uid, poid);
  //     if (data != null) {
  //       setState(() {
  //         _activeList = data.activeVendor;
  //         _completeList = data.completeVendor;
  //       });
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to fetch vendor transactions: $e');
  //   }
  // }

  int _selectedIndex = 0;
 // static const TextStyle optionStyle = TextStyle(fontSize: 21);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      DrawerItem(
        title: "Map TM (RFID)",
        icon: Icons.credit_card_sharp,
        screen: MapTm(
          uid: widget.uid,
          sitename: widget.sitename,
          locationid: widget.locationid,
        ),
      ),
      DrawerItem(
        title: AppLocalizations.of(context)!.share,
        icon: Icons.share,
        onTap: () {
          Share.share(
            'Check out this amazing app: [https://example.com/RDC Concrete_application]',
          );
        },
      ),
      DrawerItem(
        title: AppLocalizations.of(context)!.logout,
        icon: Icons.logout,
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Get.offAll(() => const SelectProfile());
        },
      ),
    ];

    final primaryColor = Theme.of(context).primaryColor;

    return PopScope(
      // canPop: widget.role == "ADMIN" || widget.role == "Admin",
      // onPopInvoked: (bool didPop) {
      //   if (!didPop) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("You don't have permission to go back.")),
      //     );
      //   }
      // },
      canPop: widget.role == "ADMIN" || widget.role == "Admin",
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You don't have permission to go back.")),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            'RDC Concrete',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
        body: Stack(
          children: [
            Container(
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
              child: _isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading Orders...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
                  : SmartRefresher(
                controller: _refreshController,
                onRefresh: _fetchData,
                header: WaterDropHeader(),
                child: SingleChildScrollView(
                  child: Center(
                    child: _selectedIndex == 0
                        ? buildOnRoadOrdersList()
                        : buildCompleteOrdersList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake),
              label: 'On Road Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Complete Orders',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget buildOnRoadOrdersList() {
    if (_activeList1.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No On Road Orders Available',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _fetchData,
            //   child: Text('Retry'),
            // ),
          ],
        ),
      );
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _activeList1.length,
          itemBuilder: (context, index) {
            final activeList = _activeList1[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${activeList.itemname} (${activeList.vehicleno})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        int orderId = activeList.orderid;
                        expandedItems[orderId] = !(expandedItems[orderId] ?? false);
                      });
                    },
                  ),
                  if (expandedItems[activeList.orderid] ?? false)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Divider(thickness: 1, color: Colors.green),
                          SizedBox(height: 8),
                          _buildInfoRow('PO Number', activeList.ponumber.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Chalan Number', activeList.challanno.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Vehicle Number', activeList.vehicleno.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Driver Name', activeList.drivername.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Site Name', activeList.sitename.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Chalan Weight', '${activeList.netweight} kg'),
                          SizedBox(height: 8),
                          _buildInfoRow('Royalty Pass', activeList.orderid.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Last Action', activeList.sitename.toString()),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          expandedItems[activeList.orderid] ?? false
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        onPressed: () {
                          setState(() {
                            int orderId = activeList.orderid;
                            expandedItems[orderId] = !(expandedItems[orderId] ?? false);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildCompleteOrdersList() {
    if (_completeList1.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Complete Orders Available',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            // SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _fetchData,
            //   child: Text('Retry'),
            // ),
          ],
        ),
      );
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _completeList1.length,
          itemBuilder: (context, index) {
            final completedList = _completeList1[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${completedList.itemname} (${completedList.vehicleno})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        int orderId = completedList.orderid;
                        expandedItems[orderId] = !(expandedItems[orderId] ?? false);
                      });
                    },
                  ),
                  if (expandedItems[completedList.orderid] ?? false)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Divider(thickness: 1, color: Colors.green),
                          _buildInfoRow('Order Status', "Completed"),
                          SizedBox(height: 8),
                          _buildInfoRow('PO Number', completedList.ponumber.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Chalan Number', completedList.challanno.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Vehicle Number', completedList.vehicleno.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Driver Name', completedList.drivername.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Site Name', completedList.sitename.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Chalan Weight', '${completedList.netweight} kg'),
                          SizedBox(height: 8),
                          _buildInfoRow('Royalty Pass', completedList.orderid.toString()),
                          SizedBox(height: 8),
                          _buildInfoRow('Last Action', completedList.sitename.toString()),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [],
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          expandedItems[completedList.orderid] ?? false
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        onPressed: () {
                          setState(() {
                            int orderId = completedList.orderid;
                            expandedItems[orderId] = !(expandedItems[orderId] ?? false);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}