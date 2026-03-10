import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rdc_concrete/component/custom_elevated_button.dart';
import 'package:intl/intl.dart';
import 'package:rdc_concrete/screens/map_mobile_to_vendor_profile.dart';
import 'package:rdc_concrete/screens/po_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../core/network/api_client.dart';
import '../models/fetch_po_pojo.dart';

import '../services/fetch_po_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';

class FetchPO extends StatefulWidget {
  final int? locationid; // Nullable
  final String? sitename; // Nullable
  final int? uid; // Nullable
  final int? uprofileid; // Nullable
  final String? role;
  final String? uname;

  const FetchPO({
    super.key,
    this.locationid,
    this.sitename,
    this.uid,
    this.role,
    this.uname,
    this.uprofileid,
  });

  @override
  State<FetchPO> createState() => _FetchPOState();
}

class _FetchPOState extends State<FetchPO> with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  bool isSearching = false;
  bool _isLoading = true;
  double progress = 0.0;
  final String _errorMessage = '';
  late AnimationController _controller;
  TextEditingController searchController = TextEditingController();

  bool isExpanded = false;

  void _startSearch() {
    FocusScope.of(context).requestFocus(_focusNode);
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      // filteredNotes = allNotes; // Reset the list when search is canceled
      searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    //print("siteeeeeeeeeeeeeee: ${widget.sitename}");

   // SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
    fetchPOData();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Keep rotating
    // print("role${widget.role}");
    // print("sitename${widget.sitename}");
    // print("role${widget.locationid}");
    //print("uname${widget.uname}");
    // print("role${widget.uprofileid}");
    // print("role${widget.role}");
   // _simulateLoading();
    searchController.addListener(() {
      filterPOList();
    });
  }

  // void _simulateLoading() {
  //   // Simulate data loading process
  //   Timer.periodic(Duration(milliseconds: 500), (timer) {
  //     if (progress >= 1.0) {
  //       timer.cancel();
  //       setState(() {
  //         _isLoading = false;
  //         _controller.stop(); // Stop rotating when loading completes
  //       });
  //     } else {
  //       setState(() {
  //         progress += 0.1; // Increment progress
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  List<Mapped> mappedList = [];
  List<Mapped> _filteredMappedList = [];
  // List<Unmapped> _UnmappedList = [];
  Map<int, bool> expandedItems = {};
  void filterPOList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      _filteredMappedList =
          mappedList.where((mapped) {
            return mapped.ponumber.toLowerCase().contains(
              query,
            ); // Filter based on ponumber
          }).toList();
    });
  }

  Future<void> fetchPOData() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');

    // if (sitename == null) {
      //print("No sitename found in SharedPreferences${sitename}");
      // return;
   // }
    if (sitename == null) {
      setState(() {
        _isLoading = false; // Stop loading even if no data
      });
      return;
    }
    //  print("Fetching users for sitename: $sitename");

    final dio = ApiClient.getDio();
    final service = FetchsitepolistService(dio);
    try {
      // Pass sitename directly

      Fetchsitepolist? data = await service.fetchFetchsitepolist(widget.sitename.toString());
      if (data != null) {
        //print("Data fetched  successfully: ${data.toString()}");

        setState(() {
          mappedList = data.mapped;
          _filteredMappedList = mappedList;
          _isLoading = false;
             _controller.stop();
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      //  print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    // final MappedList = _MappedList[];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        // title: Text('RDC Concrete (India)', style: TextStyle(color: Colors.white),),
        title:
            isSearching
                ? TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.search_PO_Numbar,
                  ),
                  // onChanged: ,
                )
                : Center(
                  child: Text(
                    AppLocalizations.of(context)!.fetch_po,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child:
                isSearching
                    ? IconButton(
                      onPressed: _stopSearch,
                      icon: Icon(Icons.clear),
                    )
                    : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _startSearch,
                    ),
          ),
        ],
      ),

      resizeToAvoidBottomInset: false,
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

            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage("assets/bg_image/RDC.png"),
            //     fit: BoxFit.cover
            //   )
            // ),
          ),
          Positioned.fill(
            top: 85,
            child: SingleChildScrollView(child: Center(child: buildPOList())),
          ),

          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: SizedBox(
              child: Material(
                borderRadius: BorderRadius.circular(25),
                // width: MediaQuery.of(context).size.width * 0.8,
                // width: MediaQuery.of(context).size.width * 0.4,
                child: SlideAction(
                  onSubmit: () {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MapMobileToVendorProfile(
                              sitename: widget.sitename.toString(),

                            ),
                      ),
                    );
                  },
                  sliderButtonIconSize: 19,
                  sliderRotate: true,
                  innerColor: Colors.white,
                  outerColor: Colors.green.shade300,
                  elevation: 3,
                  borderRadius: 25,
                  // alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.new_Vendor_Available_to_Map,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  //  child: Text('New Vendor Available to Map', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPOList() {
    final primaryColor = Theme.of(context).primaryColor;

    // Check if loading
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.green,
          ), // Set the color to green
        ),
      ); // Show loading indicator
    }

    // Check if there is an error message
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ); // Show error message
    }

    // If not loading and no error, show the list
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _filteredMappedList.length, // Example item count
          itemBuilder: (context, index) {
            final mappedList = _filteredMappedList[index];

            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                mappedList.itemName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            // Text(
                            //   "$mappedList.availableQty} KG",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                            Text("${mappedList.availableQty} KG", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              mappedList.siteName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}", // Time
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        expandedItems[mappedList.ponumberId] =
                            !(expandedItems[mappedList.ponumberId] ?? false);
                      });
                    },
                  ),
                  if (expandedItems[mappedList.ponumberId] ?? false)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Divider(thickness: 1, color: Colors.green),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.pO_Number,
                            mappedList.ponumber,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.uOM,
                            mappedList.uom,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.line_ID,
                            mappedList.lineId,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.ship_To,
                            mappedList.shipTo,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.bill_to,
                            mappedList.billTo,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.created_By,
                            mappedList.createdId.toString(),
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.need_By,
                            mappedList.needByDt,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.mapped,
                            mappedList.isMapped,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.mobilenumber,
                            mappedList.mobile,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            AppLocalizations.of(context)!.vendor_Name,
                            mappedList.vendorName,
                          ),

                          // SizedBox(height: 8),
                          // _buildInfoRow('Vendor Name', MappedList.vendorSysId.toString()),

                          // SizedBox(height: 8),
                          // _buildInfoRow('Vendor Name', MappedList.createdId.toString()),
                          //
                          SizedBox(height: 8),
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
                                          (context) => PODetails(
                                            ponumberId:
                                                mappedList
                                                    .ponumberId, // Pass the required record ID
                                            sitename:
                                                mappedList
                                                    .siteName, // Pass the required record ID
                                            uid: widget.uid,
                                            itemname: mappedList.itemName,
                                            locationid: widget.locationid,
                                            role: widget.role,
                                            availableQty: mappedList.availableQty      ,
                                            uname:
                                                widget
                                                    .uname, // Pass the required record ID
                                            uprofileid:
                                                widget
                                                    .uprofileid, // Pass the required record ID
                                          ),
                                    ),
                                  );
                                },
                                text: AppLocalizations.of(context)!.open,
                                popOnPress: false,
                                backgroundColor: primaryColor,
                              ),
                              CustomElevatedButton(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MapMobileToVendorProfile(
                                            sitename:
                                                widget.sitename.toString(),
                                            vendorId: mappedList.vendorId,
                                            createdid: mappedList.vendorSysId,
                                          ),
                                    ),
                                  );
                                },
                                text: AppLocalizations.of(context)!.edit,
                                popOnPress: false,
                                backgroundColor: primaryColor,
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
                          expandedItems[mappedList.ponumberId] ?? false
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        onPressed: () {
                          setState(() {
                            expandedItems[mappedList.ponumberId] =
                                !(expandedItems[mappedList.ponumberId] ??
                                    false);
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

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Flexible(
          child: Text(value, overflow: TextOverflow.ellipsis, softWrap: true),
        ),
      ],
    );
  }
}
