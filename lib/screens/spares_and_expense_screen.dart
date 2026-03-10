// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
//
// class _MaterialLine {
//   String? itemName;
//   String? materialCode;
//   String? materialDesc;
//   String? uom;
//   String? qty;
//   String? price;
//   String? total;
//   String? taxCategory;
//   File? invoiceFile;
//   String? invoicePath;
//
//   _MaterialLine();
// }
//
// class SparesAndExpenseScreen extends StatefulWidget {
//   const SparesAndExpenseScreen({super.key});
//
//   @override
//   State<SparesAndExpenseScreen> createState() => _SparesAndExpenseScreenState();
// }
//
// class _SparesAndExpenseScreenState extends State<SparesAndExpenseScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _vendorIdCtrl = TextEditingController();
//   final _billToCtrl = TextEditingController();
//   final _shipToCtrl = TextEditingController();
//
//   String _selectedType = 'Expense';
//   final List<String> _typeOptions = ['Expense', 'Spare'];
//   final List<_MaterialLine> _materials = [];
//
//   bool _isSubmitting = false;
//
//   void _addMaterial() => setState(() => _materials.add(_MaterialLine()));
//   void _removeMaterial(int i) => setState(() => _materials.removeAt(i));
//
//   Future<void> _pickInvoice(int i) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//     if (result == null) return;
//
//     final file = File(result.files.single.path!);
//     if (file.lengthSync() > 4 * 1024 * 1024) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('File must be ≤ 4 MB')),
//       );
//       return;
//     }
//
//     setState(() {
//       _materials[i].invoiceFile = file;
//       _materials[i].invoicePath = result.files.single.name;
//     });
//   }
//
//   Future<void> _finalSubmit() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isSubmitting = true);
//     await Future.delayed(const Duration(seconds: 1)); // TODO: API
//     setState(() => _isSubmitting = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('PO Created!')),
//     );
//   }
//
//   @override
//   void dispose() {
//     _vendorIdCtrl.dispose();
//     _billToCtrl.dispose();
//     _shipToCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).primaryColor;
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor:primary,
//         foregroundColor: Colors.white,
//         title: const Text('Create PO', style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           // BACKGROUND IMAGE + DARK OVERLAY
//           Container(
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               color: Color.fromRGBO(0, 0, 0, 0.5),
//               image: DecorationImage(
//                 image: AssetImage("assets/bg_image/RDC.png"),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Color.fromRGBO(0, 0, 0, 0.3),
//                   BlendMode.dstATop,
//                 ),
//               ),
//             ),
//           ),
//
//           // MAIN FORM CONTENT (on top of background)
//           SafeArea(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // SCROLLABLE CONTENT
//                   Expanded(
//                     child: ListView(
//                       padding: const EdgeInsets.all(16),
//                       children: [
//                         // MAIN CARD (elevated, clean)
//                         Card(
//                           elevation: 8,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildSectionTitle('Select Type'),
//                                 _buildDropdown(
//                                   value: _selectedType,
//                                   items: _typeOptions,
//                                   onChanged: (v) =>
//                                       setState(() => _selectedType = v!),
//                                 ),
//                                 const SizedBox(height: 16),
//
//                                 _buildSectionTitle('Vendor ID'),
//                                 _buildTextField(_vendorIdCtrl, 'Select Vendor ID'),
//                                 const SizedBox(height: 16),
//
//                                 _buildSectionTitle('Supplier Site Name'),
//                                 _buildTextField(_billToCtrl, 'Select Vendor Site'),
//                                 const SizedBox(height: 16),
//
//                                 _buildSectionTitle('Bill To - Ship To Site Name'),
//                                 _buildTextField(_shipToCtrl,
//                                     'Select Bill to - Ship To Site'),
//                                 const SizedBox(height: 24),
//
//                                 _buildSectionTitle('Add Materials'),
//                                 const SizedBox(height: 12),
//
//                                 // MATERIAL LINES
//                                 ..._materials.asMap().entries.map((e) {
//                                   final i = e.key;
//                                   final m = e.value;
//                                   return _buildMaterialCard(i, m);
//                                 }),
//
//                                 const SizedBox(height: 16),
//                                 Center(
//                                   child: OutlinedButton.icon(
//                                     onPressed: _addMaterial,
//                                     icon: const Icon(Icons.add),
//                                     label: const Text('Add Material'),
//                                     style: OutlinedButton.styleFrom(
//                                       foregroundColor: Colors.green,
//                                       side: const BorderSide(color: Colors.green),
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(12)),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // SUBMIT BUTTON (on top of background)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     child: ElevatedButton(
//                       onPressed: _isSubmitting ? null : _finalSubmit,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                         elevation: 6,
//                       ),
//                       child: _isSubmitting
//                           ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                               color: Colors.white, strokeWidth: 2))
//                           : const Text(
//                         'Final Submit',
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Reusable Widgets
//   Widget _buildSectionTitle(String text) {
//     return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));
//   }
//
//   Widget _buildDropdown({required String value, required List<String> items, required Function(String?) onChanged}) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: _inputDecorationHint(),
//       items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//       onChanged: onChanged,
//       validator: (v) => v == null ? 'Required' : null,
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hint) {
//     return TextFormField(
//       controller: controller,
//       decoration: _inputDecorationHint(hint: hint),
//       validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
//     );
//   }
//
//   InputDecoration _inputDecorationHint({String? hint}) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.grey[100],
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     );
//   }
//
//   Widget _buildMaterialCard(int index, _MaterialLine m) {
//     final itemCtrl = TextEditingController(text: m.itemName);
//     final qtyCtrl = TextEditingController(text: m.qty);
//     final priceCtrl = TextEditingController(text: m.price);
//
//     void sync() {
//       m.itemName = itemCtrl.text;
//       m.qty = qtyCtrl.text;
//       m.price = priceCtrl.text;
//       final q = double.tryParse(qtyCtrl.text) ?? 0;
//       final p = double.tryParse(priceCtrl.text) ?? 0;
//       m.total = (q * p).toStringAsFixed(2);
//     }
//
//     itemCtrl.addListener(sync);
//     qtyCtrl.addListener(sync);
//     priceCtrl.addListener(sync);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Material #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
//               IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removeMaterial(index)),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           _buildTextField(itemCtrl, 'Select Item'),
//           const SizedBox(height: 12),
//           _readonlyField(m.materialCode ?? 'Auto-filled'),
//           const SizedBox(height: 12),
//           _readonlyField(m.materialDesc ?? 'Auto-filled'),
//           const SizedBox(height: 12),
//
//           _buildDropdown(
//             value: m.uom ?? 'KG',
//             items: ['KG', 'TON', 'NOS', 'MTR'],
//             onChanged: (v) => setState(() => m.uom = v),
//           ),
//           const SizedBox(height: 12),
//
//           _buildTextField(qtyCtrl, 'Quantity'),
//           const SizedBox(height: 12),
//           _buildTextField(priceCtrl, 'Price Per Unit'),
//           const SizedBox(height: 12),
//           _readonlyField(m.total ?? '0.00'),
//           const SizedBox(height: 12),
//
//           _buildDropdown(
//             value: m.taxCategory ?? 'GST 18%',
//             items: ['GST 18%', 'GST 12%', 'GST 5%', 'IGST 18%'],
//             onChanged: (v) => setState(() => m.taxCategory = v),
//           ),
//           const SizedBox(height: 16),
//
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: () => _pickInvoice(index),
//               icon: const Icon(Icons.attach_file),
//               label: Text(m.invoicePath ?? 'Upload Invoice (PDF)'),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _readonlyField(String text) {
//     return TextFormField(
//       enabled: false,
//       initialValue: text,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.grey[200],
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../core/network/api_client.dart';
import '../models/fetch_location_pojo.dart';
import '../models/vedor_response_pojo.dart';
import '../models/site_response_pojo.dart';
import '../models/item_response_pojo.dart';
import '../models/insert_transaction_new_pojo.dart';
import '../services/InsertSpares_api_Service.dart';
import '../services/Item_api_Service.dart';
import '../services/Site_api_Service.dart';
import '../services/Vendor_new_api_Service.dart';
import '../services/fetch_location_api_service.dart' show LocationService;

/// ---------------------------------------------------------------------------
///  MATERIAL LINE (kept exactly as you had in the commented code)
/// ---------------------------------------------------------------------------
class _MaterialLine {
  String? itemName;
  String? materialCode;
  String? materialDesc;
  String? uom;
  String? qty;
  String? price;
  String? total;
  String? taxCategory;
  File? invoiceFile;
  String? invoicePath;

  _MaterialLine();
}

/// ---------------------------------------------------------------------------
///  MAIN SCREEN
/// ---------------------------------------------------------------------------
class SparesAndExpenseScreen extends StatefulWidget {
  const SparesAndExpenseScreen({super.key});

  @override
  State<SparesAndExpenseScreen> createState() => _SparesAndExpenseScreenState();
}

class _SparesAndExpenseScreenState extends State<SparesAndExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = ApiClient.getDio();

  // ── Controllers ────────────────────────────────────────────────────────
  final _vendorIdCtrl = TextEditingController();
  final _billToCtrl = TextEditingController();
  final _shipToCtrl = TextEditingController();
  final _fromDateCtrl = TextEditingController();
  final _toDateCtrl = TextEditingController();
  final _invoiceNumberCtrl = TextEditingController();

  // ── Services ───────────────────────────────────────────────────────────
  late final VendorService _vendorService;
  late final SiteService _siteService;
  late final ItemService _itemService;
  late final LocationService _locationService;
  late final InsertSparesService _insertService;

  // ── UI State ───────────────────────────────────────────────────────────
  String _selectedType = 'Goods';
  final List<String> _typeOptions = ['Goods', 'Expense'];
  final List<String> _uomOptions = ['NOS', 'KG', 'Litre'];
  final List<String> _taxCategories = [
    "C+S GST 18% Recoverable Tax Category",
    "C+S GST 5% Recoverable Tax Category",
    "C+S GST 12% Recoverable Tax Category",
    "C+S GST 0% Recoverable Tax Category",
    "C+S GST 3% Recoverable Tax Category",
    "C+S GST 28% Recoverable Tax Category",
    "IGST 18% Recoverable Tax Category",
    "IGST 5% Recoverable Tax Category",
    "IGST 12% Recoverable Tax Category",
    "IGST 0% Recoverable Tax Category",
    "IGST 3% Recoverable Tax Category",
    "IGST 28% Recoverable Tax Category",
  ];

  final List<_MaterialLine> _materials = [];

  List<Vendor> _vendorList = [];
  List<String> _siteList = [];
  List<Item> _itemList = [];
  List<LocationList> _locationList = [];

  String _selectedVendorId = '';
  String _selectedAPSegment = '';
  String _invoiceBase64 = '';
  bool _isLoading = false;
  bool _isSubmitting = false;

  // ------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _vendorService = VendorService(_dio);
    _siteService = SiteService(_dio);
    _itemService = ItemService(_dio);
    _locationService = LocationService();
    _insertService = InsertSparesService(_dio);

    _fetchLocations();
  }

  // ------------------------------------------------------------------------
  //  API Calls
  // ------------------------------------------------------------------------
  Future<void> _fetchLocations() async {
    setState(() => _isLoading = true);
    try {
      final loc = await _locationService.getLocations('1');
      setState(() => _locationList = loc);
    } catch (_) {
      _showSnack('Failed to load locations');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchVendors(String q) async {
    if (q.trim().length < 2) return;
    setState(() => _isLoading = true);
    try {
      final res = await _vendorService.getvendorslist(q.trim());
      setState(() => _vendorList = res?.data ?? []);
    } catch (_) {
      _showSnack('Failed to load vendors');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchSites(String vendorId) async {
    setState(() => _isLoading = true);
    try {
      final res = await _siteService.getSites(vendorId);
      setState(() => _siteList = res?.sites ?? []);
    } catch (_) {
      _showSnack('Failed to load sites');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchItems(String siteCode) async {
    setState(() => _isLoading = true);
    try {
      final res = await _itemService.getItems(siteCode);
      setState(() => _itemList = res?.items ?? []);
    } catch (_) {
      _showSnack('Failed to load items');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ------------------------------------------------------------------------
  //  PDF Upload (global – one invoice for the whole PO)
  // ------------------------------------------------------------------------
  Future<void> _pickInvoice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    if (file.lengthSync() > 4 * 1024 * 1024) {
      _showSnack('File must be ≤ 4 MB');
      return;
    }

    final bytes = await file.readAsBytes();
    setState(() => _invoiceBase64 = base64Encode(bytes));
    _showSnack('Invoice Uploaded');
  }

  // ------------------------------------------------------------------------
  //  Add / Edit / Delete material
  // ------------------------------------------------------------------------
  void _addMaterial() => setState(() => _materials.add(_MaterialLine()));

  void _removeMaterial(int i) => setState(() => _materials.removeAt(i));

  Future<void> _pickInvoiceForMaterial(int i) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    if (file.lengthSync() > 4 * 1024 * 1024) {
      _showSnack('File must be ≤ 4 MB');
      return;
    }

    setState(() {
      _materials[i].invoiceFile = file;
      _materials[i].invoicePath = result.files.single.name;
    });
  }

  // ------------------------------------------------------------------------
  //  Final Submit
  // ------------------------------------------------------------------------
  Future<void> _finalSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_materials.isEmpty) {
      _showSnack('Add at least one material');
      return;
    }
    if (_selectedVendorId.isEmpty) {
      _showSnack('Select a vendor');
      return;
    }

    setState(() => _isSubmitting = true);

    final transaction = InsertTransactionNew(
      billTo: _billToCtrl.text,
      shipTo: _shipToCtrl.text,
      // fromDate: '${_fromDateCtrl.text} 00:00:00',
      // userId: 22225,
      // vendorId: _selectedVendorId,
      // apSegment: _selectedAPSegment,
      invoiceBase64: _invoiceBase64,
      invoiceNumber: _invoiceNumberCtrl.text, needBy: '', vId: null, apSegment1: '', invoiceDate: '', items: [],
      // toDate: _toDateCtrl.text,
      // materials: _materials
      //     .asMap()
      //     .entries
      //     .map((e) => ItemMaterial(
      //   itemName: e.value.itemName ?? '',
      //   itemCode: e.value.materialCode ?? '',
      //   materialDesc: e.value.materialDesc ?? '',
      //   type: _selectedType,
      //   uom: e.value.uom ?? '',
      //   quantity: int.tryParse(e.value.qty ?? '0') ?? 0,
      //   price: double.tryParse(e.value.price ?? '0') ?? 0.0,
      //   total: double.tryParse(e.value.total ?? '0') ?? 0.0,
      //   srNo: e.key + 1,
      //   date: _toDateCtrl.text,
      //   taxCategory: e.value.taxCategory ?? '',
      // ))
      //     .toList(),Microsoft.QuickAction.MobileHotspot
    );

    try {
      final res = await _insertService.addnewtransaction(transaction);
      if (res != null) {
        _showSnack('Transaction saved');
        Navigator.pop(context);
      } else {
        _showSnack('Save failed');
      }
    } catch (e) {
      _showSnack('Network error: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // ------------------------------------------------------------------------
  @override
  void dispose() {
    _vendorIdCtrl.dispose();
    _billToCtrl.dispose();
    _shipToCtrl.dispose();
    _fromDateCtrl.dispose();
    _toDateCtrl.dispose();
    _invoiceNumberCtrl.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------------
  //  UI
  // ------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Create PO', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ── Background ─────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              image: DecorationImage(
                image: AssetImage('assets/bg_image/RDC.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromRGBO(0, 0, 0, 0.3), BlendMode.dstATop),
              ),
            ),
          ),

          // ── Form ───────────────────────────────────────────────────────────
          SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ── Scrollable Content ───────────────────────────────────────
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _section('Select Type'),
                                _dropdown(
                                  value: _selectedType,
                                  items: _typeOptions,
                                  onChanged: (v) => setState(() => _selectedType = v!),
                                ),
                                const SizedBox(height: 16),

                                _section('Vendor ID'),
                                _vendorAutocomplete(),
                                const SizedBox(height: 16),

                                _section('Supplier Site Name (Bill To)'),
                                _siteDropdown(),
                                const SizedBox(height: 16),

                                _section('Ship To Location'),
                                _locationDropdown(),
                                const SizedBox(height: 16),

                                _section('From Date'),
                                _dateField(_fromDateCtrl),
                                const SizedBox(height: 16),

                                _section('To Date'),
                                _dateField(_toDateCtrl),
                                const SizedBox(height: 16),

                                _section('Invoice Number'),
                                _textField(_invoiceNumberCtrl, 'Enter Invoice Number'),
                                const SizedBox(height: 16),

                                _section('Upload Invoice (PDF)'),
                                ElevatedButton.icon(
                                  onPressed: _pickInvoice,
                                  icon: const Icon(Icons.attach_file),
                                  label: Text(_invoiceBase64.isEmpty ? 'Choose PDF' : 'Invoice Uploaded'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                ),
                                const SizedBox(height: 24),

                                _section('Add Materials'),
                                const SizedBox(height: 12),

                                // ── Inline Material Cards ───────────────────────
                                ..._materials.asMap().entries.map((e) => _materialCard(e.key, e.value)),

                                const SizedBox(height: 16),
                                Center(
                                  child: OutlinedButton.icon(
                                    onPressed: _addMaterial,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Material'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green,
                                      side: const BorderSide(color: Colors.green),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  // ── Submit Button ─────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _finalSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Final Submit',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Loading Overlay ───────────────────────────────────────────────
          if (_isLoading)
            Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------
  //  Reusable UI helpers
  // ------------------------------------------------------------------------
  Widget _section(String title) => Text(title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));

  Widget _dropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      decoration: _dec(),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _textField(TextEditingController ctrl, String hint) {
    return TextFormField(
      controller: ctrl,
      decoration: _dec(hint: hint),
      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _dateField(TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      decoration: _dec(hint: 'Select Date'),
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (d != null) ctrl.text = DateFormat('yyyy-MM-dd').format(d);
      },
      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
    );
  }

  InputDecoration _dec({String? hint}) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  // ------------------------------------------------------------------------
  //  Vendor autocomplete
  // ------------------------------------------------------------------------
  Widget _vendorAutocomplete() {
    return Autocomplete<Vendor>(
      optionsBuilder: (tv) {
        if (tv.text.isEmpty) return const Iterable<Vendor>.empty();
        _searchVendors(tv.text);
        return _vendorList;
      },
      displayStringForOption: (v) => v.apSegment1 ?? '',
      onSelected: (v) {
        setState(() {
          _selectedVendorId = v.vendorId.toString();
          _selectedAPSegment = v.apSegment1 ?? '';
          _vendorIdCtrl.text = v.apSegment1 ?? '';
          _fetchSites(_selectedVendorId);
        });
      },
      fieldViewBuilder: (_, ctrl, focus, __) => TextFormField(
        controller: ctrl,
        focusNode: focus,
        decoration: _dec(hint: 'Search Vendor ID'),
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
    );
  }

  // ------------------------------------------------------------------------
  //  Site dropdown
  // ------------------------------------------------------------------------
  Widget _siteDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: _dec(hint: 'Select Site'),
      items: _siteList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (s) {
        _billToCtrl.text = s ?? '';
        if (s != null && s.isNotEmpty) _fetchItems(s);
      },
    );
  }

  // ------------------------------------------------------------------------
  //  Location dropdown
  // ------------------------------------------------------------------------
  Widget _locationDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: _dec(hint: 'Select Location'),
      items: [
        const DropdownMenuItem(value: '', child: Text('Select Location')),
        ..._locationList.map((l) => DropdownMenuItem(value: l.locationName, child: Text(l.locationName))),
      ],
      onChanged: (v) => _shipToCtrl.text = v ?? '',
    );
  }

  // ------------------------------------------------------------------------
  //  Item autocomplete (inside material card)
  // ------------------------------------------------------------------------
  Widget _itemAutocomplete(_MaterialLine m, int idx) {
    final ctrl = TextEditingController(text: m.itemName);
    ctrl.addListener(() {
      m.itemName = ctrl.text;
      // try to fill code/desc when an item is selected
      final found = _itemList.firstWhereOrNull((i) => i.itemcode == ctrl.text);
      if (found != null) {
        setState(() {
          m.materialCode = found.itemcode;
          m.materialDesc = found.description ?? '';
        });
      }
    });

    return Autocomplete<Item>(
      optionsBuilder: (tv) => _itemList.where((i) => i.itemcode!.toLowerCase().contains(tv.text.toLowerCase())),
      displayStringForOption: (i) => i.itemcode.toString(),
      onSelected: (i) {
        ctrl.text = i.itemcode.toString();
        setState(() {
          m.itemName = i.itemcode;
          m.materialCode = i.itemcode;
          m.materialDesc = i.description ?? '';
        });
      },
      fieldViewBuilder: (_, c, f, __) => TextFormField(
        controller: c,
        focusNode: f,
        decoration: _dec(hint: 'Item Code'),
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
    );
  }

  // ------------------------------------------------------------------------
  //  Material Card (inline, exactly as you wanted)
  // ------------------------------------------------------------------------
  Widget _materialCard(int idx, _MaterialLine m) {
    // individual controllers – they keep the value even after rebuild
    final itemCtrl = TextEditingController(text: m.itemName);
    final qtyCtrl = TextEditingController(text: m.qty);
    final priceCtrl = TextEditingController(text: m.price);
    final totalCtrl = TextEditingController(text: m.total);

    void _calc() {
      final q = double.tryParse(qtyCtrl.text) ?? 0;
      final p = double.tryParse(priceCtrl.text) ?? 0;
      totalCtrl.text = (q * p).toStringAsFixed(2);
      m.total = totalCtrl.text;
    }

    qtyCtrl.addListener(_calc);
    priceCtrl.addListener(_calc);
    itemCtrl.addListener(() => m.itemName = itemCtrl.text);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Material #${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removeMaterial(idx)),
            ],
          ),
          const SizedBox(height: 12),

          // Item autocomplete
          _itemAutocomplete(m, idx),
          const SizedBox(height: 12),

          // Code (read-only)
          _readonlyField(m.materialCode ?? 'Auto-filled'),
          const SizedBox(height: 12),

          // Description (read-only)
          _readonlyField(m.materialDesc ?? 'Auto-filled'),
          const SizedBox(height: 12),

          // UOM
          _dropdown(
            value: m.uom ?? _uomOptions[0],
            items: _uomOptions,
            onChanged: (v) => setState(() => m.uom = v),
          ),
          const SizedBox(height: 12),

          // Qty
          TextFormField(
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            decoration: _dec(hint: 'Quantity'),
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 12),

          // Price
          TextFormField(
            controller: priceCtrl,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: _dec(hint: 'Price Per Unit'),
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 12),

          // Total (read-only)
          _readonlyField(totalCtrl.text),
          const SizedBox(height: 12),

          // Tax
          _dropdown(
            value: m.taxCategory ?? _taxCategories[0],
            items: _taxCategories,
            onChanged: (v) => setState(() => m.taxCategory = v),
          ),
          const SizedBox(height: 16),

          // PDF per material
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _pickInvoiceForMaterial(idx),
              icon: const Icon(Icons.attach_file),
              label: Text(m.invoicePath ?? 'Upload Invoice (PDF)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readonlyField(String text) {
    return TextFormField(
      enabled: false,
      initialValue: text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}