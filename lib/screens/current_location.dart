import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/current_loc_pojo.dart';
import '../services/current_loc_api_service.dart';
// import '../services/current_loc_update_api_servce.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';

class CurrentLocation extends StatefulWidget {
  final String sitename;
  final int? uprofileid;
  final String? language;
  const CurrentLocation({
    super.key,
    required this.sitename,
    this.uprofileid,
    this.language,
  });

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  double? latitude;
  double? longitude;

  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  String currentLocation = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLocation(widget.sitename);
   // SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
  }

  void fetchLocation(String sitename) async {
    LocationService locationService = LocationService();
    LocationPoJo? location = await locationService.fetchLocationOfSite(
      sitename,
    );

    // if (location != null && location.latitude != null && location.longitude != null) {
    if (location != null) {
      setState(() {
        latitude = double.tryParse(location.latitude) ?? 0.0;
        longitude = double.tryParse(location.longitude) ?? 0.0;
        latitudeController.text = latitude.toString();
        longitudeController.text = longitude.toString();
      });
    } else {
      //print("Failed to fetch location or location data is null.");
    }
  }

  Future<void> updateLocation(String siteName) async {
    // Check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permissions are denied, handle accordingly
        return;
      }
    }
    setState(() {
      isLoading = true;
    });
    // Get the current location
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // Set the desired accuracy
      distanceFilter: 10, // Optional: Set the distance filter in meters
    );

    // Get the current location using the new settings parameter
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;
    //print("Latitude: $latitude");
    //print("Longitude: $longitude");

    if (latitude != 0.0 && longitude != 0.0) {
      currentLocation = "Lati: $latitude Longi: $longitude";
      //print("adddddddddddd${currentLocation}");
      await uploadAddress(siteName, currentLocation);
    } else {
      // Handle case where location is not valid
      //print("Invalid location received.");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadAddress(String id, String address) async {
    try {
      //CurrentLocUpdateApiServce locationService = CurrentLocUpdateApiServce();
      // SetStatus status = await locationService.uploadAddress(id, address);
      // Handle successful response
      //print("Address updated successfully: ${status.message}"); // Assuming SetStatus has a message field
    } catch (e) {
      // Handle error
      //print("Error updating address: $e");
    }
  }
  // Future<void> updateLocation() async {
  //   // Check for location permission
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
  //       // Permissions are denied, handle accordingly
  //       return;
  //     }
  //   }
  //
  //   // Get the current location
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   double latitude = position.latitude;
  //   double longitude = position.longitude;
  //   print("latitude${latitude}");
  //   print("longitude${longitude}");
  //
  //   if (latitude != 0.0 && longitude != 0.0) {
  //     currentLocation = "Lati: $latitude Longi: $longitude";
  //     await uploadAddress(widget.sitename, currentLocation);
  //   } else {
  //     // Handle case where location is not valid
  //   }
  // }
  // Future<void> uploadAddress(String id, String address) async {
  //   try {
  //     CurrentLocUpdateApiServce locationService = CurrentLocUpdateApiServce();
  //     SetStatus status = await locationService.uploadAddress(id, address);
  //     // Handle successful response
  //     print("Address updated successfully: ${status.message}"); // Assuming SetStatus has a message field
  //   } catch (e) {
  //     // Handle error
  //     print("Error updating address: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.current_location,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.location,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.location_Details,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.current_Reading,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    AppLocalizations.of(context)!.active_Now,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: latitudeController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.green.shade50,
                                hintText: '00.00',
                                hintStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.map,
                                  color: primaryColor,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              readOnly: true,
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: longitudeController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.green.shade50,
                                hintText: '00.00',
                                hintStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.navigation,
                                  color: primaryColor,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              readOnly: true,
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed:
                                    isLoading
                                        ? null
                                        : () async {
                                          await updateLocation(
                                            widget.sitename,
                                          ); // Use widget.sitename
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 30,
                                  ),
                                ),
                                icon: Icon(Icons.update, color: Colors.white),
                                label: Text(
                                  AppLocalizations.of(context)!.update_location,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
