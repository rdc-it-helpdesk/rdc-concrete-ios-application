import 'package:flutter/material.dart';

class InfoFormValidator {
  // static String? validateVehicleNumber(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return "Vehicle number is required";
  //   }
  //   // Add other validation rules here
  //   return null; // Valid case
  // }

  static String? validateVehicleNumber(
    String? value,
    String activeVehicleSiteName,
    bool vavailable,
  ) {
    if (value == null || value.isEmpty) {
      return "Enter Vehicle Number";
    }

    String vehicleNumber = value
        .toUpperCase()
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .replaceAll("\r", "");

    if (vehicleNumber.length < 8) {
      return "Vehicle number must be at least 8 characters";
    }

    if (!vavailable) {
      return "Vehicle Number is Active in $activeVehicleSiteName";
    }

    return null; // Valid case
  }

  static bool validateDriver(String driverId, BuildContext context) {
    if (driverId == "0") {
      showSnackbar(context, "Select Driver");
      return false;
    }
    return true;
  }

  static bool validateChallanNumber(
    TextEditingController controller,
    BuildContext context,
  ) {
    String challanNumber = controller.text.replaceAll("\r", "");
    if (challanNumber.isEmpty) {
      showError(controller, context, "Enter Challan No");
      return false;
    }
    return true;
  }

  static bool validateNetWeight(
    TextEditingController controller,
    String availableQty,
    BuildContext context,
  ) {
    String netWeight = controller.text.replaceAll("\r", "");
    if (netWeight.isEmpty) {
      showError(controller, context, "Enter Valid Weight Data");
      return false;
    }
    if (double.tryParse(netWeight) != null &&
        double.parse(netWeight) > double.parse(availableQty)) {
      showError(controller, context, "More than available Qty!");
      return false;
    }
    return true;
  }

  static bool validateAdditionalChallan(
    bool optionalFormFlag,
    TextEditingController controller,
    BuildContext context,
  ) {
    if (optionalFormFlag && controller.text.isEmpty) {
      showError(controller, context, "Please Enter Additional Challan No!");
      return false;
    }
    return true;
  }

  static bool validateAdditionalNetWeight(
    bool optionalFormFlag,
    TextEditingController controller,
    String availableQty,
    BuildContext context,
  ) {
    String netOneText = controller.text.trim();
    double? netOneValue = double.tryParse(netOneText);
    double availableQuantity = double.tryParse(availableQty) ?? 0;

    if (optionalFormFlag && netOneText.isEmpty) {
      showError(controller, context, "More than available Qty!");
      return false;
    }
    if (optionalFormFlag && (netOneValue == null || netOneValue <= 0)) {
      showError(controller, context, "Please Enter Additional Net!");
      return false;
    }
    if (optionalFormFlag &&
        netOneValue != null &&
        netOneValue > availableQuantity) {
      showError(controller, context, "More than available Qty!");
      return false;
    }
    return true;
  }

  static bool validateChallanMismatch(
    TextEditingController challanOneController,
    TextEditingController challanNumberController,
    BuildContext context,
  ) {
    if (challanOneController.text.trim() ==
        challanNumberController.text.trim()) {
      showError(challanOneController, context, "Challan No could not be same!");
      return false;
    }
    return true;
  }

  static bool validateInvoiceUpload(
    int withInvoice,
    String base64File,
    BuildContext context,
  ) {
    if (withInvoice != 0 && base64File.isEmpty) {
      showErrorDialog(context, "Upload Invoice File!");
      return false;
    }
    return true;
  }

  // Helper function to show an error dialog
  static void showErrorDialog(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  static bool validateDoubleNetWeight(
    bool optionalFormFlag,
    TextEditingController netOneController,
    TextEditingController netController,
    BuildContext context,
  ) {
    int? netOneValue = int.tryParse(netOneController.text.trim());
    int? netWeightValue = int.tryParse(netController.text.trim());

    if (optionalFormFlag &&
        (netOneValue == null ||
            netOneValue < 1 ||
            netWeightValue == null ||
            netWeightValue < 1)) {
      showError(
        netController,
        context,
        "In case of double, Net Weight is required!",
      );
      return false;
    }
    return true;
  }

  static bool validateDoubleInvoice(
    bool optionalFormFlag,
    String base64File1,
    String base64File2,
    BuildContext context,
  ) {
    if (optionalFormFlag && (base64File1.isEmpty || base64File2.isEmpty)) {
      showSnackbar(context, "Invoice required in Double Challan case!");
      return false;
    }
    return true;
  }

  static void showError(
    TextEditingController controller,
    BuildContext context,
    String message,
  ) {
    controller.clear();
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    showSnackbar(context, message);
  }

  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
