import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';
import '../models/fetch_po_pojo.dart';

import '../services/fetch_po_api_service.dart';

import '../services/map_to_vendor_services/addnewvendor_api_service.dart';
import '../services/map_to_vendor_services/mapvendorwithpo_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';
import 'fetch_po.dart';

class MapMobileToVendorProfile extends StatefulWidget {
  //final int locationid;

  final String sitename;
  //final List<Mapped> mappedList;
  final int? vendorId; // Optional parameter
  final int? createdid;
  //  final int uid;
  // final Mapped mappedList;
  const MapMobileToVendorProfile({
    super.key,
    required this.sitename,
    this.vendorId,
    this.createdid,
  });

  @override
  State<MapMobileToVendorProfile> createState() => _MapMobileToVendorProfile();
}

class _MapMobileToVendorProfile extends State<MapMobileToVendorProfile> {
  // const MapMobileToVendorProfile({super.key});
  // Store active
  TextEditingController vendorEmailController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  TextEditingController vendorMobileController = TextEditingController();
  TextEditingController vendorPasswordController = TextEditingController();
   bool _isLoading = true;

  @override
  void initState() {
    super.initState();

 //   print("siteeeeeeeeeeeeeeedonnnnnnnnnn: ${widget.sitename}");

    fetchPOData(widget.sitename);
   // SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
  }

  List<Unmapped> unmappedList = [];
  List<Mapped> mappedList = [];
  Map<int, bool> expandedItems = {};
  Future<void> fetchPOData(String sitename) async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');

    if (sitename == null) {
      setState(() => _isLoading = false);
      return;
    }

    // print("Fetching users for sitename: $sitename");
    final dio = ApiClient.getDio();
    final service = FetchsitepolistService(dio);

    try {
      Fetchsitepolist? data = await service.fetchFetchsitepolist(sitename);
      //  print("Vendor ID: ${widget.vendorId}");
      //  print("Vendor site ID: ${widget.sitename}");
      if (data != null) {
        // print("Data fetched successfully!");

        setState(() {
          if (widget.vendorId == null) {
            // Unmapped Vendors
            unmappedList = data.unmapped;
            spinnerItems =
                unmappedList.where((item) => item.isMapped == "false").toList();
          } else {
            // Mapped Vendors
            mappedList = data.mapped;
            spinnerItemsMap =
                mappedList.where((item) => item.isMapped == "true").toList();
          }
          _isLoading = false;
        });

        // print("Updated Spinner Items: ${spinnerItems.length}");
        //  print("Updated Spinner Items MAp: ${spinnerItemsMap.length}");
      } else {
        //print("No data found.");
        setState(() {
          spinnerItems = [];
          spinnerItemsMap = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      // print("Error fetching data: $e");
    }
  }

  void validate() {
    final String vmobile = vendorMobileController.text.trim();
    final String pass = vendorPasswordController.text.trim();
    final String vemailaddress = vendorEmailController.text.trim();
    final String vendorName = vendorNameController.text.trim();

    // Debugging
    //print("Mobile: '$vmobile'");
    //print("Password: '$pass'");
    //print("email: '$vemailaddress'");
    // print("name: '$vendorName'");
    // print("name: '$poId'");

    final RegExp passwordPattern = RegExp(
      r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$',
    ); // At least 8 characters, alphanumeric

    if (vmobile.length != 10) {
      _showError("Enter a valid mobile number!");
      return;
    }

    if (!passwordPattern.hasMatch(pass)) {
      _showError("Password must be at least 8 characters and alphanumeric!");
      return;
    }
    addVendor(vmobile, vemailaddress, vendorName, pass);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white), // Ensure text is readable
        ),
        backgroundColor: Colors.red, // Set red background for error
        behavior: SnackBarBehavior.floating, // Optional: Makes it float
        duration: Duration(seconds: 3), // Optional: Auto-hide after 3 seconds
      ),
    );
  }
  void addVendor(
      String mobile,
      String email,
      String name,
      String password,
      ) async {
    // ✅ Log all parameters before sending API request
    // print("📢 Sending Add Vendor API Request:");
    // print("📍 Name: $name");
    // print("📍 Mobile: $mobile");
    // print("📍 Email: $email");
    // print("📍 Site: ${widget.sitename}");
    // print("🔑 Password: $password");

    final dio = ApiClient.getDio();
    final addNewVendorService = AddNewVendor(dio);

    // Call the API to add a new vendor
    SetStatus status = await addNewVendorService.addNewVendor(
      name,
      mobile,
      email,
      widget.sitename,
      password,
    );

    // ✅ Log the API response for debugging
    // print("📢 API Response:");
    // print("Status: ${status.status}");
    // print("Message: ${status.message}");
    // print("Created ID: ${status.createdid}");

    if (status.status == "1") {
      String? vendorid;
      if (widget.createdid == null || widget.createdid == 1) {
        vendorid = status.createdid;
      } else {
        vendorid = widget.createdid.toString();
      }

      if (vendorid != null) {
        setVendorToPO(vendorid.toString(), name, mobile, email);
      } else {
        showErrorDialog("Vendor ID is null");
      }
    } else {
      showErrorDialog(status.message);
    }
  }

//main
  // void addVendor(
  //   String mobile,
  //   String email,
  //   String name,
  //   String password,
  // ) async {
  //   final dio = ApiClient.getDio();
  //   final addNewVendorService = AddNewVendor(dio);
  //   // print("🔑 New Password being sent: $password");
  //   // Call the API to add a new vendor
  //   SetStatus status = await addNewVendorService.addNewVendor(
  //     name,
  //     mobile,
  //     email,
  //     widget.sitename,
  //     password,
  //   );
  //
  //   if (status.status == "1") {
  //     //print("createdid ${status.createdid}");
  //     // String? vendorid = status.createdid; unmap
  //     String? vendorid;
  //     if (widget.createdid == null || widget.createdid == 1) {
  //       vendorid =
  //           status
  //               .createdid; // Assuming selectedLocationItem is defined somewhere
  //     } else {
  //       vendorid = widget.createdid.toString();
  //     }
  //     // map
  //     //print("vendoridsettt ${vendorid}");// Ensure createdId is handled properly
  //     if (vendorid != null) {
  //       setVendorToPO(vendorid.toString(), name, mobile, email);
  //     } else {
  //       showErrorDialog("Vendor ID is null");
  //     }
  //   } else {
  //     // Handle error
  //     showErrorDialog(status.message);
  //   }
  // }

  void setVendorToPO(
    String vendorid,
    String vendorName,
    String mobile,
    String email,
  ) async {
    final dio = ApiClient.getDio();
    final vendorService = VendorService(dio);

    String? poId;

    if (widget.createdid == null || widget.createdid == 1) {
      poId =
          selectedLocationItem; // Assuming selectedLocationItem is defined somewhere
    } else {
      poId = widget.vendorId.toString();
    }

    //print("Sending to API: vendorid: $vendorid, poid: $poId, vname: $vendorName");
    try {
      // Call the API to update the PO details
      SetStatus status = await vendorService.updatePODetails(
        vendorid,
        poId!,
        vendorName,
      );

      if (status.status == "1") {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FetchPO(sitename: widget.sitename,),
          ), // Replace FetchPoScreen with your actual widget
        );
        // Success
        // await sendEmail("YOUR UPDATE MOBILE NUMBER LOGIN Credential", poId!, vendorEmailController.text, vendorMobileController.text);
        // showSuccessDialog("Vendor updated successfully!");
      } else {
        // Handle error
        showErrorDialog(status.message);
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call
      showErrorDialog("An error occurred: ${e.toString()}");
    }
  }

  Future<void> sendEmail(
    String subject,
    String poId,
    String email,
    String mobile,
  ) async {
    //   String message = "Your RDC Wighment Application LogIn Mobile Number is $mobile AND VendorID is $poId. Please check your credentials.";

    // Implement your email sending logic here
    // You can use a service or library to send emails
    // Example of using a hypothetical SendMail class
    // SendMail javaMailAPI = SendMail(this, email, subject, message);
    // await javaMailAPI.send(); // Assuming send() is a method in your SendMail class
  }
  //
  // void addVendor(String mobile, String email, String name, String password) {
  //   // Your logic to add vendor
  //   print("Vendor added with Mobile: $mobile, Email: $email, Name: $name");
  // }

  // void addOrUpdateVendor() async {
  //   String uname = vendorNameController.text.trim();
  //   String umobile = vendorMobileController.text.trim();
  //   String email = vendorEmailController.text.trim();
  //   String password = vendorPasswordController.text.trim();
  //   String siteid = "MU5"; // Example site ID
  //   String? vendorID = selectedLocationItem; // Ensure this has a value
  //
  //   // Debugging
  //   print("Vendor Name: '$uname'");
  //   print("Vendor Mobile: '$umobile'");
  //   print("Vendor Email: '$email'");
  //   print("Vendor Password: '$password'");
  //   print("Password Length: ${password.length}"); // Check the length
  //   print("Selected Vendor ID: '$vendorID'");
  //
  //   if (uname.isEmpty) {
  //     showErrorDialog("Vendor Name cannot be empty");
  //     return;
  //   }
  //   if (umobile.isEmpty || umobile.length != 10) {
  //     showErrorDialog("Please enter a valid 10-digit mobile number");
  //     return;
  //   }
  //   if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
  //     showErrorDialog("Please enter a valid email address");
  //     return;
  //   }
  //   if (password.isEmpty || password.length < 8) {
  //     showErrorDialog("Password must be at least 8 characters long");
  //     return;
  //   }
  //   if (vendorID == null || vendorID.isEmpty) {
  //     showErrorDialog("Please select a vendor ID");
  //     return;
  //   }
  //   // Proceed with adding or updating the vendor...
  // }
  //
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(""),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return PopScope(
        canPop: false, // Prevents default pop until handled
        onPopInvokedWithResult: (bool didPop, Object? result) async {
      if (didPop) return; // If already popped (e.g., via predictive back), do nothing
      // Manually pop and return true to signal HomePage to refresh
      Navigator.of(context).pop(true);
    },
    child: Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.map_to_vendor_Profile,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildVendorIDSpinner(),
                          _buildTextField(
                            AppLocalizations.of(context)!.vendor_Email,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                            controller: vendorEmailController,
                          ),
                          _buildTextField(
                            AppLocalizations.of(context)!.vendor_Name,
                            readOnly: true,
                            controller: vendorNameController,
                          ),
                          // _buildTextField("Vendor Email", keyboardType: TextInputType.emailAddress,readOnly: true,controller: vendorEmailController,),
                          // _buildTextField("Vendor Name", readOnly: true,controller: vendorNameController),
                          _buildTextField(
                            AppLocalizations.of(context)!.vendor_Mobile,
                            keyboardType: TextInputType.phone,
                            controller: vendorMobileController,
                          ),
                          // _buildTextField("Vendor Password", obscureText: true),
                          _buildTextField(
                            controller: vendorPasswordController,
                            obscureText: true, // To hide the password input
                            AppLocalizations.of(context)!.password,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 70,
                              ),
                            ),
                            onPressed: () {
                              // Call your method here
                              validate(); // Example method to handle form submission
                            },
                            child: Text(
                              AppLocalizations.of(context)!.submitbtn,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: primaryColor,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                          //   ),
                          //   onPressed: () {
                          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectProfile()));
                          //   },
                          //   child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                          // ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      //    Colors.black.withOpacity(0.3)
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3), // semi-transparent overlay
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }

  List<Unmapped> spinnerItems = [];
  Unmapped? selectedLocation;
  List<Mapped> spinnerItemsMap = [];
  Mapped? selectedLocationMAp;

  String? selectedLocationItem;
  // Add these variables to store vendor details
  String? selectedVendorEmail;
  String? selectedVendorName;
  String? selectedVendorMobile;

  Widget _buildVendorIDSpinner() {
    bool isUnmapped = widget.vendorId == null;
    // print("editvaluvid: ${isUnmapped}");

    List<dynamic> items =
        isUnmapped
            ? spinnerItems
            : spinnerItemsMap
                .where((item) => item.vendorId == widget.vendorId)
                .take(1)
                .toList();

    dynamic selectedItem = items.isNotEmpty ? items.first : null;
    //print("selectedItemunmap ${selectedItem}");
    // Pre-fill vendor details if a mapped vendor is found
    if (!isUnmapped && selectedItem != null) {
      selectedVendorEmail = selectedItem.vendorEmail;
      selectedVendorName = selectedItem.vendorName;
      selectedVendorMobile = selectedItem.mobile;

      // ✅ Update text controllers
      vendorEmailController.text = selectedVendorEmail ?? "";
      vendorNameController.text = selectedVendorName ?? "";
      vendorMobileController.text = selectedVendorMobile ?? "";
    }

    return DropdownButtonFormField<dynamic>(
      initialValue: selectedItem,
      hint: Text(AppLocalizations.of(context)!.select_Vendor_id),
      items:
          items.map((dynamic item) {
            return DropdownMenuItem<dynamic>(
              value: item,
              child: Text(
                "${item.vendorId} - ${item.contactPerson ?? AppLocalizations.of(context)!.n_a}",
              ),
            );
          }).toList(),
      onChanged: (dynamic newValue) {
        if (newValue != null) {
          setState(() {
            selectedLocation = newValue;
            selectedLocationItem = newValue.vendorId.toString();
            selectedVendorEmail = newValue.vendorEmail;
            selectedVendorName = newValue.vendorName;

            // selectedVendorMobile = newValue.mobile;

            // ✅ Update text controllers on selection change
            vendorEmailController.text = selectedVendorEmail ?? "";
            vendorNameController.text = selectedVendorName ?? "";
            // vendorMobileController.text = selectedVendorMobile ?? "";
          });

          //print("Selected Vendor ID: ${newValue.vendorId}");

          //print("selectedLocationItem: ${selectedLocationItem}");
          // print("selectedLocationItemMap: ${selectedLocationMAp}");

          // print("Vendor Email: ${selectedVendorEmail}");
          // print("Vendor Name: ${selectedVendorName}");
          // print("Vendor mobile: ${selectedVendorMobile}");
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: AppLocalizations.of(context)!.select_Vendor,
        labelStyle: TextStyle(color: Colors.black),
      ),
      dropdownColor: Colors.white,
      // hint: Text("Select Vendor"),
      isExpanded: true,
    );
  }

  Widget _buildTextField(
    String hint, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnly: readOnly,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade200,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
