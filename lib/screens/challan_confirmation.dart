import 'package:flutter/material.dart';
import 'package:rdc_concrete/component/custom_elevated_button.dart';

import '../utils/session_manager.dart';

class ChallanConfirmation extends StatefulWidget {
  // final String challanNo;
  final String selectedLocationItems;

  const ChallanConfirmation({super.key, required this.selectedLocationItems});

  @override
  State<ChallanConfirmation> createState() => _ChallanConfirmationState();
}

class _ChallanConfirmationState extends State<ChallanConfirmation> {
  late TextEditingController _siteController;

  @override
  void initState() {
    super.initState();
    //SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
    // Debug: Print challanNo to ensure it's passed correctly
    //print("Received Site Name: ${widget.selectedLocationItems}");

    // Ensure controller is updated after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _siteController.text =
            widget.selectedLocationItems; // Assign value after UI is built
      });
    });

    _siteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Challan Confirmation',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildConfirmBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.black.withOpacity(0.5),
        color: Color.fromRGBO(0, 0, 0, 0.5),
        image: DecorationImage(
          image: const AssetImage("assets/bg_image/RDC.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            // Colors.black.withOpacity(0.3),
            Color.fromRGBO(0, 0, 0, 0.3),
            BlendMode.dstATop,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmBox() {
    final primaryColor = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Reach RDC plant?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.location_on, size: 50, color: Colors.green),
            const SizedBox(height: 10),
            TextField(
              controller: _siteController, // Should now show challanNo
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Challan No',
              ),
              keyboardType: TextInputType.name,
              readOnly: false,
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const AcceptDriver(showDetails: true, showTruckDetails: false, ),
                //       settings: RouteSettings(arguments: widget.selectedLocationItems)
                //   ),
                // );
              },
              text: 'Confirm',
              backgroundColor: primaryColor,
              width: screenWidth * 0.8,
              popOnPress: false,
            ),
          ],
        ),
      ),
    );
  }
}
