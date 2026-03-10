import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rdc_concrete/component/custom_elevated_button.dart';
import 'package:rdc_concrete/screens/vendor_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inserttransaction_pojo.dart';
import '../models/userlist.dart';
import '../models/add_user_pojo.dart';
import '../models/vehicle_list.dart';
import '../services/userlist_api_service.dart';
import '../services/addnewtransaction_api_service.dart';
import '../services/addnewdriver_api_service.dart';
import '../services/drivercheck.dart';
import '../services/updatetransaction_api_service.dart';
import '../services/vehicle_api_service.dart';
import '../services/vehiclecheck.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';
import 'home_page.dart';
import 'mo_home_page.dart';
import 'package:pdfx/pdfx.dart';
import 'package:mime/mime.dart';

class POInsertForm extends StatefulWidget {
  final String? orderid;
  final int? uid;
  final int? uprofileid;
  final int? locationid;
  final int? poid;
  final String? vid;
  final int? netweight;
  final int? netweight1;
  final String? netweight2;
  final String? challan1;
  final String? challan2;
  final String? vno;
  final String? drivernamemobilenum;
  final String? sitename;
  final String? vendoremail;
  final dynamic poidpodetail;
  final int? uidvendor;
  final String? itemname;
  final String? role;
  final String? uname;
  final String? availableQty;
  const POInsertForm({
    super.key,
    this.orderid,
    this.uid,
    this.poid,
    this.vid,
    this.netweight,
    this.netweight1,
    this.netweight2,
    this.challan1,
    this.challan2,
    this.vno,
    this.drivernamemobilenum,
    this.sitename,
    this.vendoremail,
    this.poidpodetail,
    this.uidvendor,
    this.itemname,
    this.role,
    this.locationid,
    this.uname,
    this.uprofileid,
    this.availableQty,
  });

  @override
  State<POInsertForm> createState() => _POInsertFormState();
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
class _POInsertFormState extends State<POInsertForm> with WidgetsBindingObserver, RouteAware {
  final _formKey = GlobalKey<FormState>();
  bool _showAdditionalDetails = false;
  bool _isWithInvoice = false;

 // bool _isWithInvoice1 = false;
  String? _fileName;
  String? _fileName1;
  bool optionalFormflag = false;
//  bool _vehicleListenerAdded = false;
  bool _isVehicleFieldInitialized = false;
  bool _isSubmitting = false; // NEW: Flag to track submission state

  final TextEditingController _vehicleDetailsController = TextEditingController();
  final TextEditingController _challanNoController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController driverDetailsController = TextEditingController();
  final TextEditingController _additionalChallanNoController = TextEditingController();
  final TextEditingController _additionalWeightController = TextEditingController();
  final FocusNode _driverFocusNode = FocusNode();
  final GlobalKey _driverFieldKey = GlobalKey();
  final LayerLink _driverLayerLink = LayerLink();

  String? activeVehicleSiteName;
  bool vavailable = true;
  bool driverstate = false;
  String driverId = "0", mRNNO = "0", royaltipass = "0";
  String? encodedimage;
  String availableQty = "", ready = "";
  bool optionalFormFlag = false;
  int withinvoiceone = 0, withinvoicetwo = 0;
  String base64File1 = "";
  String base64File2 = "";
  List<VehicleList> _vehicleSuggestions = [];
  List<UserList> _userSuggestions = [];
  final VehicleService _vehicleService = VehicleService();
  final UserService _userService = UserService();
  String? selectedUserId;
  String? selectedvehId;
  String? selectedVehicleNumber;
  String? selectedchallanNo;
  List<UserList> _filteredSuggestions = [];
  bool clickhere = false;
  bool _isPlusButtonVisible = false;

  String _vehicleText = '';
  String _driverText = '';
  String _challanNoText = '';
  String _weightText = '';
  String _additionalChallanNoText = '';
  String _additionalWeightText = '';

  static const List<String> itemNamesArray = [
    "GGBS",
    "FLYASH",
    "CEMOPC",
    "CEMOPCFREE",
    "CEMPPC",
    "ALCOFINE",
    "CEM1",
    "CEM2",
    "CEM3",
    "FLYASHFREE",
    "GGBSFREE",
    "ULTFNE",
    "CEMSRC",
    "CEMPSC",
    "CEMPSCFREE",
    "ULTPOZ100",
    "MSILICAFRE",
    "MICROFINE",
    "CEMPPCFREE",
  ];

  final List<String> restrictedItems = [
    "ADMAEA",
    "ADMBA",
    "ADMCORR",
    "ADMCORRFRE",
    "ADMCRST",
    "ADMHPCEA",
    "ADMHPCEA1",
    "ADMHPCEAFR",
    "ADMHRWRA",
    "ADMHRWRAFR",
    "ADMLPCEA",
    "ADMLPCEAFR",
    "ADMMPCEA",
    "ADMMPCEAFR",
    "ADMNONSHR",
    "ADMPCEA",
    "ADMRA",
    "ADMRAFREE",
    "ADMSFWRA",
    "ADMVMA",
    "ADMWPA",
    "ADMWPAFREE",
    "ICE",
    "WATER",
    "WATERFREE",
    "ULTFNE",
    "ULTPOZ100",
    "MSILICA",
    "MSILICAFRE",
    "PCPP1",
    "PCPPM",
    "ALCOFINE",
    "ALCOFREE"
  ];

  final List<String> restrictedItems1 = [
    "BOMIC",
    "CA10MM",
    "CA10MMFREE",
    "CA10MMS",
    "CA12MM",
    "CA12MMFREE",
    "CA20MM",
    "CA20MMFREE",
    "CA20MMS",
    "CA25MMFREE",
    "CA40MM",
    "CEM1",
    "CEM5",
    "CEMOPC",
    "CEMOPCFREE",
    "CEMPPC",
    "CEMPPCFREE",
    "CEMPSC",
    "CEMPSCFREE",
    "CEMSRC",
    "EPSTB",
    "FACSSAND",
    "FACSSFREE",
    "FAGBS",
    "FAGBSFREE",
    "FAMSAND",
    "FAMSFREE",
    "FARSAND",
    "FARSFREE",
    "FASLAG",
    "FAWSAND",
    "FAWSFREE",
    "FIBREPE",
    "FIBREPP",
    "FIBRESS",
    "FIBRESSFRE",
    "FLYASH",
    "FLYASHFREE",
    "GGBS",
    "GGBSFREE",
    "MICROFINE",
    "SAND1",
    "SAND2",
    "SAND3",
    "SLAG"
  ];

  // Future<bool> _isValidPdf(PlatformFile platformFile) async {
  //   try {
  //     // 1. Basic MIME type check
  //     String? mimeType;
  //     if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
  //       mimeType = lookupMimeType(platformFile.name, headerBytes: platformFile.bytes);
  //     } else if (platformFile.path != null) {
  //       mimeType = lookupMimeType(platformFile.path!);
  //     }
  //     print("mimetype:,${mimeType}");
  //     if (mimeType != 'application/pdf') {
  //       return false;
  //     }
  //
  //     // 2. Get bytes safely
  //     Uint8List pdfBytes;
  //     if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
  //       pdfBytes = platformFile.bytes!; // No cast needed
  //     } else if (platformFile.path != null) {
  //       final file = File(platformFile.path!);
  //       if (!await file.exists()) return false;
  //       pdfBytes = await file.readAsBytes(); // Returns Uint8List directly
  //     } else {
  //       return false;
  //     }
  //     print("mimetype:,${pdfBytes}");
  //     // 3. Open with native renderer
  //     final PdfDocument document = await PdfDocument.openData(pdfBytes); // Direct pass – correct type
  //
  //     final int pageCount = document.pagesCount;
  //
  //     // Always close to free resources
  //     document.close();
  //
  //     // 4. Must have at least 1 page
  //     return pageCount > 0;
  //   } catch (e) {
  //     return false;
  //   }
  // }
  Future<bool> _isValidPdf(PlatformFile platformFile) async {
    PdfDocument? document;
    try {
      // 1. Check MIME type (same as Java)
      String? mimeType;
      if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
        mimeType = lookupMimeType(platformFile.name, headerBytes: platformFile.bytes);
      } else if (platformFile.path != null) {
        mimeType = lookupMimeType(platformFile.path!);
      }

      if (mimeType != 'application/pdf') {
        return false;
      }

      // 2. Get bytes
      Uint8List pdfBytes;
      if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
        pdfBytes = platformFile.bytes!;
      } else if (platformFile.path != null) {
        final file = File(platformFile.path!);
        if (!await file.exists()) return false;
        pdfBytes = await file.readAsBytes();
      } else {
        return false;
      }

      // 3. Open with native renderer (same as new PdfRenderer(pfd))
      document = await PdfDocument.openData(pdfBytes);

      // 4. Check page count (same as renderer.getPageCount())
      if (document.pagesCount <= 0) {
        return false;
      }

      return true;
    } catch (e) {
      // Any exception = fake / corrupted / encrypted / invalid PDF (same as Java catch)
      return false;
    } finally {
      // Close resources (same as Java finally block)
      document?.close();
    }
  }

//   Future<bool> _isValidPdf(PlatformFile platformFile) async {
//     PdfDocument? document;
//     try {
//       // 1. MIME type check
//       String? mimeType;
//       if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
//         mimeType = lookupMimeType(platformFile.name, headerBytes: platformFile.bytes);
//       } else if (platformFile.path != null) {
//         mimeType = lookupMimeType(platformFile.path!);
//       }
// print("not work");
//       if (mimeType != 'application/pdf') {
//         print("Rejected: Wrong MIME type $mimeType");
//         return false;
//       }
//
//       // 2. Get bytes
//       Uint8List pdfBytes;
//       if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
//         pdfBytes = platformFile.bytes!;
//       } else if (platformFile.path != null) {
//         final file = File(platformFile.path!);
//         if (!await file.exists()) return false;
//         pdfBytes = await file.readAsBytes();
//       } else {
//         return false;
//       }
//
//       // 3. Strict header check
//       if (pdfBytes.length < 8 || String.fromCharCodes(pdfBytes.sublist(0, 8)).trim() != '%PDF-1.') {
//         print("Rejected: Invalid PDF header");
//         return false;
//       }
//
//       // 4. Open document (equivalent to new PdfRenderer(pfd))
//       document = await PdfDocument.openData(pdfBytes);
//
//       // 5. Check page count
//       if (document.pagesCount <= 0) {
//         print("Rejected: No pages");
//         return false;
//       }
//
//       // 6. CRITICAL: Open the first page — this fails on many "bad" PDFs that openData accepts
//       final PdfPage page = await document.getPage(1);
//       await page.close(); // This line will throw if page is unrenderable
//
//       print("PDF passed strict validation: ${document.pagesCount} pages");
//       return true;
//     } catch (e) {
//       print("Rejected by PdfRenderer equivalent: $e");
//       return false;
//     } finally {
//       document?.close();
//     }
//   }
  bool _isValidFileSize(PlatformFile platformFile) {
    final int size = platformFile.size;
    if (size <= 0) return false; // Reject 0 KB
    if (size > 4 * 1024 * 1024) return false; // Reject >4MB
    return true;
  }
  Future<String> _convertFileToBase64(PlatformFile platformFile) async {
    Uint8List bytes;
    if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
      bytes = platformFile.bytes!;
    } else if (platformFile.path != null) {
      bytes = await File(platformFile.path!).readAsBytes();
    } else {
      throw Exception("Cannot read file");
    }
    return base64Encode(bytes);
  }
  // Future<bool> _isValidPdf(PlatformFile platformFile) async {
  //   try {
  //     if (platformFile.bytes == null || platformFile.bytes!.isEmpty) {
  //       return false;
  //     }
  //
  //     final PdfDocument document = await PdfDocument.openData(platformFile.bytes!);
  //
  //     final int pageCount = document.pagesCount;  // Same as pdfx
  //
  //     document.close();  // Important!
  //
  //     return pageCount > 0;
  //   } catch (e) {
  //     return false;
  //   }
  // }
  // bool _isValidFileSize(PlatformFile platformFile) {
  //   final size = platformFile.size;
  //   if (size <= 0) return false;
  //   if (size > 4 * 1024 * 1024) return false; // 4MB limit
  //   return true;
  // }
  //
  // Future<String> _convertFileToBase64(PlatformFile platformFile) async {
  //   List<int> bytesList;
  //
  //   if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
  //     bytesList = platformFile.bytes!;
  //   } else if (platformFile.path != null) {
  //     bytesList = await File(platformFile.path!).readAsBytes();
  //   } else {
  //     throw Exception("No file data available for Base64");
  //   }
  //
  //   return base64Encode(bytesList);
  // }
  bool isItemNameInArray() {
    return itemNamesArray.contains(widget.itemname);
  }

  void _filterSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
      });
      return;
    }

    setState(() {
      _filteredSuggestions = _userSuggestions
          .where((user) => user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SessionManager.scheduleMidnightLogout(context);
    fetchVehicles();
    fetchUsers();
    _isPlusButtonVisible = isItemNameInArray();
    _initializeFormData();
    _setupControllerListeners();

    _driverFocusNode.addListener(() {
      if (!_driverFocusNode.hasFocus && mounted) {
        setState(() {
          _filteredSuggestions = [];
          driverDetailsController.text = driverDetailsController.text;
        });
      }
    });
  }

  void _initializeFormData() {
    if (widget.orderid != null) {
      if (widget.drivernamemobilenum != null && driverDetailsController.text.isEmpty) {
        driverDetailsController.text = widget.drivernamemobilenum.toString();
        selectedUserId = driverDetailsController.text;
      }
      if (widget.vno != null && !_isVehicleFieldInitialized) {
        _isVehicleFieldInitialized = true;
        selectedvehId = widget.vno;
      }
      if (widget.challan1 != null && _challanNoController.text.isEmpty) _challanNoController.text = widget.challan1.toString();
      if (widget.netweight1 != null && _weightController.text.isEmpty) _weightController.text = widget.netweight1.toString();
      if (widget.challan2 != null && _additionalChallanNoController.text.isEmpty) _additionalChallanNoController.text = widget.challan2.toString();
      if (widget.netweight2 != null && _additionalWeightController.text.isEmpty) _additionalWeightController.text = widget.netweight2.toString();
      _restoreFormData();
    }
  }

  void _restoreFormData() {
    driverDetailsController.text = _driverText;
    _challanNoController.text = _challanNoText;
    _weightController.text = _weightText;
    _additionalChallanNoController.text = _additionalChallanNoText;
    _additionalWeightController.text = _additionalWeightText;
    if (_fileName != null) {
      setState(() {});
    }
    if (_fileName1 != null) {
      setState(() {});
    }
  }

  void _setupControllerListeners() {
    driverDetailsController.addListener(() => _driverText = driverDetailsController.text);
    _challanNoController.addListener(() => _challanNoText = _challanNoController.text);
    _weightController.addListener(() => _weightText = _weightController.text);
    _additionalChallanNoController.addListener(() => _additionalChallanNoText = _additionalChallanNoController.text);
    _additionalWeightController.addListener(() => _additionalWeightText = _additionalWeightController.text);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _driverFocusNode.dispose();
    _vehicleDetailsController.dispose();
    _challanNoController.dispose();
    _weightController.dispose();
    driverDetailsController.dispose();
    _additionalChallanNoController.dispose();
    _additionalWeightController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    if (mounted) {
      _initializeFormData();
      setState(() {
        FocusManager.instance.primaryFocus?.unfocus();
        //print("didPopNext triggered, rebuilding UI at ${DateTime.now()}");
      });
    }
    super.didPopNext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //print("App resumed, refreshing UI at ${DateTime.now()}");
      if (mounted) {
        _restoreFormData();
        setState(() {});
      }
    }
  }

  Future<void> fetchDriverStatus(String selectedUserId) async {
    try {
      DriverServicecheck driverService = DriverServicecheck();
      SetStatus status = await driverService.checkDriverStatus(selectedUserId);

      if (status.status == "1") {
        driverstate = true;
      } else {
        driverstate = false;
        _showErrorDialog(status.message);
      }
    } catch (e) {
      //print("Error fetching driver status: $e");
    }
  }

  Future<void> btn() async {
    if (_isSubmitting) return; // Prevent multiple submissions
    setState(() {
      _isSubmitting = true; // Set loading state
    });
    if (selectedvehId == widget.vno && selectedUserId != null) {
      vavailable = true;
      ready = "yes";
      driverstate = true;
      try {
        validateForm(context);
      } catch (e) {
        setState(() {
          _isSubmitting = false; // Reset loading state on error
        });
      }
    } else {
      await checkVehicle(selectedvehId);
    }
  }

  Future<void> checkVehicle(String? selectedvehId) async {
    try {
      if (selectedvehId == null) {
        setState(() {
          _isSubmitting = false; // Reset loading state
        });
        return;
      }
      Vehiclecheck driverService = Vehiclecheck();
      SetStatus status = await driverService.checkvehicleStatus(selectedvehId);
      if (!mounted) {
        setState(() {
          _isSubmitting = false; // Reset loading state
        });
        return;
      }
      if (status.status == "1") {
        vavailable = false;
        ready = "no";
        activeVehicleSiteName = status.sitename ?? "";
        _showtextDialog(status.message);
        setState(() {
          _isSubmitting = false; // Reset loading state on error
        });
      } else {
        vavailable = true;
        ready = "yes";
        validateForm(context);
      }

      if (widget.orderid != null) {
        driverstate = true;
        validateForm(context);
      } else {
      //  await fetchDriverStatus(selectedUserId ?? "");
      }
    } catch (e) {
      //print("Error checking vehicle: $e");
      setState(() {
        _isSubmitting = false; // Reset loading state on error
      });
    }
  }

  Future<void> callAddNewDriverService(String uname, String mob) async {
    DriverService driverService = DriverService();
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');

    if (sitename == null) return;
    String email = "no any";
    try {
      SetStatus status = await driverService.addNewDriver(uname, mob, email, sitename);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Driver added successfully"), backgroundColor: Colors.green),
      );
      await fetchUsers();
      if (status.status == "2") {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showDriverStatusDialog(status.message));
      }
    } catch (e) {
      //print("Error adding driver: $e");
    }
  }

  void showDriverAddedSnackBar(BuildContext context, String status) {
    if (status == "1") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Driver added successfully"), backgroundColor: Colors.green),
      );
    }
  }

  void _showDriverStatusDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Driver Information"),
        content: Text("$message\nWarning: Please try again."),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK")),
        ],
      ),
    );
  }

  Future<void> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');
    if (sitename == null) return;
    String role = "DRIVER";
    try {
      List<UserList> users = await _userService.fetchUsers(role, sitename);
      setState(() {
        _userSuggestions = users;
        _filteredSuggestions = [];
      });
    } catch (e) {
      //print("Error fetching users: $e");
    }
  }

  Future<void> fetchVehicles() async {
    String id = widget.uid.toString();
    try {
      List<VehicleList> response = await _vehicleService.fetchVehicles(id);
      setState(() {
        _vehicleSuggestions = response;
      });
    } catch (e) {
      //print("Error fetching vehicles: $e");
    }
  }
  Future<void> _submitTransaction(
      String vehiclenumberup,
      String challannumber,
      String netweight,
      String ponumberid,
      String challanone,
      String netone,
      ) async {
    setState(() {
      _isSubmitting = true;
    });

    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    String myDate = format.format(DateTime.now());
    String moisper = "0.00", acceptby = "1", condi = "0", weight = "0";

    InsertTransaction transaction = InsertTransaction(
      createdAt: myDate,
      driverId: selectedUserId,
      vendorId: widget.vid,
      poId: widget.poidpodetail.toString(),
      gross: weight,
      tare: weight,
      net: netweight,
      mrnNo: mRNNO,
      chalanNo: challannumber,
      royaltiPass: royaltipass,
      vehicleNumber: selectedvehId,
      moisturePer: moisper,
      acceptBy: acceptby,
      receipt: encodedimage,
      vehicleCondition: condi,
      moistureCheck: condi,
      vEmail: widget.vendoremail,
      chalanNoOne: challanone,
      netWeightOne: netone,
      withinVoice: withinvoiceone.toString(),
      withinVoice1: withinvoicetwo.toString(),
      invoiceNumberOne: base64File1,           // Optional: file name
      invoiceNumberTwo: base64File2,
      // invoiceNumberOne: _fileName,           // Optional: file name
      // invoiceNumberTwo: _fileName1,          // Optional: file name
      // invoiceBase64One: base64File1,         // ← Full Base64 of first PDF
      // invoiceBase64Two: base64File2,         // ← Full Base64 of second PDF
    );
    print("TOAST VALUES → withinVoice: $withinvoiceone, withinVoice1: $withinvoicetwo");
    print("Transaction Payload: ${transaction.toJson()}");

    String? orderid = widget.orderid;

    if (widget.orderid == null) {
      // New Transaction
      AddnewtransactionApiService driverService = AddnewtransactionApiService();
      try {
        SetStatus status = await driverService.addNewTransaction(transaction);
        setState(() {
          _isSubmitting = false;
        });

        if (status.status == "1") {
          if (!mounted) return;
          if (widget.role == "VENDOR") {
            showSuccessDialog(context, "Transaction created successfully", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VendorHomePage(uid: int.tryParse(widget.uid.toString())!),
                ),
              );
            });
          } else if (widget.role == "ADMIN") {
            showSuccessDialog(context, "Transaction created successfully", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    role: widget.role.toString(),
                    sitename: widget.sitename,
                    locationid: widget.locationid,
                    uname: widget.uname,
                    uprofileid: widget.uprofileid,
                  ),
                ),
              );
            });
          } else if (widget.role == "MATERIALOFFICER") {
            showSuccessDialog(context, "Transaction created successfully", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MOHomePage(
                    role: widget.role.toString(),
                    sitename: widget.sitename.toString(),
                    locationid: widget.locationid!.toInt(),
                    uname: widget.uname,
                    uprofileid: widget.uprofileid,
                  ),
                ),
              );
            });
          }
        } else {
          _showErrorDialog(status.message);
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
      }
    } else {
      // Update Transaction
      final BuildContext dialogContext = context;
      if (!mounted) return;

      showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final SetStatus? status = await UpdatetransactionApiService.updateTransaction(
          orderid: orderid ?? '',
          selectedvehId: selectedvehId ?? '',
          selectedUserId: selectedUserId ?? '',
          challannumber: challannumber,
          netweight: netweight,
          challanone: challanone,
          netone: netone,
        );

        if (!dialogContext.mounted) return;

        Navigator.of(dialogContext).pop();
        setState(() => _isSubmitting = false);

        if (status?.status == "1") {
          final String? role = widget.role;
          if (role == "VENDOR") {
            showSuccessDialog(dialogContext, "Transaction updated successfully", () {
              if (!dialogContext.mounted) return;
              Navigator.push(
                dialogContext,
                MaterialPageRoute(
                  builder: (_) => VendorHomePage(uid: int.tryParse(widget.uid.toString())!),
                ),
              );
            });
          } else if (role == "ADMIN") {
            showSuccessDialog(dialogContext, "Transaction updated successfully", () {
              if (!dialogContext.mounted) return;
              Navigator.pushReplacement(
                dialogContext,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    role: role,
                    sitename: widget.sitename,
                    locationid: widget.locationid,
                    uname: widget.uname,
                    uprofileid: widget.uprofileid,
                  ),
                ),
              );
            });
          } else if (role == "MATERIALOFFICER") {
            showSuccessDialog(dialogContext, "Transaction updated successfully", () {
              if (!dialogContext.mounted) return;
              Navigator.pushReplacement(
                dialogContext,
                MaterialPageRoute(
                  builder: (_) => MOHomePage(
                    role: role,
                    sitename: widget.sitename.toString(),
                    locationid: widget.locationid!.toInt(),
                    uname: widget.uname,
                    uprofileid: widget.uprofileid,
                  ),
                ),
              );
            });
          }
        } else {
          _showErrorDialog(status?.message ?? "Unknown error occurred");
        }
      } catch (e) {
        if (dialogContext.mounted) {
          Navigator.of(dialogContext).pop();
        }
        setState(() => _isSubmitting = false);
        _showErrorDialog("An error occurred: ${e.toString()}");
      }
    }
  }
  //
  // Future<void> _submitTransaction(
  //     String vehiclenumberup,
  //     String challannumber,
  //     String netweight,
  //     String ponumberid,
  //     String challanone,
  //     String netone,
  //     ) async
  // {
  //   DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   String myDate = format.format(DateTime.now());
  //   String moisper = "0.00", acceptby = "1", condi = "0", weight = "0";
  //   InsertTransaction transaction = InsertTransaction(
  //     createdAt: myDate,
  //     driverId: selectedUserId,
  //     vendorId: widget.vid,
  //     poId: widget.poidpodetail.toString(),
  //     gross: weight,
  //     tare: weight,
  //     net: netweight,
  //     mrnNo: mRNNO,
  //     chalanNo: challannumber,
  //     royaltiPass: royaltipass,
  //     vehicleNumber: selectedvehId,
  //     moisturePer: moisper,
  //     acceptBy: acceptby,
  //     receipt: encodedimage,
  //     vehicleCondition: condi,
  //     moistureCheck: condi,
  //     vEmail: widget.vendoremail,
  //     chalanNoOne: challanone,
  //     netWeightOne: netone,
  //     withinVoice: withinvoiceone.toString(),
  //     withinVoice1: withinvoicetwo.toString(),
  //     invoiceNumberOne: _fileName,
  //     invoiceNumberTwo: _fileName1,
  //   );
  //   print("Transaction Payload: ${transaction.toJson()}");
  //
  //   String? orderid = widget.orderid;
  //   if (widget.orderid == null) {
  //     AddnewtransactionApiService driverService = AddnewtransactionApiService();
  //     try {
  //       SetStatus status = await driverService.addNewTransaction(transaction);
  //       setState(() {
  //         _isSubmitting = false; // Reset loading state
  //       });
  //       if (status.status == "1") {
  //         if (!mounted) return;
  //         if (widget.role == "VENDOR") {
  //           showSuccessDialog(context, "Transaction created successfully", () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => VendorHomePage(uid: int.tryParse(widget.uid.toString())!)),
  //             );
  //           });
  //         } else if (widget.role == "ADMIN") {
  //           showSuccessDialog(context, "Transaction created successfully", () {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => HomePage(
  //                   role: widget.role.toString(),
  //                   sitename: widget.sitename,
  //                   locationid: widget.locationid,
  //                   uname: widget.uname,
  //                   uprofileid: widget.uprofileid,
  //                 ),
  //               ),
  //             );
  //           });
  //         } else if (widget.role == "MATERIALOFFICER") {
  //           showSuccessDialog(context, "Transaction created successfully", () {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => MOHomePage(
  //                   role: widget.role.toString(),
  //                   sitename: widget.sitename.toString(),
  //                   locationid: widget.locationid!.toInt(),
  //                   uname: widget.uname,
  //                   uprofileid: widget.uprofileid,
  //                 ),
  //               ),
  //             );
  //           });
  //         }
  //       } else {
  //         _showErrorDialog(status.message);
  //       }
  //     } catch (e) {
  //       //print("Error submitting transaction: $e");
  //       setState(() {
  //         _isSubmitting = false; // Reset loading state on error
  //       });
  //     }
  //   }
  //   else {
  //     // --------------------------------------------------------------
  //     // 1. CAPTURE context BEFORE any async work
  //     // --------------------------------------------------------------
  //     final BuildContext dialogContext = context;
  //
  //     // Early exit if widget is already disposed
  //     if (!mounted) return;
  //
  //     // --------------------------------------------------------------
  //     // 2. Show loading dialog
  //     // --------------------------------------------------------------
  //     showDialog(
  //       context: dialogContext,
  //       barrierDismissible: false,
  //       builder: (_) => const Center(child: CircularProgressIndicator()),
  //     );
  //
  //     try {
  //       // --------------------------------------------------------------
  //       // 3. API call – first await
  //       // --------------------------------------------------------------
  //       final SetStatus? status = await UpdatetransactionApiService.updateTransaction(
  //         orderid: orderid ?? '',
  //         selectedvehId: selectedvehId ?? '',
  //         selectedUserId: selectedUserId ?? '',
  //         challannumber: challannumber,
  //         netweight: netweight,
  //         challanone: challanone,
  //         netone: netone,
  //       );
  //
  //       // Check if still mounted after await
  //       if (!dialogContext.mounted) return;
  //
  //       // --------------------------------------------------------------
  //       // 4. Dismiss loading dialog
  //       // --------------------------------------------------------------
  //       Navigator.of(dialogContext).pop();
  //
  //       // Reset loading state
  //       setState(() => _isSubmitting = false);
  //
  //       // --------------------------------------------------------------
  //       // 5. Handle success
  //       // --------------------------------------------------------------
  //       if (status?.status == "1") {
  //         if (!dialogContext.mounted) return;
  //
  //         final String? role = widget.role;
  //
  //         if (role == "VENDOR") {
  //           showSuccessDialog(
  //             dialogContext,
  //             "Transaction updated successfully",
  //                 () {
  //               if (!dialogContext.mounted) return;
  //               Navigator.push(
  //                 dialogContext,
  //                 MaterialPageRoute(
  //                   builder: (_) => VendorHomePage(
  //                     uid: int.tryParse(widget.uid.toString())!,
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         } else if (role == "ADMIN") {
  //           showSuccessDialog(
  //             dialogContext,
  //             "Transaction updated successfully",
  //                 () {
  //               if (!dialogContext.mounted) return;
  //               Navigator.pushReplacement(
  //                 dialogContext,
  //                 MaterialPageRoute(
  //                   builder: (_) => HomePage(
  //                     role: role,
  //                     sitename: widget.sitename,
  //                     locationid: widget.locationid,
  //                     uname: widget.uname,
  //                     uprofileid: widget.uprofileid,
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         } else if (role == "MATERIALOFFICER") {
  //           showSuccessDialog(
  //             dialogContext,
  //             "Transaction updated successfully",
  //                 () {
  //               if (!dialogContext.mounted) return;
  //               Navigator.pushReplacement(
  //                 dialogContext,
  //                 MaterialPageRoute(
  //                   builder: (_) => MOHomePage(
  //                     role: role,
  //                     sitename: widget.sitename.toString(),
  //                     locationid: widget.locationid!.toInt(),
  //                     uname: widget.uname,
  //                     uprofileid: widget.uprofileid,
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         }
  //       } else {
  //         // --------------------------------------------------------------
  //         // 6. Handle API failure
  //         // --------------------------------------------------------------
  //         _showErrorDialog(status?.message ?? "Unknown error occurred");
  //       }
  //     } catch (e) {
  //       // --------------------------------------------------------------
  //       // 7. Handle exception
  //       // --------------------------------------------------------------
  //       if (dialogContext.mounted) {
  //         Navigator.of(dialogContext).pop(); // Dismiss loading
  //       }
  //       setState(() => _isSubmitting = false);
  //       _showErrorDialog("An error occurred: ${e.toString()}");
  //     }
  //   }
  //   // else {
  //   //   showDialog(
  //   //     context: context,
  //   //     barrierDismissible: false,
  //   //     builder: (_) => const Center(child: CircularProgressIndicator()),
  //   //   );
  //   //   try {
  //   //     SetStatus? status = await UpdatetransactionApiService.updateTransaction(
  //   //       orderid: orderid ?? '',
  //   //       selectedvehId: selectedvehId ?? '',
  //   //       selectedUserId: selectedUserId ?? '',
  //   //       challannumber: challannumber,
  //   //       netweight: netweight,
  //   //       challanone: challanone,
  //   //       netone: netone,
  //   //     );
  //   //     Navigator.of(context).pop(); // Dismiss loading dialog
  //   //     setState(() {
  //   //       _isSubmitting = false; // Reset loading state
  //   //     });
  //   //     if (status?.status == "1") {
  //   //       if (!mounted) return;
  //   //       if (widget.role == "VENDOR") {
  //   //         showSuccessDialog(context, "Transaction updated successfully", () {
  //   //           Navigator.push(
  //   //             context,
  //   //             MaterialPageRoute(builder: (context) => VendorHomePage(uid: int.tryParse(widget.uid.toString())!)),
  //   //           );
  //   //         });
  //   //       } else if (widget.role == "ADMIN") {
  //   //         showSuccessDialog(context, "Transaction updated successfully", () {
  //   //           Navigator.pushReplacement(
  //   //             context,
  //   //             MaterialPageRoute(
  //   //               builder: (context) => HomePage(
  //   //                 role: widget.role.toString(),
  //   //                 sitename: widget.sitename,
  //   //                 locationid: widget.locationid,
  //   //                 uname: widget.uname,
  //   //                 uprofileid: widget.uprofileid,
  //   //               ),
  //   //             ),
  //   //           );
  //   //         });
  //   //       } else if (widget.role == "MATERIALOFFICER") {
  //   //         showSuccessDialog(context, "Transaction updated successfully", () {
  //   //           Navigator.pushReplacement(
  //   //             context,
  //   //             MaterialPageRoute(
  //   //               builder: (context) => MOHomePage(
  //   //                 role: widget.role.toString(),
  //   //                 sitename: widget.sitename.toString(),
  //   //                 locationid: widget.locationid!.toInt(),
  //   //                 uname: widget.uname,
  //   //                 uprofileid: widget.uprofileid,
  //   //               ),
  //   //             ),
  //   //           );
  //   //         });
  //   //       }
  //   //     } else {
  //   //       _showErrorDialog(status?.message ?? "Unknown error occurred");
  //   //     }
  //   //   } catch (e) {
  //   //     Navigator.of(context).pop(); // Dismiss loading dialog on error
  //   //     setState(() {
  //   //       _isSubmitting = false; // Reset loading state on error
  //   //     });
  //   //     _showErrorDialog("An error occurred: ${e.toString()}");
  //   //   }
  //   // }
  // }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(""),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))],
      ),
    );
  }
  void _showtextDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(""),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))],
      ),
    );
  }
  // Future<void> openFileChooser() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //     );
  //     if (result != null && mounted) {
  //       setState(() {
  //         _fileName = result.files.single.name;
  //         //print("Selected file 1: $_fileName");
  //       });
  //     } else {
  //     //  print("No file selected or picker cancelled");
  //     }
  //   } catch (e) {
  //     //print("Error in file picker 1: $e");
  //   }
  // }
  //
  // Future<void> openFileChooser1() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //     );
  //     if (result != null && mounted) {
  //       setState(() {
  //         _fileName1 = result.files.single.name;
  //         //print("Selected file 2: $_fileName1");
  //       });
  //     } else {
  //      // print("No file selected or picker cancelled");
  //     }
  //   } catch (e) {
  //    // print("Error in file picker 2: $e");
  //   }
  // }
  Future<void> openFileChooser() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final PlatformFile file = result.files.single;

      // Reject oversized or empty files (same as Java)
      if (!_isValidFileSize(file)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ File is empty (0 KB) or exceeds 4MB limit."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Reject invalid PDFs (same as Java)
      if (!await _isValidPdf(file)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Invalid or corrupted PDF file."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Valid → convert to Base64
      final String base64String = await _convertFileToBase64(file);

      setState(() {
        _fileName = file.name;
        if (withinvoiceone != 0) {
          base64File1 = base64String;
        }
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("PDF validated and selected successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error reading file: $e"), backgroundColor: Colors.red),
      );
    }
  }
//   Future<void> openFileChooser() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         withData: true, // Try to load bytes in memory
//       );
//       if (result != null) {
//         final file = result.files.single;
//
//         // Size validation
//         if (!_isValidFileSize(file)) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("❌ File is empty (0 KB) or exceeds 4MB limit."),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//           return;
//         }
// print("hiiiiiiiiiiiiiiiiiiii");
//         // Real PDF validation (tries to open it)
//         if (!await _isValidPdf(file)) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("❌ Invalid or corrupted PDF file."),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//           return;
//         }
//         print("hiiiiiiiiiiiiiiiiiiii00000");
//         // Valid → proceed
//         final base64String = await _convertFileToBase64(file);
//
//         debugPrint("=== FULL BASE64 START === (${file.name})");
//         debugPrint("Base64 length: ${base64String.length}");
//
//         const int chunkSize = 3000;
//         for (int i = 0; i < base64String.length; i += chunkSize) {
//           int end = (i + chunkSize > base64String.length)
//               ? base64String.length
//               : i + chunkSize;
//           debugPrint(base64String.substring(i, end));
//         }
//
//         debugPrint("=== FULL BASE64 END ===");
//         print("Base64 of first PDF (${file.name}): $base64String");
//         setState(() {
//           _fileName = file.name;
//           if (withinvoiceone != 0) {
//             base64File1 = base64String;
//           }
//         });
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("PDF selected and validated successfully!"),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }
//
  Future<void> openFileChooser1() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // Helps load bytes on some platforms
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final PlatformFile file = result.files.single;

      // 1. Size validation: reject 0 KB or >4MB
      if (!_isValidFileSize(file)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("❌ File is empty (0 KB) or exceeds 4MB limit."),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // 2. Real PDF validation using native renderer (exact equivalent of Android PdfRenderer)
      if (!await _isValidPdf(file)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("❌ Invalid or corrupted PDF file."),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // 3. All checks passed → convert to Base64
      final String base64String = await _convertFileToBase64(file);

      // Optional: Print full Base64 in chunks for debugging
      debugPrint("=== FULL BASE64 START (Second PDF: ${file.name}) ===");
      debugPrint("Base64 length: ${base64String.length} characters");

      const int chunkSize = 3000;
      for (int i = 0; i < base64String.length; i += chunkSize) {
        int end = (i + chunkSize > base64String.length)
            ? base64String.length
            : i + chunkSize;
        debugPrint(base64String.substring(i, end));
      }
      debugPrint("=== FULL BASE64 END ===");

      // Store the Base64 and file name
      setState(() {
        _fileName1 = file.name;
        if (withinvoicetwo != 0) {
          base64File2 = base64String;
        }
      });

      // Success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Second PDF validated and selected successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error selecting file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
//   Future<void> openFileChooser1() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         withData: true, // Try to load bytes in memory
//       );
//
//       if (result != null) {
//         final PlatformFile file = result.files.single;
//
//         // 1. Size validation: reject 0 KB or >4MB
//         if (!_isValidFileSize(file)) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("❌ File is empty (0 KB) or exceeds 4MB limit."),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//           return;
//         }
//
//         // 2. Real PDF validation (tries to open with native renderer)
//         if (!await _isValidPdf(file)) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("❌ Invalid or corrupted PDF file."),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//           return;
//         }
//
//         // 3. All checks passed → convert to Base64 and store
//         final String base64String = await _convertFileToBase64(file);
//         debugPrint("=== FULL BASE64 START === (${file.name})");
//         debugPrint("Base64 length: ${base64String.length}");
//
//         const int chunkSize = 3000;
//         for (int i = 0; i < base64String.length; i += chunkSize) {
//           int end = (i + chunkSize > base64String.length)
//               ? base64String.length
//               : i + chunkSize;
//           debugPrint(base64String.substring(i, end));
//         }
//
//         debugPrint("=== FULL BASE64 END ===");
//         print("Base64 of first PDF (${file.name}): $base64String");
//         setState(() {
//           _fileName1 = file.name;                    // Display file name
//           if (withinvoicetwo != 0) {                 // Your existing flag
//             base64File2 = base64String;
//           }
//         });
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Second PDF validated and selected successfully!"),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error selecting file: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// Same for openFileChooser1(), just change _fileName1 and base64File2 / withinvoicetwo
  void validateForm(BuildContext context) {
    double availableQty = double.tryParse(widget.availableQty.toString()) ?? 0.0;
    if (restrictedItems.contains(widget.itemname) && availableQty < 2000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Available Quantity is less than 2 MT, please contact MO."), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (restrictedItems1.contains(widget.itemname) && availableQty < 20000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Available Quantity is less than 20 MT, please contact MO."), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (selectedvehId == null || selectedvehId!.length < 8 || vavailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid Vehicle Number."), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (selectedUserId == null || selectedUserId == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a Driver."), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    String challanNo = _challanNoController.text;
    if (challanNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Enter Challan No."), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    String netweight = _weightController.text;
    if (netweight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Enter Valid Weight Data."), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (widget.orderid != null) {
      if (double.tryParse(netweight) != null && double.tryParse(netweight)! > double.parse(widget.netweight1.toString())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("More than available Qty!"), backgroundColor: Colors.red),
        );
        setState(() {
          _isSubmitting = false; // Reset loading state
        });
        return;
      }
    }
    if (widget.orderid == null) {
      if (ready == "no" || ready.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("vehicle is still Active ! in $activeVehicleSiteName"), backgroundColor: Colors.red),
        );
        setState(() {
          _isSubmitting = false; // Reset loading state
        });
        return;
      }
    }
    String sechallanone = _additionalChallanNoController.text;
    if (_isPlusButtonVisible && clickhere && sechallanone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Enter Additional Challan No!"), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    String netone = _additionalWeightController.text;
    if (_isPlusButtonVisible && clickhere && netone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Enter Additional Net!"), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (widget.orderid != null) {
      if (double.tryParse(netone) != null && double.tryParse(netone)! > double.parse(widget.netweight2.toString())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("More than available Qty!"), backgroundColor: Colors.red),
        );
        setState(() {
          _isSubmitting = false; // Reset loading state
        });
        return;
      }
    }
    if (sechallanone == challanNo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Challan No could not be the same!"), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (withinvoiceone != 0 && _fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload Invoice File!"), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (clickhere && (netone.isEmpty || netweight.isEmpty || int.tryParse(netone) == null || int.tryParse(netweight) == null ||
        int.parse(netone) < 1 || int.parse(netweight) < 1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("In case of double Net Weight Required!"), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (withinvoicetwo != 0 && _fileName1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invoice File Required in Second Challan!"), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
    if (optionalFormflag && (_fileName == null || _fileName1 == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invoice Required in Double Challan case!"), backgroundColor: Colors.red),
      );
      setState(() {
        _isSubmitting = false; // Reset loading state
      });
      return;
    }
     _submitTransaction(selectedVehicleNumber.toString(), challanNo, netweight, widget.poid.toString(), sechallanone, netone);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        Navigator.of(context).pop(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.po_Insert_Form,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        resizeToAvoidBottomInset: false,
        body: RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              if (_driverFocusNode.hasFocus && mounted) {
                _driverFocusNode.unfocus();
                setState(() {
                  _filteredSuggestions = [];
                });
              }
            },
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    image: DecorationImage(
                      image: AssetImage("assets/bg_image/RDC.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Color.fromRGBO(0, 0, 0, 0.3), BlendMode.dstATop),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  // Autocomplete<VehicleList>(
                                  //   optionsBuilder: (TextEditingValue textEditingValue) {
                                  //     if (textEditingValue.text.isEmpty) {
                                  //       return const Iterable<VehicleList>.empty();
                                  //     }
                                  //     return _vehicleSuggestions.where((vehicle) =>
                                  //         vehicle.vehiclenumber
                                  //             .toLowerCase()
                                  //             .contains(textEditingValue.text.toLowerCase()));
                                  //   },
                                  //   displayStringForOption: (VehicleList option) => option.vehiclenumber,
                                  //   onSelected: (VehicleList selection) {
                                  //     selectedVehicleNumber = selection.vehiclenumber;
                                  //     selectedvehId = selectedVehicleNumber;
                                  //     driverDetailsController.text =
                                  //     "${selection.drivername.toUpperCase()}(${selection.driverrid}) (${selection.drivermobile})";
                                  //     selectedUserId = selection.driverrid.toString();
                                  //     setState(() {
                                  //       _filteredSuggestions = [];
                                  //       _isVehicleFieldInitialized = true;
                                  //     });
                                  //   },
                                  //   fieldViewBuilder: (
                                  //       BuildContext context,
                                  //       TextEditingController textEditingController,
                                  //       FocusNode focusNode,
                                  //       VoidCallback onFieldSubmitted,
                                  //       ) {
                                  //     WidgetsBinding.instance.addPostFrameCallback((_) {
                                  //       if (textEditingController.text != _vehicleText) {
                                  //         textEditingController.text = _vehicleText;
                                  //         textEditingController.selection = TextSelection.fromPosition(
                                  //             TextPosition(offset: _vehicleText.length));
                                  //       }
                                  //     });
                                  //     textEditingController.addListener(() {
                                  //       _vehicleText = textEditingController.text;
                                  //       selectedvehId = _vehicleText;
                                  //     });
                                  //     return TextFormField(
                                  //       controller: textEditingController,
                                  //       focusNode: focusNode,
                                  //       decoration: InputDecoration(
                                  //         focusedBorder: OutlineInputBorder(
                                  //           borderSide: BorderSide(color: Colors.green),
                                  //           borderRadius: BorderRadius.circular(11),
                                  //         ),
                                  //         border: OutlineInputBorder(
                                  //           borderSide: const BorderSide(color: Colors.green),
                                  //           borderRadius: BorderRadius.circular(11),
                                  //         ),
                                  //         hintText: AppLocalizations.of(context)!.vehicle_Details,
                                  //         filled: true,
                                  //         fillColor: Colors.grey.shade100,
                                  //         labelText: AppLocalizations.of(context)!.vehicle_Details,
                                  //       ),
                                  //       onFieldSubmitted: (value) {
                                  //         selectedvehId = value;
                                  //       },
                                  //     );
                                  //   },
                                  //   optionsViewBuilder: (
                                  //       BuildContext context,
                                  //       AutocompleteOnSelected<VehicleList> onSelected,
                                  //       Iterable<VehicleList> options,
                                  //       ) {
                                  //     return Align(
                                  //       alignment: Alignment.topLeft,
                                  //       child: Material(
                                  //         elevation: 4.0,
                                  //         child: Container(
                                  //           height: 250,
                                  //           color: Colors.white,
                                  //           width: 300,
                                  //           child: ListView.builder(
                                  //             padding: const EdgeInsets.all(8.0),
                                  //             itemCount: options.length,
                                  //             shrinkWrap: true,
                                  //             itemBuilder: (BuildContext context, int index) {
                                  //               final VehicleList option = options.elementAt(index);
                                  //               return ListTile(
                                  //                 title: Text(option.vehiclenumber),
                                  //                 onTap: () {
                                  //                   onSelected(option);
                                  //                 },
                                  //               );
                                  //             },
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
                                  Autocomplete<VehicleList>(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      final query = textEditingValue.text.toLowerCase();
                                      if (query.isEmpty) {
                                        return const Iterable<VehicleList>.empty();
                                      }
                                      return _vehicleSuggestions.where((vehicle) =>
                                          vehicle.vehiclenumber.toLowerCase().contains(query));
                                    },
                                    displayStringForOption: (VehicleList option) => option.vehiclenumber,
                                    onSelected: (VehicleList selection) {
                                      final upperVehicle = selection.vehiclenumber.toUpperCase();
                                      selectedVehicleNumber = upperVehicle;
                                      selectedvehId = upperVehicle;

                                      driverDetailsController.text =
                                      "${selection.drivername.toUpperCase()}(${selection.driverrid}) (${selection.drivermobile})";
                                      selectedUserId = selection.driverrid.toString();

                                      setState(() {
                                        _filteredSuggestions = [];
                                        _isVehicleFieldInitialized = true;
                                        // We can't access textEditingController here → it will be updated via the listener below
                                        _vehicleText = upperVehicle; // This triggers the listener in fieldViewBuilder
                                      });
                                    },
                                    fieldViewBuilder: (
                                        BuildContext context,
                                        TextEditingController textEditingController, // ← This is the correct controller
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted,
                                        ) {
                                      // Force uppercase on every change
                                      textEditingController.addListener(() {
                                        final currentText = textEditingController.text;
                                        final upperText = currentText.toUpperCase();

                                        if (currentText != upperText) {
                                          textEditingController.value = TextEditingValue(
                                            text: upperText,
                                            selection: TextSelection.fromPosition(
                                              TextPosition(offset: upperText.length),
                                            ),
                                          );
                                        }
                                        _vehicleText = upperText;
                                        selectedvehId = upperText;
                                        selectedVehicleNumber = upperText;
                                      });

                                      // Pre-fill with uppercase if coming from edit mode
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (widget.vno != null && !_isVehicleFieldInitialized) {
                                          final upperVno = widget.vno!.toUpperCase();
                                          textEditingController.text = upperVno;
                                          textEditingController.selection = TextSelection.fromPosition(
                                            TextPosition(offset: upperVno.length),
                                          );
                                          selectedvehId = upperVno;
                                          selectedVehicleNumber = upperVno;
                                          _vehicleText = upperVno;
                                          _isVehicleFieldInitialized = true;
                                          setState(() {});
                                        }
                                      });

                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        inputFormatters: [UpperCaseTextFormatter()],
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green),
                                            borderRadius: BorderRadius.circular(11),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.green),
                                            borderRadius: BorderRadius.circular(11),
                                          ),
                                          hintText: AppLocalizations.of(context)!.vehicle_Details,
                                          filled: true,
                                          fillColor: Colors.grey.shade100,
                                          labelText: AppLocalizations.of(context)!.vehicle_Details,
                                        ),
                                        onFieldSubmitted: (value) {
                                          selectedvehId = value.toUpperCase();
                                          selectedVehicleNumber = value.toUpperCase();
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
                                            height: 250,
                                            color: Colors.white,
                                            width: 300,
                                            child: ListView.builder(
                                              padding: const EdgeInsets.all(8.0),
                                              itemCount: options.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                final VehicleList option = options.elementAt(index);
                                                return ListTile(
                                                  title: Text(option.vehiclenumber),
                                                  onTap: () => onSelected(option),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 7),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CompositedTransformTarget(
                                        link: _driverLayerLink,
                                        child: TextFormField(
                                          key: _driverFieldKey,
                                          controller: driverDetailsController,
                                          focusNode: _driverFocusNode,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.green),
                                              borderRadius: BorderRadius.circular(11),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Colors.green),
                                              borderRadius: BorderRadius.circular(11),
                                            ),
                                            hintText: AppLocalizations.of(context)!.driver_Details,
                                            filled: true,
                                            fillColor: Colors.grey.shade100,
                                            labelText: AppLocalizations.of(context)!.driver_Details,
                                          ),
                                          onTap: () {
                                            _showDriverDetailsDialog();
                                          },
                                          onChanged: _filterSuggestions,
                                        ),
                                      ),
                                      if (_filteredSuggestions.isNotEmpty)
                                        CompositedTransformFollower(
                                          link: _driverLayerLink,
                                          showWhenUnlinked: false,
                                          offset: Offset(0, 48),
                                          child: Material(
                                            elevation: 4,
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxHeight: 200,
                                                minWidth: MediaQuery.of(context).size.width - 40,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: ClampingScrollPhysics(),
                                                itemCount: _filteredSuggestions.length,
                                                itemBuilder: (context, index) {
                                                  final user = _filteredSuggestions[index];
                                                  return ListTile(
                                                    title: Text('${user.username} (${user.usermobile})'),
                                                    onTap: () {
                                                      driverDetailsController.text =
                                                      '${user.username} (${user.usermobile})';
                                                      selectedUserId = user.userid.toString();
                                                      setState(() {
                                                        _filteredSuggestions = [];
                                                      });
                                                      _driverFocusNode.unfocus();
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  // TextFormField(
                                  //   controller: _challanNoController,
                                  //   decoration: InputDecoration(
                                  //     focusedBorder: OutlineInputBorder(
                                  //       borderSide: BorderSide(color: primaryColor),
                                  //       borderRadius: BorderRadius.circular(11),
                                  //     ),
                                  //     border: OutlineInputBorder(
                                  //       borderSide: const BorderSide(color: Colors.green),
                                  //       borderRadius: BorderRadius.circular(11),
                                  //     ),
                                  //     hintText: _isWithInvoice || _showAdditionalDetails
                                  //         ? AppLocalizations.of(context)!.invoice_No
                                  //         : AppLocalizations.of(context)!.challan_No,
                                  //     filled: true,
                                  //     fillColor: Colors.grey.shade200,
                                  //     labelText: _isWithInvoice || _showAdditionalDetails
                                  //         ? AppLocalizations.of(context)!.invoice_No
                                  //         : AppLocalizations.of(context)!.challan_No,
                                  //   ),
                                  //   validator: (value) => value == null || value.isEmpty
                                  //       ? "Enter ${_isWithInvoice || _showAdditionalDetails
                                  //       ? AppLocalizations.of(context)!.invoice_No
                                  //       : AppLocalizations.of(context)!.challan_No} No"
                                  //       : null,
                                  // ),
                                  TextFormField(
                                    controller: _challanNoController,
                                    maxLength: 16, // Limits input to 16 characters
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(16), // Enforces the limit even if pasted
                                    ],
                                    decoration: InputDecoration(
                                      counterText: "", // Optional: hides the "0/16" counter if you don't want it
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      hintText: _isWithInvoice || _showAdditionalDetails
                                          ? AppLocalizations.of(context)!.invoice_No
                                          : AppLocalizations.of(context)!.challan_No,
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      labelText: _isWithInvoice || _showAdditionalDetails
                                          ? AppLocalizations.of(context)!.invoice_No
                                          : AppLocalizations.of(context)!.challan_No,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter ${_isWithInvoice || _showAdditionalDetails
                                            ? AppLocalizations.of(context)!.invoice_No
                                            : AppLocalizations.of(context)!.challan_No} No";
                                      }
                                      if (value.length > 16) {
                                        return "Maximum 16 characters allowed";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 7),
                                  TextFormField(
                                    controller: _weightController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      hintText: AppLocalizations.of(context)!.weight_In_Kg,
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      labelText: AppLocalizations.of(context)!.weight_In_Kg,
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter valid weight data";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .do_you_have_second_challan_with_same_vehicle,
                                      style: const TextStyle(color: Colors.black),
                                      children: [
                                        if (_isPlusButtonVisible)
                                          TextSpan(
                                            text: AppLocalizations.of(context)!.click_Here,
                                            style: const TextStyle(
                                                color: Colors.blue, fontWeight: FontWeight.bold),

                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                if (_weightController.text.isNotEmpty && double.tryParse(_weightController.text) != null) {
                                                  double netWeight = double.parse(_weightController.text);
                                                  if (netWeight > 0) {
                                                    setState(() {
                                                      _showAdditionalDetails = !_showAdditionalDetails;
                                                      clickhere = !clickhere;
                                                      // NEW: When second challan is enabled, require invoice for it
                                                      withinvoicetwo = _showAdditionalDetails ? 1 : 0;
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Net weight must be greater than 0 to add additional details!'),
                                                        backgroundColor: Colors.red,
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Please enter a valid net weight first!'),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                }
                                              },
                                            // recognizer: TapGestureRecognizer()
                                            //   ..onTap = () {
                                            //     if (_weightController.text.isNotEmpty &&
                                            //         double.tryParse(_weightController.text) != null) {
                                            //       double netWeight = double.parse(_weightController.text);
                                            //       if (netWeight > 0) {
                                            //         setState(() {
                                            //           _showAdditionalDetails = !_showAdditionalDetails;
                                            //           clickhere = !clickhere;
                                            //         });
                                            //       } else {
                                            //         ScaffoldMessenger.of(context).showSnackBar(
                                            //           SnackBar(
                                            //             content: Text(
                                            //                 'Net weight must be greater than 0 to add additional details!'),
                                            //             backgroundColor: Colors.red,
                                            //           ),
                                            //         );
                                            //       }
                                            //     } else {
                                            //       ScaffoldMessenger.of(context).showSnackBar(
                                            //         SnackBar(
                                            //           content: Text('Please enter a valid net weight first!'),
                                            //           backgroundColor: Colors.red,
                                            //         ),
                                            //       );
                                            //     }
                                            //   },
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.is_With_Invoice,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start, // adjust as needed
                                          children: [
                                            // ---------- YES ----------
                                            RadioMenuButton<bool>(
                                              value: true,
                                              groupValue: _isWithInvoice,

                                              onChanged: (bool? value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _isWithInvoice = value;     // true
                                                    withinvoiceone = 1;         // custom int flag
                                                  });
                                                }
                                              },
                                              style: MenuItemButton.styleFrom(
                                                foregroundColor: primaryColor,
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                              ),
                                              child: Text(AppLocalizations.of(context)!.yes),
                                            ),

                                            const SizedBox(width: 12), // spacing (you had 5, increased slightly for clarity)

                                            // ---------- NO ----------
                                            RadioMenuButton<bool>(
                                              value: false,
                                              groupValue: _isWithInvoice,
                                              onChanged: (bool? value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _isWithInvoice = value;     // false
                                                    withinvoiceone = 0;         // custom int flag
                                                  });
                                                }
                                              },
                                              style: MenuItemButton.styleFrom(
                                                foregroundColor: primaryColor,
                                              ),
                                              child: Text(AppLocalizations.of(context)!.no),
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
                                        //           withinvoiceone = 1;
                                        //         });
                                        //       },
                                        //       activeColor: primaryColor,
                                        //     ),
                                        //     Text(AppLocalizations.of(context)!.yes),
                                        //     const SizedBox(width: 5),
                                        //     Radio<bool>(
                                        //       value: false,
                                        //       groupValue: _isWithInvoice,
                                        //       onChanged: (bool? value) {
                                        //         setState(() {
                                        //           _isWithInvoice = value!;
                                        //           withinvoiceone = 0;
                                        //         });
                                        //       },
                                        //       activeColor: primaryColor,
                                        //     ),
                                        //     Text(AppLocalizations.of(context)!.no),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  if (_isWithInvoice || _showAdditionalDetails) ...[
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: ElevatedButton.icon(
                                        key: ValueKey('chooseFileButton'),
                                        onPressed: openFileChooser,
                                        icon: Icon(Icons.attach_file_outlined, color: primaryColor),
                                        label: Text(
                                          AppLocalizations.of(context)!.choose_File,
                                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade200,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_fileName != null) ...[
                                      const SizedBox(height: 20),
                                      Text('Selected file: $_fileName'),
                                    ],
                                  ],
                                  if (_showAdditionalDetails) ...[
                                    const SizedBox(height: 20),
                                    Text(
                                      AppLocalizations.of(context)!.additional_Details_List,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _additionalChallanNoController,
                                      maxLength: 16,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(16),
                                      ],
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: primaryColor),
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.green),
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        hintText: _isWithInvoice || _showAdditionalDetails ? 'Invoice No' : 'Challan No',
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: _isWithInvoice || _showAdditionalDetails ? 'Invoice No' : 'Challan No',
                                      ),
                                      validator: (value) => value == null || value.isEmpty
                                          ? "Enter ${_isWithInvoice || _showAdditionalDetails
                                          ? AppLocalizations.of(context)!.invoice_No
                                          : AppLocalizations.of(context)!.challan_No}"
                                          : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: TextFormField(
                                        controller: _additionalWeightController,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: primaryColor),
                                            borderRadius: BorderRadius.circular(11),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.green),
                                            borderRadius: BorderRadius.circular(11),
                                          ),
                                          hintText: AppLocalizations.of(context)!.additional_Weight_In_Kg,
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          labelText: AppLocalizations.of(context)!.additional_Weight_In_Kg,
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                        value == null || value.isEmpty ? "Enter Additional Weight" : null,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: ElevatedButton.icon(
                                        key: ValueKey('chooseFileButton2'),
                                        onPressed: openFileChooser1,
                                        icon: Icon(Icons.attach_file, color: primaryColor),
                                        label: Text(
                                          AppLocalizations.of(context)!.choose_File,
                                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade200,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_fileName1 != null) ...[
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text('Selected file: $_fileName1'),
                                      ),
                                    ],
                                  ],
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                                    ),
                                    onPressed: _isSubmitting ? null : () {
                                      btn();
                                    },
                                    child: _isSubmitting
                                        ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                        : Text(
                                      AppLocalizations.of(context)!.submitbtn,
                                      style: TextStyle(fontSize: 18, color: Colors.white),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildInvoiceRadioButton(String label, bool groupValue, ValueChanged<bool?> onChanged) {
  //   final primaryColor = Theme.of(context).primaryColor;
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  //         Row(
  //           children: [
  //             Radio<bool>(
  //               activeColor: primaryColor,
  //               value: true,
  //               groupValue: groupValue,
  //               onChanged: onChanged,
  //             ),
  //             Text(AppLocalizations.of(context)!.yes),
  //             const SizedBox(width: 5),
  //             Radio<bool>(
  //               activeColor: primaryColor,
  //               value: false,
  //               groupValue: groupValue,
  //               onChanged: onChanged,
  //             ),
  //             Text(AppLocalizations.of(context)!.no),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void showSuccessDialog(BuildContext context, String message, VoidCallback onGotIt) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text("Success", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onGotIt();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text("Got it"),
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(dialogContext)!.add_New_Driver),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: AppLocalizations.of(dialogContext)!.driver_Name,
                  hintText: AppLocalizations.of(dialogContext)!.enter_Driver_Name,
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
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: AppLocalizations.of(dialogContext)!.mobile_Number,
                  hintText: AppLocalizations.of(dialogContext)!.enter_Mobile_No,
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
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                    height: 40,
                    onPressed: () async {
                      try {
                        String uname = usernameController.text;
                        String mob = mobileController.text;
                        await callAddNewDriverService(uname, mob);
                        if (mounted && dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      } catch (e) {
                        if (mounted && dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                    text: AppLocalizations.of(dialogContext)!.submitbtn,
                    backgroundColor: primaryColor,
                    width: 15,
                    popOnPress: false,
                  ),
                  CustomElevatedButton(
                    height: 40,
                    onPressed: () {
                      if (mounted && dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        setState(() {
                          _filteredSuggestions = [];
                        });
                      }
                    },
                    text: AppLocalizations.of(dialogContext)!.cancelbtn,
                    backgroundColor: primaryColor,
                    width: 15,
                    popOnPress: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


