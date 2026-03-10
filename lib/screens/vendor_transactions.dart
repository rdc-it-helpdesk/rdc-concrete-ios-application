// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import 'package:rdc_concrete/screens/po_insert_form.dart';
//
// import '../core/network/api_client.dart';
// import '../models/vendor_transaction_pojo.dart';
// import '../services/vendor_transaction_api_service.dart';
// import '../utils/session_manager.dart';
//
// class VendorTransactions extends StatefulWidget {
//   final int? uid;
//   final int? poid;
//   final int? uprofileid;
//   final String? itemname;
//   final String? role;
//   final String? uname;
//   final String? availableQty;
//   const VendorTransactions({
//     super.key,
//     this.uid,
//     this.poid,
//     this.itemname,
//     required this.role,
//     this.uname,
//     this.uprofileid,
//     this.availableQty,
//   });
//
//   @override
//   State<VendorTransactions> createState() => _VendorTransactionsState();
// }
//
// class _VendorTransactionsState extends State<VendorTransactions>
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
//     SessionManager.scheduleMidnightLogout(context);
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(); // Keep rotating
//
//    // _simulateLoading();
//
//     fetchTransactions(widget.uid.toString(), widget.poid.toString());
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
//   Map<int, bool> expandedItems = {};
//   Future<void> fetchTransactions(String uid, String poid) async {
//     //print("pppp${widget.poid}");
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
//         });
//       } else {
//         //print("Failed to fetch data");
//       }
//     } catch (e) {
//       //print("Error fetching data: $e");
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
//     final primaryColor = Theme.of(context).primaryColor;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         title: Text(
//           'Vendor Transactions',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//
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
//           itemCount: _activeList.length, // Example item count
//           itemBuilder: (context, index) {
//             final activeList = _activeList[index];
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
//                           '${activeList.itemname} (${activeList.vehiclenumber})',
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
//                           _buildInfoRow(
//                             'Order Status',
//                             activeList.orderstatus.toString(),
//                           ),
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
//                             'Chalan Number 2',
//                             activeList.challanNo1.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Vehicle Number',
//                             activeList.vehiclenumber.toString(),
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
//                             '${activeList.netweight} kg',
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Chalan Weight 2',
//                             '${activeList.net1} kg',
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Royalty Pass',
//                             activeList.orderid.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Last Action',
//                             activeList.lastaction.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow('MRN No', activeList.mrnno.toString()),
//
//                           SizedBox(height: 16),
//                           // Row(
//                           //   mainAxisAlignment: MainAxisAlignment.start,
//                           //   children: [
//                           //     Container(
//                           //       height: 55,
//                           //       width: 55,
//                           //       decoration: BoxDecoration(
//                           //         color: Theme.of(context).primaryColor,
//                           //         border: Border.all(color: primaryColor),
//                           //         borderRadius: BorderRadius.circular(12),
//                           //       ),
//                           //       child: IconButton(
//                           //         onPressed: () {
//                           //           // Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalInfoForm( orderid: activeList.orderid.toString(),uid :widget.uid,poid: widget.poid,)));
//                           //           Navigator.push(
//                           //             context,
//                           //             MaterialPageRoute(
//                           //               builder:
//                           //                   (context) => POInsertForm(
//                           //                     uname: widget.uname,
//                           //                     uprofileid: widget.uprofileid,
//                           //                     role: widget.role,
//                           //                     orderid:
//                           //                         activeList.orderid.toString(),
//                           //                     uidvendor: widget.uid,
//                           //                     poidpodetail: widget.poid,
//                           //                     netweight1: activeList.netweight,
//                           //                     netweight2: activeList.net1,
//                           //                     challan1: activeList.challanno,
//                           //                     challan2: activeList.challanNo1,
//                           //                     vno: activeList.vehiclenumber,
//                           //                     drivernamemobilenum:
//                           //                         '${activeList.drivername}(${activeList.drivermobile})',
//                           //                     sitename: activeList.sitename,
//                           //                     itemname: widget.itemname,
//                           //                     availableQty: widget.availableQty,
//                           //                   ),
//                           //             ),
//                           //           );
//                           //         },
//                           //         icon: Icon(Icons.edit),
//                           //         color: Colors.white,
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
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
//     // final primaryColor = Theme.of(context).primaryColor;
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
//           itemCount: _completeList.length,
//           //  itemCount: 1, // Example item count
//           itemBuilder: (context, index) {
//             final completedList = _completeList[index];
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
//                           '${completedList.itemname} (${completedList.vehiclenumber})',
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
//                             completedList.challanNo1.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Vehicle Number',
//                             completedList.vehiclenumber.toString(),
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
//                             completedList.net1.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Royalty Pass',
//                             completedList.orderid.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'Last Action',
//                             completedList.lastaction.toString(),
//                           ),
//                           SizedBox(height: 8),
//                           _buildInfoRow(
//                             'MRN No',
//                             completedList.mrnno.toString(),
//                           ),
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
//           Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
// }
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:rdc_concrete/screens/po_insert_form.dart';
import '../core/network/api_client.dart';
import '../models/vendor_transaction_pojo.dart';
import '../services/vendor_transaction_api_service.dart';
import '../utils/session_manager.dart';

class VendorTransactions extends StatefulWidget {
  final int? uid;
  final int? poid;
  final int? uprofileid;
  final String? itemname;
  final String? role;
  final String? uname;
  final String? availableQty;
  const VendorTransactions({
    super.key,
    this.uid,
    this.poid,
    this.itemname,
    required this.role,
    this.uname,
    this.uprofileid,
    this.availableQty,
  });

  @override
  State<VendorTransactions> createState() => _VendorTransactionsState();
}

class _VendorTransactionsState extends State<VendorTransactions>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool isExpandedC = false;
  bool _isLoading = true;
  late AnimationController _controller;
  List<Activevendor> _activeList = [];
  List<Completevendor> _completeList = [];
  Map<int, bool> expandedItems = {};

  @override
  void initState() {
    super.initState();
    SessionManager.scheduleMidnightLogout(context);
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Keep rotating

    fetchTransactions(widget.uid.toString(), widget.poid.toString());
  }

  Future<void> fetchTransactions(String uid, String poid) async {
    setState(() {
      _isLoading = true; // Ensure loading is true at the start
    });

    final dio = ApiClient.getDio();
    final service = VendorTransactionService(dio);
    try {
      VendorTransactionList? data = await service.fetchVendorTransaction(uid, poid);
      setState(() {
        _isLoading = false; // Set loading to false after API call
        _controller.stop(); // Stop the animation
        if (data != null) {
          _activeList = data.activeVendor;
          _completeList = data.completeVendor;
        } else {
          _activeList = [];
          _completeList = [];
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false even on error
        _controller.stop(); // Stop the animation
      });
      //print("Error fetching data: $e");
    }
  }

  int _selectedIndex = 0;
  // static const TextStyle optionStyle = TextStyle(fontSize: 21);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text('On Road Orders', style: optionStyle),
  //   Text('Complete Orders', style: optionStyle),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Vendor Transactions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
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
            child: SingleChildScrollView(
              child: Center(
                child: _isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
                    : _selectedIndex == 0
                    ? buildOnRoadOrdersList()
                    : buildCompleteOrdersList(),
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
    );
  }

  Widget buildOnRoadOrdersList() {
    //final primaryColor = Theme.of(context).primaryColor;
    if (_activeList.isEmpty) {
      return Center(child: Text("No active transactions available"));
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _activeList.length,
          itemBuilder: (context, index) {
            final activeList = _activeList[index];
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
                          '${activeList.itemname} (${activeList.vehiclenumber})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        int orderId = activeList.orderid ?? 0;
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
                          _buildInfoRow('Order Status', activeList.orderstatus.toString()),
                          _buildInfoRow('PO Number', activeList.ponumber.toString()),
                          _buildInfoRow('Chalan Number 1', activeList.challanno.toString()),
                          _buildInfoRow('Chalan Number 2', activeList.challanNo1.toString()),
                          _buildInfoRow('Vehicle Number', activeList.vehiclenumber.toString()),
                          _buildInfoRow('Driver Name', activeList.drivername.toString()),
                          _buildInfoRow('Site Name', activeList.sitename.toString()),
                          _buildInfoRow('Chalan Weight 1', '${activeList.netweight} kg'),
                          _buildInfoRow('Chalan Weight 2', '${activeList.net1} kg'),
                          _buildInfoRow('Royalty Pass', activeList.orderid.toString()),
                          _buildInfoRow('Last Action', activeList.lastaction.toString()),
                          _buildInfoRow('MRN No', activeList.mrnno.toString()),
                          SizedBox(height: 16),
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
                            int orderId = activeList.orderid ?? 0;
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
    if (_completeList.isEmpty) {
      return Center(child: Text("No completed transactions available"));
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _completeList.length,
          itemBuilder: (context, index) {
            final completedList = _completeList[index];
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
                          '${completedList.itemname} (${completedList.vehiclenumber})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        int orderId = completedList.orderid ?? 0;
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
                          _buildInfoRow('PO Number', completedList.ponumber.toString()),
                          _buildInfoRow('Chalan Number 1', completedList.challanno.toString()),
                          _buildInfoRow('Chalan Number 2', completedList.challanNo1.toString()),
                          _buildInfoRow('Vehicle Number', completedList.vehiclenumber.toString()),
                          _buildInfoRow('Driver Name', completedList.drivername.toString()),
                          _buildInfoRow('Site Name', completedList.sitename.toString()),
                          _buildInfoRow('Chalan Weight 1', completedList.netweight.toString()),
                          _buildInfoRow('Chalan Weight 2', completedList.net1.toString()),
                          _buildInfoRow('Royalty Pass', completedList.orderid.toString()),
                          _buildInfoRow('Last Action', completedList.lastaction.toString()),
                          _buildInfoRow('MRN No', completedList.mrnno.toString()),
                          SizedBox(height: 16),
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
                            int orderId = completedList.orderid ?? 0;
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
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
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