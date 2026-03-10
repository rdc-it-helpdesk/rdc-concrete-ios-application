// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:rdc_concrete/core/network/api_client.dart';
// import 'package:rdc_concrete/models/expense_pojo.dart';
// import 'package:rdc_concrete/src/generated/l10n/app_localizations.dart';
// import 'package:rdc_concrete/utils/session_manager.dart';
//
// class ExpenseMain extends StatefulWidget {
//   final int? locationid;
//   final int? uprofileid;
//   final String sitename;
//   final String? uname;
//   final String? role;
//   final String? language;
//
//   const ExpenseMain({
//     super.key,
//     required this.locationid,
//     required this.sitename,
//     this.role,
//     this.uname,
//     this.uprofileid,
//     this.language,
//   });
//
//   @override
//   State<ExpenseMain> createState() => _ExpenseMainState();
// }
//
// class _ExpenseMainState extends State<ExpenseMain>
//     with SingleTickerProviderStateMixin {
//   // -------------------------------------------------------------------------
//   // UI state
//   // -------------------------------------------------------------------------
//   bool _isLoading = true;
//   String _errorMessage = '';
//   int _selectedTab = 0; // 0=Expenses, 1=Approvals, 2=Reports
//
//   List<Expense> _expenses = [];
//   List<Expense> _approvals = [];
//   List<Expense> _reports = [];
//
//   final TextEditingController _titleCtrl = TextEditingController();
//   final TextEditingController _amountCtrl = TextEditingController();
//   final TextEditingController _descCtrl = TextEditingController();
//
//   final Map<int, bool> _expanded = {};
//
//   late final AnimationController _animCtrl;
//
//   @override
//   void initState() {
//     super.initState();
//     SessionManager.scheduleMidnightLogout(context);
//
//     _animCtrl = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _animCtrl.dispose();
//     _titleCtrl.dispose();
//     _amountCtrl.dispose();
//     _descCtrl.dispose();
//     super.dispose();
//   }
//
//   // -------------------------------------------------------------------------
//   // Helper UI
//   // -------------------------------------------------------------------------
//   void _showLoading() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   void _hideLoading() {
//     Navigator.of(context, rootNavigator: true).pop();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).primaryColor;
//
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context, widget.sitename);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: primary,
//           title: const Text(
//             'RDC Concrete (India)',
//             style: TextStyle(color: Colors.white),
//           ),
//           iconTheme: const IconThemeData(color: Colors.white),
//         ),
//         resizeToAvoidBottomInset: false,
//
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed:  ,
//         //   backgroundColor: primary,
//         //   child: const Icon(Icons.add, color: Colors.white),
//         // ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//
//         body: Stack(
//           children: [
//             // Background image (same as you had)
//             Container(
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 color: const Color.fromRGBO(0, 0, 0, 0.5),
//                 image: DecorationImage(
//                   image: const AssetImage("assets/bg_image/RDC.png"),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                     const Color.fromRGBO(0, 0, 0, 0.3),
//                     BlendMode.dstATop,
//                   ),
//                 ),
//               ),
//             ),
//
//             // -------------------------------------------------------------
//             // Placeholder for future tab content
//             // -------------------------------------------------------------
//             Center(
//               child: Text(
//                 _selectedTab == 0
//                     ? 'Expenses list will appear here'
//                     : _selectedTab == 1
//                     ? 'Approvals list'
//                     : 'Reports',
//                 style: const TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rdc_concrete/screens/spares_and_expense_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rdc_concrete/core/network/api_client.dart';
import 'package:rdc_concrete/models/expense_pojo.dart';
import 'package:rdc_concrete/models/purchase_order_pojo.dart';
import 'package:rdc_concrete/models/po_reasponse_pojo.dart';
import 'package:rdc_concrete/src/generated/l10n/app_localizations.dart';
import 'package:rdc_concrete/utils/session_manager.dart';

import '../services/PO_api_Service.dart';
import '../services/pOForMO_api_Service.dart';


class ExpenseMain extends StatefulWidget {
  final int? locationid;
  final int? uprofileid;
  final String sitename;
  final String? uname;
  final String? role;
  final String? language;

  const ExpenseMain({
    super.key,
    required this.locationid,
    required this.sitename,
    this.role,
    this.uname,
    this.uprofileid,
    this.language,
  });

  @override
  State<ExpenseMain> createState() => _ExpenseMainState();
}

class _ExpenseMainState extends State<ExpenseMain> with TickerProviderStateMixin{
  // -------------------------------------------------------------------------
  // UI state
  // -------------------------------------------------------------------------
  bool _isLoading = true;
  String _errorMessage = '';
  int _selectedTab = 0; // 0=Expenses, 1=Approvals, 2=Reports

  List<PurchaseOrder> _vendorPOs = [];
  List<PurchaseOrder> _sitePOs = [];
  List<Expense> _allExpenses = [];

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  final Map<int, bool> _expanded = {};
  late final AnimationController _animCtrl;

  late final POService _poService;
  late final POForMOService _poForMOService;

  @override
  void initState() {
    super.initState();
    print("fhbrwvbyigr${widget.sitename}");
    SessionManager.scheduleMidnightLogout(context);
    _animCtrl = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Initialize API services
    final dio = ApiClient.getDio();
    _poService = POService(dio);
    _poForMOService = POForMOService(dio);

    // Load data
    _loadAllData();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Data Loading
  // -------------------------------------------------------------------------
  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate vendorId from user profile or pass via constructor
      final int vendorId = widget.uprofileid ?? 1; // Replace with actual logic

      final results = await Future.wait([
        _poService.getcreatedpo(page: 1, vendorId: vendorId),
        _poForMOService.getcreatedpoformo(page: 1, sitename: widget.sitename),
      ], eagerError: true);

      final POResponse? vendorResponse = results[0] as POResponse?;
      final POResponse? siteResponse = results[1] as POResponse?;

      setState(() {
        _vendorPOs = vendorResponse?.poDetails ?? [];
        _sitePOs = siteResponse?.poDetails ?? [];

        // Combine all expenses
        final Set<Expense> uniqueExpenses = {};
        for (var po in [..._vendorPOs, ..._sitePOs]) {
          if (po.expenseAndSpares != null) {
            uniqueExpenses.addAll(po.expenseAndSpares!);
          }
        }
        _allExpenses = uniqueExpenses.toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // -------------------------------------------------------------------------
  // Helper UI
  // -------------------------------------------------------------------------
  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // -------------------------------------------------------------------------
  // Build UI
  // -------------------------------------------------------------------------
  @override
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.sitename);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text(
            'RDC Concrete (India)',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          // bottom: TabBar(
          //   controller: _tabController,
          //   tabs: const [
          //     Tab(text: 'Expenses'),
          //     Tab(text: 'Approvals'),
          //     Tab(text: 'Reports'),
          //   ],
          // ),
        ),
        resizeToAvoidBottomInset: false,

        // FAB – Opens Spares & Expense Form
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SparesAndExpenseScreen(),
              ),
            );
          },
          backgroundColor: primary,
          tooltip: 'Create PO (Spares & Expense)',
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        body: Stack(
          children: [
            // Background image
            Container(
              height: double.infinity,
              decoration: const BoxDecoration(
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

            // Main Content
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Loading expenses...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAllData,
      child: _buildTabContent(),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildExpensesTab();
      case 1:
        return _buildApprovalsTab();
      case 2:
        return _buildReportsTab();
      default:
        return const SizedBox();
    }
  }

  // -------------------------------------------------------------------------
  // Tab 0: Expenses
  // -------------------------------------------------------------------------
  Widget _buildExpensesTab() {
    if (_allExpenses.isEmpty) {
      return _buildEmptyState('No expenses found');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _allExpenses.length,
      itemBuilder: (context, index) {
        final expense = _allExpenses[index];
        final bool isExpanded = _expanded[index] ?? false;

        return Card(
          color: Colors.white.withOpacity(0.9),
          child: ExpansionTile(
            leading: const Icon(Icons.receipt, color: Colors.blue),
            title: Text(
              expense.itemName ?? 'Unknown Item',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('₹${expense.price ?? '0'} • ${expense.qty ?? '0'} ${expense.uom ?? ''}'),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onExpansionChanged: (expanded) {
              setState(() {
                _expanded[index] = expanded;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow('Item Code', expense.itemCode),
                    _infoRow('Tax Category', expense.taxCategory),
                    _infoRow('Invoice', expense.invoicefilelocation ?? 'Not uploaded'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // View invoice
                          },
                          child: const Text('View Invoice'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Approve/Reject
                          },
                          child: const Text('Approve'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Tab 1: Approvals
  // -------------------------------------------------------------------------
  Widget _buildApprovalsTab() {
    final pendingPOs = [..._vendorPOs, ..._sitePOs]
        .where((po) => po.status?.toLowerCase() == 'pending')
        .toList();

    if (pendingPOs.isEmpty) {
      return _buildEmptyState('No pending approvals');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: pendingPOs.length,
      itemBuilder: (context, index) {
        final po = pendingPOs[index];
        return Card(
          color: Colors.white.withOpacity(0.9),
          child: ListTile(
            leading: const Icon(Icons.pending_actions, color: Colors.orange),
            title: Text('PO #${po.id}'),
            subtitle: Text('Ship To: ${po.shipTo}\n${po.expenseAndSpares?.length ?? 0} items'),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to approval detail
            },
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Tab 2: Reports
  // -------------------------------------------------------------------------
  Widget _buildReportsTab() {
    final totalAmount = _allExpenses.fold<double>(
      0.0,
          (sum, e) => sum + (double.tryParse(e.price ?? '0') ?? 0) * (double.tryParse(e.qty ?? '1') ?? 1),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _reportCard('Total Expenses', '₹${totalAmount.toStringAsFixed(2)}'),
          _reportCard('Total Items', '${_allExpenses.length}'),
          _reportCard('From Vendor POs', '${_vendorPOs.length} POs'),
          _reportCard('From Site POs', '${_sitePOs.length} POs'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Generate PDF/Excel
            },
            child: const Text('Export Report'),
          ),
        ],
      ),
    );
  }

  Widget _reportCard(String title, String value) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.white70),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }
}