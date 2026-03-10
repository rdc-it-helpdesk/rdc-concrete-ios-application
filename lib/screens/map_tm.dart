import 'dart:async';

import 'package:flutter/material.dart';

import '../models/vehicle_list.dart';
import '../models/add_user_pojo.dart';
import '../models/checkrfid_pojo.dart';
import '../services/efidservice_api_service.dart';
import '../services/get_tm_api_service.dart';
import '../services/updatevehicle_api_service.dart';

import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';

class MapTm extends StatefulWidget {
  final int? uid;
  final String? sitename;
  final int? locationid;
  const MapTm({super.key, this.uid, this.sitename, this.locationid});

  @override
  State<MapTm> createState() => _MapTm();
}

class _MapTm extends State<MapTm> {
  //final _formKey = GlobalKey<FormState>();

  List<VehicleList> _vehicleSuggestions = [];
  final GetTmApiService _vehicleService = GetTmApiService();
  final TextEditingController _vehicleDetailsController =
      TextEditingController();
  final TextEditingController _fastagController = TextEditingController();
  String? selectedvehId;
  String? selectedVehicleNumber;
  bool vehicleMapped = false;
  Timer? timer;
  String selectedRadioButton = '';
  bool vehicleCheck = false;
  @override
  void initState() {
    super.initState();
    fetchVehicles();
  //  SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
  }

  Future<void> fetchVehicles() async {
    // String id = widget.vid.toString(); // edit time

    String id = widget.uid.toString(); // create
    try {
      // Fetch the vehicles from the service
      List<VehicleList> response = await _vehicleService.gettmlist(id);

      //print("Response type: ${response.runtimeType}");
      //print("Response content: $response");

      // Directly assign the response to _vehicleSuggestions
      setState(() {
        _vehicleSuggestions = response; // No need to map again
      });
    } catch (e) {
      //print("Error fetching vehicles: $e");
    }
  }

  Future<void> rfidService() async {
    if (selectedvehId != null && selectedvehId != '') {
      // Your code here
      ///  print("selectedvehId${selectedvehId}");
      RfidService rfidService = RfidService();

      String location = widget.sitename.toString();
      CheckRfid? checkRfidResponse = await rfidService.checkRfid(
        selectedvehId.toString(),
        location,
      );
      if (checkRfidResponse != null) {
        // Check if the status is not "0"
        if (checkRfidResponse.status != "0") {
          _fastagController.text = checkRfidResponse.rfid.toString();
          //vehicleMapped = true; // Set vehicleMapped to true if status is not "0"
          //print('Vehicle mapping successful. Status: ${checkRfidResponse.status}');
        } else {
          //vehicleMapped = false; // Set vehicleMapped to false if status is "0"
          //print('Status is 0, vehicle mapping failed. RFID: ${checkRfidResponse.rfid}');
        }
      } else {
        //print('Failed to retrieve RFID data.');
      }
    }
  }

  Future<void> updateVehicle() async {
    //print("heeeeeeeeeeeeeeeeee");
    String tmNumber = _vehicleDetailsController.text;
    String rfidNo = _fastagController.text;
    //  String rfidNo = "1100DD00D19991113321DDDDDD1135688D0D";
    String? selectedId121 = selectedRadioButton.toString();
    //  print("selectedId121${selectedId121}");

    for (VehicleList vehicle in _vehicleSuggestions) {
      if (tmNumber == vehicle.vehiclenumber) {
        //print("nooo");
        vehicleCheck = true;
        break;
      } else {
        vehicleCheck = false;
      }
    }

    if (tmNumber == "" ||
        rfidNo == "Please Tap Fastag  card !" ||
        vehicleCheck == false) {
      showErrorDialog(
        "Please Select TM number !",
        "Please Enter Correct Details",
      );
      return;
    }

    if (selectedRadioButton.isEmpty) {
      showErrorDialog(
        "Please Select RFID Type !",
        "Please Enter Correct Details",
      );
      return;
    }
    UpdatevehicleApiService updatevehicleApiService = UpdatevehicleApiService();
    try {
      SetStatus status = await updatevehicleApiService.updatevehicle(
        tmNumber,
        rfidNo,
        selectedId121.toString(),
      );
      if (status.status == "1") {
        showErrorDialog("Updated !", status.message);
      } else {
        showErrorDialog(
          "Duplication Not Allowed",
          "${status.message} , Update using Computer Software",
        );
      }
    } catch (e) {
      showErrorDialog("Error", "Failed to update vehicle. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.map_TM,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      resizeToAvoidBottomInset: false,
      body: Container(
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
        //       image: const AssetImage('assets/bg_image/RDC.png'),
        //       fit: BoxFit.cover
        //
        //   )
        // ),
        child: SingleChildScrollView(
          // Added scrollview for better handling of small screens
          child: Padding(
            padding: const EdgeInsets.all(19),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Border Layout (Select RDFID Type Section)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Adjusting Text size with MediaQuery for responsiveness
                            Text(
                              AppLocalizations.of(context)!.select_Rfid_Type,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth *
                                    0.04, // Adjust font size based on screen width
                              ),
                            ),
                          ],
                        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ---- RFID ----
                  RadioMenuButton<String>(
                    value: 'RFID',
                    groupValue: selectedRadioButton,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedRadioButton = value);
                      }
                    },
                    style: MenuItemButton.styleFrom(
                      // optional: customise the look of the whole button
                      foregroundColor: primaryColor,
                    ),
                    child: Text(AppLocalizations.of(context)!.rfid),
                  ),

                  SizedBox(width: screenWidth * 0.02),

                  // ---- RFID 2 ----
                  RadioMenuButton<String>(
                    value: 'RFID2',
                    groupValue: selectedRadioButton,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedRadioButton = value);
                      }
                    },
                    style: MenuItemButton.styleFrom(
                      foregroundColor: primaryColor,
                    ),
                    child: Text(AppLocalizations.of(context)!.rfid_2),
                  ),
                ],
              ),

                        ///old
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Radio(
                        //           activeColor: primaryColor,
                        //           value:
                        //               'RFID', // Use string values for consistency
                        //           groupValue:
                        //               selectedRadioButton, // Set the group value to the selected value
                        //           onChanged: (value) {
                        //             setState(() {
                        //               selectedRadioButton = value.toString();
                        //               // print("selectedRadioButton$selectedRadioButton");
                        //             });
                        //           },
                        //         ),
                        //         Text(AppLocalizations.of(context)!.rfid),
                        //       ],
                        //     ),
                        //     SizedBox(
                        //       width: screenWidth * 0.02,
                        //     ), // Space between buttons
                        //     Row(
                        //       children: [
                        //         Radio(
                        //           activeColor: primaryColor,
                        //           value:
                        //               'RFID2', // Use string values for consistency
                        //           groupValue:
                        //               selectedRadioButton, // Set the group value to the selected value
                        //           onChanged: (value) {
                        //             setState(() {
                        //               selectedRadioButton = value.toString();
                        //               //print("selectedRadioButton$selectedRadioButton");
                        //             });
                        //           },
                        //         ),
                        //         Text(AppLocalizations.of(context)!.rfid_2),
                        //       ],
                        //     ),
                        //   ],
                        // ),





                        // Row(
                        //   children: [
                        //     Radio(
                        //       value: 1,
                        //       groupValue: selectedRadioButton,
                        //       onChanged: (value) {
                        //         setState(() {
                        //           selectedRadioButton = value.toString();
                        //         });
                        //       },
                        //     ),
                        //     Text('RFID'),
                        //     Radio(
                        //       value:2,
                        //       groupValue: selectedRadioButton,
                        //       onChanged: (value) {
                        //         setState(() {
                        //           selectedRadioButton = value.toString();
                        //         });
                        //       },
                        //     ),
                        //     Text('RFID2'),
                        //   ],
                        // ),
                        // Vehicle Number Field
                        SizedBox(height: screenHeight * 0.02),

                        Autocomplete<VehicleList>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<VehicleList>.empty();
                            }
                            return _vehicleSuggestions.where(
                              (vehicle) =>
                                  vehicle.vehiclenumber.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ),
                            );
                          },
                          displayStringForOption:
                              (VehicleList option) => option.vehiclenumber,
                          onSelected: (VehicleList selection) {
                            // Set the vehicle number in the vehicle details controller
                            _vehicleDetailsController.text =
                                selection.vehiclenumber;
                            selectedVehicleNumber = selection.vehiclenumber;
                            selectedvehId = selectedVehicleNumber;
                            timer = Timer.periodic(Duration(seconds: 2), (
                              Timer t,
                            ) {
                              rfidService();
                            });

                            // Set the driver details in the driver details controller
                            // driverDetailsController.text = "${selection.drivername.toUpperCase()} (${selection.drivermobile})"; // Format as "DRIVERNAME (drivermobilenumber)"
                          },
                          fieldViewBuilder: (
                            BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                  ), // Change to your primary color
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                hintText:
                                    AppLocalizations.of(
                                      context,
                                    )!.vendor_Details,
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                labelText:
                                    AppLocalizations.of(
                                      context,
                                    )!.vendor_Details,
                              ),
                              onFieldSubmitted: (value) {
                                // Update selectedvehId when the user submits the form
                                selectedvehId =
                                    value; // Set selectedvehId to the manually entered vehicle number
                              },
                            );
                          },
                          optionsViewBuilder: (
                            BuildContext context,
                            AutocompleteOnSelected<VehicleList> onSelected,
                            Iterable<VehicleList> options,
                          ) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                child: Container(
                                  color:
                                      Colors
                                          .white, // Set the background color to white
                                  width: 300,
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  // Set a width for the dropdown
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(5.0),
                                    itemCount: options.length,
                                    shrinkWrap:
                                        true, // This allows the ListView to take only the space it needs
                                    physics:
                                        AlwaysScrollableScrollPhysics(), // Disable scrolling if you want to limit height
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      final VehicleList option = options
                                          .elementAt(index);
                                      return ListTile(
                                        title: Text(option.vehiclenumber),
                                        onTap: () {
                                          onSelected(option);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // FASTAG No. Field
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [],
                        ),
                        TextField(
                          controller:
                              _fastagController, // Use the controller to set the text
                          readOnly: true, // Make the text field read-only
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ), // Change to your primary color
                              borderRadius: BorderRadius.circular(11),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            hintText: AppLocalizations.of(context)!.fastag_No,
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            labelText:
                                AppLocalizations.of(
                                  context,
                                )!.fastag_No, // Change label text to match the field
                          ),
                        ),
                        // Action Buttons
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // "Map" button
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  updateVehicle();
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
                            // "Cancel" button
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ), // Adds a little space at the bottom
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                //  Navigator.push(context, MaterialPageRoute(builder: (context) => MOHomePage(locationid: widget.locationid!.toInt(),sitename:widget.sitename.toString(),userid:widget.uid!.toInt(),)));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
