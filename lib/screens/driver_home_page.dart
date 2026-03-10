import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:rdc_concrete/screens/select_profile.dart';
// import 'package:rdc_concrete/screens/user_management.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import '../component/custom_alert_dialog.dart';
import '../component/drawer.dart';
// import '../core/network/api_client.dart';
import '../models/driverdt_otp_pojo.dart';
//import '../models/fetch_dashboard_pojo.dart';
import '../models/fetch_location_pojo.dart';
// import '../services/current_loc_api_service.dart';
import '../services/driver_home_api_service.dart';
// import '../services/fetch_location_api_service.dart';
// import '../services/fetch_dashboard_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';
import 'LanguageController.dart';
import 'accept_driver.dart';
// import 'current_location.dart';
// import 'fetch_po.dart';
import 'map_tm.dart';

class DriverHomePage extends StatefulWidget {
  final String? id; // Add this line
  final String? profileName; // Add this line
  final String? role;
  final String? sitename;
  final String? uname;
  final int? locationid;
  final int? uprofileid;
  final String? language;

  const DriverHomePage(this.id,this.profileName, {super.key, this.role, this.sitename, this.uname, this.locationid, this.uprofileid, this.language});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {

  String languageCode = Get.locale?.languageCode ?? 'en';
  List<LocationList> locations = [];

  // List<String> spinnerItems = ["Select Location"];
  List<String> spinnerItems = [];
  String? selectedItem;
  String selectedStatus = "Pending";
  //late MaterialOfficerModel _materialOfficerModel;
 // bool _isLoading = true;
  //String _errorMessage = '';
  int _completeCounter = 0;
  int _activeCounter = 0;
  int _cancelCounter = 0;
  List<Active> _activeMoList = []; // Store active transactions
  List<Cancel> _canceledMOList = []; // Store active transactions
  List<Complete> _completeMOList = []; // Store active transactions
//  List<Pending> _pendingMOList = []; // Store active transactions
  Map<int, bool> expandedItems = {};
 // String Currentversion = "9.1", updatedate = "23 Jan 2025,\n Thrsaday";

  @override
  void initState() {
    super.initState();
    loadrecycler ();
  //  SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
    // print("iddddddddddd${widget.id}");
    // print("iddddddddddd${widget.uprofileid}");
    // print("iddddddddddd${widget.locationid}");
    // print("iddddddddddd${widget.uname}");
    // print("iddddddddddd${widget.sitename}");
    // print("iddddddddddd${widget.role}");
    // print("iddddddddddd${widget.profileName}");
    // fetchLocations();
   // fetchMaterialOfficerData(widget.sitename.toString());
    //spinnerItems = [AppLocalizations.of(context)!.select_location];
  }

  void _showCustomDialog(
      BuildContext context,
      String orderId,
      String ponumber,
      String challanno,
      String vehicleno,
      String itemName,
      String sitename,
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
        //    print("User  confirmed with orderId: $orderId");
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AcceptDriver(
                      order: orderId,
                      itemName: itemName,
                      challanno: challanno,
                      vehicleno: vehicleno,
                      ponumber: ponumber, // Pass the orderId here
                      sitename: sitename,
                          // Ensure it's not null
                     // uid: widget.uprofileid!,
                      //locationid: widget.locationid,
                      uname: widget.profileName,
                      // role: widget.role,


                  // order: orderId,
                  // itemName: itemName,
                  // challanno: challanno,
                  // vehicleno: vehicleno,
                  // ponumber: ponumber,
                  // // Pass the orderId here
                  // sitename: widget.sitename ?? "Default Site Name",
                  // // Ensure it's not null
                  // uid: widget.uprofileid!,
                  // locationid: widget.locationid,
                  // uname: widget.uname,
                  // role: widget.role, // Ensure it's not null
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

  void showLanguageDialog(BuildContext context) {
    final LanguageController languageController =
    Get.find<LanguageController>();

    Get.defaultDialog(
      title: 'Select Language',
      content: Column(
        children: [
          ListTile(
            title: Text('English'),
            onTap: () {
              languageController.updateLanguage('en');
              Get.back();
            },
          ),
          ListTile(
            title: Text('Hindi'),
            onTap: () {
              languageController.updateLanguage('hi');
              Get.back();
            },
          ),
          ListTile(
            title: Text('Gujarati'),
            onTap: () {
              languageController.updateLanguage('gu');
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> loadrecycler () async {
    DriverHomeApiService driverHomeApiService=DriverHomeApiService();
    try {
      DriverDT? data=await driverHomeApiService.logindriverhome(widget.id.toString());

      if (data != null) {
        //print("Data fetched successfully: ${data.toString()}");

        setState(() {
          _completeCounter = data.completecounter;
          _activeCounter = data.activecounter;
          _cancelCounter = data.cancelcounter;
          _activeMoList = data.active!.toList();
          _canceledMOList = data.cancel!.toList();
          _completeMOList = data.complete!.toList();
        });
      //  final prefs = await SharedPreferences.getInstance();
      //  await prefs.setString('sitename', sitename);
      } else {
        //print("Failed to fetch data");
      }
    } catch (e) {
      //print("Error fetching data: $e");
    }
  }

  String convertToGujaratiNumerals(int number) {
    const List<String> gujaratiNumerals = [
      '૦',
      '૧',
      '૨',
      '૩',
      '૪',
      '૫',
      '૬',
      '૭',
      '૮',
      '૯',
    ];

    return number
        .toString()
        .split('')
        .map((digit) {
      return gujaratiNumerals[int.parse(digit)];
    })
        .join('');
  }

  String convertToHindiNumerals(int number) {
    const List<String> hindiNumerals = [
      '०',
      '१',
      '२',
      '३',
      '४',
      '५',
      '६',
      '७',
      '८',
      '९',
    ];

    return number
        .toString()
        .split('')
        .map((digit) {
      return hindiNumerals[int.parse(digit)];
    })
        .join('');
  }


  // bool isLoading = true; // Add this variable to track loading state
  // Future<void> fetchLocations() async {
  //   setState(() {
  //     isLoading = true; // Set loading state to true
  //   });
  //
  //   LocationService locationService = LocationService();
  //   try {
  //     List<LocationList> fetchedLocations = await locationService.getLocations(
  //       "1",
  //     );
  //     setState(() {
  //       locations = fetchedLocations;
  //       // spinnerItems = ["Select Location"] + fetchedLocations.map((loc) => loc.locationName).toList();
  //       spinnerItems =
  //           [AppLocalizations.of(context)!.select_location] +
  //               fetchedLocations.map((loc) => loc.locationName).toList();
  //       isLoading = false; // Set loading state to false
  //     });
  //   } catch (e) {
  //     print("Error fetching locations: $e");
  //     setState(() {
  //       isLoading = false; // Set loading state to false on error
  //     });
  //   }
  // }

  // String selectedStatus = "Pending";

  @override
  Widget build(BuildContext context) {

    Locale currentLocale = Localizations.localeOf(context);
    String displayedCounter;

    // Determine which numeral system to use based on the current locale
    if (currentLocale.languageCode == 'gu') {
      displayedCounter = convertToGujaratiNumerals(_completeCounter);
    } else if (currentLocale.languageCode == 'hi') {
      displayedCounter = convertToHindiNumerals(_completeCounter);
    } else {
      // Default to Arabic numerals
      displayedCounter = _completeCounter.toString();
    }

   // String displayedMrnNo;
    // for (var item in _completeMOList) {
    //   // Check if item.mrnno is not null or empty
    //   if (item.mrnno.isNotEmpty) {
    //     if (currentLocale.languageCode == 'gu') {
    //       displayedMrnNo = convertToGujaratiNumerals(
    //         int.tryParse(item.mrnno) ?? 0,
    //       );
    //     } else if (currentLocale.languageCode == 'hi') {
    //       displayedMrnNo = convertToHindiNumerals(
    //         int.tryParse(item.mrnno) ?? 0,
    //       );
    //     } else {
    //       displayedMrnNo = item.mrnno; // Default to the original value
    //     }
    //   } else {
    //     displayedMrnNo = "N/A"; // Handle case where MRN No is empty
    //   }
    // }
    // Convert MRN No based on locale
    String displayedactiveCounter;
    if (currentLocale.languageCode == 'gu') {
      displayedactiveCounter = convertToGujaratiNumerals(_activeCounter);
    } else if (currentLocale.languageCode == 'hi') {
      displayedactiveCounter = convertToHindiNumerals(_activeCounter);
    } else {
      // Default to Arabic numerals
      displayedactiveCounter = _activeCounter.toString();
    }
    String displayedcancelCounter;
    if (currentLocale.languageCode == 'gu') {
      displayedcancelCounter = convertToGujaratiNumerals(_cancelCounter);
    } else if (currentLocale.languageCode == 'hi') {
      displayedcancelCounter = convertToHindiNumerals(_cancelCounter);
    } else {
      // Default to Arabic numerals
      displayedcancelCounter = _cancelCounter.toString();
    } // Define the drawer items


    final drawerItems = [
      // DrawerItem(
      //   title: AppLocalizations.of(context)!.user_management,
      //   icon: Icons.person,
      //   iconColor: Colors.green,
      //   // screen: UserManagement(role: widget.role, locationid: widget.locationid,sitename:widget.sitename),
      //   screen: UserManagement(
      //     locationid: widget.locationid?.toInt(),
      //     sitename: widget.sitename.toString(),
      //     role: widget.role,
      //     uname: widget.uname,
      //     uprofileid: widget.uprofileid,
      //     language: languageCode,
      //   ),
      // ),
      // DrawerItem(
      //   title:      AppLocalizations.of(context)!.weighbridge_status,
      //   icon: Icons.fire_truck_sharp,
      //   iconColor: Colors.green,
      //   screen: WeyBridge(),
      // ),
      DrawerItem(
        title: AppLocalizations.of(context)!.share,
        icon: Icons.share,
        iconColor: Colors.green,
        onTap: () {
          //print('share tile pressed.');
          Share.share(
            'Check out this amazing app: [https://example.com/RDC Concrete_application]',
          );
        },
      ),
      DrawerItem(
        title: "Map TM (RFID)",
        icon: Icons.credit_card_sharp,
        screen: MapTm(
          // id pass issue
          uid: widget.locationid,
          sitename: widget.sitename,
          locationid: widget.locationid,
        ),
      ),
      // DrawerItem(
      //   title: AppLocalizations.of(context)!.current_location,
      //   icon: Icons.share_location,
      //   iconColor: Colors.green,
      //   screen: CurrentLocation(
      //     sitename: widget.sitename.toString(),
      //     uprofileid: widget.uprofileid,
      //     language: languageCode,
      //   ),
      // ),
      // DrawerItem(
      //   title: AppLocalizations.of(context)!.fetch_po,
      //   icon: Icons.cloud_download_rounded,
      //   iconColor: Colors.green,
      //   screen: FetchPO(
      //     locationid: widget.locationid,
      //     sitename: widget.sitename,
      //     uid: widget.uprofileid,
      //     role: widget.role,
      //     uname: widget.uname,
      //     uprofileid: widget.uprofileid,
      //   ),
      //   // screen: VendorTransactions(),
      // ),
      // DrawerItem(
      //   title: AppLocalizations.of(context)!.language,
      //   icon: Icons.language,
      //   iconColor: Colors.green,
      //   onTap: () {
      //     showLanguageDialog(context); // Call the language dialog here
      //   },
      // ),
      DrawerItem(
        title: AppLocalizations.of(context)!.logout,
        icon: Icons.logout,
        iconColor: Colors.green,
        screen: SelectProfile(),
      ),
      DrawerItem(

      ),
      DrawerItem(

      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0EB154),
        // or use primaryColor
        elevation: 7,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.title, // Updated line
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(drawerItems: drawerItems, username: widget.profileName),
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
          ),
          RefreshIndicator(
            onRefresh: () async {
              // Add refresh logic
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        /// select location drop down button.
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Completed Card
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStatus = "Completed";
                                  });
                                },
                                child: Card(
                                  shape:
                                  selectedStatus == "Completed"
                                      ? RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  )
                                      : null,
                                  color: Colors.green.shade100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.completed,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          displayedCounter,
                                          // Localized label with counter in the appropriate numeral system
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        // Text(
                                        //   "$_completeCounter", // Displays complete counter
                                        //   style: TextStyle(fontWeight: FontWeight.bold),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Pending Card
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStatus = "Pending";
                                  });
                                },
                                child: Card(
                                  shape:
                                  selectedStatus == "Pending"
                                      ? RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  )
                                      : null,
                                  color: Colors.green.shade100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        SizedBox(height: 8),

                                        // Use the activeCounter value from the API response
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.pending,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          displayedactiveCounter,
                                          // Localized label with counter in the appropriate numeral system
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Text("${apiResponse?.activeCounter ?? 0}"),
                                        // Text("${pendingTransactions.length}"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Canceled Card
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStatus = "Canceled";
                                  });
                                },
                                child: Card(
                                  shape:
                                  selectedStatus == "Canceled"
                                      ? RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  )
                                      : null,
                                  color: Colors.green.shade100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.canceled,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          displayedcancelCounter,
                                          // Localized label with counter in the appropriate numeral system
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Use the cancelCounter value from the API response
                                        // Text(
                                        //   "${apiResponse?.cancelCounter ?? 0}",
                                        //   style: TextStyle(fontWeight: FontWeight.bold),
                                        // ),
                                        //Text("${apiResponse?.cancelCounter ?? 0}"),
                                        //  Text("${canceledTransactions.length}"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SingleChildScrollView(
                          child: Column(
                            children: [
                              if (selectedStatus == "Completed") ...[
                                for (var item
                                in _completeMOList) // Loop through canceledMO[]
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expandedItems[item.orderid] =
                                        !(expandedItems[item.orderid] ??
                                            false);
                                        // isExpandedCanceled = !isExpandedCanceled; // Toggle expansion
                                      });
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // Order Number with background color
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${item.itemname} (${item.vehiclenumber})',
                                                    // Dynamically set order number
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "PO: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(item.ponumber),
                                                      // Dynamically set PO number
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (expandedItems[item.orderid] ??
                                                false) ...[
                                              SizedBox(height: 8),
                                              // _buildInfoRow("Order Status: ", "Completed"),
                                              // _buildDivider(),
                                              // _buildInfoRow("Chalan Number 1: ", item.challanno),
                                              // _buildDivider(),
                                              // _buildInfoRow("Chalan Number 2: ", item.challanno),
                                              // _buildDivider(),
                                              // _buildInfoRow("Vehicle Number: ", item.vehiclenumber),
                                              // _buildDivider(),
                                              // _buildInfoRow("Driver Name: ", item.drivername),
                                              // _buildDivider(),
                                              // _buildInfoRow("Site Name: ", item.sitename),
                                              // _buildDivider(),
                                              // _buildInfoRow("Net Weight: ", item.netweight.toString()),
                                              // _buildDivider(),
                                              // _buildInfoRow("Chalan Weight 1: ", item.challanno),
                                              // _buildDivider(),
                                              // _buildInfoRow("Chalan Weight 2: ", item.challanno),
                                              // _buildDivider(),
                                              // _buildInfoRow("Royalty Pass: ", item.challanno),
                                              // _buildDivider(),
                                              // _buildInfoRow("Moisture %: ", item.moisture),
                                              // _buildDivider(),
                                              // _buildInfoRow("Last Action: ", item.lastaction),
                                              // _buildDivider(),
                                              // _buildInfoRow("MRN No: ", item.mrnno),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.order_Status,
                                                "Completed",
                                              ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.chalan_number_1,
                                                item.challanno,
                                              ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.chalan_number_2,
                                                item.challanno,
                                              ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.vehicle_Number,
                                                item.vehiclenumber,
                                              ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.driver_Name,
                                              //   item.,
                                              // ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.site_Name,
                                                item.sitename,
                                              ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.net_Weight,
                                                item.netweight.toString(),
                                              ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.chalan_Weight_1,
                                                item.netweight.toString(),
                                              ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.chalan_Weight_2,
                                              //   item.net1.toString(),
                                              // ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.royalty_Pass,
                                                item.orderid.toString(),
                                              ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.moisture,
                                              //   item.moisture,
                                              // ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.last_Action,
                                              //   item.lastaction,
                                              // ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.mrn_No,
                                              //   item.mrnno,
                                              // ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                              if (selectedStatus == "Pending") ...[
                                for (var item in _activeMoList)
                                  GestureDetector(
                                    onTap: () {
                                      _showCustomDialog(
                                        context,
                                        item.orderid.toString(),
                                        item.ponumber,
                                        item.challanno,
                                        item.vehiclenumber,
                                        item.itemname,
                                        item.sitename,
                                      ); // Pass the orderId here
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(3.0),
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              // First Column
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(width: 8),
                                                        // Vendor Name
                                                        Expanded(
                                                          child: Text(
                                                            '${item.vehiclenumber} (${item.drivermobile})',
                                                            // Dynamically set vendor name
                                                            style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 13,
                                                            ),
                                                            overflow:
                                                            TextOverflow
                                                                .visible,
                                                            maxLines: null,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.green,
                                                        ),
                                                        SizedBox(width: 8),
                                                        // Site Name (Address)
                                                        Expanded(
                                                          child: Text(
                                                            item.sitename,
                                                            // Use sitename from API
                                                            overflow:
                                                            TextOverflow
                                                                .visible,
                                                            maxLines: null,
                                                            style: TextStyle(
                                                              color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.receipt,
                                                          color: Colors.green,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          "PO: ${item.ponumber}",
                                                          // Use PO number
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .calendar_today,
                                                          color: Colors.green,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          item.actiontime,
                                                          // Use action time from API
                                                          style: TextStyle(
                                                            color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                          ),
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
                                                    // GestureDetector(
                                                    //   onTap: () async {
                                                    //     Navigator.push(
                                                    //       context,
                                                    //       MaterialPageRoute(
                                                    //         builder: (context) => QaMoScreen(
                                                    //           // showMapTmSection: true,
                                                    //           // showDetails: false,
                                                    //           // showTruckDetails: true,
                                                    //           // showOtpField: false,
                                                    //           // showConfirmBox: false,
                                                    //           sitename: widget.sitename,
                                                    //           vehicleNumber: item.vehicleNumber,
                                                    //           moisture: item.moisture,
                                                    //           itemName: item.itemName,
                                                    //           ponumber: item.poNumber,
                                                    //           challanno: item.challanNo,
                                                    //           challanno1: item.challan_no1,
                                                    //           driverName: item.driverName,
                                                    //           driverMobile: item.driverMobile,
                                                    //           actionTime: item.actionTime,
                                                    //           filename: item.fileName,
                                                    //           oderid: item.orderId,
                                                    //           role: widget.role,
                                                    //           uid: widget.uprofileid,
                                                    //           uname: widget.uname,
                                                    //           locationid: widget.locationid,
                                                    //           // order: item.poNumber.toString(),
                                                    //           // order: order,
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    //   child: Card(
                                                    //     color:
                                                    //     Colors
                                                    //         .green
                                                    //         .shade100,
                                                    //     shape: RoundedRectangleBorder(
                                                    //       borderRadius:
                                                    //       BorderRadius.circular(
                                                    //         8,
                                                    //       ),
                                                    //     ),
                                                    //     child: Padding(
                                                    //       padding:
                                                    //       const EdgeInsets.all(
                                                    //         8.0,
                                                    //       ),
                                                    //       child: Icon(
                                                    //         Icons.fact_check,
                                                    //         size: 30,
                                                    //         color:
                                                    //         Colors.green,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // SizedBox(height: 10),
                                                    // Accept Driver Button
                                                    // GestureDetector(
                                                    //   onTap: () {
                                                    //     _showCustomDialog(context, item.orderId.toString(),item.poNumber); // Pass the orderId here
                                                    //   },
                                                    Card(
                                                      color:
                                                      Colors
                                                          .green
                                                          .shade100,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .directions_car,
                                                          size: 30,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                              // if (selectedStatus == "Pending") ...[
                              //   for (var item in _activeMoList)
                              //
                              //     // Loop through activemo[]
                              //     Container(
                              //       padding: EdgeInsets.all(3.0),
                              //       child: Card(
                              //         color: Colors.white,
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(12),
                              //           side: BorderSide(color: Colors.grey.shade300),
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(16.0),
                              //           child: Row(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               // First Column
                              //               Expanded(
                              //                 flex: 4,
                              //                 child: Column(
                              //                   crossAxisAlignment: CrossAxisAlignment.start,
                              //                   children: [
                              //                     Row(
                              //                       crossAxisAlignment: CrossAxisAlignment.start,
                              //                       children: [
                              //                         SizedBox(width: 8),
                              //                         // Vendor Name
                              //                         Expanded(
                              //                           child: Text(
                              //                             '${item.vehicleNumber} (${item.driverName})', // Dynamically set vendor name
                              //                             style: TextStyle(
                              //                               fontWeight: FontWeight.bold,
                              //                               fontSize: 13,
                              //                             ),
                              //                             overflow: TextOverflow.visible,
                              //                             maxLines: null,
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     SizedBox(height: 8),
                              //                     Row(
                              //                       crossAxisAlignment: CrossAxisAlignment.start,
                              //                       children: [
                              //                         Icon(Icons.location_on, color: Colors.green),
                              //                         SizedBox(width: 8),
                              //                         // Site Name (Address)
                              //                         Expanded(
                              //                           child: Text(
                              //                             item.siteName, // Use sitename from API
                              //                             overflow: TextOverflow.visible,
                              //                             maxLines: null,
                              //                             style: TextStyle(color: Colors.grey.shade600),
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     SizedBox(height: 8),
                              //                     Row(
                              //                       children: [
                              //                         Icon(Icons.receipt, color: Colors.green),
                              //                         SizedBox(width: 8),
                              //                         Text(
                              //                           "PO: ${item.poNumber}", // Use PO number
                              //                           style: TextStyle(fontWeight: FontWeight.w500),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     Row(
                              //                       children: [
                              //                         Icon(Icons.receipt, color: Colors.green),
                              //                         SizedBox(width: 8),
                              //                         Text(
                              //                           "oid: ${item.orderId}", // Use PO number
                              //                           style: TextStyle(fontWeight: FontWeight.w500),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     SizedBox(height: 8),
                              //                     Row(
                              //                       children: [
                              //                         Icon(Icons.calendar_today, color: Colors.green),
                              //                         SizedBox(width: 8),
                              //                         Text(
                              //                           item.actionTime, // Use action time from API
                              //                           style: TextStyle(color: Colors.grey.shade600),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               SizedBox(width: 8),
                              //               // Second Column (Buttons)
                              //               Expanded(
                              //                 child: Column(
                              //                   children: [
                              //                     // QA/MO Button
                              //                     GestureDetector(
                              //                       onTap: () {
                              //                         Navigator.push(
                              //                           context,
                              //                           MaterialPageRoute(builder: (context) => EditRfid()),
                              //                         );
                              //                       },
                              //                       child: Card(
                              //                         color: Colors.green.shade100,
                              //                         shape: RoundedRectangleBorder(
                              //                           borderRadius: BorderRadius.circular(8),
                              //                         ),
                              //                         child: Padding(
                              //                           padding: const EdgeInsets.all(8.0),
                              //                           child: Icon(Icons.fact_check, size: 30, color: Colors.green),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     SizedBox(height: 10),
                              //                     // Accept Driver Button
                              //                     GestureDetector(
                              //                       onTap: () {
                              //                         Navigator.push(
                              //                           context,
                              //                             _showCustomDialog(context)
                              //                           // MaterialPageRoute(
                              //                           //   builder: (context) => AcceptDriver(showDetails: true,
                              //                           //       showTruckDetails: true,
                              //                           //       showOtpField: false, // Provide a value for showOtpField
                              //                           //       showConfirmBox: false, // Provide a value for showConfirmBox
                              //                           //       selectedLocationItems: '',
                              //                           //       sitename:widget.sitename,vno:item.vehicleNumber
                              //                           //   ),
                              //                           // ),
                              //                           // MaterialPageRoute(
                              //                           //   builder: (context) => AcceptDriver(showDetails: true,
                              //                           //     showTruckDetails: true,
                              //                           //     showOtpField: false, // Provide a value for showOtpField
                              //                           //     showConfirmBox: false, // Provide a value for showConfirmBox
                              //                           //     selectedLocationItems: '',
                              //                           //       sitename:widget.sitename,vno:item.vehicleNumber
                              //                           //   ),
                              //                           // ),
                              //                         );
                              //                       },
                              //
                              //                       child: Card(
                              //                         color: Colors.green.shade100,
                              //                         shape: RoundedRectangleBorder(
                              //                           borderRadius: BorderRadius.circular(8),
                              //                         ),
                              //                         child: Padding(
                              //                           padding: const EdgeInsets.all(8.0),
                              //                           child: Icon(Icons.directions_car, size: 30, color: Colors.green),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              // ],
                              if (selectedStatus == "Canceled") ...[
                                for (var item
                                in _canceledMOList) // Loop through canceledMO[]
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expandedItems[item.orderid] =
                                        !(expandedItems[item.orderid] ??
                                            false);
                                      });
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          8.0,
                                          8.0,
                                          8.0,
                                          8.0,
                                        ),

                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // Order Number with background color
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  0.0,
                                                ),

                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${item.itemname} (${item.vehiclenumber})',
                                                      // Dynamically set order number
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "PO: ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                        Text(item.ponumber),
                                                        // Dynamically set PO number
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (expandedItems[item.orderid] ??
                                                false) ...[
                                              SizedBox(height: 8),
                                              // _buildInfoRow("Order Status: ", item.orderStatus),
                                              // _buildDivider(),
                                              // _buildInfoRow(AppLocalizations.of(context)!.chalan_number_1, item.challanNo),
                                              // _buildDivider(),
                                              // _buildInfoRow("Chalan Number 2: ", item.challanNo),
                                              // _buildDivider(),
                                              // _buildInfoRow("Vehicle Number: ", item.vehicleNumber),
                                              // _buildDivider(),
                                              // _buildInfoRow("Driver Name: ", item.driverName),
                                              // _buildDivider(),
                                              // _buildInfoRow("Site Name: ", item.siteName),
                                              // _buildDivider(),
                                              // _buildInfoRow("Net Weight: ", item.netWeight.toString()),
                                              // _buildDivider(),
                                              // _buildInfoRow("Chalan Weight 1: ", item.challanNo),
                                              // _buildDivider(),
                                              // _buildInfoRow("Chalan Weight 2: ", item.challanNo),
                                              // _buildDivider(),
                                              // _buildInfoRow("Royalty Pass: ", item.challanNo),
                                              // _buildDivider(),
                                              // _buildInfoRow("Moisture %: ", item.moisture),
                                              // _buildDivider(),
                                              // _buildInfoRow("Last Action: ", item.lastAction),
                                              // _buildDivider(),
                                              // _buildInfoRow("MRN No: ", item.mrnno.toString()),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.order_Status,
                                              //   item.orderStatus,
                                              // ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.chalan_number_1,
                                                item.challanno,
                                              ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.chalan_number_2,
                                              //   item.challanNo1,
                                              // ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.vehicle_Number,
                                                item.vehiclenumber,
                                              ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.driver_Name,
                                              //   item.driverName,
                                              // ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.site_Name,
                                                item.sitename,
                                              ),
                                              // _buildDivider(),
                                              // _buildInfoRow(AppLocalizations.of(context)!.net_Weight, item.netWeight.toString()),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.chalan_Weight_1,
                                              //   item.netWeight.toString(),
                                              // ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.chalan_Weight_2,
                                              //   item.net1.toString(),
                                              // ),
                                              _buildDivider(),
                                              _buildInfoRow(
                                                AppLocalizations.of(
                                                  context,
                                                )!.royalty_Pass,
                                                item.orderid.toString(),
                                              ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.moisture,
                                              //   item.m,
                                              // ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.last_Action,
                                              //   item.lastAction,
                                              // ),
                                              // _buildDivider(),
                                              // _buildInfoRow(
                                              //   AppLocalizations.of(
                                              //     context,
                                              //   )!.mrn_No,
                                              //   item.mrnno.toString(),
                                              // ),
                                              // Fixed field
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200);
  }
}
