import 'package:flutter/material.dart';

import 'package:rdc_concrete/screens/order_request.dart';

class WeyBridge extends StatelessWidget {
  const WeyBridge({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Capture Weight", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      resizeToAvoidBottomInset:
          false, // Prevent layout resize when keyboard opens

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
        //     image: const AssetImage('assets/bg_image/RDC.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // First Card Section - Location & Current Reading
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    // Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        Text(
                          "Location Details",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Current Reading",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    Divider(color: Colors.black, thickness: 2, height: 20),
                    Text(
                      "Active Now",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '00.00',
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Second Card Section - Connection Details
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Colors.grey[800],
                  // borderRadius: BorderRadius.circular(8),
                  // border: Border.all(color: Colors.white),
                ),
                child: Column(
                  children: [
                    // Header Row for Connection Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Connection Details",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.delete, color: Colors.black),
                      ],
                    ),
                    SizedBox(height: 15),
                    // VPN Section
                    _buildTextFieldWithLabel("VPN", "Complete"),
                    SizedBox(height: 10),
                    // UHF Section
                    _buildTextFieldWithLabel("UHF", "Enter UHF"),
                    SizedBox(height: 10),
                    // Camera Section
                    _buildTextFieldWithLabel("Camera", "Enter Camera Details"),
                    SizedBox(height: 10),
                    // Capture Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderRequest(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        backgroundColor: primaryColor,
                        // minimumSize: Size(screenWidth * 0.8, 50),
                      ),
                      child: Text(
                        "Capture Weight",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Driver & Vendor Info
                    _buildDriverInfo(),
                    _buildVendorInfo(),
                    _buildVendorEmailInfo(),
                    _buildDriverContactInfo(),
                    _buildCreationTimeInfo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create text fields with labels
  Widget _buildTextFieldWithLabel(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }

  // Helper function for Driver Info
  Widget _buildDriverInfo() {
    return _buildInfoRow("Driver Name", "RDC Concrete(India)");
  }

  // Helper function for Vendor Contact Info
  Widget _buildVendorInfo() {
    return _buildInfoRow("Vendor Contact", "RDC Concrete(India)");
  }

  // Helper function for Vendor Email Info
  Widget _buildVendorEmailInfo() {
    return _buildInfoRow("Vendor Email", "RDC Concrete(India)");
  }

  // Helper function for Driver contact Info
  Widget _buildDriverContactInfo() {
    return _buildInfoRow("Driver Contact", "RDC Concrete(India)");
  }

  // Helper function for Creation time Info
  Widget _buildCreationTimeInfo() {
    return _buildInfoRow("Creation Time", "RDC Concrete(India)");
  }

  // Helper function to create info rows (Driver, Vendor, etc.)
  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
