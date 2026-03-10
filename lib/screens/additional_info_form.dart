import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:rdc_concrete/component/custom_elevated_button.dart';

import '../core/network/api_client.dart';
import '../models/vendor_transaction_pojo.dart';

import '../services/vendor_transaction_api_service.dart';
import '../utils/session_manager.dart';

class AdditionalInfoForm extends StatefulWidget {
  final String? orderid;
  final int? uid;
  final int? poid;
  const AdditionalInfoForm({super.key, this.orderid, this.uid, this.poid});

  @override
  State<AdditionalInfoForm> createState() => _AdditionalInfoFormState();
}

class _AdditionalInfoFormState extends State<AdditionalInfoForm> with WidgetsBindingObserver {
  bool _isWithInvoice = true;
  bool _isWithInvoice1 = true;
  String? _fileName;
  TextEditingController vehicleDetailsController = TextEditingController();
  TextEditingController driverDetailsController = TextEditingController();
  TextEditingController challanNoController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchTransactions(widget.uid.toString(), widget.poid.toString());
    WidgetsBinding.instance.addObserver(this); // Register observer
    //SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);

  }

  List<Activevendor> _activeList = [];
  // Function to open the file chooser
  void openFileChooser() async {
    // Open file picker to pick a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Only allow PDF files
    );

    if (result != null) {
      // Get the file path or file name
      // String? path = result.files.single.path;
      String? fileName = result.files.single.name;

      setState(() {
        _fileName = fileName;
      });

      // You can also perform other actions with the selected file, like uploading it
      //print('Selected file: $fileName');
      // print('File path: $path');
    } else {
      // User canceled the picker
      //print('No file selected');
    }
  }

  // Future<void> fetchTransactions(String uid, String poid) async {
  //   final dio = ApiClient.getDio();
  //   final service = VendorTransactionService(dio);
  //   try {
  //     VendorTransactionList? data = await service.fetchVendorTransaction(uid, poid);
  //     if (data != null) {
  //       print("Data fetched successfully: ${data.toString()}");
  //
  //       setState(() {
  //         _activeList = data.activeVendor;
  //       });
  //     } else {
  //       print("Failed to fetch data");
  //     }
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //   }
  // }
  // Future<void> fetchTransactions(String uid, String poid) async {
  //   final dio = ApiClient.getDio();
  //   final service = VendorTransactionService(dio);
  //   try {
  //     VendorTransactionList? data = await service.fetchVendorTransaction(uid, poid);
  //     if (data != null) {
  //       print("Data fetched successfully: ${data.toString()}");
  //
  //       // Filter the activeVendor list based on the orderid
  //       setState(() {
  //         _activeList = data.activeVendor.where((vendor) => vendor.orderid == widget.orderid).toList();
  //       });
  //     } else {
  //       print("Failed to fetch data");
  //     }
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //   }
  // }
  Future<void> fetchTransactions(String uid, String poid) async {
    final dio = ApiClient.getDio();
    final service = VendorTransactionService(dio);
    try {
      VendorTransactionList? data = await service.fetchVendorTransaction(
        uid,
        poid,
      );
      if (data != null) {
        //print("Data fetched successfully: ${data.toString()}");

        // Filter the activeVendor list based on the orderid
        setState(() {
          _activeList =
              data.activeVendor
                  .where(
                    (vendor) => vendor.orderid.toString() == widget.orderid,
                  )
                  .toList();

          // If there are active vendors, set the text field values
          if (_activeList.isNotEmpty) {
            final vendor = _activeList.first; // Get the first vendor
            vehicleDetailsController.text = vendor.vehiclenumber ?? "";
            driverDetailsController.text = vendor.drivername ?? "";
            challanNoController.text = vendor.challanno ?? "";
            weightController.text = vendor.netweight?.toString() ?? "";

            //print("Vehicle Number: ${vehicleDetailsController.text}");
            //   print("Driver Name: ${driverDetailsController.text}");
            // print("Challan No: ${challanNoController.text}");
            //  print("Weight in KG: ${weightController.text}");// Assuming netweight is the weight you want
          }
        });
      } else {
        //print("Failed to fetch data");
      }
    } catch (e) {
      //print("Error fetching data: $e");
    }
  }

  // @override
  // void dispose() {
  //   vehicleDetailsController.dispose();
  //   driverDetailsController.dispose();
  //   challanNoController.dispose();
  //   weightController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Additional Info Form',
          style: TextStyle(color: Colors.white),
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
                          _buildTextField(
                            "Vehicle Details",
                            controller: vehicleDetailsController,
                          ),
                          GestureDetector(
                            onTap: _showDriverDetailsDialog,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: driverDetailsController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                    ),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  hintText: 'Driver Details',
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: "Driver Details",
                                ),
                              ),
                            ),
                          ),
                          _buildTextField(
                            "Enter Challan No",
                            controller: challanNoController,
                            keyboardType: TextInputType.number,
                          ),
                          _buildTextField(
                            "Weight in KG",
                            controller: weightController,
                            keyboardType: TextInputType.phone,
                          ),

                          // _buildTextField("Vehicle Details"),
                          // _buildTextField("Driver Details", keyboardType: TextInputType.emailAddress),
                          // _buildTextField("Enter Challan No", keyboardType: TextInputType.number),
                          // _buildTextField("Weight in KG", keyboardType: TextInputType.phone),
                          // _buildTextField("Vendor Password", obscureText: true),
                          const SizedBox(height: 5),
                          Container(
                            height: 70,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TextView in XML
                                Text(
                                  'Is With Invoice',
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // SizedBox(width: 10), // Margin between text and radio buttons

                                // Radio Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start, // or spaceEvenly if needed
                                  children: [
                                    // ---- YES ----
                                    RadioMenuButton<bool>(
                                      value: true,
                                      groupValue: _isWithInvoice,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          setState(() => _isWithInvoice = value);
                                        }
                                      },
                                      style: MenuItemButton.styleFrom(
                                        foregroundColor: primaryColor, // active radio dot color
                                      ),
                                      child: const Text('Yes'),
                                    ),

                                    const SizedBox(width: 16), // Space between buttons (adjust as needed)

                                    // ---- NO ----
                                    RadioMenuButton<bool>(
                                      value: false,
                                      groupValue: _isWithInvoice,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          setState(() => _isWithInvoice = value);
                                        }
                                      },
                                      style: MenuItemButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                      child: const Text('No'),
                                    ),
                                  ],
                                ),
                                //old
                                // Row(
                                //   children: [
                                //     Radio<bool>(
                                //       value: true,
                                //       groupValue: _isWithInvoice,
                                //       onChanged: (bool? value) {
                                //         setState(() {
                                //           _isWithInvoice = value!;
                                //         });
                                //       },
                                //       activeColor: primaryColor,
                                //     ),
                                //     Text(
                                //       'Yes',
                                //       // style: TextStyle(color: Colors.white),
                                //     ),
                                //     SizedBox(
                                //       width: 5,
                                //     ), // Space between radio buttons
                                //
                                //     Radio<bool>(
                                //       value: false,
                                //       groupValue: _isWithInvoice,
                                //       onChanged: (bool? value) {
                                //         setState(() {
                                //           _isWithInvoice = value!;
                                //         });
                                //       },
                                //       activeColor: primaryColor,
                                //     ),
                                //     Text(
                                //       'No',
                                //       // style: TextStyle(color: Colors.white),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                          Text(
                            "Additional Details list",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _buildTextField(
                            "Additional Challan No",
                            keyboardType: TextInputType.number,
                          ),
                          _buildTextField(
                            "Additional Weight in KG",
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 70,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TextView in XML
                                Text(
                                  'Is With Invoice',
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // SizedBox(width: 10), // Margin between text and radio buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,   // adjust as you need
                                  children: [
                                    // ---------- YES ----------
                                    RadioMenuButton<bool>(
                                      value: true,
                                      groupValue: _isWithInvoice1,
                                      onChanged: (bool? v) {
                                        if (v != null) setState(() => _isWithInvoice1 = v);
                                      },
                                      style: MenuItemButton.styleFrom(
                                        foregroundColor: primaryColor,   // active dot colour
                                        // optional padding
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      child: const Text('Yes'),
                                    ),

                                    const SizedBox(width: 12),   // spacing (you had 5 before)

                                    // ---------- NO ----------
                                    RadioMenuButton<bool>(
                                      value: false,
                                      groupValue: _isWithInvoice1,
                                      onChanged: (bool? v) {
                                        if (v != null) setState(() => _isWithInvoice1 = v);
                                      },
                                      style: MenuItemButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                      child: const Text('No'),
                                    ),
                                  ],
                                ),
                                // Radio Buttons
                                //old
                                // Row(
                                //   children: [
                                //     Radio<bool>(
                                //       value: true,
                                //       groupValue: _isWithInvoice1,
                                //       onChanged: (bool? value) {
                                //         setState(() {
                                //           _isWithInvoice1 = value!;
                                //         });
                                //       },
                                //       activeColor: primaryColor,
                                //     ),
                                //     Text(
                                //       'Yes',
                                //       // style: TextStyle(color: Colors.white),
                                //     ),
                                //     SizedBox(
                                //       width: 5,
                                //     ), // Space between radio buttons
                                //
                                //     Radio<bool>(
                                //       value: false,
                                //       groupValue: _isWithInvoice1,
                                //       onChanged: (bool? value) {
                                //         setState(() {
                                //           _isWithInvoice1 = value!;
                                //         });
                                //       },
                                //       activeColor: primaryColor,
                                //     ),
                                //     Text(
                                //       'No',
                                //       // style: TextStyle(color: Colors.white),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                          CustomElevatedButton(
                            onPressed: openFileChooser,
                            text: 'Choose File',
                            popOnPress: false,
                            backgroundColor: Colors.grey,
                          ),
                          if (_fileName != null) ...[
                            SizedBox(height: 20),
                            Text('Selected file: $_fileName'),
                          ],

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
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectProfile()));
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
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
    );
  }

  void _showDriverDetailsDialog() {
    final primaryColor = Theme.of(context).primaryColor;

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();

    // If editing existing details, parse and set initial values
    // if (_driverNameController.text.isNotEmpty) {
    //   final regex = RegExp(r"(.*) \((.*)\)");
    //   final match = regex.firstMatch(_driverNameController.text);
    //   if (match != null && match.groupCount >= 2) {
    //     usernameController.text = match.group(1)!;
    //     mobileController.text = match.group(2)!;
    //   }
    // }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Driver"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: "Driver Name",
                    hintText: "Enter Driver Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, // No border by default
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,
                      ), // Green border on focus
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ), // Transparent border when enabled
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: "Mobile Number",
                    hintText: "Enter Mobile No",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, // No border by default
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,
                      ), // Green border on focus
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ), // Transparent border when enabled
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      height: 40,
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                      text: 'Save',
                      backgroundColor: primaryColor,
                      width: 15,
                      popOnPress: false,
                    ),
                    CustomElevatedButton(
                      height: 40,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Cancel',
                      backgroundColor: primaryColor,
                      width: 15,
                      popOnPress: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     child: const Text("Cancel"),
          //   ),
          //   CustomElevatedButton(onPressed: (){}, text: 'Save', backgroundColor: primaryColor)
          //   // TextButton(
          //   //   onPressed: () {
          //   //     // Simple validation
          //   //     if (usernameController.text.trim().isEmpty) {
          //   //       ScaffoldMessenger.of(context).showSnackBar(
          //   //         const SnackBar(content: Text("Please enter driver name")),
          //   //       );
          //   //       return;
          //   //     }
          //   //
          //   //     if (mobileController.text.trim().isEmpty) {
          //   //       ScaffoldMessenger.of(context).showSnackBar(
          //   //         const SnackBar(content: Text("Please enter mobile number")),
          //   //       );
          //   //       return;
          //   //     }
          //   //
          //   //     setState(() {
          //   //       _driverNameController.text = "${usernameController.text} (${mobileController.text})";
          //   //     });
          //   //     Navigator.pop(context);
          //   //   },
          //   //   child: const Text("Save"),
          //   // ),
          // ],
        );
      },
    );
    //     .then((_) {
    //   // Clean up the controllers when the dialog is dismissed
    //   usernameController.dispose();
    //   mobileController.dispose();
    // });
  }

  Widget _buildTextField(
    String hint, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller, // Set t
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(11),
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




