import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rdc_concrete/component/custom_elevated_button.dart';
import 'package:rdc_concrete/models/add_user_pojo.dart';
import 'package:rdc_concrete/screens/home_page.dart';
//import 'package:rdc_concrete/screens/select_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/checkrfid_pojo.dart';
import '../models/reachplant_pojo.dart';
import '../models/weighbridgestatus_pojo.dart';
//import '../services/api_service.dart';
import '../services/defaultmoisture_api_service.dart';
import '../services/efidservice_api_service.dart';
import '../services/getreceiptid_api_service.dart';
import '../services/reachplantornot_api_service.dart';
import '../services/updatedriver_del_api_service.dart';
import '../services/weighbridgestatus_api_service.dart';
import '../services/weighbridgeweight_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';

class AcceptDriver extends StatefulWidget {
  final String? sitename;

  final String? vno;
  final String? order;
  final int? uid;
  final int? locationid;
  final String? ponumber;
  final String? vehicleno;
  final String? challanno1;
  final String? challanno;
  final String? itemName;
  final String? uname;
  final String? role;

  const AcceptDriver({
    super.key,

     this.sitename,
    this.vno,
    this.order,
    this.uid,
    this.ponumber,
    this.vehicleno,
    this.challanno1,
    this.challanno,
    this.itemName,
    this.role,
    this.locationid,
    this.uname,
  });

  @override
  State<AcceptDriver> createState() => _AcceptDriverScreenState();
}

class _AcceptDriverScreenState extends State<AcceptDriver> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  // final _formKey = GlobalKey<FormState>();
  late bool _showConfirmBox; // Start by showing the confirm box
  late bool _showDetails; // Details will be hidden initially
  // bool _showConfirmBox = false;
  // bool _showDetails = false;
  //bool _showTruckDetails = true;

  // final GlobalKey<FormState> myWidgetKey = GlobalKey<FormState>();

  // Access the state
  //myWidgetKey.currentState?.someMethod();
  bool reachrdcplant = false, checkflag = false;
  late TextEditingController _siteController;
  late TextEditingController _moistureController = TextEditingController();
  String? reachplant = "";
  // bool reachRDCPlant = false;
  String weight = '';
  String allow = '';
  bool timeCheck = false;
  bool secondtransactiontap = false;
  bool vehicleMapped = false;
  // bool flag = false;
  String readerstate = "nottapped";
  Timer? timer;
  String? newtime1, hardware, datename;
  String weighmentno = "1", weigmentfnl = "2";
  String? receiptticketid = "";
  bool flag = false, moistureval = false;
  String? myTime;
  DateTime? newTime;
  String displayTime = "Start";
  Timer? countdownTimer;
  DateTime? date;
  DateTime? date1;
  DateTime? date2;
  bool timecheck = false;
  String fastagStatus = '';
  String? weighttype = 'Gross Weight';
  String? myDate;
  late final bool? showDeleteIcon;
  bool _isLoading = true;
  @override
  void initState() {
   // print("objectobject${widget.sitename}");
    super.initState();
    rfidService();

    datename = "${widget.order}date";
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      getWeightData();
      //WidgetsBinding.instance.addObserver(this); // Register observer
   //   SessionManager.checkAutoLogoutOnce();
      SessionManager.scheduleMidnightLogout(context);

    });
    // getWeightData();
    getWeighbridge();
    _showConfirmBox = false; // Start by showing the confirm box
    _showDetails = false;
    //print(" _showDetails = widget.showDetails;: ${ _showDetails = widget.showDetails}");

    // Debug: Print site name to ensure it's passed correctly
    //print("Received Site Name: ${widget.sitename}");

    // Ensure controller is updated after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _siteController.text =
            widget.sitename.toString(); // Assign value after UI is built
      });
    });

    // Initialize the controllers
    _siteController = TextEditingController();
    _moistureController = TextEditingController();
  }
  // @override
  // void dispose() {
  //
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     checkAutoLogout(); // ← runs when app resumes
  //   }
  // }

  Future<void> confirmbtn() async {
    setState(() {
      reachplant = "1";
      _showConfirmBox = false; // Hide the confirm box
      _showDetails = true; // Show the details section
    });
    reachplantstatus();
  }

  Future<void> getWeightData() async {
    String location = widget.sitename.toString();
    String oid = widget.order.toString();
    // if (widget.role=="ADMIN") {
    //
    //
    //
    // }
    try {
      // WeighbridgeweightApiService weighbridgeweightApiService= WeighbridgeweightApiService();
      // WeighbridgeStatus? uploadAddress = await weighbridgeweightApiService.getweight(location, oid);
      WeighbridgeweightApiService weighbridgeweightApiService =
          WeighbridgeweightApiService();
      List<WeighbridgeStatus>? uploadAddress =
          (await weighbridgeweightApiService.getweight(location, oid))
              as List<WeighbridgeStatus>?;
      // Check if the response is successful and handle accordingly
      if (uploadAddress != null && uploadAddress.isNotEmpty) {
        if (!reachrdcplant && !checkflag) {
          reachplantstatus(); // Call your method here
        }
        DateFormat df = DateFormat("yyyy-MM-dd HH:mm:ss");
        myDate = df.format(DateTime.now());

        if (receiptticketid != null) {
          // Get shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // Retrieve the value for the key "Transaction"
          weighmentno = prefs.getString("Transaction") ?? "";
        }

        for (WeighbridgeStatus size in uploadAddress) {
          if (weighmentno == "2" && !timeCheck) {
            checktime();
            // Update UI accordingly
            setState(() {
              // _buildDriverInfo();
              weighttype = "Tare Weight";
              // Update your UI state here
            });
          } else if (weighmentno == "2" &&
              secondtransactiontap == false &&
              readerstate == "tapped") {
            // Handle tapped state

            setState(() {
              fastagStatus = "Fastag is not Matched!";
              weighttype = "Tare Weight";
              secondcheck();
              // Update your UI state here
            });
          } else if (weighmentno == "2" &&
              secondtransactiontap == false &&
              readerstate == "nottapped") {
            // Handle not tapped state
            setState(() {
              fastagStatus = "Fastag is not Tapped !";
              weighttype = "Tare Weight";
              secondcheck();
              // Update your UI state here
            });
          } else {
            for (WeighbridgeStatus status in uploadAddress) {
              if (status.weight == "Moisture isn't Check") {
                if (newtime1 != null) {
                  DateTime date1 = DateTime.parse(newtime1!);
                  DateTime date2 = DateTime.parse(myDate!);
                  Duration diff = date1.difference(date2);
                  int seconds = diff.inSeconds;

                  Timer.periodic(Duration(seconds: 1), (timer) {
                    if (seconds > 0) {
                      setState(() {
                        int minutes = seconds ~/ 60;
                        int remainingSeconds = seconds % 60;
                        fastagStatus = "$minutes:$remainingSeconds Left";
                      });
                      seconds--;
                    } else {
                      timer.cancel();
                      setState(() {
                        fastagStatus = "Let's Go";
                      });
                    }
                  });

                  addMoisture();
                } else {
                  addMoisture();
                  setState(() {
                    fastagStatus = "Quality Checking Is Pending !";
                  });
                }
              } else if (flag == false && vehicleMapped == false) {
                getWeighbridge();
                rfidService();
                setState(() {
                  fastagStatus = "Fastag is Not Mapped !";
                });
              } else if (flag == false && vehicleMapped == false ||
                  secondtransactiontap == false) {
                secondcheck();
                getWeighbridge();
                setState(() {
                  fastagStatus = "Fastag is Not Tapped !";
                });
              } else if (double.parse(size.weight) < 1) {
                secondcheck();
                setState(() {
                  fastagStatus = "${size.weight} KG";
                });
              } else if (allow == "no") {
                setState(() {
                  fastagStatus = "${size.weight} KG";
                  weight = size.weight;
                });
              } else {
                setState(() {
                  fastagStatus = "${size.weight} KG";
                  weight = size.weight;
                  secondcheck();
                });
              }
            }
          }
        }
      } else {
        //print('No data found.');
      }
    } catch (e) {
      ////print('Error: $e');
    }
  }

  Future<void> checktime() async {
    SharedPreferences sh112 = await SharedPreferences.getInstance();
    String myTime = sh112.getString("grosstime") ?? "";

    // Print the retrieved time for debugging
    //print("Retrieved grosstime: $myTime");

    // Get the current date and time
    DateTime now = DateTime.now();

    try {
      //print("hiiii");

      // Check if myTime is empty
      if (myTime.isEmpty) {
        //print("grosstime is empty");
        return;
      }

      // Replace space with 'T' for ISO 8601 format
      myTime = myTime.replaceAll(" ", "T");

      // Print the modified time for debugging
      //print("Modified grosstime for parsing: $myTime");

      // Parse the stored time
      date = DateTime.parse(myTime);

      // Add 2 minutes to the stored time
      newTime = date!.add(Duration(minutes: 2));
    } catch (e) {
      //print("Error parsing date: $e");
      return;
    }

    if (newTime!.isBefore(now)) {
      // If the new time is before the current time
      setState(() {
        timecheck = true;
        displayTime = "Start";
      });
    } else {
      // Start the countdown timer
      countdownTimer?.cancel(); // Cancel any existing timer
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        final remainingTime = newTime!.difference(DateTime.now());

        if (remainingTime.isNegative) {
          // Time is up
          setState(() {
            displayTime = "Start";
          });
          timer.cancel();
        } else {
          setState(() {
            final minutes = remainingTime.inMinutes;
            final seconds = remainingTime.inSeconds % 60;
            displayTime = "$minutes:${seconds.toString().padLeft(2, '0')} Left";
          });
        }
      });
      timecheck = false;
    }
  }
  // void checkAutoLogout() async {
  //   final apiService = ApiService();
  //   bool logout = await apiService.shouldLogoutNow();
  //
  //   if (logout) {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.clear();
  //     // Navigator.pushReplacementNamed(context, '/login');
  //     Get.offAll(() => SelectProfile());
  //   }
  // }
  //
  // void scheduleMidnightLogout() {
  //   DateTime now = DateTime.now();
  //   DateTime midnight = DateTime(now.year, now.month, now.day + 1); // 12:00 AM next day
  //
  //   Duration timeUntilMidnight = midnight.difference(now);
  //
  //   Timer(timeUntilMidnight, () async {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.clear();
  //     Get.offAll(() => SelectProfile());
  //
  //   });
  //
  //   print("Logout scheduled at midnight: $midnight");
  // }

  Future<void> addMoisture() async {
    print('→ addMoisture() started | item: ${widget.itemName} | order: ${widget.order} | uid: ${widget.uid}');
    String moistureUp;
    String itemName = widget.itemName.toString();
    // Check if the item name contains "SAND"
    if (itemName.toUpperCase().contains("SAND")) {
      moistureUp = "2.0";
      print('  → SAND detected → moistureUp = 2.0');
    } else {
      moistureUp = "0";
      print('  → No SAND → moistureUp = 0');
    }

    // Format the current date
    String myDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    print('  → Current time: $myDate');
    // Call the API
    try {
      print('  → Calling defaultmoisture API...');
      // SetStatus response = await ApiClient.getApi().defaultMoisture(orderId, moistureUp, id, myDate);
      DefaultmoistureApiService defaultmoistureApiService =
          DefaultmoistureApiService();
      SetStatus? response = await defaultmoistureApiService.defaultmoisture(
        widget.order.toString(),
        moistureUp,
        widget.uid.toString(),
        myDate,
      );
      print('  → API response received: status=${response?.status}, message=${response?.message}');
      // Check the response status
      if (response.status == "1") {
        moistureval = true;
        newtime1 = response.message;
        print('  → Success: moistureval = true, newtime1 = $newtime1');
      } else {
        moistureval = false;
        newtime1 = response.message;
        print('  → Failed: moistureval = false, message = $newtime1');
      }
    } catch (e,stack) {
      print('  → ERROR in addMoisture: $e');
      print('  → Stack trace: $stack');
      // Handle any errors
      showErrorDialog("Something went wrong");
    }
    print('← addMoisture() finished');
  }

  Future<void> reachplantstatus() async {
    ReachplantornotApiService reachplantornotApiService =
        ReachplantornotApiService();
    ReachPlant? response = await reachplantornotApiService.reachSite(
      widget.order.toString(),
      widget.uid.toString(),
      reachplant!,
    );
    setState(() {
      if (response.reachplant == "yes") {
        reachrdcplant = true;
        checkflag = false;
        //ask
        // if (newtime1 !="moisture updated !") {
        //   MediaPlayer mediaPlayer = MediaPlayer.create(getApplicationContext(), R.raw.qcaudio);
        //   mediaPlayer.start();
        // }
        _showDetails = true;
        _showConfirmBox = false;

        ///loading dismis
      } else {
        // print("reachplantstatuselseeeee");
        checkflag = false;
        reachrdcplant = false;
        _showConfirmBox = true;
        _showDetails = false;

        // loadingDialog.dismiss();
      }
    });

    if (mounted) {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> checkweighbridgestatus() async {
    WeighbridgestatusApiService weighbridgestatusApiService =
        WeighbridgestatusApiService();
    SetStatus response = await weighbridgestatusApiService.weighbridgestatus(
      widget.sitename.toString(),
    );
    // if (response != null) {
    // Check the status of the response
    if (response.status == "0") {
      // Show error dialog and set variables accordingly
      //   Showerrordialog(response.getMessage());
      allow = "no";
      hardware = response.message;
    } else {
      // If status is not "0", set allow to "yes"
      allow = "yes";
      // You can add additional logic here if needed
    }
  }
  // else {
  //   // Handle the case where the response is null (optional)
  //   //Showerrordialog("Failed to get a valid response.");
  //   allow = "no";
  // }
  //}

  // Future<void> GetWeighbridge()async{
  //
  //   GetreceiptidApiService reachplantornotApiService= GetreceiptidApiService();
  //   SetStatus? response = await reachplantornotApiService.getweighbridge(widget.vehicleno.toString(), widget.order.toString(),  widget.sitename.toString());
  //
  //
  // }
  Future<void> getWeighbridge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    weighmentno = prefs.getString("Transaction") ?? "";

    GetreceiptidApiService reachplantornotApiService = GetreceiptidApiService();

    try {
      SetStatus? responseBody = await reachplantornotApiService.getweighbridge(
        widget.vehicleno.toString(),
        widget.order.toString(),
        widget.sitename.toString(),
      );
      if (responseBody.status == "1") {
        receiptticketid = responseBody.message;
        flag = true;
      } else if (responseBody.status == "0") {
        flag = false;
        await prefs.remove("Transaction");
        await prefs.remove("weight");
        await prefs.remove("grosstime");
      } else {
        String? myDate = responseBody.createdid;
        receiptticketid = responseBody.message;
        flag = true;

        if (weighmentno != "2") {
          await prefs.setString(
            "Transaction",
            weigmentfnl,
          ); // Replace with actual value
          await prefs.setString("grosstime", myDate!);
          await prefs.setString("weight", responseBody.status);
        }
      }
    } catch (e) {
      showErrorDialog("Something went wrong: $e");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
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

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    _siteController.dispose();
    _moistureController.dispose();
    //WidgetsBinding.instance.removeObserver(this);
    // Dispose of OTP controllers
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    timer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> rfidService() async {
    RfidService rfidService = RfidService();
    // Example usage
    String vehicleNumber = widget.vehicleno.toString();

    String location = widget.sitename.toString();
    CheckRfid? checkRfidResponse = await rfidService.checkRfid(
      vehicleNumber,
      location,
    );
    if (checkRfidResponse != null) {
      // Check if the status is not "0"
      if (checkRfidResponse.status != "0") {
        vehicleMapped = true; // Set vehicleMapped to true if status is not "0"
        // print('Vehicle mapping successful. Status: ${checkRfidResponse.status}');
      } else {
        vehicleMapped = false; // Set vehicleMapped to false if status is "0"
        // print('Status is 0, vehicle mapping failed. RFID: ${checkRfidResponse.rfid}');
      }
    } else {
      // print('Failed to retrieve RFID data.');
    }
  }

  Future<void> secondcheck() async {
    RfidService rfidService = RfidService();
    // Example usage
    String vehicleNumber = widget.vno.toString();
    String location = widget.sitename.toString();
    CheckRfid? checkRfidResponse = await rfidService.checkRfid(
      vehicleNumber,
      location,
    );

    if (checkRfidResponse?.rfid == "Please Tap Fastag  card !") {
      readerstate = "nottapped";
    } else {
      readerstate = "tapped";
    }
    if (checkRfidResponse?.secondcheck == "Yes") {
      secondtransactiontap = true;
    } else {
      secondtransactiontap = false;
    }
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    //final selectedLocationItems = ModalRoute.of(context)?.settings.arguments as String?;
    // print("_showDetailssssssssssss${_showDetails}");
    // print("_showConfirmBoxxxxxxxxxxx${_showConfirmBox}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.accept_Driver,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.green,
                ), // Set the color to green
              ),
            ),
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

            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/bg_image/RDC.png"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showDetails) _buildDetailsSection(),
                  if (_showConfirmBox) _buildConfirmBox(),

                  //
                  // if( _showDetails = true)...[
                  //   _showDetails ? _buildDetailsSection() : SizedBox.shrink(),
                  // ]
                  // else if(_showConfirmBox = true)...[
                  //   _showConfirmBox ? _buildConfirmBox() : SizedBox.shrink(),
                  // ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable OTP Input Widget Method
  Widget otpInputWidget({
    required BuildContext context,
    required Function onVerify,
  }) {
    //if (!widget.showOtpField) return SizedBox.shrink();
    // FocusNodes for each OTP text field
    final FocusNode otpFocusNode1 = FocusNode();
    final FocusNode otpFocusNode2 = FocusNode();
    final FocusNode otpFocusNode3 = FocusNode();
    final FocusNode otpFocusNode4 = FocusNode();

    // Initialize FocusNodes and handle keyboard focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(otpFocusNode1);
    });

    return Column(
      children: [
        // OTP input fields
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // OTP input box 1 with FocusNode
              _buildOtpTextField(otpFocusNode1, otpFocusNode2),
              // OTP input box 2
              _buildOtpTextField(otpFocusNode2, otpFocusNode3),
              // OTP input box 3
              _buildOtpTextField(otpFocusNode3, otpFocusNode4),
              // OTP input box 4
              _buildOtpTextField(otpFocusNode4, null),
            ],
          ),
        ),
        // Verify Button
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ElevatedButton(
            onPressed: () {
              onVerify(); // Call the onVerify callback when the button is pressed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Verify',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Function to build each OTP TextField
  Widget _buildOtpTextField(
    FocusNode currentFocusNode,
    FocusNode? nextFocusNode,
  ) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        focusNode: currentFocusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }

  // The confirmation box widget
  Widget _buildConfirmBox() {
    final primaryColor = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.reach_Rdc_Plant,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.location_on, size: 50, color: Colors.green),
            const SizedBox(height: 10),
            TextField(
              controller: _siteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ), // Set border color and width
                ),
                hintText: '',
              ),
              keyboardType: TextInputType.name,
              readOnly: false,
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              onPressed: () {
                setState(() {
                  confirmbtn();
                  // _showConfirmBox = false; // Hide the confirm box
                  //  _showDetails = true;     // Show the details section
                });
              },
              text: AppLocalizations.of(context)!.confirm,
              backgroundColor: primaryColor,
              width: screenWidth * 0.8,
              popOnPress: false,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         'OTP has been Sent',
  //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //       ),
  //       Image.asset('assets/mainrdc.png', width: 100, height: 100),
  //     ],
  //   );
  // }
  //
  // Widget _buildOtpSection() {
  //   final primaryColor = Theme.of(context).primaryColor;
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   String? errorMessage; // To store validation error
  //
  //   return StatefulBuilder(
  //     builder: (context, setState) => Form(
  //       key: _formKey,
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: List.generate(
  //               4,
  //               (index) => SizedBox(
  //                 width: 60,
  //                 child: TextFormField(
  //                   controller: _otpControllers[index],
  //                   keyboardType: TextInputType.number,
  //                   textAlign: TextAlign.center,
  //                   maxLength: 1,
  //                   decoration: InputDecoration(
  //                     counterText: '',
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                   onChanged: (value) {
  //                     if (value.length == 1 && index < 3) {
  //                       FocusScope.of(context).nextFocus();
  //                     } else if (value.isEmpty && index > 0) {
  //                       FocusScope.of(context).previousFocus();
  //                     }
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //           if (errorMessage != null) // Show error message only when needed
  //             Padding(
  //               padding: const EdgeInsets.only(top: 8.0),
  //               child: Text(
  //                 errorMessage!,
  //                 style: TextStyle(color: Colors.red, fontSize: 14),
  //               ),
  //             ),
  //           SizedBox(height: 20),
  //           CustomElevatedButton(
  //             onPressed: () {
  //               bool allFilled = _otpControllers
  //                   .every((controller) => controller.text.isNotEmpty);
  //
  //               if (!allFilled) {
  //                 setState(() {
  //                   errorMessage = "Please fill all OTP fields!";
  //                 });
  //               } else {
  //                 setState(() {
  //                   errorMessage = null;
  //
  //                   /// Clear error when valid
  //                   FocusScope.of(context).unfocus();
  //
  //                   /// disable keyboard after OTP is verified.
  //                   _showConfirmBox = true;
  //
  //                   /// clear all OTP fields
  //                   for (var controller in _otpControllers) {
  //                     controller.clear();
  //                   }
  //                 });
  //               }
  //             },
  //             text: 'Verify',
  //             backgroundColor: primaryColor,
  //             width: screenWidth * 0.8, popOnPress: false,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDivider() {
    return Divider(color: Colors.green.shade200);
  }

  Widget _buildDivider1() {
    return Divider(color: Colors.grey.shade100);
  }

  Widget _buildDetailsSection() {
    // Ensure we only render the details section if _showTruckDetails is true
    // if (!_showTruckDetails) {
    //   return SizedBox.shrink(); // If _showDetails is false, return an empty widget
    // }

    // final selectedLocation = ModalRoute.of(context)?.settings.arguments as String?;
    // final selectedLocationItems = ModalRoute.of(context)?.settings.arguments as String?;
    // final primaryColor = Theme.of(context).primaryColor;
    //double screenWidth = MediaQuery.of(context).size.width;
    // String fastagStatus = 'Fastag is Not Tapped!';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.location_on, // Use the location icon
                  color: Colors.green, // Set the icon color to green
                  size: 24, // Set the size of the icon
                ),
                SizedBox(width: 8), // Add some space between the icon and text
                Text(
                  '${widget.sitename}', // Display the location text
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // Text('Location: ${widget.selectedLocationItems}', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  )!.material, // Display the location text
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('${widget.itemName}', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.driver_is_allowed_to_enter_in_plant,
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            _buildDivider(),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weighttype.toString(),
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fastagStatus,
                      style: TextStyle(fontSize: 19, color: Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
            _buildOrderInfo(),
            SizedBox(height: 20),
            //  _buildDriverInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Set border radius to zero
          ),
          margin: EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ), // Optional: Add some horizontal padding for text
                child: Text(
                  AppLocalizations.of(context)!.order_Information,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              if (widget.role == "ADMIN") ...[
                IconButton(
                  key: ValueKey(
                    'deleteIconButton',
                  ), // Assigning an ID to the IconButton
                  onPressed: () => showAlert(context),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.green, // Set the icon color to green
                  ),
                ),
              ], // Check if the icon should be shown
            ],
          ),
        ),

        SizedBox(height: 5),
        _buildInfoRow(
          AppLocalizations.of(context)!.pO_Number,
          widget.ponumber.toString(),
        ),
        _buildDivider1(),
        _buildInfoRow(
          AppLocalizations.of(context)!.chalan_number_1,
          widget.challanno.toString(),
        ),
        _buildDivider1(),
        _buildInfoRow(
          AppLocalizations.of(context)!.chalan_number_2,
          widget.challanno1.toString(),
        ),
        _buildDivider1(),
        _buildInfoRow(
          AppLocalizations.of(context)!.vehicle_Number,
          widget.vehicleno.toString(),
        ),
      ],
    );
  }

  // Widget _buildDriverInfo() {
  //   //if (!widget.showTruckDetails) return SizedBox.shrink();
  //
  //   final primaryColor = Theme.of(context).primaryColor;
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomElevatedButton(
  //         onPressed: () {
  //           // Verify OTP logic here
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => ConfigureScreen()));
  //           setState(() {
  //             _showDetails = false;
  //           });
  //         },
  //         text: 'Capture weight',
  //         backgroundColor: primaryColor,
  //         height: 40,
  //         width: screenWidth * 0.4,popOnPress: false
  //       ),
  //       _buildInfoRow('Driver name', 'Kuldeep Sharma'),
  //       _buildInfoRow('Vendor Contact', '+7890123456'),
  //       _buildInfoRow('Vendor Email', 'vendor@example.com'),
  //       _buildInfoRow('Driver Contact', '+9876543210'),
  //       _buildInfoRow('Creation time', '2024-05-20 10:30 AM'),
  //       //Divider(),
  //       // _buildInfoRow('RFID 1', '1100EE00E40007469243'),
  //       // _buildInfoRow('RFID 2', '1100EE00E40007561353'),
  //       CustomElevatedButton(
  //         onPressed: () {
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => EditRfid()));
  //         },
  //         text: "Edit RFID",
  //         backgroundColor: primaryColor,
  //         width: 50,
  //         height: 40,
  //           popOnPress: false
  //       )
  //     ],
  //   );
  // }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // prevent closing by tapping outside
      builder: (BuildContext context) {
        bool isLoading = false; // track loading state

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Warning!"),
              content: Text("Do you want to reject this record?"), // always visible
              actions: <Widget>[
                // Cancel button
                TextButton(

                  onPressed: isLoading ? null : () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),

                // Yes button
                // TextButton(
                //
                //   onPressed: isLoading
                //       ? null
                //       : () async {
                //     setState(() => isLoading = true);
                //
                //     bool isSuccess = await _rejectRecord();
                //     final BuildContext currentContext = context;
                //     if (!mounted) return;
                //
                //     if (isSuccess) {
                //       // ✅ Show snackbar
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text("Deleted successfully!"),
                //           backgroundColor: Colors.green,
                //           duration: Duration(seconds: 2),
                //         ),
                //       );
                //
                //       await Future.delayed(const Duration(seconds: 2));
                //
                //       if (context.mounted) {
                //         Navigator.pushReplacement(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => HomePage(
                //               sitename: widget.sitename ?? '',
                //               role: widget.role ?? '',
                //               uprofileid: widget.uid?.toInt() ?? 0,
                //               locationid: widget.locationid?.toInt() ?? 0,
                //               uname: widget.uname ?? '',
                //             ),
                //           ),
                //         );
                //       }
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text("Something went wrong!"),
                //           backgroundColor: Colors.red,
                //           duration: Duration(seconds: 2),
                //         ),
                //       );
                //
                //       setState(() => isLoading = false); // stop loader
                //     }
                //   },
                //   child: isLoading
                //       ? SizedBox(
                //     width: 24,
                //     height: 24,
                //     child: CircularProgressIndicator(strokeWidth: 2),
                //   )
                //       : Text("Yes"),
                // ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    // ---- CAPTURE CONTEXT FIRST, BEFORE ANY AWAIT ----
                    final BuildContext dialogContext = context;

                    // ---- early-exit if widget is already disposed ----
                    if (!mounted) return;

                    // ---- start loading ----
                    setState(() => isLoading = true);

                    // ---- now safe to await ----
                    final bool isSuccess = await _rejectRecord();

                    // ---- check again after await (optional but safe) ----
                    if (!dialogContext.mounted) return;

                    // ----------------------------------------------------
                    // SUCCESS
                    // ----------------------------------------------------
                    if (isSuccess) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Deleted successfully!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 2));

                      if (dialogContext.mounted) {
                        Navigator.pushReplacement(
                          dialogContext,
                          MaterialPageRoute(
                            builder: (_) => HomePage(
                              sitename: widget.sitename ?? '',
                              role: widget.role ?? '',
                              uprofileid: widget.uid?.toInt() ?? 0,
                              locationid: widget.locationid?.toInt() ?? 0,
                              uname: widget.uname ?? '',
                            ),
                          ),
                        );
                      }
                      return;
                    }

                    // ----------------------------------------------------
                    // FAILURE
                    // ----------------------------------------------------
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('Something went wrong!'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    setState(() => isLoading = false);
                  },

                  // child comes LAST
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Yes'),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
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
  //         title: Text("Warning!"),
  //         content: Text("Do you want to reject this record?"),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text("Cancel"),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Dismiss the dialog
  //             },
  //           ),
  //           TextButton(
  //             child: Text("Yes"),
  //               onPressed: () async {
  //                 bool isSuccess = await _rejectRecord();
  //
  //                 if (!mounted) return;
  //
  //                 if (isSuccess) {
  //                   // ✅ Show snackbar
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text("Delete successfully!"),
  //                       backgroundColor: Colors.green,
  //                       duration: Duration(seconds: 2),
  //                     ),
  //                   );
  //
  //                   // ✅ Wait before navigating
  //                   await Future.delayed(const Duration(seconds: 2));
  //
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (_) => HomePage(
  //                         sitename: widget.sitename ?? '',
  //                         role: widget.role ?? '',
  //                         uprofileid: widget.uid?.toInt() ?? 0,
  //                         locationid: widget.locationid?.toInt() ?? 0,
  //                         uname: widget.uname ?? '',
  //                       ),
  //                     ),
  //                   );
  //                 } else {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text("Something went wrong!"),
  //                       backgroundColor: Colors.red,
  //                       duration: Duration(seconds: 2),
  //                     ),
  //                   );
  //                 }
  //               }
  //
  //             // onPressed: () {
  //             //   Navigator.of(context).pop(); // Dismiss the dialog
  //             //   _rejectRecord(context);
  //             // },
  //           ),
  //         ],
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> _rejectRecord(BuildContext context) async {
  //   // Show loading indicator
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  //
  //   String myDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  //   final apiService = UpdatedriverDelApiService();
  //
  //   try {
  //     SetStatus? statusResponse = await apiService.setStatus(
  //       widget.order.toString(),
  //       widget.uid.toString(),
  //       myDate,
  //       false,
  //       false,
  //     );
  //
  //     if (mounted) {
  //       Navigator.of(context).pop(); // Dismiss loading dialog
  //     }
  //
  //     if (statusResponse?.status == "1") {
  //       if (mounted) {
  //
  //         print("uppppppppp");
  //        // Navigator.pushReplacementNamed(context, '/qutester');
  //       }
  //     } else {
  //       if (mounted) {
  //         _showErrorDialog(context, "Something went wrong!");
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //     //  Navigator.of(context).pop(); // Dismiss loading dialog
  //       _showErrorDialog(context, "Something wentt wrong!");
  //     }
  //   }
  // }
  // Future<void> _rejectRecord(BuildContext context) async {
  //   // Show loading indicator
  //   if (mounted) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext dialogContext) {
  //         return Center(child: CircularProgressIndicator());
  //       },
  //     );
  //   }
  //
  //   String myDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  //   final apiService = UpdatedriverDelApiService();
  //
  //   try {
  //     SetStatus? statusResponse = await apiService.setStatus(
  //       widget.order.toString(),
  //       widget.uid.toString(),
  //       myDate,
  //       false,
  //       false,
  //     );
  //
  //     // Dismiss loading dialog
  //     // if (mounted) {
  //     //   Navigator.of(context).pop(); // Dismiss loading dialog
  //     // }
  //
  //     if (statusResponse?.status == "1") {
  //       // if (mounted) {
  //         print("uppppppppp");
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => HomePage()));
  //         // Navigator.pushReplacementNamed(context, '/qutester');
  //       // }
  //     } else {
  //       if (mounted) {
  //         _showErrorDialog(context, "Something went wrong!");
  //       }
  //     }
  //   } catch (e) {
  //     // Dismiss loading dialog if possible
  //     if (mounted) {
  //       if (Navigator.canPop(context)) {
  //         Navigator.of(context).pop(); // Dismiss loading dialog if possible
  //       }
  //       _showErrorDialog(context, "Something went wrong!");
  //     }
  //   }
  // // }
  // Future<void> _rejectRecord(BuildContext context) async {
  //   // Show loading indicator
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext dialogContext) {
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  //
  //   String myDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  //   final apiService = UpdatedriverDelApiService();
  //
  //   try {
  //     SetStatus? statusResponse = await apiService.setStatus(
  //       widget.order.toString(),
  //       widget.uid.toString(),
  //       myDate,
  //       false,
  //       false,
  //     );
  //
  //     // Dismiss loading dialog
  //     if (Navigator.canPop(context)) {
  //       Navigator.of(context).pop(); // Dismiss loading dialog
  //     }
  //
  //     if (statusResponse?.status == "1") {
  //       // Check if the widget is still mounted before navigating
  //       if (mounted) {
  //         print("uppppppppp");
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomePage(sitename:widget.sitename,role:widget.role)),
  //         );
  //       }
  //     } else {
  //       if (mounted) {
  //         _showErrorDialog(context, "Something went wrong!");
  //       }
  //     }
  //   } catch (e) {
  //     // Dismiss loading dialog if possible
  //     if (Navigator.canPop(context)) {
  //       Navigator.of(context).pop(); // Dismiss loading dialog if possible
  //     }
  //     if (mounted) {
  //       _showErrorDialog(context, "Something went wrong!");
  //     }
  //   }
  // }
  // Future<void> _rejectRecord(BuildContext context) async {
  //   String myDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  //   final apiService = UpdatedriverDelApiService();
  //
  //   try {
  //     SetStatus? statusResponse = await apiService.setStatus(
  //       widget.order.toString(),
  //       widget.uid.toString(),
  //       myDate,
  //       false,
  //       false,
  //     );
  //
  //     if (statusResponse?.status == "1") {
  //       print("uppppppppp");
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage(sitename: widget.sitename , role: widget.role)),
  //       );
  //     } else {
  //       _showErrorDialog(context, "Something went wrong!");
  //     }
  //   } catch (e) {
  //     _showErrorDialog(context, "Something went wrong!");
  //   }
  // }

  // main
  // Future<void> _rejectRecord(BuildContext context) async {
  //   String myDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  //   final apiService = UpdatedriverDelApiService();
  //
  //   try {
  //     SetStatus? statusResponse = await apiService.setStatus(
  //       widget.order.toString(),
  //       widget.uid.toString(),
  //       myDate,
  //       false,
  //       false,
  //     );
  //
  //     if (statusResponse.status == "1") {
  //       //print("uppppppppp");
  //       if (context.mounted) {
  //         // Check if the widget is still mounted
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder:
  //                 (context) => HomePage(
  //                   sitename: widget.sitename.toString(),
  //                   role: widget.role.toString(),
  //                   uprofileid: widget.uid!.toInt(),
  //                   locationid: widget.locationid!.toInt(),
  //                   uname: widget.uname.toString(),
  //                 ),
  //           ),
  //         );
  //       }
  //     } else {
  //       if (context.mounted) {
  //         // Check if the widget is still mounted
  //         _showErrorDialog(context, "Something went wrong!");
  //       }
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       // Check if the widget is still mounted
  //       _showErrorDialog(context, "Something went wrong!");
  //     }
  //   }
  // }
  Future<bool> _rejectRecord() async {
    String myDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final apiService = UpdatedriverDelApiService();

    try {
      SetStatus statusResponse = await apiService.setStatus(
        widget.order.toString(),
        widget.uid.toString(),
        myDate,
        false,
        false,
      );

      // print("🔎 RAW STATUS TYPE: ${statusResponse.status.runtimeType}");
      // print("🔎 RAW STATUS VALUE: ${statusResponse.status}");
      // print("🔎 RAW MESSAGE: ${statusResponse.message}");

      // ✅ Safely convert to int
      final statusInt = int.tryParse(statusResponse.status.toString()) ?? 0;
     // print("✅ PARSED STATUS AS INT: $statusInt");

      return statusInt == 1;
    } catch (e) {
     // print("🔥 Exception in _rejectRecord: $e");
      return false;
    }
  }

  // void _showErrorDialog(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Error"),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text("OK"),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Dismiss the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

// Widget _buildDetailsSection() {
//  // final primaryColor = Theme.of(context).primaryColor;
//   // Early return if details should not be shown
//   // if (!_showTruckDetails) {
//   //   return SizedBox.shrink();
//   // }
//
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 9, vertical: 7),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black12,
//           blurRadius: 6,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Header Section
//         Container(
//           padding: EdgeInsets.all(11),
//           decoration: BoxDecoration(
//             color: Color(0xFF0EB154).withOpacity(0.1),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.location_on, color: Color(0xFF0EB154), size: 24),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Text(
//                         //   label,
//                         //   style: TextStyle(
//                         //     fontSize: 14,
//                         //     color: Colors.grey.shade600,
//                         //     fontWeight: FontWeight.w500,
//                         //   ),
//                         // ),
//                         Text(
//                     '${widget.sitename}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // _buildDetailRow(
//               //   icon: Icons.location_on,
//               //   label: 'Location',
//               //   value: widget.selectedLocationItems,
//               // ),
//               // Text(
//               //   'Driver Details',
//               //   style: TextStyle(
//               //     fontSize: 22,
//               //     fontWeight: FontWeight.bold,
//               //     color: Color(0xFF0EB154),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//
//         // Details Content
//         Padding(
//           padding: const EdgeInsets.all(11.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Location and Material Information
//               // _buildDetailRow(
//               //   icon: Icons.location_on,
//               //   label: 'Location',
//               //   value: widget.selectedLocationItems,
//               // ),
//               _buildDetailRow(
//                 icon: Icons.category,
//                 label: 'Material',
//                 value: widget.itemName ?? 'N/A',
//               ),
//
//               // Plant Entry Status
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   children: [
//                     Icon(Icons.check_circle, color: primaryColor, size: 24),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         'Driver Is Allowed to Enter in Plant',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: primaryColor,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(color: Colors.grey.shade300),
//               // Welcome and Fastag Status
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Welcome',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0EB154),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.warning, color: Colors.redAccent),
//                       SizedBox(width: 8),
//                       Text(
//                         'Fastag is Not Tapped!',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.redAccent,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               // Order and Driver Information
//               Padding(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildOrderInfo(widget.order),
//                     SizedBox(height: 16),
//                     _buildDriverInfo(order),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Helper method to create consistent detail rows
// Widget _buildDetailRow({
//   required IconData icon,
//   required String label,
//   required String value,
// }) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 3.0),
//     child: Row(
//       children: [
//         Icon(icon, color: Color(0xFF0EB154), size: 24),
//         SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
