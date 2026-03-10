import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:rdc_concrete/screens/accept_driver.dart';

import 'package:rdc_concrete/screens/fetch_po.dart';

import 'package:rdc_concrete/screens/map_tm.dart';
import 'package:rdc_concrete/screens/qa_mo_screen.dart';
import 'package:rdc_concrete/screens/select_profile.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../component/custom_alert_dialog.dart';
import '../component/drawer.dart';
import '../core/network/api_client.dart';
import '../models/fetch_dashboard_pojo.dart';
import '../services/fetch_dashboard_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';

class MOHomePage extends StatefulWidget {
  final int locationid;
  final String sitename;
  final int? userid;
  final int? uprofileid;

  final String? uname;
  final String? role;
  const MOHomePage({
    super.key,
    required this.locationid,
    required this.sitename,
    this.userid,
    this.role,
    this.uname,
    this.uprofileid,
  });

  @override
  State<MOHomePage> createState() => _MOHomePageState();
}

class _MOHomePageState extends State<MOHomePage> {
  bool isExpanded = false;
  bool isExpandedC = false;
  bool isExpandedR = false;
  bool isScrolled = true;

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 21);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('On Road Orders', style: optionStyle),
    Text('Complete Orders', style: optionStyle),
    Text('Rejected Orders', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<ActiveMO> _activeMoList = []; // Store active transactions
  List<CanceledMO> _canceledMOList = []; // Store active transactions
  List<CompleteMo> _completeMOList = [];
  Map<int, bool> expandedItems = {};
  @override
  void initState() {
    super.initState();
    SessionManager.checkAutoLogoutOnce();
//    SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
   // print("uprofileid${widget.uprofileid}");
   //  print("locationid${widget.locationid}");
   //  print("userid${widget.userid}");
   //  print("uprofileid${widget.uprofileid}");
   //  print("uname${widget.uname}");


    fetchMaterialOfficerMOData();
  }

  void _showCustomDialog(
    BuildContext context,
    String orderId,
    String ponumber,
    String challanno,
    String challanno1,
    String vehicleno,
    String itemName,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: "Camera not working",
          message: "This is a sample message.",
          confirmText: "Confirm",
          cancelText: "Please try again",
          onConfirm: () {
            //print("User  confirmed with orderId: $orderId");
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AcceptDriver(
                      order: orderId,
                      itemName: itemName,
                      challanno: challanno,
                      challanno1: challanno1,
                      vehicleno: vehicleno,
                      ponumber: ponumber, // Pass the orderId here
                      sitename: widget.sitename, // Ensure it's not null
                      uid: widget.uprofileid,
                      locationid: widget.locationid,
                      uname: widget.uname,
                      role: widget.role, // Ensure it's not null
                      // showDetails: false,
                      // showTruckDetails: false,
                      // showOtpField: false,
                      // showConfirmBox: false,
                    ),
              ),
            );
          },
          onCancel: () {
            Navigator.pop(context);
          },
          confirmColor: primaryColor,
          cancelColor: Colors.redAccent,
        );
      },
    );
  }

  Future<void> fetchMaterialOfficerMOData() async {
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');

    if (sitename == null) {
      //print("No sitename found in SharedPreferences");
      return;
    }

    //print("Fetching users for sitename: $sitename");

    final dio = ApiClient.getDio();
    final service = MaterialOfficerService(dio);
    try {
      // Pass sitename directly
      MaterialOfficerModel? data = await service
          .fetchMaterialOfficerTransaction(sitename);
      if (data != null) {
        //print("Data fetched successfully: ${data.toString()}");

        setState(() {
          _activeMoList = data.activeMO;
          _canceledMOList = data.canceledMO;
          _completeMOList = data.completeMO;
        });
      } else {
        //print("Failed to fetch data");
      }
    } catch (e) {
      //print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      // DrawerItem(
      //   title: "Notification",
      //   icon: Icons.notification_important,
      //   //screen: MOHomePage(locationid: widget.locationid,sitename:widget.sitename),
      // ),
      // DrawerItem(
      //   title: "Weighbridge Status",
      //   icon: Icons.fire_truck_sharp,
      //   screen: WeyBridge(),
      // ),
      DrawerItem(
        title: "Map TM (RFID)",
        icon: Icons.credit_card_sharp,
        screen: MapTm(
          uid: widget.userid,
          sitename: widget.sitename,
          locationid: widget.locationid,
        ),
      ),
      DrawerItem(
        title: AppLocalizations.of(context)!.share,
        icon: Icons.share,
        onTap: () {
          //print('share tile pressed.');
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
      DrawerItem(),
      DrawerItem(),
      DrawerItem(),
    ];

    final primaryColor = Theme.of(context).primaryColor;
    // return PopScope(
    //   canPop: true,
    //   onWillPop: () async {
    //       // Check the role before allowing back navigation
    //       if (widget.role == "ADMIN" || widget.role == "Admin") {
    //         // Allow back navigation
    //         return true;
    //       } else {
    //         // Prevent back navigation and show a message
    //
    //         return false; // Prevent back navigation
    //       }
    //     },
    return PopScope(
      canPop: widget.role == "ADMIN" || widget.role == "Admin",
      // ignore: deprecated_member_use
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("You don't have permission to go back."))
          // );
        }
      },

      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.material_officer,
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
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage("assets/bg_image/RDC.png"),
              //         fit: BoxFit.cover
              //     )
              // ),
            ),

            Positioned.fill(
              top: 85,
              child: SingleChildScrollView(
                child: Center(
                  child:
                      _selectedIndex == 0
                          ? buildOnRoadOrdersList()
                          : _selectedIndex == 1
                          ? buildCompleteOrdersList()
                          : _selectedIndex == 2
                          ? buildRejectedOrdersList()
                          : _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
            ),

            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                // width: MediaQuery.of(context).size.width * 0.4,
                child: SlideAction(
                  onSubmit: () {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FetchPO(
                              locationid: widget.locationid,
                              sitename: widget.sitename,
                              uid: widget.userid,
                              uname: widget.uname,
                              uprofileid: widget.uprofileid,
                              role: widget.role,
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
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.handshake),
              label: AppLocalizations.of(context)!.on_Road_Orders,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.business),
              label: AppLocalizations.of(context)!.complete_Orders,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer_off_outlined),
              label: AppLocalizations.of(context)!.rejected_Orders,
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
    // bool isExpanded = false;
    // final primaryColor = Theme.of(context).primaryColor;
    isExpanded = true;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _activeMoList.length, // Example item count
          itemBuilder: (context, index) {
            final active = _activeMoList[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                3,
                0,
                3,
                2,
              ), // Only top padding of 3.0
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First Column
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 8),
                                // Vendor Name
                                Expanded(
                                  child: Text(
                                    '${active.vehicleNumber} (${active.driverName})', // Dynamically set vendor name
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on, color: Colors.green),
                                SizedBox(width: 8),
                                // Site Name (Address)
                                Expanded(
                                  child: Text(
                                    active.contact,
                                    // active.siteName, // Use sitename from API
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.receipt, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  "PO: ${active.poNumber}", // Use PO number
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  active.actionTime,
                                  //item.actionTime, // Use action time from API
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      // Second Column (Buttons)
                      Expanded(
                        child: Column(
                          children: [
                            // QA/MO Button
                            GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => QaMoScreen(
                                          // showMapTmSection: true,
                                          // showDetails: false,
                                          // showTruckDetails: true,
                                          // showOtpField: false,
                                          // showConfirmBox: false,
                                          sitename: widget.sitename,
                                          vehicleNumber: active.vehicleNumber,
                                          moisture: active.moisture,
                                          itemName: active.itemName,
                                          ponumber: active.poNumber,
                                          challanno: active.challanNo,
                                          challanno1: active.challanno1,
                                          driverName: active.driverName,
                                          driverMobile: active.driverMobile,
                                          actionTime: active.actionTime,
                                          role: widget.role,
                                          oderid: active.orderId,
                                          locationid: widget.locationid,
                                          uid: widget.uprofileid,
                                          // order: item.poNumber.toString(),
                                          // order: order,
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.green.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.fact_check,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Accept Driver Button
                            GestureDetector(
                              onTap: () {
                                _showCustomDialog(
                                  context,
                                  active.orderId.toString(),
                                  active.poNumber.toString(),
                                  active.challanNo,
                                  active.challanno1,
                                  active.vehicleNumber,
                                  active.itemName,
                                ); // Pass the orderId here

                                //  Navigator.push(
                                //    context,
                                //    //MaterialPageRoute(builder: (context) => AcceptDriver(showDetails: true, showTruckDetails: true,)),
                                // //   MaterialPageRoute(builder: (context) => AcceptDriver(showDetails: true, showTruckDetails: true,)),
                                //  );
                              },
                              child: Card(
                                color: Colors.green.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.directions_car,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            // return Card(
            //   color: Colors.white,
            //   elevation: 5,
            //   margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //   child: ListTile(
            //     contentPadding: EdgeInsets.symmetric(horizontal: 16),  /// Padding inside the card
            //     title: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text("Order ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
            //         Text("PO: 405873", style: TextStyle(fontWeight: FontWeight.bold)),
            //       ],
            //     ),
            //     subtitle: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //
            //           children: [
            //             // Icon(Icons.location_pin),
            //             Text("Naveen Enterprise"),
            //           ],
            //         ),
            //
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           // crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             Row(
            //               children: [
            //                 Text(
            //                   DateFormat('dd/MM/yyyy').format(DateTime.now()),
            //                   style: TextStyle(fontSize: 12, color: Colors.grey),
            //                 ),
            //                 SizedBox(width: 8),
            //                 Text(
            //                   "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}", // Time
            //                   style: TextStyle(fontSize: 12, color: Colors.grey),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 IconButton(
            //                     onPressed: (){
            //                       Navigator.push(context, MaterialPageRoute(builder: (context) => ChallanConfirmation()));
            //                     },
            //                     icon: Image.asset("assets/driver.png",
            //                       height: 35,
            //                       width: 35,
            //                       color: Colors.green.shade200,)
            //                 ),
            //                 IconButton(
            //                     onPressed: (){
            //                       Navigator.push(context, MaterialPageRoute(builder: (context) => AcceptDriver(showDetails: true, showTruckDetails: true,)));
            //                     },
            //                     icon: Icon(Icons.list_alt,
            //                       size: 35, color: Colors.green.shade200,)
            //                 ),
            //               ],
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //   ),
            // );
          },
        ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 20.0),
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(Icons.directions_car),
        //         SizedBox(width: 10),
        //         Text("Driver Actions")
        //       ],
        //     ),
        //   ),
        // ),
        // SizedBox(height: 20,)
      ],
    );
  }

  Widget buildCompleteOrdersList() {
    // final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _completeMOList.length,
          itemBuilder: (context, index) {
            final complete = _completeMOList[index];

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Number with Expand/Collapse functionality
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedItems[complete.orderId] =
                              !(expandedItems[complete.orderId] ?? false);
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${complete.itemname} (${complete.vehiclenumber})', // Dynamically set order number
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "PO: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  complete.ponumber,
                                ), // Dynamically set PO number
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (expandedItems[complete.orderId] ?? false) ...[
                      SizedBox(height: 8),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.order_Status,
                        "Completed",
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_number_1,
                        complete.challanno,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_number_2,
                        complete.challanno,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.vehicle_Number,
                        complete.vehiclenumber,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.driver_Name,
                        complete.drivername,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.site_Name,
                        complete.sitename,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.net_Weight,
                        complete.netweight.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_Weight_1,
                        complete.netweight.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_Weight_2,
                        complete.net1.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.royalty_Pass,
                        complete.orderId.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.moisture,
                        complete.moisture,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.last_Action,
                        complete.lastaction,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.mrn_No,
                        complete.mrnno,
                      ), // Fixed field
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildRejectedOrdersList() {
    // final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _canceledMOList.length,
          itemBuilder: (context, index) {
            final cancel = _canceledMOList[index];

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Number with Expand/Collapse functionality
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedItems[cancel.orderId] =
                              !(expandedItems[cancel.orderId] ?? false);
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cancel.itemName} (${cancel.vehicleNumber})', // Dynamically set order number
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "PO: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  cancel.poNumber,
                                ), // Dynamically set PO number
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (expandedItems[cancel.orderId] ?? false) ...[
                      SizedBox(height: 8),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.order_Status,
                        cancel.orderStatus,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_number_1,
                        cancel.challanNo,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_number_2,
                        cancel.challanNo1,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.vehicle_Number,
                        cancel.vehicleNumber,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.driver_Name,
                        cancel.driverName,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.site_Name,
                        cancel.siteName,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.net_Weight,
                        cancel.netWeight.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_Weight_1,
                        cancel.net1.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.chalan_Weight_2,
                        cancel.net1.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.royalty_Pass,
                        cancel.orderId.toString(),
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.moisture,
                        cancel.moisture,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.last_Action,
                        cancel.lastAction,
                      ),
                      _buildDivider(),
                      _buildInfoRow(
                        AppLocalizations.of(context)!.mrn_No,
                        cancel.mrnno.toString(),
                      ), // Fixed field
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200);
  }

  // Widget _buildInfoRow(String title, String value) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
  //       Text(value),
  //     ],
  //   );
  // }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 4),
          Expanded(
            // Ensures text wraps instead of overflowing
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // Prevents overflow
              softWrap: true, // Allows wrapping
            ),
          ),
        ],
      ),
    );
  }
}
