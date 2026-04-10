import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rdc_concrete/component/drawer.dart';
import 'package:rdc_concrete/screens/accept_driver.dart';

//import 'package:rdc_concrete/screens/current_location.dart';

import 'package:rdc_concrete/screens/fetch_po.dart';
import 'package:rdc_concrete/screens/qa_mo_screen.dart';
import 'package:rdc_concrete/screens/select_profile.dart';
import 'package:rdc_concrete/screens/user_management.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/custom_alert_dialog.dart';
import '../component/item_menu.dart';
import '../core/network/api_client.dart';
import '../models/fetch_dashboard_pojo.dart';
import '../models/fetch_location_pojo.dart';

import '../services/api_service.dart';
import '../services/fetch_location_api_service.dart';
import '../services/fetch_dashboard_api_service.dart';
import 'package:get/get.dart';

import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';
import 'expense_main.dart';
import 'languagecontroller.dart';

class HomePage extends StatefulWidget {
  final String? role;
  final String? sitename;
  final String? uname;
  final int? locationid;
  final int? uprofileid;
  final String? language;

  const HomePage({
    super.key,
    required this.role,
    required this.sitename,
    required this.uname,
    required this.locationid,
    required this.uprofileid,
    this.language,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with WidgetsBindingObserver, AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  String languageCode = Get.locale?.languageCode ?? 'en';
  List<LocationList> locations = [];
  // List<String> spinnerItems = ["Select Location"];
  List<String> spinnerItems = [];
  String? selectedItem;
  String selectedStatus = "Pending";
  // late MaterialOfficerModel _materialOfficerModel;
  // bool _isLoading = true;
  // String _errorMessage = '';
  int _completeCounter = 0;
  int _activeCounter = 0;
  int _cancelCounter = 0;
  List<ActiveMO> _activeMoList = []; // Store active transactions
  List<CanceledMO> _canceledMOList = []; // Store active transactions
  List<CompleteMo> _completeMOList = []; // Store active transactions
  Map<int, bool> expandedItems = {};
  //bool _isLoading = false;

  // String Currentversion = "9.1", updatedate = "23 Jan 2025,\n Thrsaday";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchLocations();
   // _loadSavedSite();
    fetchMaterialOfficerData( selectedItem.toString());
    //spinnerItems = [AppLocalizations.of(context)!.select_location];
  //  WidgetsBinding.instance.addObserver(this); // Register observer
    //SessionManager.checkAutoLogoutOnce();
    //SessionManager.scheduleMidnightLogout(context);
    // scheduleNoonLogout(); // Optional: live logout at 12:00 PM
    SessionManager.checkAutoLogoutOnce(); // Uncomment if you want additional check
    SessionManager.scheduleMidnightLogout(context); // Schedule midnight logout
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // only run after widget build
     // await SessionManager.checkAutoLogoutOnce();
      SessionManager.scheduleMidnightLogout(context);
      // fetchVendorData(widget.uid.toString());
    });
  }
  Future<void> _loadSavedSite() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSite = prefs.getString('sitename');
    if (savedSite != null && savedSite.isNotEmpty && spinnerItems.contains(savedSite)) {
      setState(() {
        selectedItem = savedSite;
      });
      await fetchMaterialOfficerData(savedSite);
    } else if (widget.sitename != null && spinnerItems.contains(widget.sitename!)) {
      setState(() {
        selectedItem = widget.sitename!;
      });
      await fetchMaterialOfficerData(widget.sitename!);
    }
  }

  // Save site to SharedPreferences (session)
  // Future<void> _saveSiteToPrefs(String siteName) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('sitename', siteName);
  // }
  // Future<void> _switchStatus(String status) async {
  //   setState(() => isLoading = true);
  //
  //   // 👉 simulate API call (replace with your real API)
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   setState(() {
  //     selectedStatus = status;
  //     isLoading = false;
  //   });
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        // Trigger a refresh of data or UI
        fetchMaterialOfficerData(selectedItem ?? widget.sitename ?? "");
      });
      checkAutoLogout();
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      fetchMaterialOfficerData(selectedItem ?? widget.sitename ?? "");
    }
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
          title: AppLocalizations.of(context)!.camera_Not_Working,
          message: "",
          confirmText: AppLocalizations.of(context)!.confirm,
          cancelText: AppLocalizations.of(context)!.please_try_again,
          onConfirm: () {
            // print("User  confirmed with orderId: $orderId");
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
                      sitename:selectedItem                           ??
                          "Default Site Name", // Ensure it's not null
                      uid: widget.uprofileid!,
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

  Future<void> fetchMaterialOfficerData(String sitename) async {
    final dio = ApiClient.getDio();
    final service = MaterialOfficerService(dio);
    try {
      // Pass sitename directly
      MaterialOfficerModel? data = await service
          .fetchMaterialOfficerTransaction(sitename);
      if (data != null) {
        //print("Data fetched successfully: ${data.toString()}");

        setState(() {
          _completeCounter = data.completeCounter;
          _activeCounter = data.activeCounter;
          _cancelCounter = data.cancelCounter;
          _activeMoList = data.activeMO;
          _canceledMOList = data.canceledMO;
          _completeMOList = data.completeMO;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('sitename', sitename);
      } else {
        //print("Failed to fetch data");
      }
    } catch (e) {
      //print("Error fetching data: $e");
    }
  }
  void checkAutoLogout() async {
    final apiService = ApiService();
    bool logout = await apiService.shouldLogoutNow();

    if (logout) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      // Navigator.pushReplacementNamed(context, '/login');
      Get.offAll(() => SelectProfile());
    }
  }

  void scheduleMidnightLogout() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1); // 12:00 AM next day

    Duration timeUntilMidnight = midnight.difference(now);

    Timer(timeUntilMidnight, () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => SelectProfile());

    });

    //print("Logout scheduled at midnight: $midnight");
  }
  void scheduleNoonLogout() {
    // --------------------------------------------------------------
    // 1. Capture the BuildContext **once**, before any async work
    // --------------------------------------------------------------
    final BuildContext ctx = context;

    // --------------------------------------------------------------
    // 2. Compute the time until noon (no async → safe)
    // --------------------------------------------------------------
    final DateTime now = DateTime.now();
    final DateTime noonToday = DateTime(now.year, now.month, now.day, 12, 0, 0);

    if (now.isAfter(noonToday)) return;

    final Duration timeUntilNoon = noonToday.difference(now);

    // --------------------------------------------------------------
    // 3. Schedule the timer – the callback is async
    // --------------------------------------------------------------
    Timer(timeUntilNoon, () async {
      // ---- early-exit if the widget was disposed while waiting ----
      if (!ctx.mounted) return;

      // ---- clear SharedPreferences (async) -------------------------
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // ---- still mounted after the async clear? -------------------
      if (!ctx.mounted) return;

      // ---- navigate ------------------------------------------------
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(builder: (_) => const SelectProfile()),
      );
    });
  }
  // void scheduleNoonLogout() {
  //   DateTime now = DateTime.now();
  //   DateTime noonToday = DateTime(now.year, now.month, now.day, 12, 0, 0);
  //
  //   if (now.isAfter(noonToday)) return;
  //
  //   Duration timeUntilNoon = noonToday.difference(now);
  //
  //   Timer(timeUntilNoon, () async {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.clear();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => SelectProfile()),
  //     );
  //   });
  // }

  //
  // void checkAutoLogout() async {
  //
  //   bool logout = await apiService.shouldLogoutNow();
  //
  //   if (logout) {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.clear();
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }
  Future<String?> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; // This will give you "1.0.1"
  }

  String convertToGujaratiNumerals(int number) {
    const List<String> gujaratiNumerals = [
      '૦', '૧', '૨', '૩', '૪', '૫','૬','૭','૮','૯',
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
      '०','१', '२', '३','४','५','६', '७','८', '९',
    ];

    return number
        .toString()
        .split('')
        .map((digit) {
          return hindiNumerals[int.parse(digit)];
        })
        .join('');
  }

  bool isLoading = true; // Add this variable to track loading state

  Future<void> fetchLocations() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    LocationService locationService = LocationService();
    try {
      List<LocationList> fetchedLocations = await locationService.getLocations(
        "1",
      );
      setState(() {
        locations = fetchedLocations;
        // spinnerItems = ["Select Location"] + fetchedLocations.map((loc) => loc.locationName).toList();
        spinnerItems =
            [AppLocalizations.of(context)!.select_location] +
            fetchedLocations.map((loc) => loc.locationName).toList();
        isLoading = false; // Set loading state to false
      });

      await _loadSavedSite();
    } catch (e) {
      //print("Error fetching locations: $e");
      setState(() {
        isLoading = false; // Set loading state to false on error
      });
    }
  }

  bool isExpandedPending =
      false; // Controls the expanded state of the Pending details
  bool isExpandedCanceled =
      false; // Controls the expanded state of the Canceled details
  bool isExpandedCompleted = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //  final primaryColor = Theme.of(context).primaryColor;

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

    List<String> displayedMrnNos = [];
    for (var item in _completeMOList) {
      String displayedmrnno;
      // Check if item.mrnno is not null or empty
      if (item.mrnno.isNotEmpty) {
        if (currentLocale.languageCode == 'gu') {
          displayedmrnno = convertToGujaratiNumerals(
            int.tryParse(item.mrnno) ?? 0,
          );
        } else if (currentLocale.languageCode == 'hi') {
          displayedmrnno = convertToHindiNumerals(
            int.tryParse(item.mrnno) ?? 0,
          );
        } else {
          displayedmrnno = item.mrnno; // Default to the original value
        }
      } else {
        displayedmrnno = "N/A"; // Handle case where MRN No is empty
      }
      displayedMrnNos.add(displayedmrnno);
    }
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
      DrawerItem(
        title: AppLocalizations.of(context)!.user_management,
        icon: Icons.person,
        iconColor: Colors.green,
        // screen: UserManagement(role: widget.role, locationid: widget.locationid,sitename:widget.sitename),
        screen: UserManagement(
          locationid: widget.locationid?.toInt(),
          // sitename: widget.sitename.toString(),
          sitename: selectedItem.toString(),
          role: widget.role,
          uname: widget.uname,
          uprofileid: widget.uprofileid,
          language: languageCode,
        ),
      ),
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
      //     // sitename: widget.sitename,
      //     sitename: selectedItem.toString(),
      //     uid: widget.uprofileid,
      //     role: widget.role,
      //     uname: widget.uname,
      //     uprofileid: widget.uprofileid,
      //   ),
      //   // screen: VendorTransactions(),
      // ),
      DrawerItem(
        title: AppLocalizations.of(context)!.fetch_po,
        icon: Icons.cloud_download_rounded,
        iconColor: Colors.green,
        screen: FetchPO(
          locationid: widget.locationid,
          sitename: selectedItem.toString(),
          uid: widget.uprofileid,
          role: widget.role,
          uname: widget.uname,
          uprofileid: widget.uprofileid,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FetchPO(
                locationid: widget.locationid,
                sitename: selectedItem.toString(),
                uid: widget.uprofileid,
                role: widget.role,
                uname: widget.uname,
                uprofileid: widget.uprofileid,
              ),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                fetchMaterialOfficerData(selectedItem ?? widget.sitename ?? "");
                fetchLocations(); // Refresh if needed
              });
            }
          });
        },
      ),
      // DrawerItem(
      //   title: AppLocalizations.of(context)!.spares_and_expense,
      //   icon: Icons.cloud_download_rounded,
      //   iconColor: Colors.green,
      //   screen: ExpenseMain(
      //     locationid: widget.locationid,
      //      sitename: selectedItem.toString(),
      //     // uid: widget.uprofileid,
      //     // role: widget.role,
      //     // uname: widget.uname,
      //     // uprofileid: widget.uprofileid,
      //   ),
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ExpenseMain(
      //            locationid: widget.locationid,
      //            sitename: selectedItem.toString(),
      //           // uid: widget.uprofileid,
      //           // role: widget.role,
      //           // uname: widget.uname,
      //           // uprofileid: widget.uprofileid,
      //         ),
      //       ),
      //     ).then((value) {
      //       if (value == true) {
      //         setState(() {
      //           fetchMaterialOfficerData(selectedItem ?? widget.sitename ?? "");
      //           fetchLocations(); // Refresh if needed
      //         });
      //       }
      //     });
      //   },
      // ),
      DrawerItem(
        title: AppLocalizations.of(context)!.language,
        icon: Icons.language,
        iconColor: Colors.green,
        onTap: () {
          showLanguageDialog(context); // Call the language dialog here
        },
      ),
      DrawerItem(
        title: "Logout",
        icon: Icons.logout,
        onTap: () async {
          // Clear SharedPreferences to log out the user
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          // Navigate to SelectProfile screen
          Get.offAll(() => const SelectProfile());
        },
      ),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0EB154), // or use primaryColor
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
          actions: [
            PopupMenuButton<MenuItems>(
              color: Colors.white,
              itemBuilder:
                  (BuildContext context) => [
                    PopupMenuItem<MenuItems>(
                      value: MenuItems(
                        text: widget.uname.toString(),
                        icon: Icons.person,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ), // Reduce padding
                      child: Text(
                        widget.uname.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),

                    PopupMenuItem<MenuItems>(
                      value: MenuItems(
                        text: widget.role.toString(),
                        icon: Icons.person,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ), // Reduce padding
                      child: Text(widget.role.toString()),
                    ),

                    // PopupMenuItem<MenuItems>(
                    //   value: MenuItems(text: 'Logout', icon: Icons.logout),
                    //   padding: EdgeInsets.symmetric(
                    //     vertical: 2,
                    //     horizontal: 10,
                    //   ), // Reduce padding
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.logout,
                    //         size: 18,
                    //         color: Colors.green,
                    //       ), // Reduced size
                    //       SizedBox(width: 8), // Reduced space
                    //       Text(
                    //         AppLocalizations.of(context)!.logout,
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
              onSelected: (MenuItems selectedItem) {
                if (selectedItem.text == 'Logout') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectProfile()),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.account_circle,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        drawer: MyDrawer(drawerItems: drawerItems, username: widget.uname),
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
                          _buildSpinner(),

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
                                  // onTap: () async {
                                  //   setState(() {
                                  //     isLoading = true; // show loading
                                  //   });
                                  //
                                  //   // 👉 wait for response (example: API call or delay)
                                  //   await Future.delayed(Duration(seconds: 2));
                                  //
                                  //   setState(() {
                                  //     selectedStatus = "Completed"; // update after response
                                  //     isLoading = false; // hide loading
                                  //   });
                                  // },

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
                                            displayedCounter, // Localized label with counter in the appropriate numeral system
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
                                  // onTap: () async {
                                  //   setState(() {
                                  //     isLoading = true; // show loading
                                  //   });
                                  //
                                  //   // 👉 wait for response (example: API call or delay)
                                  //   await Future.delayed(Duration(seconds: 2));
                                  //
                                  //   setState(() {
                                  //     selectedStatus = "Pending"; // update after response
                                  //     isLoading = false; // hide loading
                                  //   });
                                  // },
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
                                            displayedactiveCounter, // Localized label with counter in the appropriate numeral system
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
                                            displayedcancelCounter, // Localized label with counter in the appropriate numeral system
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
                                // if (selectedStatus == "Completed") ...[
                                //   for (var item in _completeMOList) // Loop through canceledMO[]
                                //     GestureDetector(
                                //       onTap: () {
                                //         setState(() {
                                //           expandedItems[item.orderId] =
                                //               !(expandedItems[item.orderId] ??
                                //                   false);
                                //           // isExpandedCanceled = !isExpandedCanceled; // Toggle expansion
                                //         });
                                //       },
                                //       child: Card(
                                //         color: Colors.white,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(
                                //             8,
                                //           ),
                                //         ),
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(10.0),
                                //           child: Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               // Order Number with background color
                                //               Container(
                                //                 width: double.infinity,
                                //                 padding: EdgeInsets.symmetric(
                                //                   vertical: 8,
                                //                   horizontal: 8,
                                //                 ),
                                //                 decoration: BoxDecoration(
                                //                   color: Colors.green.shade100,
                                //                   borderRadius:
                                //                       BorderRadius.circular(4),
                                //                 ),
                                //                 child: Row(
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment
                                //                           .spaceBetween,
                                //                   children: [
                                //                     Text(
                                //                       '${item.itemname} (${item.vehiclenumber})', // Dynamically set order number
                                //                       style: TextStyle(
                                //                         fontWeight:
                                //                             FontWeight.bold,
                                //                         fontSize: 14,
                                //                       ),
                                //                     ),
                                //                     Row(
                                //                       children: [
                                //                         Text(
                                //                           "PO: ",
                                //                           style: TextStyle(
                                //                             fontWeight:
                                //                                 FontWeight.bold,
                                //                           ),
                                //                         ),
                                //                         Text(
                                //                           item.ponumber,
                                //                         ), // Dynamically set PO number
                                //                       ],
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //               if (expandedItems[item.orderId] ??
                                //                   false) ...[
                                //                 SizedBox(height: 8),
                                //                 // _buildInfoRow("Order Status: ", "Completed"),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Chalan Number 1: ", item.challanno),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Chalan Number 2: ", item.challanno),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Vehicle Number: ", item.vehiclenumber),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Driver Name: ", item.drivername),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Site Name: ", item.sitename),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Net Weight: ", item.netweight.toString()),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Chalan Weight 1: ", item.challanno),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Chalan Weight 2: ", item.challanno),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Royalty Pass: ", item.challanno),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Moisture %: ", item.moisture),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("Last Action: ", item.lastaction),
                                //                 // _buildDivider(),
                                //                 // _buildInfoRow("MRN No: ", item.mrnno),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.order_Status,
                                //                   "Completed",
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.chalan_number_1,
                                //                   item.challanno,
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.chalan_number_2,
                                //                   item.challanno,
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.vehicle_Number,
                                //                   item.vehiclenumber,
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.driver_Name,
                                //                   item.drivername,
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.site_Name,
                                //                   item.sitename,
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.net_Weight,
                                //                   item.netweight.toString(),
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.chalan_Weight_1,
                                //                   item.netweight.toString(),
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.chalan_Weight_2,
                                //                   item.net1.toString(),
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.royalty_Pass,
                                //                   item.orderId.toString(),
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.moisture,
                                //                   item.moisture,
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.last_Action,
                                //                   item.lastaction,
                                //                 ),
                                //                 _buildDivider(),
                                //                 _buildInfoRow(
                                //                   AppLocalizations.of(
                                //                     context,
                                //                   )!.mrn_No,
                                //                   item.mrnno,
                                //                 ),
                                //               ],
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                // ],
                                if (selectedStatus == "Completed") ...[
                                  ..._completeMOList.map((item) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          expandedItems[item.orderId] =
                                          !(expandedItems[item.orderId] ?? false);
                                        });
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade100,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${item.itemname} (${item.vehiclenumber})',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("PO: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                                        Text(item.ponumber),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              if (expandedItems[item.orderId] ?? false) ...[
                                                SizedBox(height: 8),
                                                _buildInfoRow(AppLocalizations.of(context)!.order_Status, "Completed"),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.chalan_number_1, item.challanno),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.chalan_number_2, item.challanno),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.vehicle_Number, item.vehiclenumber),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.driver_Name, item.drivername),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.site_Name, item.sitename),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.net_Weight, item.netweight.toString()),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.chalan_Weight_1, item.netweight.toString()),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.chalan_Weight_2, item.net1.toString()),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.royalty_Pass, item.orderId.toString()),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.moisture, item.moisture),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.last_Action, item.lastaction),
                                                _buildDivider(),
                                                _buildInfoRow(AppLocalizations.of(context)!.mrn_No, item.mrnno),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],

                                if (selectedStatus == "Pending") ...[
                                  ..._activeMoList.map((item) {
                                    return GestureDetector(
                                      onTap: () {
                                        _showCustomDialog(
                                          context,
                                          item.orderId.toString(),
                                          item.poNumber.toString(),
                                          item.challanNo,
                                          item.challanno1,
                                          item.vehicleNumber,
                                          item.itemName,
                                        ); // Pass the orderId here
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(3.0),
                                        child: Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
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
                                                              '${item.vehicleNumber} (${item.driverName})',
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
                                                          Expanded(
                                                            child: Text(
                                                              item.siteName,
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
                                                            "PO: ${item.poNumber}",
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
                                                            item.actionTime,
                                                            style: TextStyle(
                                                              color: Colors.grey.shade600,
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
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => QaMoScreen(
                                                                sitename:selectedItem                           ??
                                                                    "Default Site Name",
                                                                vehicleNumber: item.vehicleNumber,
                                                                moisture: item.moisture,
                                                                itemName: item.itemName,
                                                                ponumber: item.poNumber,
                                                                challanno: item.challanNo,
                                                                challanno1: item.challanno1,
                                                                driverName: item.driverName,
                                                                driverMobile: item.driverMobile,
                                                                actionTime: item.actionTime,
                                                                filename: item.fileName,
                                                                oderid: item.orderId,
                                                                role: widget.role,
                                                                uid: widget.uprofileid,
                                                                uname: widget.uname,
                                                                locationid: widget.locationid,
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
                                                            child: Icon(Icons.fact_check,
                                                                size: 30, color: Colors.green),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      // Accept Driver Button
                                                      Card(
                                                        color: Colors.green.shade100,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(Icons.directions_car,
                                                              size: 30, color: Colors.green),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],

                                // if (selectedStatus == "Pending") ...[
                                //   for (var item in _activeMoList)
                                //     GestureDetector(
                                //       onTap: () {
                                //         _showCustomDialog(
                                //           context,
                                //           item.orderId.toString(),
                                //           item.poNumber.toString(),
                                //           item.challanNo,
                                //           item.challanno1,
                                //           item.vehicleNumber,
                                //           item.itemName,
                                //         ); // Pass the orderId here
                                //       },
                                //       child: Container(
                                //         padding: EdgeInsets.all(3.0),
                                //         child: Card(
                                //           color: Colors.white,
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(
                                //               12,
                                //             ),
                                //             side: BorderSide(
                                //               color: Colors.grey.shade300,
                                //             ),
                                //           ),
                                //           child: Padding(
                                //             padding: const EdgeInsets.all(16.0),
                                //             child: Row(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 // First Column
                                //                 Expanded(
                                //                   flex: 4,
                                //                   child: Column(
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment
                                //                             .start,
                                //                     children: [
                                //                       Row(
                                //                         crossAxisAlignment:
                                //                             CrossAxisAlignment
                                //                                 .start,
                                //                         children: [
                                //                           SizedBox(width: 8),
                                //                           // Vendor Name
                                //                           Expanded(
                                //                             child: Text(
                                //                               '${item.vehicleNumber} (${item.driverName})', // Dynamically set vendor name
                                //                               style: TextStyle(
                                //                                 fontWeight:
                                //                                     FontWeight
                                //                                         .bold,
                                //                                 fontSize: 13,
                                //                               ),
                                //                               overflow:
                                //                                   TextOverflow
                                //                                       .visible,
                                //                               maxLines: null,
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                       SizedBox(height: 8),
                                //                       Row(
                                //                         crossAxisAlignment:
                                //                             CrossAxisAlignment
                                //                                 .start,
                                //                         children: [
                                //                           Icon(
                                //                             Icons.location_on,
                                //                             color: Colors.green,
                                //                           ),
                                //                           SizedBox(width: 8),
                                //                           // Site Name (Address)
                                //                           Expanded(
                                //                             child: Text(
                                //                               item.siteName, // Use sitename from API
                                //                               overflow:
                                //                                   TextOverflow
                                //                                       .visible,
                                //                               maxLines: null,
                                //                               style: TextStyle(
                                //                                 color:
                                //                                     Colors
                                //                                         .grey
                                //                                         .shade600,
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                       SizedBox(height: 8),
                                //                       Row(
                                //                         children: [
                                //                           Icon(
                                //                             Icons.receipt,
                                //                             color: Colors.green,
                                //                           ),
                                //                           SizedBox(width: 8),
                                //                           Text(
                                //                             "PO: ${item.poNumber}", // Use PO number
                                //                             style: TextStyle(
                                //                               fontWeight:
                                //                                   FontWeight
                                //                                       .w500,
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //
                                //                       SizedBox(height: 8),
                                //                       Row(
                                //                         children: [
                                //                           Icon(
                                //                             Icons
                                //                                 .calendar_today,
                                //                             color: Colors.green,
                                //                           ),
                                //                           SizedBox(width: 8),
                                //                           Text(
                                //                             item.actionTime, // Use action time from API
                                //                             style: TextStyle(
                                //                               color:
                                //                                   Colors
                                //                                       .grey
                                //                                       .shade600,
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //                 SizedBox(width: 8),
                                //                 // Second Column (Buttons)
                                //                 Expanded(
                                //                   child: Column(
                                //                     children: [
                                //                       // QA/MO Button
                                //                       GestureDetector(
                                //                         onTap: () async {
                                //                           Navigator.push(
                                //                             context,
                                //                             MaterialPageRoute(
                                //                               builder:
                                //                                   (
                                //                                     context,
                                //                                   ) => QaMoScreen(
                                //                                     // showMapTmSection: true,
                                //                                     // showDetails: false,
                                //                                     // showTruckDetails: true,
                                //                                     // showOtpField: false,
                                //                                     // showConfirmBox: false,
                                //                                     sitename:
                                //                                         widget
                                //                                             .sitename,
                                //                                     vehicleNumber:
                                //                                         item.vehicleNumber,
                                //                                     moisture:
                                //                                         item.moisture,
                                //                                     itemName:
                                //                                         item.itemName,
                                //                                     ponumber:
                                //                                         item.poNumber,
                                //                                     challanno:
                                //                                         item.challanNo,
                                //                                     challanno1:
                                //                                         item.challanno1,
                                //                                     driverName:
                                //                                         item.driverName,
                                //                                     driverMobile:
                                //                                         item.driverMobile,
                                //                                     actionTime:
                                //                                         item.actionTime,
                                //                                     filename:
                                //                                         item.fileName,
                                //                                     oderid:
                                //                                         item.orderId,
                                //                                     role:
                                //                                         widget
                                //                                             .role,
                                //                                     uid:
                                //                                         widget
                                //                                             .uprofileid,
                                //                                     uname:
                                //                                         widget
                                //                                             .uname,
                                //
                                //                                     locationid:
                                //                                         widget
                                //                                             .locationid,
                                //                                     // order: item.poNumber.toString(),
                                //                                     // order: order,
                                //                                   ),
                                //                             ),
                                //                           );
                                //                         },
                                //                         child: Card(
                                //                           color:
                                //                               Colors
                                //                                   .green
                                //                                   .shade100,
                                //                           shape: RoundedRectangleBorder(
                                //                             borderRadius:
                                //                                 BorderRadius.circular(
                                //                                   8,
                                //                                 ),
                                //                           ),
                                //                           child: Padding(
                                //                             padding:
                                //                                 const EdgeInsets.all(
                                //                                   8.0,
                                //                                 ),
                                //                             child: Icon(
                                //                               Icons.fact_check,
                                //                               size: 30,
                                //                               color:
                                //                                   Colors.green,
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       ),
                                //                       SizedBox(height: 10),
                                //                       // Accept Driver Button
                                //                       // GestureDetector(
                                //                       //   onTap: () {
                                //                       //     _showCustomDialog(context, item.orderId.toString(),item.poNumber); // Pass the orderId here
                                //                       //   },
                                //                       Card(
                                //                         color:
                                //                             Colors
                                //                                 .green
                                //                                 .shade100,
                                //                         shape: RoundedRectangleBorder(
                                //                           borderRadius:
                                //                               BorderRadius.circular(
                                //                                 8,
                                //                               ),
                                //                         ),
                                //                         child: Padding(
                                //                           padding:
                                //                               const EdgeInsets.all(
                                //                                 8.0,
                                //                               ),
                                //                           child: Icon(
                                //                             Icons
                                //                                 .directions_car,
                                //                             size: 30,
                                //                             color: Colors.green,
                                //                           ),
                                //                         ),
                                //                       ),
                                //                       // ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
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
                                          expandedItems[item.orderId] =
                                              !(expandedItems[item.orderId] ??
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
                                                        '${item.itemName} (${item.vehicleNumber})', // Dynamically set order number
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
                                                          Text(
                                                            item.poNumber,
                                                          ), // Dynamically set PO number
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (expandedItems[item.orderId] ??
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
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.order_Status,
                                                  item.orderStatus,
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.chalan_number_1,
                                                  item.challanNo,
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.chalan_number_2,
                                                  item.challanNo1,
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.vehicle_Number,
                                                  item.vehicleNumber,
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.driver_Name,
                                                  item.driverName,
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.site_Name,
                                                  item.siteName,
                                                ),
                                                // _buildDivider(),
                                                // _buildInfoRow(AppLocalizations.of(context)!.net_Weight, item.netWeight.toString()),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.chalan_Weight_1,
                                                  item.netWeight.toString(),
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.chalan_Weight_2,
                                                  item.net1.toString(),
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.royalty_Pass,
                                                  item.orderId.toString(),
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.moisture,
                                                  item.moisture,
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.last_Action,
                                                  item.lastAction,
                                                ),
                                                _buildDivider(),
                                                _buildInfoRow(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.mrn_No,
                                                  item.mrnno.toString(),
                                                ), // Fixed field
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

  Widget _buildSpinner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            // color: Colors.grey.withOpacity(0.3),
            color: Color.fromRGBO(158, 158, 158, 0.3), // Grey with 30% opacity
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: DropdownButtonFormField<String>(
        initialValue: selectedItem,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.select_location,
          hintStyle: TextStyle(color: Colors.grey),
        ),
        isExpanded: true,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedItem = newValue;
            });

            // Call fetchMaterialOfficerData with selected sitename
            fetchMaterialOfficerData(selectedItem!);
          }
        },
        items:
            spinnerItems.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        icon: Icon(Icons.location_on, color: Colors.green),
        style: TextStyle(color: Colors.black, fontSize: 16),
        dropdownColor: Colors.white,
        itemHeight: 50,
      ),
    );
  }


}


