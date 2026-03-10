import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rdc_concrete/component/custom_elevated_button.dart';

import '../models/reportmodel_pojo.dart';
import '../services/transactionsummary_api_service.dart';
import '../utils/session_manager.dart';

class TransactionSummary extends StatefulWidget {
  final int? uid;
  const TransactionSummary({super.key, this.uid});

  @override
  State<TransactionSummary> createState() => _TransactionSummaryState();
}

class _TransactionSummaryState extends State<TransactionSummary> {
  DateTime? startDate;
  DateTime? endDate;
  bool isFiltered = false; // Controls when transactions should be shown
  List<Completereport> _completeMOList = [];
  Map<int, bool> expandedItems = {};
  @override
  void initState() {
    super.initState();
    //SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
    //fetchLocations();
    //btnfilter();
  }

  // void setDates(DateTime start, DateTime end) {
  //   setState(() {
  //     startDate = start;
  //     endDate = end;
  //   });
  // }
  Future<void> btnfilter() async {
    // Ensure that startDate and endDate are not null
    // if (startDate == null || endDate == null) {
    //   // Handle the case where dates are not set
    //   print("Start date or end date is not set.");
    //   return;
    // }

    // Format the dates as "YYYY-MM-DD"
    String startdate =
        "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
    String enddate =
        "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";
    // print("startdate${startdate}");
    // print("enddate${enddate}");
    String uid = widget.uid.toString();
    TransactionsummaryApiService transactionsummaryApiService =
        TransactionsummaryApiService();

    // Call the API with the formatted dates
    ReportModel? response = await transactionsummaryApiService.getreport(
      uid,
      startdate,
      enddate,
    );

    // Handle the response as needed
    if (response.status != 0) {
      // Process the response
      _completeMOList = response.completereport;
      //print("Report fetched successfully.");
    } else {
      // print("Failed to fetch report.");
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate =
        isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now();
    DateTime firstDate = DateTime(2023, 1, 1);
    DateTime lastDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  void _applyFilter() {
    if (startDate != null && endDate != null) {
      setState(() {
        btnfilter();
        isFiltered = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both start and end dates"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 4),
          Expanded(
            // Ensures text wraps instead of overflowing
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // Prevents overflow
              softWrap: true, // Allows wrapping
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Transaction Summary',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // drawer: MyDrawer(drawerItems: const []),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              image: DecorationImage(
                image: const AssetImage('assets/bg_image/RDC.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.3),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      _buildDatePickerRow(),
                      const SizedBox(height: 15),
                      _buildFilterButton(),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),

                SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var item
                          in _completeMOList) // Loop through canceledMO[]
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expandedItems[item.orderid] =
                                  !(expandedItems[item.orderid] ?? false);
                              // isExpandedCanceled = !isExpandedCanceled; // Toggle expansion
                            });
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Order Number with background color
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${item.itemname} (${item.vehiclenumber})', // Dynamically set order number
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "PO: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              item.ponumber,
                                            ), // Dynamically set PO number
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (expandedItems[item.orderid] ?? false) ...[
                                    SizedBox(height: 8),
                                    _buildInfoRow(
                                      "Order Status: ",
                                      "Completed",
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Chalan Number 1: ",
                                      item.challanno,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Chalan Number 2: ",
                                      item.challanno,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Vehicle Number: ",
                                      item.vehiclenumber,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Driver Name: ",
                                      item.drivername,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow("Site Name: ", item.sitename),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Net Weight: ",
                                      item.netweight.toString(),
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Chalan Weight 1: ",
                                      item.challanno,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Chalan Weight 2: ",
                                      item.challanno,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Royalty Pass: ",
                                      item.challanno,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Moisture %: ",
                                      item.moisture,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow(
                                      "Last Action: ",
                                      item.lastaction,
                                    ),
                                    _buildDivider(),
                                    _buildInfoRow("MRN No: ", item.mrnno),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDatePicker(
            "Start Date",
            startDate,
            () => _selectDate(context, true),
          ),
          _buildDatePicker(
            "End Date",
            endDate,
            () => _selectDate(context, false),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date != null ? DateFormat('dd/MM/yyyy').format(date) : label,
              ),
              const Icon(Icons.calendar_today, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    final primaryColor = Theme.of(context).primaryColor;
    return CustomElevatedButton(
      onPressed: _applyFilter,
      text: "Filter",
      popOnPress: false,
      backgroundColor: primaryColor,
      width: MediaQuery.of(context).size.width * 0.6,
    );
  }
}
