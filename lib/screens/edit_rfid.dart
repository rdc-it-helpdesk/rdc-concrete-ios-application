import 'package:flutter/material.dart';

class EditRfid extends StatelessWidget {
  // final TextEditingController _vehicleNoController = TextEditingController();
  // final TextEditingController _fastTagNoController = TextEditingController();
  const EditRfid({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          "Edit RFID",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      resizeToAvoidBottomInset:
          false, // Prevent layout resize when keyboard opens

      body: Container(
        height:
            double.infinity, // Use double.infinity to avoid stretching issues
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
        //     fit: BoxFit.cover, // This ensures the background covers the screen without stretching
        //   ),
        // ),
        child: Center(
          child: SafeArea(
            // SafeArea ensures no overlap with screen edges
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CustomTextField(label: "Vehicle No", isPassword: false),

                  const SizedBox(height: 24),
                  CustomTextField(label: "FASTAG No", isPassword: true),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          // backgroundColor: Colors.green,
                          backgroundColor: primaryColor,
                          minimumSize: Size(screenWidth * 0.4, 50),
                        ),
                        child: Text(
                          'Map',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => AcceptDriver(showDetails: true, showTruckDetails: false,)));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          // backgroundColor: Colors.green,
                          backgroundColor: primaryColor,
                          minimumSize: Size(screenWidth * 0.4, 50),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white, // White background for input fields
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
      style: TextStyle(fontSize: 16, color: Colors.black), // Black text color
    );
  }
}
