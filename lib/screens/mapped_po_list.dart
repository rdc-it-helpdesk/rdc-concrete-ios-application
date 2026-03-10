import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rdc_concrete/screens/po_insert_form.dart';
import 'package:rdc_concrete/screens/vendor_transactions.dart';

import '../component/custom_elevated_button.dart';

import '../models/vendordt.dart';
import '../services/vendor_info_api_service.dart';
import '../utils/session_manager.dart';

class MappedPoList extends StatefulWidget {
  final dynamic ponumberid;
  // final String? uid;
  final int? uid;
  final int? uprofileid;
  final int? locationid;
  final String? role;
  final String? uname;
  const MappedPoList({
    super.key,
    required this.ponumberid,
    this.uid,
    this.role,
    this.locationid,
    this.uname,
    this.uprofileid,
  });

  @override
  State<MappedPoList> createState() => _MappedPoListState();
}

class _MappedPoListState extends State<MappedPoList>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool _isLoading = true;
  double progress = 0.0;
  final String _errorMessage = '';
  late AnimationController _controller;
  Vendordt? vendorData;
  String? vendorLocation;
  List<PO> poItems = [];
  @override
  // void initState() {
  //   super.initState();
  //   SessionManager.checkAutoLogoutOnce();
  //   SessionManager.scheduleMidnightLogout(context);
  //   fetchVendorData(widget.uid.toString());
  //   _controller = AnimationController(
  //     duration: Duration(seconds: 2),
  //     vsync: this,
  //   )..repeat(); // Keep rotating
  //
  //   _simulateLoading();
  // }
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _simulateLoading();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // only run after widget build
     // await SessionManager.checkAutoLogoutOnce();
      SessionManager.scheduleMidnightLogout(context);
      fetchVendorData(widget.uid.toString());
    });
  }


  void _simulateLoading() {
    // Simulate data loading process
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        setState(() {
          _isLoading = false;
          _controller.stop(); // Stop rotating when loading completes
        });
      } else {
        setState(() {
          progress += 0.1; // Increment progress
        });
      }
    });
  }

  String? currentPonumberid;
  List<PO> mappedList = [];
  // List<Vendordt> mappedList1 = [];
  Future<void> fetchVendorData(String uid) async {
    // final dio = ApiClient.getDio(); // Assuming you have a method to get Dio instance
    // final vendorService = VendorService(dio); // Pass Dio instance to VendorService if needed
    VendorService vendorService = VendorService();
    try {

      Vendordt? data = await vendorService.vendordata(
        uid,
      );
      setState(() {
        // Filter list based on ponumberId
        mappedList =
            data.po
                .where((item) => item.ponumberid == widget.ponumberid)
                .toList();

      });

      // Print the filtered _MappedList
      //print("Filtered Mapped List: $_MappedList");

      // }
      // else {
      // //  print("Failed to fetch data");
      // }
    } catch (e) {
      //  print("Error fetching vendor data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          "Mapped PO list",
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
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.green,
                ), // Set the color to green
              ),
            ),
          // Error message
          if (_errorMessage.isNotEmpty)
            Center(
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ), // Show error message

          SingleChildScrollView(
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (mappedList.isNotEmpty) ...[
                      _buildInfoRow('PO Number', mappedList.first.ponumber),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow(
                        'PO Generate Date',
                        mappedList.first.pocreationtime,
                      ),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow(
                        'Issue Quality',
                        mappedList.first.isuueqty.toString(),
                      ),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow(
                        'Available Quality',
                        mappedList.first.availableqty.toString(),
                      ),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow('Address', mappedList.first.sitename),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow(
                        'Line ID No',
                        mappedList.first.lineid.toString(),
                      ),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow('Need By', mappedList.first.needbydt),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow('Ship To', mappedList.first.shipto),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow('Bill To', mappedList.first.billto),
                      SizedBox(height: 8),
                      _buildDivider(),
                      _buildInfoRow(
                        'Created by',
                        mappedList.first.createdid.toString(),
                      ),
                      SizedBox(height: 8),
                    ] else ...[
                      // Show "No data available" message if the list is empty
                      Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomElevatedButton(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => VendorTransactions(
                                      uid: widget.uid,
                                      poid: widget.ponumberid,
                                      role: '',
                                    ),
                              ),
                            );
                          },
                          text: 'Transaction Summary',
                          popOnPress: false,
                          backgroundColor: primaryColor,
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
      floatingActionButton:  mappedList.isEmpty
          ? null
          :  FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => POInsertForm(
                    role: widget.role,
                    sitename: mappedList.first.sitename.toString(),
                    uid: widget.uid,
                    uname: widget.uname,
                    uprofileid: widget.uprofileid,
                    poidpodetail: mappedList.first.ponumberid,
                    vendoremail: mappedList.first.vemail,
                    itemname: mappedList.first.itemname,
                    locationid: widget.locationid,
                      availableQty: mappedList.first.availableqty,
                 vid: widget.uid.toString(),
                  ),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  // Widget buildCompleteOrdersList() {
  //   final primaryColor = Theme.of(context).primaryColor;
  //
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8),
  //     child: Column(
  //       children: [
  //              Card(
  //               color: Colors.white,
  //               elevation: 5,
  //               margin: EdgeInsets.all(8),
  //               child: Column(
  //                 children: [
  //                   ListTile(
  //                     title: Column(
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text("{po.itemname}", style: TextStyle(fontWeight: FontWeight.bold)),
  //
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text("Ahmedabad", style: TextStyle(fontWeight: FontWeight.bold)),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     subtitle: Row(
  //                       children: [
  //                         Text(
  //                           DateFormat('dd/MM/yyyy').format(DateTime.now()),
  //                           style: TextStyle(fontSize: 12, color: Colors.grey),
  //                         ),
  //                         SizedBox(width: 8),
  //                         Text(
  //                           "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}", // Time
  //                           style: TextStyle(fontSize: 12, color: Colors.grey),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: 5,),
  //                   if (isExpanded)
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 16),
  //                       child: Column(
  //                         children: [
  //                           Divider(thickness: 1, color: Colors.green),
  //                           SizedBox(height: 10,),
  //                           _buildInfoRow('Net Weight', '4611'),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('UOM', 'kg'),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Line ID', 'MH0212TY'),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Ship To', 'Mangalore 1 RMC Plant'),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Bill To', 'Mangalore 1 RMC Plant'),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Created By', '10954'),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Need By', '31/03/25'),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Mobile Number', ''),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Mapped', ''),
  //                           SizedBox(height: 8),
  //                           _buildInfoRow('Vendor Name', ''),
  //                           SizedBox(height: 8,),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                             children: [
  //                               CustomElevatedButton(
  //                                   width: MediaQuery.of(context).size.width * 0.4,
  //                                   height: 40,
  //                                   onPressed: (){
  //                                     Navigator.push(context, MaterialPageRoute(builder: (context) => VendorTransactions()));
  //                                   },
  //                                   text: 'Transaction Summary',
  //                                   backgroundColor: primaryColor,
  //                                 popOnPress: false,
  //                               ),
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
  //                         icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
  //                         onPressed: () {
  //                           setState(() {
  //                             isExpanded = !isExpanded;
  //                             //   isScrolled = isExpandedC; // Update isScrolled when expanded
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //
  //       ],
  //     ),
  //   );
  // }
  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}

Widget _buildDivider() {
  return Divider(color: Colors.grey.shade200);
}
