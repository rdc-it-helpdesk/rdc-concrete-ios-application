// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:rdc_concrete/component/custom_elevated_button.dart';
//
// import 'package:rdc_concrete/screens/vendor_transactions.dart';
// import 'package:rdc_concrete/screens/po_insert_form.dart';
//
// import '../core/network/api_client.dart';
// import '../models/fetch_po_pojo.dart';
// import '../services/fetch_po_api_service.dart';
// import '../src/generated/l10n/app_localizations.dart';
// import '../utils/session_manager.dart';
//
// class PODetails extends StatefulWidget {
//   final dynamic ponumberId; // Nullable
//   final String? sitename; // Nullable
//   final int? uid;
//   final int? locationid;
//   final String? itemname; // Nullable
//   final String? role;
//   final String? uname;
//   final String? availableQty;
//   final int? uprofileid;
//
//   const PODetails({
//     super.key,
//     this.ponumberId,
//     this.sitename,
//     this.uid,
//     this.itemname,
//     this.role,
//     this.locationid,
//     this.uname,
//     this.uprofileid,
//     this.availableQty,
//   });
//
//   @override
//   State<PODetails> createState() => _PODetailsState();
// }
//
// class _PODetailsState extends State<PODetails>
//     with SingleTickerProviderStateMixin {
//   List<Mapped> mappedList = [];
//   bool _isLoading = true;
//   late AnimationController _controller;
//   dynamic _previousPonumberId; // Track previous ponumberId for state comparison
//
//   String sanitizeText(String? text) => text?.replaceAll(RegExp(r'[^\x20-\x7E]'), '') ?? 'N/A';
//
//   @override
//   void initState() {
//     super.initState();
//     print("initState: ponumberId=${widget.ponumberId}, sitename=${widget.sitename}, uid=${widget.uid}");
//     _previousPonumberId = widget.ponumberId; // Initialize previous ponumberId
//     SessionManager.scheduleMidnightLogout(context);
//     fetchPOData(widget.sitename.toString());
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     print("didChangeDependencies: ponumberId=${widget.ponumberId}, previousPonumberId=$_previousPonumberId, mappedList length=${mappedList.length}");
//     // Force refresh if ponumberId changes or data is empty/stale
//     if (mappedList.isEmpty || widget.ponumberId != _previousPonumberId) {
//       mappedList.clear(); // Clear stale data
//       fetchPOData(widget.sitename.toString());
//       _previousPonumberId = widget.ponumberId; // Update previous ponumberId
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     mappedList.clear(); // Clear data when disposing to prevent stale state
//     super.dispose();
//   }
//
//   Future<void> fetchPOData(String sitename) async {
//     print("fetchPOData: Starting with sitename=$sitename");
//     setState(() => _isLoading = true);
//     try {
//       final dio = ApiClient.getDio();
//       final service = FetchsitepolistService(dio);
//       print("fetchPOData: Calling API with sitename=$sitename");
//       final data = await service.fetchFetchsitepolist(sitename);
//       print("fetchPOData: API response raw data=$data");
//       if (data != null && data.mapped.isNotEmpty) {
//         setState(() {
//           mappedList = data.mapped.where((item) => item.ponumberId == widget.ponumberId).toList();
//           _isLoading = false;
//           _controller.stop();
//         });
//         print("fetchPOData: Filtered mappedList=$mappedList");
//       } else {
//         print("fetchPOData: No data or empty mapped list received");
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       print("fetchPOData: Error occurred - $e");
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Widget _buildInfoRow(String title, String? value) {
//     print("buildInfoRow: title=$title, value=$value");
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
//         Flexible(child: Text(sanitizeText(value), overflow: TextOverflow.ellipsis, softWrap: true)),
//       ],
//     );
//   }
//
//   Widget _buildDivider() {
//     return Divider(color: Colors.grey.shade200);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("build: _isLoading=$_isLoading, mappedList length=${mappedList.length}");
//     final primaryColor = Theme.of(context).primaryColor;
//
//     return WillPopScope(
//       onWillPop: () async {
//         // Clear state and refresh when popping back
//         mappedList.clear();
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: primaryColor,
//           centerTitle: true,
//           title: Text(
//             AppLocalizations.of(context)!.pO_Details,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//         resizeToAvoidBottomInset: false,
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
//             ),
//             if (_isLoading)
//               Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//                 ),
//               ),
//             SingleChildScrollView(
//               child: Card(
//                 elevation: 5,
//                 margin: EdgeInsets.all(8),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       if (mappedList.isEmpty && !_isLoading) ...[
//                         Center(
//                           child: Text(
//                             'No data available',
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                         ),
//                       ] else if (mappedList.isNotEmpty) ...[
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.pO_Number,
//                           mappedList.first.ponumber,
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.pO_Generate_Date,
//                           mappedList.first.poCreationTime,
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.issue_Quality,
//                           mappedList.first.issueQty.toString(),
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.available_Quality,
//                           mappedList.first.availableQty.toString(),
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.address,
//                           mappedList.first.siteName,
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.line_ID_No,
//                           mappedList.first.lineId.toString(),
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.need_By,
//                           mappedList.first.needByDt,
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.ship_To,
//                           mappedList.first.shipTo,
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.bill_to,
//                           mappedList.first.billTo,
//                         ),
//                         SizedBox(height: 8),
//                         _buildDivider(),
//                         _buildInfoRow(
//                           AppLocalizations.of(context)!.created_By,
//                           mappedList.first.createdId.toString(),
//                         ),
//                         SizedBox(height: 8),
//                       ],
//                       ElevatedButton(
//                         onPressed: () => fetchPOData(widget.sitename.toString()),
//                         child: Text('Refresh'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           CustomElevatedButton(
//                             width: MediaQuery.of(context).size.width * 0.4,
//                             height: 40,
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => VendorTransactions(
//                                     uid: widget.uid,
//                                     poid: widget.ponumberId,
//                                     itemname: widget.itemname,
//                                     role: widget.role,
//                                     uname: widget.uname,
//                                     uprofileid: widget.uprofileid,
//                                     availableQty: widget.availableQty,
//                                   ),
//                                 ),
//                               ).then((_) {
//                                 // Refresh data when returning from VendorTransactions
//                                 if (mounted) {
//                                   mappedList.clear();
//                                   fetchPOData(widget.sitename.toString());
//                                 }
//                               });
//                             },
//                             text: AppLocalizations.of(context)!.transaction_Summary,
//                             popOnPress: false,
//                             backgroundColor: primaryColor,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: _isLoading || mappedList.isEmpty
//             ? null
//             : FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => POInsertForm(
//                   sitename: widget.sitename,
//                   role: widget.role,
//                   uname: widget.uname,
//                   uprofileid: widget.uprofileid,
//                   uid: widget.uid,
//                   poidpodetail: widget.ponumberId,
//                   vid: mappedList.first.vendorSysId.toString(),
//                   vendoremail: mappedList.first.vendorEmail,
//                   itemname: widget.itemname,
//                   locationid: widget.locationid,
//                   availableQty: widget.availableQty,
//                 ),
//               ),
//             ).then((_) {
//               // Refresh data when returning from POInsertForm
//               if (mounted) {
//                 mappedList.clear();
//                 fetchPOData(widget.sitename.toString());
//               }
//             });
//           },
//           backgroundColor: primaryColor,
//           child: Icon(Icons.edit, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rdc_concrete/component/custom_elevated_button.dart';

import 'package:rdc_concrete/screens/vendor_transactions.dart';
import 'package:rdc_concrete/screens/po_insert_form.dart';

import '../core/network/api_client.dart';
import '../models/fetch_po_pojo.dart';
import '../services/fetch_po_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';

class PODetails extends StatefulWidget {
  final dynamic ponumberId; // Nullable
  final String? sitename; // Nullable
  final int? uid;
  final int? locationid;
  final String? itemname; // Nullable
  final String? role;
  final String? uname;
  final String? availableQty;
  final int? uprofileid;

  const PODetails({
    super.key,
    this.ponumberId,
    this.sitename,
    this.uid,
    this.itemname,
    this.role,
    this.locationid,
    this.uname,
    this.uprofileid,
    this.availableQty,
  });

  @override
  State<PODetails> createState() => _PODetailsState();
}

class _PODetailsState extends State<PODetails>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List<Mapped> mappedList = [];
  bool _isLoading = true;
  late AnimationController _controller;
  dynamic _previousPonumberId; // Track previous ponumberId for state comparison

  String sanitizeText(String? text) => text?.replaceAll(RegExp(r'[^\x20-\x7E]'), '') ?? 'N/A';

  @override
  void initState() {
    super.initState();
    //print("initState: ponumberId=${widget.ponumberId}, sitename=${widget.sitename}, uid=${widget.uid}");
    _previousPonumberId = widget.ponumberId; // Initialize previous ponumberId
    SessionManager.scheduleMidnightLogout(context);
    fetchPOData(widget.sitename.toString());
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //print("App resumed, refreshing data");
      if (mounted) {
        setState(() {
          mappedList.clear();
          _isLoading = true;
        });
        fetchPOData(widget.sitename.toString());
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //print("didChangeDependencies: ponumberId=${widget.ponumberId}, previousPonumberId=$_previousPonumberId, mappedList length=${mappedList.length}");
    // Force refresh if ponumberId changes or data is empty/stale
    if (mappedList.isEmpty || widget.ponumberId != _previousPonumberId) {
      mappedList.clear(); // Clear stale data
      fetchPOData(widget.sitename.toString());
      _previousPonumberId = widget.ponumberId; // Update previous ponumberId
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    mappedList.clear(); // Clear data when disposing to prevent stale state
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }

  Future<void> fetchPOData(String sitename) async {
    //print("fetchPOData: Starting with sitename=$sitename");
    setState(() => _isLoading = true);
    try {
      final dio = ApiClient.getDio();
      final service = FetchsitepolistService(dio);
      //print("fetchPOData: Calling API with sitename=$sitename");
      final data = await service.fetchFetchsitepolist(sitename);
      //print("fetchPOData: API response raw data=$data");
      if (data != null && data.mapped.isNotEmpty) {
        setState(() {
          mappedList = data.mapped.where((item) => item.ponumberId == widget.ponumberId).toList();
          _isLoading = false;
          _controller.stop();
        });
        //print("fetchPOData: Filtered mappedList=$mappedList");
      } else {
        //print("fetchPOData: No data or empty mapped list received");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      //print("fetchPOData: Error occurred - $e");
      setState(() => _isLoading = false);
    }
  }

  Widget _buildInfoRow(String title, String? value) {
    //print("buildInfoRow: title=$title, value=$value");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
        Flexible(child: Text(sanitizeText(value), overflow: TextOverflow.ellipsis, softWrap: true)),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200);
  }

  @override
  Widget build(BuildContext context) {
    //print("build: _isLoading=$_isLoading, mappedList length=${mappedList.length}");
    final primaryColor = Theme.of(context).primaryColor;
    return PopScope(
      canPop: true, // Allow pop by default
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          // This runs *after* the page is popped
          mappedList.clear();
          // Optionally refresh parent if needed
          // fetchPOData(widget.sitename.toString());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.pO_Details,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        resizeToAvoidBottomInset: false,
        body: RepaintBoundary(
          child: Stack(
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if (mappedList.isEmpty && !_isLoading) ...[
                          Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ] else if (mappedList.isNotEmpty) ...[
                          _buildInfoRow(
                            AppLocalizations.of(context)!.pO_Number,
                            mappedList.first.ponumber,
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.pO_Generate_Date,
                            mappedList.first.poCreationTime,
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.issue_Quality,
                            mappedList.first.issueQty.toString(),
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.available_Quality,
                            mappedList.first.availableQty.toString(),
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.address,
                            mappedList.first.siteName,
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.line_ID_No,
                            mappedList.first.lineId.toString(),
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.need_By,
                            mappedList.first.needByDt,
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.ship_To,
                            mappedList.first.shipTo,
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.bill_to,
                            mappedList.first.billTo,
                          ),
                          SizedBox(height: 8),
                          _buildDivider(),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.created_By,
                            mappedList.first.createdId.toString(),
                          ),
                          SizedBox(height: 8),
                        ],
                        // ElevatedButton(
                        //   onPressed: () => fetchPOData(widget.sitename.toString()),
                        //   child: Text('Refresh'),
                        // ),
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
                                    builder: (context) => VendorTransactions(
                                      uid: widget.uid,
                                      poid: widget.ponumberId,
                                      itemname: widget.itemname,
                                      role: widget.role,
                                      uname: widget.uname,
                                      uprofileid: widget.uprofileid,
                                      availableQty: widget.availableQty,
                                    ),
                                  ),
                                ).then((_) {
                                  // Refresh data when returning from VendorTransactions
                                  if (mounted) {
                                    mappedList.clear();
                                    fetchPOData(widget.sitename.toString());
                                  }
                                });
                              },
                              text: AppLocalizations.of(context)!.transaction_Summary,
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
        ),
        floatingActionButton: _isLoading || mappedList.isEmpty
            ? null
            : FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => POInsertForm(
                  sitename: widget.sitename,
                  role: widget.role,
                  uname: widget.uname,
                  uprofileid: widget.uprofileid,
                  uid: widget.uid,
                  poidpodetail: widget.ponumberId,
                  vid: mappedList.first.vendorSysId.toString(),
                  vendoremail: mappedList.first.vendorEmail,
                  itemname: widget.itemname,
                  locationid: widget.locationid,
                  availableQty: widget.availableQty,
                ),
              ),
            ).then((_) {
              // Refresh data when returning from POInsertForm
              if (mounted) {
                mappedList.clear();
                fetchPOData(widget.sitename.toString());
              }
            });
          },
          backgroundColor: primaryColor,
          child: Icon(Icons.edit, color: Colors.white),
        ),
      ),
    );
    // return WillPopScope(
    //   onWillPop: () async {
    //     // Clear state and refresh when popping back
    //     mappedList.clear();
    //     return true;
    //   },
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: primaryColor,
    //       centerTitle: true,
    //       title: Text(
    //         AppLocalizations.of(context)!.pO_Details,
    //         style: TextStyle(
    //           fontSize: 24,
    //           fontWeight: FontWeight.bold,
    //           color: Colors.white,
    //         ),
    //       ),
    //       iconTheme: IconThemeData(color: Colors.white),
    //     ),
    //     resizeToAvoidBottomInset: false,
    //     body: RepaintBoundary(
    //       child: Stack(
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
    //           ),
    //           if (_isLoading)
    //             Center(
    //               child: CircularProgressIndicator(
    //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    //               ),
    //             ),
    //           SingleChildScrollView(
    //             child: Card(
    //               elevation: 5,
    //               margin: EdgeInsets.all(8),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child: Column(
    //                   children: [
    //                     if (mappedList.isEmpty && !_isLoading) ...[
    //                       Center(
    //                         child: Text(
    //                           'No data available',
    //                           style: TextStyle(fontSize: 18, color: Colors.grey),
    //                         ),
    //                       ),
    //                     ] else if (mappedList.isNotEmpty) ...[
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.pO_Number,
    //                         mappedList.first.ponumber,
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.pO_Generate_Date,
    //                         mappedList.first.poCreationTime,
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.issue_Quality,
    //                         mappedList.first.issueQty.toString(),
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.available_Quality,
    //                         mappedList.first.availableQty.toString(),
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.address,
    //                         mappedList.first.siteName,
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.line_ID_No,
    //                         mappedList.first.lineId.toString(),
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.need_By,
    //                         mappedList.first.needByDt,
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.ship_To,
    //                         mappedList.first.shipTo,
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.bill_to,
    //                         mappedList.first.billTo,
    //                       ),
    //                       SizedBox(height: 8),
    //                       _buildDivider(),
    //                       _buildInfoRow(
    //                         AppLocalizations.of(context)!.created_By,
    //                         mappedList.first.createdId.toString(),
    //                       ),
    //                       SizedBox(height: 8),
    //                     ],
    //                     // ElevatedButton(
    //                     //   onPressed: () => fetchPOData(widget.sitename.toString()),
    //                     //   child: Text('Refresh'),
    //                     // ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                       children: [
    //                         CustomElevatedButton(
    //                           width: MediaQuery.of(context).size.width * 0.4,
    //                           height: 40,
    //                           onPressed: () {
    //                             Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                 builder: (context) => VendorTransactions(
    //                                   uid: widget.uid,
    //                                   poid: widget.ponumberId,
    //                                   itemname: widget.itemname,
    //                                   role: widget.role,
    //                                   uname: widget.uname,
    //                                   uprofileid: widget.uprofileid,
    //                                   availableQty: widget.availableQty,
    //                                 ),
    //                               ),
    //                             ).then((_) {
    //                               // Refresh data when returning from VendorTransactions
    //                               if (mounted) {
    //                                 mappedList.clear();
    //                                 fetchPOData(widget.sitename.toString());
    //                               }
    //                             });
    //                           },
    //                           text: AppLocalizations.of(context)!.transaction_Summary,
    //                           popOnPress: false,
    //                           backgroundColor: primaryColor,
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     floatingActionButton: _isLoading || mappedList.isEmpty
    //         ? null
    //         : FloatingActionButton(
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => POInsertForm(
    //               sitename: widget.sitename,
    //               role: widget.role,
    //               uname: widget.uname,
    //               uprofileid: widget.uprofileid,
    //               uid: widget.uid,
    //               poidpodetail: widget.ponumberId,
    //               vid: mappedList.first.vendorSysId.toString(),
    //               vendoremail: mappedList.first.vendorEmail,
    //               itemname: widget.itemname,
    //               locationid: widget.locationid,
    //               availableQty: widget.availableQty,
    //             ),
    //           ),
    //         ).then((_) {
    //           // Refresh data when returning from POInsertForm
    //           if (mounted) {
    //             mappedList.clear();
    //             fetchPOData(widget.sitename.toString());
    //           }
    //         });
    //       },
    //       backgroundColor: primaryColor,
    //       child: Icon(Icons.edit, color: Colors.white),
    //     ),
    //   ),
    // );
  }
}