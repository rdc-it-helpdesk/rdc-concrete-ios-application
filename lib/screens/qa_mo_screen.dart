import 'dart:async'; // For Timer

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:rdc_concrete/screens/qa_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rdc_concrete/component/custom_elevated_button.dart';

import 'package:rdc_concrete/services/efidservice_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/add_user_pojo.dart';

///

import '../models/checkrfid_pojo.dart';

import '../models/reachplant_pojo.dart';
import '../models/weighbridgestatus_pojo.dart';

import '../services/insertvehicle_api_service.dart';
import '../services/reachplantornot_api_service.dart';
import '../services/updatedriver_del_api_service.dart';
import '../services/updatemoisture_api_service.dart';
import '../services/updatevehicle_api_service.dart';
// import '../services/updatevehiclenumber_api_service.dart';
import '../services/weighbridgeweight_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';
import 'home_page.dart';
import 'mo_home_page.dart';

// import '../services/update_moisture_service.dart';

class QaMoScreen extends StatefulWidget {
  // bool showMapTmSection;
  // bool showDetails;
  // bool showTruckDetails;
  // final bool showOtpField;
  // final bool showConfirmBox;
  final String? sitename;
  final String? vehicleNumber;
  final String? moisture;
  final String? itemName;
  // final String? rfid;
  final String? ponumber;
  final String? challanno;
  final String? challanno1;
  final String? driverName;
  final String? driverMobile;
  final String? actionTime;
  final String? uname;
  final String? filename;

  final String? role;
  final int? oderid;
  final int? uid;
  final int? locationid;

  // final ActiveMO order;

  const QaMoScreen({
    super.key,

    // this.showMapTmSection = false,
    // this.showDetails = false,
    // this.showTruckDetails = false,
    // required this.showOtpField,
    // required this.showConfirmBox,
    required this.sitename,
    this.vehicleNumber,
    this.moisture,
    this.itemName,
    // this.rfid,
    this.ponumber,
    this.challanno,
    this.challanno1,
    this.driverName,
    this.driverMobile,
    this.actionTime,
    this.role,
    required this.oderid,
    this.uid,
    this.uname,
    this.locationid,
    this.filename,
    // required this.order,
  });

  @override
  State<QaMoScreen> createState() => _QaMoScreenState();
}

class _QaMoScreenState extends State<QaMoScreen> with WidgetsBindingObserver {
  String? rfid, rfid1, rfid2;
  final List<TextEditingController> _otpControllers = List.generate(
    4,
        (_) => TextEditingController(),
  );
  // final _formKey = GlobalKey<FormState>();
  //late bool _showConfirmBox; // Start by showing the confirm box
  // late bool _showDetails; // Details will be hidden initially
  // bool _showConfirmBox = false;
  // bool _showDetails = false;
  bool flag1 = false, first = false, second = false;
  bool adminMo = false, maporupdate = false;

  bool isCancelled = false;
  bool _previousShowTruckDetails = true; // Store previous state
  bool _previousShowDetailsSection = true; // Store previous state
 // bool _previousIsMoistureCheck = true;
  bool _showMapTmSection = true;
  bool _showTruckDetails = true;
  bool _showDetailsSection = true;
  bool _isTruckOk = true;
  Set<int> expandedIndices = {};
  bool isMoistureCheck = true;
  bool cancelbtn = false;
  // bool _isradio = false;
  // bool _isnotreach = false;
  // bool _isaccept = false;
  // bool _isreject = false;
  late TextEditingController _siteController;
  late TextEditingController _voController;
  late TextEditingController _moistureController;
  late TextEditingController _vnController;
  late TextEditingController _ftnController;
  //String? _currentRfid;
  CheckRfid? rfidData;
  List<CheckRfid?> rfidDataList = [];
  bool _isLoading = false, moistureval = false;
  String uhfno = ""; // To hold the RFID type
  // To indicate if the second RFID is selected
  String? newtime1;
  String? truckcondition = "0";
  Timer? timer;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer for lifecycle
    checkuser();
    //SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);

    // Initialize controllers
    _siteController = TextEditingController();
    _voController = TextEditingController();
    _moistureController = TextEditingController();
    _vnController = TextEditingController(text: widget.vehicleNumber ?? "");
    //_ftnController = TextEditingController();
    _ftnController = TextEditingController(text: rfid ?? "Please Tap Fastag  card !");
    //
    // _showMapTmSection = widget.showMapTmSection;
    // _showConfirmBox = widget.showConfirmBox;
    // _showDetails = widget.showDetails;

    // print("🔹 Received Site Name: ${widget.sitename}");
    // print("🔹 Received Vehicle Number: ${widget.vehicleNumber}");
    // print("🔹 Received Moisture Value: ${widget.moisture}");
    fetchRfidDataui();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // setState(() {
      _siteController.text = widget.sitename!;
      _voController.text = widget.vehicleNumber ?? "";
      _moistureController.text = widget.moisture ?? "";
      // });
      _startPolling();
    });

  }

  void _startPolling() {
    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(Duration(seconds:1), (Timer t) {
      //  Fetch RFID Data
      fetchRfidData();
    });
  }

  Timer? _rfidTimer; // Timer to control the loop

  Future<void> fetchRfidData() async {
    if (widget.vehicleNumber == null || widget.vehicleNumber!.isEmpty) {
      //print('❌ Vehicle number is required');
      return;
    }
    if (widget.sitename == null || widget.sitename!.isEmpty) {
      //print('❌ Location is required');
      return;
    }

    try {
      // print("🔹 Fetching RFID for Vehicle: ${widget
      //     .vehicleNumber}, Location: ${widget.sitename}");

      RfidService service = RfidService();
      CheckRfid? rfidData = await service.checkRfid(
        widget.vehicleNumber!,
        widget.sitename!,
      );

      if (rfidData != null) {



        rfidData.rfid.toString();
        rfidData.rfid1.toString();
        rfidData.rfid2.toString();
        rfid = rfidData.rfid.toString();
        rfid1 = rfidData.rfid1.toString();
        rfid2 = rfidData.rfid2.toString();
        _ftnController.text = rfid ?? "Please Tap Fastag  card !";
        // print("rfiddemo${ rfidData.rfid.toString()}");
        // print("rfidone1${ rfidData.rfid1.toString()}");
        // print("rfidtwo2${ rfidData.rfid2.toString()}");

        if (maporupdate == true) {
          //print("maporupdate == true");

          _showMapTmSection = true;
          // cancelbtn = false;
          //cancelbutn gone
          //set vfiels and rfid
        } else if (rfidData.status == "1" || flag1 == false) {
          //all visible
          _showMapTmSection = false;
          if (_showMapTmSection == false) {
            //   _showTruckDetails = true;
            // _showDetailsSection = true;
            _buildTruckInfo();
            _buildDetailsSection();
          }

          if (mounted) {
            setState(() => _isLoading = false);
          }
        } else {
          _showMapTmSection = true;
          // cancelbtn = false;
          //cancelbutn gone
          //set v and rfid
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }

        return;
      }
      if (mounted) {
        setState(() {
          rfidData = rfidData;
          _isLoading = false;
        });
      }

      // Extract RFID values safely
      // String? rfid = _rfidData?.rfid;
      // String? rfid1 = _rfidData?.rfid1;
      // String? rfid2 = _rfidData?.rfid2;

      //print("rfidss${_rfidData?.rfid}");
      //print("rfid111${_rfidData?.rfid1}");
      //print("rfid2${_rfidData?.rfid2}");

      // Stop polling if status is "1"
      // if (_rfidData!.status == "1") {
      //   print("✅ Stopping polling as status is '1'.");
      //   _rfidTimer?.cancel();
      // }
    } catch (e) {
      //print('❌ Error in fetchRfidData: $e');
      //print(stackTrace);
      // setState(() => _isLoading = false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }
  Future<void> fetchRfidDataui() async {
    if (widget.vehicleNumber == null || widget.vehicleNumber!.isEmpty) {
      //print('❌ Vehicle number is required');
      return;
    }
    if (widget.sitename == null || widget.sitename!.isEmpty) {
      //print('❌ Location is required');
      return;
    }

    try {
      // print("🔹 Fetching RFID for Vehicle: ${widget
      //     .vehicleNumber}, Location: ${widget.sitename}");

      RfidService service = RfidService();
      CheckRfid? rfidData = await service.checkRfid(
        widget.vehicleNumber!,
        widget.sitename!,
      );

      if (rfidData != null) {



        rfidData.rfid.toString();
        rfidData.rfid1.toString();
        rfidData.rfid2.toString();
        rfid = rfidData.rfid.toString();
        rfid1 = rfidData.rfid1.toString();
        rfid2 = rfidData.rfid2.toString();
        _ftnController.text = rfid ?? "Please Tap Fastag  card !";
        // print("rfiddemo${ rfidData.rfid.toString()}");
        // print("rfidone1${ rfidData.rfid1.toString()}");
        // print("rfidtwo2${ rfidData.rfid2.toString()}");

        if (maporupdate == true) {
          //print("maporupdate == true");

          _showMapTmSection = true;
          // cancelbtn = false;
          //cancelbutn gone
          //set vfiels and rfid
        } else if (rfidData.status == "1" || flag1 == false) {
          //all visible
          _showMapTmSection = false;
          if (_showMapTmSection == false) {
            //   _showTruckDetails = true;
            // _showDetailsSection = true;
            _buildTruckInfo();
            _buildDetailsSection();
          }

          if (mounted) {
            setState(() => _isLoading = false);
          }
        } else {
          _showMapTmSection = true;
          // cancelbtn = false;
          //cancelbutn gone
          //set v and rfid
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }

        return;
      }
      if (mounted) {
        setState(() {
          rfidData = rfidData;
          _isLoading = false;
        });
      }

      // Extract RFID values safely
      // String? rfid = _rfidData?.rfid;
      // String? rfid1 = _rfidData?.rfid1;
      // String? rfid2 = _rfidData?.rfid2;

      //print("rfidss${_rfidData?.rfid}");
      //print("rfid111${_rfidData?.rfid1}");
      //print("rfid2${_rfidData?.rfid2}");

      // Stop polling if status is "1"
      // if (_rfidData!.status == "1") {
      //   print("✅ Stopping polling as status is '1'.");
      //   _rfidTimer?.cancel();
      // }
    } catch (e) {
      //print('❌ Error in fetchRfidData: $e');
      //print(stackTrace);
      // setState(() => _isLoading = false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  Future<void> saveStatusToPrefs(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('rfid_status', status);
  }

  // Call this function when you want to stop fetching
  void stopRfidFetching() {
    _rfidTimer?.cancel();
    //print("RFID fetching stopped.");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App is resuming from background (e.g., after file picker)
      _startPolling(); // Restart polling or refresh data
      fetchRfidData(); // Optionally fetch data immediately
    } else if (state == AppLifecycleState.paused) {
      // App is going to background
      timer?.cancel(); // Pause the timer to avoid unnecessary calls
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    // Dispose of the controllers to avoid memory leaks
    _siteController.dispose();
    _voController.dispose();
    _moistureController.dispose();
    _ftnController.dispose();

    // Dispose of OTP controllers
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _rfidTimer?.cancel(); // Cancel the timer when screen is disposed
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkuser() async {
    if (widget.role == "MATERIALOFFICER") {
      adminMo = true;
      flag1 = true;
      checkischecked();
    }
    if (widget.role == "ADMIN") {
      adminMo = true;
      flag1 = true;
      checkischecked();
    }
  }

  Future<void> reachplantstatus() async {
    //print("hellloooo");
    String reachplant = "0";
    ReachplantornotApiService reachplantornotApiService =
    ReachplantornotApiService();
    ReachPlant? response = await reachplantornotApiService.reachSite(
      widget.oderid.toString(),
      widget.uid.toString(),
      reachplant,
    );
    if (mounted) {
      setState(() {
        if (response.reachplant == "no") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => QaHomeScreen(
                uid: widget.uid,
                itemname: widget.itemName,
                role: widget.role,
                uname: widget.uname,
                sitename: widget.sitename,
                locationid: widget.locationid,
              ),
            ),
          );

          ///loading dismis
        } else {
          showErrorDialog("Try again !");
          // loadingDialog.dismiss();
        }
      });
    }
  }

  Future<void> cancel() async {
    flag1 = false;
    _showMapTmSection = false;
    _showTruckDetails = true;
    _showDetailsSection = true;
  }

  Future<void> reject() async {
    showAlert(context);
  }

  Future<void> checkischecked() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    String location = widget.sitename.toString();
    String oid = widget.oderid.toString();

    try {
      WeighbridgeweightApiService weighbridgeweightApiService =
      WeighbridgeweightApiService();
      List<WeighbridgeStatus>? uploadAddress =
      (await weighbridgeweightApiService.getweight(location, oid))
      as List<WeighbridgeStatus>?;

      if (uploadAddress != null && uploadAddress.isNotEmpty) {
        for (WeighbridgeStatus size in uploadAddress) {
          if (size.weight == "Moisture isn't Check") {
            //  setState(() {
            // // Set to true if moisture check is not done
            //  });
            //  break; // Exit the loop if we find a match
          } else {
            if (mounted) {
              setState(() {
                // _isMoistureCheck = false;
                // _isaccept = false;
                // _isradio = false;
                // _isreject = false;
                // _isnotreach = false;
                _showDetailsSection = false;
              });
            }
          }
        }
      }
    } catch (e) {
      //print('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(""),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startCountDown(Duration duration) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      int seconds = duration.inSeconds - timer.tick;
      if (seconds <= 0) {
        timer.cancel();
        setState(() {
          // Update UI after countdown ends
        });
      } else {
        setState(() {
          // Update countdown UI
        });
      }
    });
  }
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        bool isLoading = false; // Track loading state

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Warning!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!
                          .do_you_want_to_reject_this_record,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 50,
                    ),
                    SizedBox(height: 20),

                    // Show loader if isLoading == true
                    if (isLoading)  Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ), // Set the color to green
                      ),
                    ),

                    if (!isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() => isLoading = true);

                              String myDate = DateFormat('yyyy-MM-dd HH:mm')
                                  .format(DateTime.now());
                              final apiService = UpdatedriverDelApiService();

                              try {
                                SetStatus? statusResponse =
                                await apiService.setStatus(
                                  widget.oderid.toString(),
                                  widget.uid.toString(),
                                  myDate,
                                  false,
                                  false,
                                );

                                if (statusResponse.status == "1") {


                                  if (context.mounted) {
                                    if(widget.role == "ADMIN") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(
                                                sitename: widget.sitename
                                                    .toString(),
                                                role: widget.role.toString(),
                                                uprofileid: widget.uid!.toInt(),
                                                locationid: widget.locationid,
                                                uname: widget.uname.toString(),

                                              ),
                                        ),
                                      );
                                    }else{
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MOHomePage(
                                                role: widget.role.toString(),
                                                sitename: widget.sitename.toString(),
                                                uname: widget.uname.toString(),
                                                locationid: widget.locationid!.toInt(),
                                                uprofileid: widget.uid!.toInt(),
                                                // userid:widget.uid.toString(),
                                                // sitename: widget.sitename
                                                //     .toString(),
                                                // role: widget.role.toString(),
                                                // uprofileid: widget.uid!.toInt(),
                                                // locationid: widget.locationid,
                                                // uname: widget.uname.toString(),
                                              ),
                                        ),
                                      );
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    Navigator.of(context).pop(); // Close dialog
                                    _showErrorDialog(
                                        context, "Something went wrong!");
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Navigator.of(context).pop(); // Close dialog
                                  _showErrorDialog(
                                      context, "Something went wrong!");
                                }
                              } finally {
                                if (context.mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.yes),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

//main
  // void showAlert(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.transparent,
  //         content: Container(
  //           padding: EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Warning!',
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 10),
  //               Text(
  //                 AppLocalizations.of(
  //                   context,
  //                 )!.do_you_want_to_reject_this_record,
  //                 style: TextStyle(fontSize: 16),
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: 20),
  //               Icon(
  //                 Icons.warning, // Use the warning icon from Material Icons
  //                 color: Colors.red,
  //                 size: 50, // Set the size of the icon
  //               ),
  //               SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop(); // Dismiss the dialog
  //                     },
  //                     child: Text(AppLocalizations.of(context)!.cancel),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       String myDate = DateFormat(
  //                         'yyyy-MM-dd HH:mm',
  //                       ).format(DateTime.now());
  //                       final apiService = UpdatedriverDelApiService();
  //
  //                       try {
  //                         SetStatus? statusResponse = await apiService
  //                             .setStatus(
  //                               widget.oderid.toString(),
  //                               widget.uid.toString(),
  //                               myDate,
  //                               false,
  //                               false,
  //                             );
  //
  //                         if (statusResponse.status == "1") {
  //                           //print("uppppppppp");
  //                           // Check if the widget is still mounted
  //                           if (context.mounted) {
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder:
  //                                     (context) => HomePage(
  //                                       sitename: widget.sitename.toString(),
  //                                       role: widget.role.toString(),
  //                                       uprofileid: widget.uid!.toInt(),
  //                                       locationid: widget.locationid,
  //                                       uname: widget.uname.toString(),
  //                                     ),
  //                               ),
  //                             );
  //                           }
  //                         } else {
  //                           if (context.mounted) {
  //                             // Check if the widget is still mounted
  //                             _showErrorDialog(
  //                               context,
  //                               "Something went wrong!",
  //                             );
  //                           }
  //                         }
  //                       } catch (e) {
  //                         if (mounted) {
  //                           // Check if the widget is still mounted
  //                           (context, "Something went wrong!");
  //                         }
  //                       }
  //                     },
  //                     child: Text(AppLocalizations.of(context)!.yes),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void showAlert1(BuildContext context, String createdid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Warning!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'do you want to Update Vehicle Number ',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Icon(
                  Icons.warning, // Use the warning icon from Material Icons
                  color: Colors.red,
                  size: 50, // Set the size of the icon
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // String myDate = DateFormat('yyyy-MM-dd HH:mm').format(
                        //     DateTime.now());
                        // final apiService = UpdatedriverDelApiService(); // Dismiss the dialog

                        //UpdatevehiclenumberApiService updatevehiclenumberApiService = UpdatevehiclenumberApiService();
                        // SetStatus? statusResponse = await updatevehiclenumberApiService
                        //     .Updatevehicle(
                        //   widget.oderid.toString(),
                        //   createdid,
                        //
                        // );
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    ElevatedButton(onPressed: () async {}, child: Text('Yes')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> accept() async {
    print('→ accept() started | item: ${widget.itemName} | order: ${widget.oderid} | uid: ${widget.uid} | role: ${widget.role}');
    //  String moistureUp;

    double? moisture;
    moisture = double.tryParse(_moistureController.text);

    print('  → Parsed moisture: $moisture (raw input: ${_moistureController.text})');

    String itemName = widget.itemName.toString();
    //String itemName = "SAND";
    print("sand${itemName}");

    if (moisture! > 30) {
      print('  → Validation failed: moisture $moisture > 30');
      _showErrorDialog(context, "Invalid Moisture Data");
      return;
    }
    // Check if the item name contains "SAND"
    else if (itemName.toUpperCase().contains("SAND") && moisture < 2.0) {
      print('  → SAND item → moisture $moisture < 2.0 → rejected');
      _showErrorDialog(context, "Minimum 2% Require !");
      return;
    }
    // Call the API
    try {
      // --------------------------------------------------------------
      // 1. CAPTURE context BEFORE any async operation
      // --------------------------------------------------------------
      final BuildContext ctx = context;

      // Early exit if widget is already disposed
      if (!mounted) return;

      print("moisture${moisture}");


      // --------------------------------------------------------------
      // 2. API call
      // --------------------------------------------------------------
      final UpdatemoistureApiService updatemoistureApiService = UpdatemoistureApiService();
      final SetStatus response = await updatemoistureApiService.updatetmoisture(
        moisture.toString(),
        widget.oderid.toString(),
        truckcondition.toString(),
        widget.uid.toString(),
      );
      final String moistureStr = moisture.toString();
      final String orderIdStr  = widget.oderid.toString();
      final String conditionStr = truckcondition.toString();
      final String uidStr      = widget.uid.toString();
      final Map<String, String> payload = {
        "moisture": moistureStr,
        "oderid": orderIdStr,           // or "order_id" depending on backend
        "truckcondition": conditionStr, // or "truck_condition"
        "uid": uidStr,
      };

      print('Payload (JSON-like):');
      print(payload);                    // compact
// or more readable:
      print('→ Full payload map: $payload');
      print('  → API response: status=${response.status}, message=${response.message ?? "no message"}');
      // --------------------------------------------------------------
      // 3. Check if still mounted after await
      // --------------------------------------------------------------
      if (!ctx.mounted) return;
      // --------------------------------------------------------------
      // 4. Handle success      // --------------------------------------------------------------
      if (response.status == "1") {
        final String? role = widget.role;

        if (role == "QA TESTER") {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => QaHomeScreen(
                uid: widget.uid,
                itemname: widget.itemName,
                role: role,
                uname: widget.uname,
                sitename: widget.sitename,
                locationid: widget.locationid,
              ),
            ),
          );
        } else if (role == "ADMIN") {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(
              builder: (_) => HomePage(
                sitename: widget.sitename.toString(),
                role: role,
                uprofileid: widget.uid!.toInt(),
                locationid: widget.locationid,
                uname: widget.uname.toString(),
              ),
            ),
          );
        } else {
          // Default: MO or others
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => MOHomePage(
                sitename: widget.sitename!,
                locationid: widget.locationid!.toInt(),
                uprofileid: widget.uid,
                role: role,
                uname: widget.uname,
              ),
            ),
          );
        }
      } else {
        // --------------------------------------------------------------
        // 5. API failed (status != "1")
        // --------------------------------------------------------------
        _showErrorDialog(ctx, "Try again !");
      }
    } catch (e) {
      // --------------------------------------------------------------
      // 6. Exception handling
      // --------------------------------------------------------------
      final BuildContext ctx = context; // safe to recapture here
      if (ctx.mounted) {
        _showErrorDialog(ctx, "Something went wrong");
      }
    }
    // try {
    //   // SetStatus response = await ApiClient.getApi().defaultMoisture(orderId, moistureUp, id, myDate);
    //   UpdatemoistureApiService updatemoistureApiService =
    //   UpdatemoistureApiService();
    //   SetStatus? response = await updatemoistureApiService.updatetmoisture(
    //     moisture.toString(),
    //     widget.oderid.toString(),
    //     truckcondition.toString(),
    //     widget.uid.toString(),
    //   );
    //   // Check the response status
    //   if (response.status == "1") {
    //     if (widget.role == "QA TESTER") {
    //       if (!mounted) return;
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder:
    //               (context) => QaHomeScreen(
    //             uid: widget.uid,
    //             itemname: widget.itemName,
    //             role: widget.role,
    //             uname: widget.uname,
    //             sitename: widget.sitename,
    //             locationid: widget.locationid,
    //           ),
    //         ),
    //       );
    //     }else if (widget.role == "ADMIN") {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) =>
    //               HomePage(
    //                 sitename: widget.sitename
    //                     .toString(),
    //                 role: widget.role.toString(),
    //                 uprofileid: widget.uid!.toInt(),
    //                 locationid: widget.locationid,
    //                 uname: widget.uname.toString(),
    //
    //               ),
    //         ),
    //       );
    //     }else {
    //       if (!mounted) return;
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder:
    //               (context) => MOHomePage(
    //             sitename: widget.sitename!,
    //             locationid: widget.locationid!.toInt(),
    //             uprofileid: widget.uid,
    //             role: widget.role,
    //             uname: widget.uname,
    //
    //           ),
    //         ),
    //       );
    //     }
    //   } else {
    //     showErrorDialog("Try again !");
    //   }
    // } catch (e) {
    //   // Handle any errors
    //   showErrorDialog("Something went wrong");
    // }
  }

  Future<void> map() async {
    setState(() {
      _isLoading = true; // show loader
    });
    String rfifno = _ftnController.text;
    ///String rfifno = _currentRfid.toString();
    String vehicleno = _vnController.text;
    // print('vehiclenovehicleno $vehicleno');
    // print('vehiclenovehicleno $rfifno');
    // String rfidNo = _fastagController.text;
    try {
      if (rfifno == "Please Tap Fastag  card !" || rfifno.isEmpty) {
        _showErrorDialog(context, "Please tap Fastag card before proceeding!");
        return;
      }
      if (first == true || second == true) {
        //print('hetyeegdy $rfifno');
        if (rfifno != "Please Tap Fastag  card !") {
          UpdatevehicleApiService updatevehicleApiService =
          UpdatevehicleApiService();
          SetStatus status = await updatevehicleApiService.updatevehicle(
            vehicleno,
            rfifno,
            uhfno,
          );
          //print('hetygdy $rfifno');
          if (status.status == "1") {
            try {
              _showMapTmSection = false;
              if (_showMapTmSection = false) {
                _buildTruckInfo();
                _buildDetailsSection();
              }
            } catch (e) {
              if (!mounted) return;
              _showErrorDialog(
                context,
                "Failed to update vehicle. Please try again.",
              );
            }
          }
          else{
            if (!mounted) return;
            _showErrorDialog(
              context,
              "${status.message} ,Update  using Computer Software",
            );
          }
        } else {
          _showErrorDialog(context, "Please select mandatory !");
        }
      }
      else {
        InsertvehicleApiService insertvehicleApiService =
        InsertvehicleApiService();

        if (rfifno != "Please Tap Fastag  card !" &&
            rfifno != "FASTAG :") {
          SetStatus status = await insertvehicleApiService.insertvehicle(
            rfifno,
            vehicleno
            ,
          );
          if (status.status == "1") {
            try {
              _showMapTmSection = false;
              if (_showMapTmSection = false) {
                if (!mounted) return;
                _buildTruckInfo();
                _buildDetailsSection();
                _showErrorDialog(context, status.message.toString());
              }
            } catch (e) {
              if (!mounted) return;
              showAlert1(context, status.createdid.toString());
              _showErrorDialog(
                context,
                "Failed to update vehicle. Please try again.",
              );
            }
          } else {
            if (!mounted) return;
            _showErrorDialog(
              context,
              "${status.message} ,Update  using Computer Software",
            );
          }
        }
      }
    }catch (e) {
      if (!mounted) return; // ensure widget is still in tree
      _showErrorDialog(context, "Failed to update vehicle. Please try again.");
    }
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // hide loader after all work is done
        });
      }
    }
  }

  void _showErrorDialog(BuildContext context,  String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(""),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'QA/MO',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// Background Image
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
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

          /// Show Loader While Fetching Data
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          else
            RefreshIndicator(
              onRefresh: () async {
                setState(() => _isLoading = true);
                await fetchRfidData();
                setState(() => _isLoading = false);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_showMapTmSection) _buildMapTmSection(),
                      if (!_showMapTmSection) ...[
                        _buildTruckInfo(),
                        const SizedBox(height: 10),
                        _buildDetailsSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final primaryColor = Theme.of(context).primaryColor;
  //   //   final selectedLocationItems = ModalRoute
  //   // .of(context)
  //   //  ?.settings
  //   //   .arguments as String?;
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: primaryColor,
  //       centerTitle: true,
  //       title: Text(
  //         'QA/MO',
  //         style: TextStyle(
  //           fontSize: 24,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //       iconTheme: IconThemeData(color: Colors.white),
  //     ),
  //     resizeToAvoidBottomInset: false,
  //     body: Stack(
  //       children: [
  //         if (_isLoading)
  //           Center(
  //             child: CircularProgressIndicator(
  //               valueColor: AlwaysStoppedAnimation<Color>(
  //                 Colors.green,
  //               ), // Set the color to green
  //             ),
  //           ),
  //
  //         /// Background Image
  //         Container(
  //           height: double.infinity,
  //           decoration: BoxDecoration(
  //             color: Color.fromRGBO(0, 0, 0, 0.5),
  //             image: DecorationImage(
  //               image: AssetImage("assets/bg_image/RDC.png"),
  //               fit: BoxFit.cover,
  //               colorFilter: ColorFilter.mode(
  //                 Color.fromRGBO(0, 0, 0, 0.3),
  //                 BlendMode.dstATop,
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         /// Show Loader While Fetching Data
  //         _isLoading
  //             ? Center(child: CircularProgressIndicator(color: Colors.white))
  //             : RefreshIndicator(
  //               onRefresh: () async {
  //                 setState(() => _isLoading = true);
  //                 await fetchRfidData();
  //                 setState(() {
  //                   _isLoading = false;
  //                   // if (_rfidData != null && _rfidData?.status != "0" && _rfidData?.rfid != "Please Tap Fastag  card !") {
  //                   //   _ftnController.text = _rfidData?.rfid ?? "N/A";
  //                   // }
  //                 });
  //               },
  //               child: SingleChildScrollView(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       if (_showMapTmSection) _buildMapTmSection(),
  //                       //
  //                       //if (_rfidData == null ||  _rfidData?.status == "0" || _rfidData?.rfid == "Please Tap Fastag  card !") ...[
  //                       //   _buildMapTmSection(),
  //                       //   SizedBox(height: 10),
  //                       // ]
  //                       // else ...[
  //                       if (!_showMapTmSection) ...[
  //                         _buildTruckInfo(),
  //                         SizedBox(height: 10),
  //                         _buildDetailsSection(),
  //                       ],
  //
  //                       // ],
  //
  //                       //    if (_rfidData == null ||  _rfidData?.status == "0" || _rfidData?.rfid == "Please Tap Fastag  card !") ...[
  //                       //      _buildMapTmSection(),
  //                       //      SizedBox(height: 10),
  //                       //    ]
  //                       //    else ...[
  //                       //      _buildTruckInfo(),
  //                       //      SizedBox(height: 10),
  //                       //      _buildDetailsSection(),
  //                       // ],
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMapTmSection() {
    // if (!_showMapTmSection) return SizedBox.shrink(); // Return empty if not visible

    final primaryColor = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    controller: _vnController,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      hintText:
                      AppLocalizations.of(context)!.enter_Vehicle_Number,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelText:
                      AppLocalizations.of(context)!.enter_Vehicle_Number,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      hintText: AppLocalizations.of(context)!.enter_Fastag_No,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelText: AppLocalizations.of(context)!.enter_Fastag_No,
                    ),
                    readOnly: true,
                    controller: _ftnController,
                    // controller: _ftnController(
                    //   text:
                    //       rfid ??
                    //       "Please Tap Fastag  card !", // Set the RFID value here
                    // ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              map();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: primaryColor,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.map,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      if (cancelbtn) ...[
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                               // _showMapTmSection =false;
                                _showMapTmSection = false;
                                _showTruckDetails = _previousShowTruckDetails;
                                _showDetailsSection = _previousShowDetailsSection;
                             //  _isMoistureCheck = _previousIsMoistureCheck;
                                cancelbtn = false;
                                maporupdate = false;
                                first = false;
                                second = false;
                                uhfno = "";
                             //   _currentRfid = null;
                                // Refresh data to ensure _buildDetailsSection is up-to-date
                                fetchRfidData();
                                // if (_showMapTmSection == false) {
                                //   //   _showTruckDetails = true;
                                //   // _showDetailsSection = true;
                                //   _buildTruckInfo();
                                //   _buildDetailsSection();
                                // }
                                // Hide the section on cancel

                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //   Widget _buildMapTmSection() {
  //    // if (!widget.showMapTmSection) return SizedBox.shrink();
  //
  // print("calllllllllll");
  //     final primaryColor = Theme.of(context).primaryColor;
  //     final screenWidth = MediaQuery.of(context).size.width; // Get screen width
  //     final screenHeight = MediaQuery.of(context).size.height; // Get screen height
  //
  //     return Padding(
  //       padding: const EdgeInsets.all(2),
  //       child: Column(
  //
  //
  //         children: [
  //
  //           Card(
  //             child: Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 children: [
  //
  //                   SizedBox(height: screenHeight * 0.02),
  //
  //                   TextField(
  //                     controller: _vnController,
  //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //                     decoration: InputDecoration(
  //                         focusedBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: primaryColor),
  //                             borderRadius: BorderRadius.circular(11)
  //                         ),
  //                         border: OutlineInputBorder(
  //                             borderSide: const BorderSide(color: Colors.green),
  //                             borderRadius: BorderRadius.circular(11)
  //                         ),
  //                         hintText: 'Enter Vehicle Number',
  //                         filled: true,
  //                         fillColor: Colors.grey.shade200,
  //                         labelText: "Enter Vehicle Number"
  //                     ),
  //                     // decoration: InputDecoration(
  //                     //   hintText: 'Enter Vehicle Number',
  //                     //   border: OutlineInputBorder(),
  //                     //   contentPadding: EdgeInsets.all(screenWidth * 0.04),
  //                     // ),
  //                     readOnly: true,
  //                   ),
  //                   // FASTAG No. Field
  //                   SizedBox(height: screenHeight * 0.02),
  //
  //                   TextField(
  //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //                     decoration: InputDecoration(
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide: BorderSide(color: primaryColor),
  //                         borderRadius: BorderRadius.circular(11),
  //                       ),
  //                       border: OutlineInputBorder(
  //                         borderSide: const BorderSide(color: Colors.green),
  //                         borderRadius: BorderRadius.circular(11),
  //                       ),
  //                       hintText: 'Enter FASTAG No.',
  //                       filled: true,
  //                       fillColor: Colors.grey.shade200,
  //                       labelText: "Enter FASTAG No.",
  //                     ),
  //
  //                     readOnly: true,  // Prevents manual editing if needed
  //                     controller: TextEditingController(
  //                       //text: _rfidData?.rfid ?? "N/A", // Directly setting RFID value here
  //                       text: _rfidData?.rfid.toString(), // Directly setting RFID value here
  //                     ),
  //
  //                   ),
  //
  //                   // Action Buttons
  //                   SizedBox(height: screenHeight * 0.03),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       // "Map" button
  //                       SizedBox(
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             setState(() {
  //                                // Hide this section
  //                               // log(_rfidData!.rfid);
  //                               // widget.showMapTmSection = false;
  //                               // // if(_showTruckDetails == true) _buildTruckInfo();
  //                               // widget.showTruckDetails = true;  // Show Truck Info Section
  //                               // widget.showDetails = true;  // Show Details Section
  //                             });
  //
  //
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             backgroundColor: primaryColor,
  //                           ),
  //                           child: Text(
  //                             'Map',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: screenWidth * 0.05),
  //                       // "Cancel" button
  //                       SizedBox(
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //
  //                                               },
  //                           style: ElevatedButton.styleFrom(
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             backgroundColor: Colors.redAccent,
  //                           ),
  //                           child: Text(
  //                             'Cancel',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: screenHeight * 0.05),  // Adds a little space at the bottom
  //                 ],
  //               ),
  //             ),
  //           ),
  //
  //         ],
  //       ),
  //     );
  //   }

  Widget _buildTruckInfo() {
    if (_showDetailsSection) {
      if (!mounted) return Container();
      final primaryColor = Theme.of(context).primaryColor;
      double screenWidth = MediaQuery.of(context).size.width;
      if (isMoistureCheck) {
        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // if (AdminMo) ...[
                //   CustomElevatedButton(
                //     height: 45,
                //     width: screenWidth * 0.3,
                //     onPressed: () {},
                //     text: "Map Fastage",
                //     backgroundColor: primaryColor,
                //     popOnPress: true,
                //   ),
                // ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // or spaceBetween, center, etc.
                  children: [
                    // ---------- TRUCK OK (Yes) ----------
                    RadioMenuButton<bool>(
                      value: true,
                      groupValue: _isTruckOk,
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() => _isTruckOk = value);
                        }
                      },
                      style: MenuItemButton.styleFrom(
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(AppLocalizations.of(context)!.truck_Is_Ok),
                    ),

                    const SizedBox(width: 16), // spacing between options



                    // ---------- TRUCK NOT OK (No) ----------
                    RadioMenuButton<bool>(
                      value: false,
                      groupValue: _isTruckOk,
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() => _isTruckOk = value);
                        }
                      },
                      style: MenuItemButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                      child: Text(AppLocalizations.of(context)!.truck_Is_Not_Ok),
                    ),
                  ],
                ),
                //old
                // Row(
                //   children: [
                //     Radio(
                //       activeColor: primaryColor,
                //       value: true,
                //       groupValue: _isTruckOk,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           _isTruckOk = value!;
                //         });
                //       },
                //     ),
                //     Text(AppLocalizations.of(context)!.truck_Is_Ok),
                //     Radio(
                //       activeColor: primaryColor,
                //       value: false,
                //       groupValue: _isTruckOk,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           _isTruckOk = value!;
                //         });
                //       },
                //     ),
                //     Text(AppLocalizations.of(context)!.truck_Is_Not_Ok),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        reachplantstatus();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.dont_reach_the_plant,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomElevatedButton(
                      height: 45,
                      width: screenWidth * 0.3,
                      onPressed: () {
                        accept();
                      },
                      text: AppLocalizations.of(context)!.accept,
                      backgroundColor: primaryColor,
                      popOnPress: true,
                    ),
                    CustomElevatedButton(
                      height: 45,
                      width: screenWidth * 0.3,
                      onPressed: () {
                        reject();
                      },
                      text: AppLocalizations.of(context)!.reject,
                      backgroundColor: primaryColor,
                      popOnPress: true,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                if (adminMo) ...[
                  TextField(
                    controller: _moistureController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.green.shade50,
                      hintText:
                      (widget.moisture == null ||
                          widget.moisture!.trim().isEmpty ||
                          double.tryParse(widget.moisture!) == null ||
                          double.parse(widget.moisture!) <= 0)
                          ? AppLocalizations.of(context)!.moisture
                          : widget.moisture,
                      hintStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      }
    }
    // Ensure that a Widget is always returned
    return SizedBox.shrink(); // This will be returned if _showDetailsSection is false or _isMoistureCheck is false
  }
  // Widget _buildTruckInfo() {
  //   if(_showDetailsSection) {
  //     // if (!widget.showTruckDetails) return SizedBox.shrink();
  //     if (!mounted) return Container();
  //     final primaryColor = Theme.of(context).primaryColor;
  //     double screenWidth = MediaQuery.of(context).size.width;
  //     if(_isMoistureCheck){
  //       return Card(
  //         color: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             children: [
  //               if (AdminMo) ...[
  //                 CustomElevatedButton(
  //                   height: 45,
  //                   width: screenWidth * 0.3,
  //                   onPressed: () {
  //
  //                   },
  //                   text: "Map Fastage",
  //                   backgroundColor: primaryColor,
  //                   popOnPress: true,
  //                 ),
  //               ],        // Show the original UI elements
  //               Row(
  //                 children: [
  //                   Radio(
  //                     activeColor: primaryColor,
  //                     value: true,
  //                     groupValue: _isTruckOk,
  //                     onChanged: (bool? value) {
  //                       setState(() {
  //                         _isTruckOk = value!;
  //                       });
  //                     },
  //                   ),
  //                   Text('Truck is Ok'),
  //                   Radio(
  //                     activeColor: primaryColor,
  //                     value: false,
  //                     groupValue: _isTruckOk,
  //                     onChanged: (bool? value) {
  //                       setState(() {
  //                         _isTruckOk = value!;
  //                       });
  //                     },
  //                   ),
  //                   Text('Truck is not Ok'),
  //                 ],
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   TextButton(
  //                     onPressed: () {
  //                       reachplantstatus();
  //                     },
  //                     child: Text("Don't reach the Plant !!!"),
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   CustomElevatedButton(
  //                     height: 45,
  //                     width: screenWidth * 0.3,
  //                     onPressed: () {
  //                       accept();
  //                     },
  //                     text: "Accept",
  //                     backgroundColor: primaryColor,
  //                     popOnPress: true,
  //                   ),
  //                   CustomElevatedButton(
  //                     height: 45,
  //                     width: screenWidth * 0.3,
  //
  //                     onPressed: () {
  //                       reject();
  //                     },
  //                     text: "Reject",
  //                     backgroundColor: primaryColor,
  //                     popOnPress: true,
  //                   ),
  //                 ],
  //               ),
  //
  //               SizedBox(
  //                 height: 15,
  //               ),
  //
  //               if (AdminMo) ...[
  //                 TextField(
  //                   controller: _moistureController,
  //                   keyboardType: TextInputType.text,
  //                   decoration: InputDecoration(
  //                     filled: true,
  //                     fillColor: Colors.green.shade50,
  //                     hintText: (widget.moisture == null || widget.moisture!.trim().isEmpty ||
  //                         double.tryParse(widget.moisture!) == null ||
  //                         double.parse(widget.moisture!) <= 0)
  //                         ? "Moisture"
  //                         : widget.moisture,
  //                     // hintText: widget.moisture,
  //                     hintStyle: TextStyle(color: Colors.black54),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(15),
  //                       borderSide: BorderSide(color: Colors.green),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(15),
  //                       borderSide: BorderSide(color: Colors.green),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(15),
  //                       borderSide: BorderSide(color: Colors.green, width: 2),
  //                     ),
  //                     // prefixIcon: Icon(Icons.map, color: Colors.green),
  //                     contentPadding:
  //                     EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //                   ),
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                   textAlign: TextAlign.center,
  //                   // readOnly: true,
  //                 ),
  //
  //               ],
  //             ],
  //           ),
  //         ),
  //       );}
  //     return SizedBox.shrink();
  // }
  //}

  // void _openPdf(BuildContext context) async {
  //   String? filename = widget.filename;
  //   // Base URL
  //   String baseUrl = "https://vendors.rdc.in/rdc01/";
  //   // URL to the PDF
  //   String pdfUrl = "$baseUrl$filename";
  //
  //   // Check if the URL can be launched
  //   if (await canLaunch(pdfUrl)) {
  //     // Open the URL in the default browser
  //     await launch(pdfUrl);
  //   } else {
  //     print('Could not launch $pdfUrl');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Could not open PDF."), backgroundColor: Colors.red),
  //     );
  //   }
  // }


  void _openPdf(String filename) async {
    final Uri pdfUri = Uri.parse("https://vendors.rdc.in/rdc01/$filename");

    await launchUrl(
      pdfUri,
      mode: LaunchMode.externalApplication, // opens in browser
    );
  }
  //main
  // void _openPdf() async {
  //   String? filename = widget.filename; // Use nullable type
  //
  //   // Check if the filename is null or empty
  //   if (filename == null || filename.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Filename is missing."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return; // Exit the function early
  //   }
  //
  //   // URL to the PDF
  //   String pdfUrl = "https://vendors.rdc.in/rdc01/$filename";
  //
  //   // Create a Uri object
  //   Uri pdfUri = Uri.parse(pdfUrl);
  //
  //   // Check if the URL can be launched
  //   if (await canLaunchUrl(pdfUri)) {
  //     // Open the URL in the default browser
  //     await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $pdfUrl';
  //   }
  // }
  //
  //----
  // void _openPdf() async {
  //   String? filename = widget.filename; // Use nullable type
  //   //print("filename: $filename");
  //
  //   // Check if the filename is null or empty
  //   if (filename == null || filename.isEmpty) {
  //     //print("Error: Filename is null or empty.");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(" Filename is missing."),backgroundColor: Colors.red,),
  //     );
  //     return; // Exit the function early
  //   }
  //
  //   // URL to the PDF
  //   String pdfUrl = "https://vendors.rdc.in/rdc01/$filename";
  //   //print("PDF URL: $pdfUrl");
  //
  //   // Check if the URL can be launched
  //   if (await canLaunch(pdfUrl)) {
  //     // Open the URL in the default browser
  //     await launch(pdfUrl, forceSafariVC: false, forceWebView: false);
  //   } else {
  //     //print('Could not launch $pdfUrl');
  //     throw 'Could not launch $pdfUrl';
  //   }
  // }

  Widget _buildDetailsSection() {
    if (!mounted) return Container();
    final primaryColor = Theme.of(context).primaryColor;
    // Early return if details should not be shown
    if (!_showTruckDetails) {
      return SizedBox.shrink();
    }

    CheckRfid? rfidData = rfidDataList.isNotEmpty ? rfidDataList.first : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(11),
            decoration: BoxDecoration(
              // color: Color(0xFF0EB154).withOpacity(0.1),
              color: Color.fromRGBO(14, 177, 84, 0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF0EB154), size: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   label,
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Colors.grey.shade600,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          Text(
                            widget.sitename!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // _buildDetailRow(
                //   icon: Icons.location_on,
                //   label: 'Location',
                //   value: widget.selectedLocationItems,
                // ),
                // Text(
                //   'Driver Details',
                //   style: TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFF0EB154),
                //   ),
                // ),
              ],
            ),
          ),

          // Details Content
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Material Information
                // _buildDetailRow(
                //   icon: Icons.location_on,
                //   label: 'Location',
                //   value: widget.selectedLocationItems,
                // ),
                _buildDetailRow(
                  icon: Icons.category,
                  label: AppLocalizations.of(context)!.material,
                  value: widget.itemName ?? 'N/A',
                ),

                // Plant Entry Status
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    // onTap: _openPdf,
                    onTap: () {
                      _openPdf(widget.filename ?? "");
                    },

                    // onTap: () => _openPdf(context), // Call the method when tapped
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_rounded,
                          color: primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.view_Invoice,
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                // Welcome and Fastag Status
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.welcome,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0EB154),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        rfidData?.rfid == "Please Tap Fastag  card !"
                            ? Text(
                          textAlign: TextAlign.center,
                          'Fastag is Not Tapped!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                            : SizedBox(),
                      ],
                    ), // Completely hides the widget if the condition is false
                  ],
                ),

                // Order and Driver Information
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildOrderInfo(
                        widget.ponumber.toString(),
                        widget.challanno.toString(),
                        widget.challanno1.toString(),
                      ),
                      // _buildOrderInfo(widget.order),
                      SizedBox(height: 16),
                      _buildDriverInfo(
                        widget.driverName.toString(),
                        widget.driverMobile.toString(),
                        widget.actionTime.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  // Widget _buildDivider() {
  //   return Divider(color: Colors.green);
  // }
  Widget _buildOrderInfo(String poNumber, String challanno, String challanno1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.role == "ADMIN") ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.order_Information,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  showAlert(context);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ],
        SizedBox(height: 5),
        _buildInfoRow(AppLocalizations.of(context)!.pO_Number, poNumber),
        _buildInfoRow(AppLocalizations.of(context)!.chalan_number_1, challanno),
        _buildInfoRow(
          AppLocalizations.of(context)!.chalan_number_2,
          challanno1,
        ),
        _buildInfoRow(
          AppLocalizations.of(context)!.vehicle_Number,
          widget.vehicleNumber.toString(),
        ),
        // _buildInfoRow('Challan No 1', order.challanNo ?? "N/A"),
        // _buildInfoRow('Challan No 2', order.challan_no1 ?? "N/A"),
        // _buildInfoRow('Vehicle Number', order.vehicleNumber),
      ],
    );
  }

  Widget _buildDriverInfo(
      String driverName,
      String driverMobile,
      String actionTime,
      ) {
    // Early return if truck details should not be shown
    //if (!widget.showTruckDetails) return SizedBox.shrink();

    // CheckRfid? rfidData = rfidDataList.isNotEmpty
    //     ? rfidDataList.first
    //     : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Content Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Driver Details
            _buildDetailSection(AppLocalizations.of(context)!.driver_Details, [
              _buildInfoRow(
                AppLocalizations.of(context)!.driver_Name,
                driverName,
              ),
              _buildInfoRow(
                AppLocalizations.of(context)!.driver_Contact,
                driverMobile,
              ),
              if (adminMo) ...[
                _buildInfoRow(
                  AppLocalizations.of(context)!.creation_Time,
                  actionTime,
                ),
              ],
            ], 0),

            // Vendor Details
            _buildDetailSection(AppLocalizations.of(context)!.vendor_Details, [
              _buildInfoRow(
                AppLocalizations.of(context)!.vendor_Contact,
                "N/A",
              ),
              _buildInfoRow(AppLocalizations.of(context)!.vendor_Email, "N/A"),
            ], 1),

            // RFID Details
            _buildDetailSection(
              AppLocalizations.of(context)!.rfid_Information,
              [
                _buildRfidInfoRow(
                  AppLocalizations.of(context)!.rfid_1,

                  // _rfidData!.rfid.toString(),
                  rfid1 ?? AppLocalizations.of(context)!.n_a,

                  //rfid1.toString(),
                  fontSize: 9,
                ),
                _buildRfidInfoRow(
                  AppLocalizations.of(context)!.rfid_2,
                  // _rfidData?.rfid2  ?? "N/A",
                  rfid2 ?? AppLocalizations.of(context)!.n_a,
                  // _rfidData!.rfid1.toString(),
                  fontSize: 9,
                ),
              ],
              2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRfidInfoRow(String label, String value, {double? fontSize}) {
    //print("AdminMo${AdminMo}");
    return Row(
      children: [
        if (adminMo) ...[
          IconButton(
            onPressed: () {
              setState(() {
                // Save previous state
                _previousShowTruckDetails = _showTruckDetails;
                _previousShowDetailsSection = _showDetailsSection;
                // _previousIsMoistureCheck = ;
                // Set the RFID type and flags based on which RFID is being edited
                if (label == 'RFID 1') {
                  uhfno = "RFID";
                  first = true;
                } else if (label == 'RFID 2') {
                  uhfno = "RFID2";
                  second = true;
                }
                flag1 = true;
                maporupdate = true;
                cancelbtn = true;
                // Show the map section
                _showMapTmSection = true; // Show the map section
               // _currentRfid = value; // Set the current RFID value
              });
            },
            icon: Icon(Icons.edit, size: 16),
            visualDensity: VisualDensity.compact,
          ),
        ],

        Expanded(
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Text(
                value,
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.right,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  // Widget _buildRfidInfoRow(String label, String value, {double? fontSize}) {
  //   CheckRfid? rfidData = rfidDataList.isNotEmpty
  //       ? rfidDataList.first
  //       : null;
  //
  //   return Row(
  //     children: [
  //       /// Edit Icon Button Label Row
  //      // Check the role condition
  //
  //       if (AdminMo) ...[
  //         IconButton(
  //           onPressed: () {
  //                     },
  //           icon: Icon(Icons.edit, size: 16),
  //           visualDensity: VisualDensity.compact,
  //         ),
  //       ],
  //       /// Label
  //       Expanded(
  //         child: Text(
  //           label,
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //           overflow: TextOverflow.ellipsis, // Prevents overflow
  //           softWrap: false,
  //         ),
  //       ),
  //
  //       /// Value Row
  //       Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           /// Value text
  //           ConstrainedBox(
  //             constraints: BoxConstraints(maxWidth: 150), // Limit width to prevent overflow
  //             child: Text(
  //               value,
  //               style: TextStyle(fontSize: fontSize),
  //               textAlign: TextAlign.right,
  //               overflow: TextOverflow.visible, // Prevents text from exceeding width
  //               softWrap: true,
  //             ),
  //           ),
  //           SizedBox(width: 8), // Space between text and icon
  //         ],
  //       ),
  //     ],
  //   );
  // }
  // Helper method to create a section with a title
  Widget _buildDetailSection(String title, List<Widget> children, int index) {
    bool isExpanded = expandedIndices.contains(index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0EB154),
              ),
            ),
            IconButton(
              icon:
              isExpanded
                  ? Icon(Icons.expand_more)
                  : Image.asset(
                'assets/arrow_forward.png',
                width: 16,
                height: 18,
              ),
              // icon: Icon(isExpanded ? Icons.expand_less : Image.asset('assets/arrow_forward.png', width: 24, height: 24),),
              onPressed: () {
                setState(() {
                  if (isExpanded) {
                    expandedIndices.remove(index);
                  } else {
                    expandedIndices.add(index);
                  }
                });
              },
            ),
          ],
        ),
        if (isExpanded) ...children,
        Divider(color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF0EB154), size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildActionButton({
  //   required String text,
  //   required VoidCallback onPressed,
  // }) {
  //   return ElevatedButton(
  //     onPressed: onPressed,
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Color(0xFF0EB154),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       // padding: EdgeInsets.symmetric(vertical: 12),
  //     ),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }
  /// main InfoRow widget
  Widget _buildInfoRow(String label, String value, {double? fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.right,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}