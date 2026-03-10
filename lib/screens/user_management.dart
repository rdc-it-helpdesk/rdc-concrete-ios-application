import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rdc_concrete/screens/mo_home_page.dart';
import 'package:rdc_concrete/screens/vendor_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';

import '../models/fetch_location_pojo.dart';
import '../models/fetch_role_pojo.dart';
import '../models/user_list_pojo.dart';
import '../services/add_user_api_service.dart';

import '../services/fetch_location_api_service.dart';
import '../services/fetch_role_api_service.dart';
import '../services/user_list_api_service.dart';
import '../src/generated/l10n/app_localizations.dart';
import '../utils/session_manager.dart';

class UserManagement extends StatefulWidget {
  // final String role;
  final int? locationid;
  final int? uprofileid;
  final String sitename;
  final String? uname;
  final String? role;
  final String? language;

  //const UserManagement({super.key, required this.role, required  this.locationid,required  this.sitename});
  const UserManagement({
    super.key,
    required this.locationid,
    required this.sitename,
    this.role,
    this.uname,
    this.uprofileid,
    this.language,
  });

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  bool isExpandedV = false;
  bool isExpandedQA = false;
  bool isExpandedMO = false;

  //  String? selectedItem;
  String? selectedLocationItem;
  List<LocationList> locations = [];

  //List<RoleList> roles = [];
  // List<String> spinnerItems = ["Select Location"];
  List<String> spinnerItemsroles = ["Select Role"];

  bool _isLoading = true;
  double progress = 0.0;
  final String _errorMessage = '';
  List<User> _userList = [];
  late AnimationController _controller;

  List<LocationList> spinnerItems = [];
  LocationList? selectedLocation;

  List<RoleList> spinnerItemsRoles = [];
  int? selectedRoleId; // Store selected role ID

  final TextEditingController titleController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  Map<int, bool> expandedItems = {};

  @override
  void initState() {
    super.initState();


    //print("teeettet${widget.sitename}");
    // _loadData();
    //  SessionManager.checkAutoLogoutOnce();
    SessionManager.scheduleMidnightLogout(context);
    fetchLocations();
    fetchRoles();
    fetchUserVendorListData();
    // fetchUserVendorListData( widget.sitename);
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Keep rotating

    _simulateLoading();
    // Fetch locations when the widget is initialized
  }

  void _simulateLoading() {
    // Simulate data loading process
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        setState(() {
          _isLoading = false;
          _controller.stop(); // Stop rotating when loading completes
        });
      } else {
        setState(() {
          progress += 0.1; // Increment progress
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  // bool isLoading = true; // Add this variable to track loading state

  Future<void> fetchLocations() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    LocationService locationService = LocationService();
    try {
      List<LocationList> fetchedLocations = await locationService.getLocations(
        "1",
      );
      setState(() {
        locations = fetchedLocations;
        spinnerItems =
            [LocationList(locationName: "Select Location", locationId: 0)] +
            fetchedLocations; // Add default option

        _isLoading = false; // Set loading state to false
      });
    } catch (e) {
      // print("Error fetching locations: $e");
      setState(() {
        _isLoading = false; // Set loading state to false on error
      });
    }
  }

  // Future<void> fetchLocations() async {
  //   setState(() {
  //     _isLoading = true; // Set loading state to true
  //   });
  //
  //   LocationService locationService = LocationService();
  //   try {
  //     List<LocationList> fetchedLocations = await locationService.getLocations("1");
  //     setState(() {
  //       locations = fetchedLocations;
  //       spinnerItems = ["Select Location"] + fetchedLocations.map((loc) => loc.locationName).toList();
  //       _isLoading = false; // Set loading state to false
  //     });
  //   } catch (e) {
  //     print("Error fetching locations: $e");
  //     setState(() {
  //       _isLoading = false; // Set loading state to false on error
  //     });
  //   }
  // }

  Future<void> fetchUserVendorListData() async {
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');

    if (sitename == null) {
      //  print("No sitename found in SharedPreferences");
      return;
    }

    ///  print("Fetching users for sitename: $sitename");

    final dio = ApiClient.getDio();
    final service = UserListApiService(dio);
    const String role = "VENDOR";

    try {
      List<User>? userList = await service.getUsers(role, widget.sitename);
      if (userList != null && userList.isNotEmpty) {
        //  print("Users fetched successfully: ${userList.length} users");

        setState(() {
          _userList = userList;
        });
      } else {
        //  print("No users found for sitename: $sitename");
        setState(() {
          _userList = [];
        });
      }
    } catch (e) {
      // print("Error fetching users: $e");
    }
  }

  Future<void> fetchUserQATesterListData() async {
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');

    if (sitename == null) {
      //  print("No sitename found in SharedPreferences");
      return;
    }

    // print("Fetching users for sitename: $sitename");

    final dio = ApiClient.getDio();
    final service = UserListApiService(dio);
    const String role = "QA TESTER";
    try {
      List<User>? userList = await service.getUsers(role, widget.sitename);
      if (userList != null && userList.isNotEmpty) {
        //print("Users fetched successfully: ${userList.length} users");

        setState(() {
          _userList = userList;
        });
      } else {
        //   print("No users found for sitename: $sitename");
        setState(() {
          _userList = [];
        });
      }
    } catch (e) {
      //print("Error fetching users: $e");
    }
  }

  Future<void> fetchUserMOListData() async {
    final prefs = await SharedPreferences.getInstance();
    String? sitename = prefs.getString('sitename');

    if (sitename == null) {
      //print("No sitename found in SharedPreferences");
      return;
    }

    //print("Fetching users for sitename: $sitename");

    final dio = ApiClient.getDio();
    final service = UserListApiService(dio);
    const String role = "MATERIALOFFICER";
    try {
      List<User>? userList = await service.getUsers(role, widget.sitename);
      if (userList != null && userList.isNotEmpty) {
        //print("Users fetched successfully: ${userList.length} users");

        setState(() {
          _userList = userList;
        });
      } else {
        // print("No users found for sitename: $sitename");
        setState(() {
          _userList = [];
        });
      }
    } catch (e) {
      //print("Error fetching users: $e");
    }
  }

  // void fetchRoles() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   RoleService apiService = RoleService();
  //   try {
  //     List<RoleList> fetchedRoles = await apiService.getRoles("1");
  //
  //     setState(() {
  //       spinnerItemsRoles = [
  //         RoleList(roleName: "Select Role", roleId: 0), // Default option
  //       ];
  //       spinnerItemsRoles.addAll(fetchedRoles); // Append roles
  //
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     //print("Error fetching roles: $e");
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  void fetchRoles() async {
    setState(() {
      _isLoading = true;
    });

    RoleService apiService = RoleService();
    try {
      List<RoleList> fetchedRoles = await apiService.getRoles("1");

      // Filter out 'Vendor' and 'VENDOR' (case-insensitive)
      List<RoleList> filteredRoles =
          fetchedRoles.where((role) {
            return role.roleName.toLowerCase() != 'vendor';
          }).toList();

      setState(() {
        spinnerItemsRoles = [
          RoleList(roleName: "Select Role", roleId: 0), // Default option
        ];
        spinnerItemsRoles.addAll(filteredRoles); // Add filtered roles

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void fetchRoles() async {
  //   setState(() {
  //     _isLoading = true; // Set loading state to true
  //   });
  //   RoleService apiService = RoleService();
  //   try {
  //     List<RoleList> roles = await apiService.getRoles("1");
  //     setState(() {
  //       roles = roles;
  //       spinnerItemsroles = ["Select Role"] + roles.map((loc) => loc.roleName).toList();
  //       _isLoading = false; // Set loading state to false
  //     });
  //   } catch (e) {
  //     print("Error fetching role: $e");
  //     setState(() {
  //       _isLoading = false; // Set loading state to false on error
  //     });
  //   }
  // }
  /// controllers
  //TextEditingController titleController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();

  // TextEditingController roleController = TextEditingController();
  TextEditingController rdcLocationController = TextEditingController();

  final int maxTitleLength = 10;

  /// maximum title length

  int _selectedIndex = 0;

  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 21, );
  // // static const List<Widget> _widgetOptions = <Widget>[
  // //   Text(
  // //     'Vendors',
  // //     style: optionStyle,
  // //   ),
  // //   Text(
  // //     'QA Tester',
  // //     style: optionStyle,
  // //   ),
  // //   Text(
  // //     'Material Officer',
  // //     style: optionStyle,
  // //   ),
  // // ];
  //
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: () async {
        // Pass widget.sitename back to the previous screen
        Navigator.pop(context, widget.sitename);
        return false; // Prevent default back navigation
      },
      child:Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'RDC Concrete (India)',
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
              // 0.5 opacity for black// RGBA values
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

          _isLoading // Check if loading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green,
                  ), // Set the color to green
                ),
              ) // Show loading indicator
              : _errorMessage
                  .isNotEmpty // Check for error message
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 40),
                    SizedBox(height: 10),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ) // Show error message
              : SingleChildScrollView(
                child: Center(
                  child:
                      _selectedIndex == 0
                          ? buildVendorList()
                          : _selectedIndex == 1
                          ? buildQATesterList()
                          : _selectedIndex == 2
                          ? buildMOList()
                          : Container(), // Fallback if no index matches
                ),
              ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) {
              titleController.clear();
              roleController.clear();
              mobileController.clear();
              emailController.clear();
              passwordController.clear();
              confPasswordController.clear();
              return getBottomSheetWidget();
            },
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.edit, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            fetchUserQATesterListData();
          } else if (index == 0) {
            fetchUserVendorListData();
          } else if (index == 2) {
            fetchUserMOListData();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.handshake),
            label: AppLocalizations.of(context)!.vendors,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_tree),
            label: AppLocalizations.of(context)!.qa_tester,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.business),
            label: AppLocalizations.of(context)!.material_officer,
          ),
        ],
      ),
    ),
    );
  }

  // void _insertUser() async {
  //   if (_formKey.currentState!.validate()) {
  //     if (selectedLocationItem == null || selectedItem == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('⚠️ Please select both a location and a role!'), backgroundColor: Colors.orange),
  //       );
  //       return;
  //     }
  //
  //     // Show loading indicator
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('⏳ Adding user...'), backgroundColor: Colors.blue),
  //     );
  //
  //     AddUserApiService apiService = AddUserApiService();
  //
  //     try {
  //       SetStatus response = await apiService.addNewUser(
  //         uname: titleController.text.trim(),
  //         umobile: mobileController.text.trim(),
  //         email: emailController.text.trim(),
  //         pass: passwordController.text.trim(),
  //         siteid: selectedLocationItem ?? "",
  //         roleid: selectedItem ?? "",
  //       );
  //
  //       if (response.status == "1") {
  //         // Success message
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('✅ ${response.message}'), backgroundColor: Colors.green),
  //         );
  //         Navigator.pop(context); // Close the form page after success
  //       } else {
  //         // API returned an error
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('❌ ${response.message}'), backgroundColor: Colors.red),
  //         );
  //       }
  //     } catch (error) {
  //       // Handle network error
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('🚨 Error: $error'), backgroundColor: Colors.red),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('⚠️ Please fix the errors in the form!'), backgroundColor: Colors.orange),
  //     );
  //   }
  // }

  // Future<void> _insertUser() async {
  //   if (_formKey.currentState!.validate()) {
  //     // Show loading indicator (optional)
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Center(child: CircularProgressIndicator());
  //       },
  //     );
  //
  //     // Create instance of API service
  //     AddUserApiService apiService = AddUserApiService();
  //
  //     try {
  //       SetStatus response = await apiService.addNewUser(
  //         uname: titleController.text.trim(),
  //         umobile: mobileController.text.trim(),
  //         email: emailController.text.trim(),
  //         pass: passwordController.text.trim(),
  //         siteid: selectedLocationItem ?? "",
  //         roleid: selectedItem ?? "",
  //       );
  //
  //       // Close loading dialog
  //       Navigator.pop(context);
  //
  //       if (response.status == "1") {
  //         // Success
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(response.message), backgroundColor: Colors.green),
  //         );
  //         Navigator.pop(context); // Close the current screen
  //       } else {
  //         // Failure
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(response.message), backgroundColor: Colors.red),
  //         );
  //       }
  //     } catch (error) {
  //       // Close loading dialog
  //       Navigator.pop(context);
  //
  //       // Handle API error
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("❌ Error: $error"), backgroundColor: Colors.red),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('⚠️ Please fix the issues in the form!'), backgroundColor: Colors.orange),
  //     );
  //   }
  // }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    // Define a form key to control the form validation
    final context = this.context;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final primaryColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(11),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: primaryColor,
              ),
              child: Center(
                child: Text(
                  // 'Add New User',
                  AppLocalizations.of(context)!.addnewuser,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 21),

            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // User Name Input Field
                    TextFormField(
                      controller: titleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        filled: true,
                        // Enable background color
                        fillColor: Colors.grey[100],
                        // Light grey background color
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        // Reduce size
                        hintText: AppLocalizations.of(context)!.username,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // No border by default
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                          // Green border on focus
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          // Transparent border when enabled
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.username,
                          style: TextStyle(color: Colors.black), // Green label
                        ),
                      ),
                      // Add validator for title field
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'User Name cannot be empty';
                        }
                        if (value.length > maxTitleLength) {
                          return 'User Name cannot exceed $maxTitleLength characters';
                        }
                        return null;
                      },
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),

                    SizedBox(height: 11),
                    // Mobile number Input Field
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: mobileController,
                      autofocus: false,
                      // decoration: InputDecoration(
                      //   filled: true, // Enable background color
                      //   fillColor: Colors.grey[100],
                      //   contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Reduce size
                      //   hintText: "Mobile number",
                      //   hintStyle: TextStyle(color: Colors.grey),
                      //   border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   focusedBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.green), // Green color on focus
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   enabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.grey), // Green color when enabled
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   label: Text(
                      //     'Mobile number',
                      //     style: TextStyle(color: Colors.black), // Green label
                      //   ),
                      // ),
                      // Add validator for title field
                      decoration: InputDecoration(
                        filled: true,
                        // Enable background color
                        fillColor: Colors.grey[100],
                        // Light grey background color
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        // Reduce size
                        hintText: AppLocalizations.of(context)!.mobilenumber,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // No border by default
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                          // Green border on focus
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          // Transparent border when enabled
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.mobilenumber,
                          style: TextStyle(color: Colors.black), // Green label
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mobile number cannot be empty';
                        }
                        if (value.length != 10) {
                          return 'Mobile number must be exactly 10 digits';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Mobile number must contain only digits';
                        }
                        return null; // Return null if all validations pass
                      },
                      // style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: null,
                      textAlign: TextAlign.start,
                    ),

                    SizedBox(height: 11),
                    // Email address Input Field
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        // Enable background color
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        // Reduce size
                        // hintText: "Email",
                        hintText: AppLocalizations.of(context)!.email,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // No border by default
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                          // Green border on focus
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          // Transparent border when enabled
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.email,
                          style: TextStyle(color: Colors.black), // Green label
                        ),
                      ),
                      // Add validator for title field
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        // if (value.length > maxTitleLength) {
                        //   return ' cannot exceed $maxTitleLength characters';
                        // }
                        return null;
                      },
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                      ),
                      maxLines: null,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 11),
                    // Email address Input Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      // Hide password with dots
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        // hintText: "Password",
                        hintText: AppLocalizations.of(context)!.password,
                        hintStyle: TextStyle(color: Colors.grey),
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
                        // labelText: 'Password',
                        labelText: AppLocalizations.of(context)!.password,
                        labelStyle: TextStyle(color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        letterSpacing:
                            _obscureText
                                ? 2.0
                                : 0.0, // Makes password look masked
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),

                    SizedBox(height: 11),
                    // Confirm Password Input Field
                    TextFormField(
                      controller: confPasswordController,
                      obscureText: _obscureText,
                      // Hide confirm password with dots
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        // hintText: "Confirm Password",
                        hintText: AppLocalizations.of(context)!.confirmpass,
                        hintStyle: TextStyle(color: Colors.grey),
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
                        label: Text(
                          AppLocalizations.of(context)!.confirmpass,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      //  style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),

                    SizedBox(height: 11),
                    _buildRoleSpinner(),
                    SizedBox(height: 11),

                    _buildLocationSpinner(),

                    SizedBox(height: 11),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            width: double.infinity,
                            // Expanded will handle the width
                            height: 50,
                            // Adjust as needed
                            text: AppLocalizations.of(context)!.submitbtn,
                            backgroundColor: Colors.green,
                            // Customize color if needed
                            textColor: Colors.white,
                            borderRadius: 11.0,

                            onPressed: () async {
                              //  print("🟡 Save button pressed");
                              //final localContext = context;
                              if (formKey.currentState!.validate()) {
                                //print("✅ Form validated");

                                if (selectedLocationItem == null ||
                                    selectedRoleId == null) {
                                  //print("⚠️ Location or Role not selected");
                                  return;
                                }

                                String uname = titleController.text.trim();
                                String umobile = mobileController.text.trim();
                                String email = emailController.text.trim();
                                String pass = passwordController.text.trim();

                                if (uname.isEmpty ||
                                    umobile.isEmpty ||
                                    email.isEmpty ||
                                    pass.isEmpty) {
                                  //print("⚠️ One or more fields are empty");
                                  return;
                                }

                                try {
                                  final response = await AddUserApiService()
                                      .addNewUser(
                                        uname: uname,
                                        umobile: umobile,
                                        email: email,
                                        pass: pass,
                                        siteid: selectedLocationItem!,
                                        roleid: selectedRoleId.toString(),
                                      );

                                  // print("🔵 API Response Status: ${response.status}");
                                  // print("🔵 API Response Message: ${response.message}");
                                  if (context.mounted) {
                                    if (response.status == "1") {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "User added successfully!",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(response.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  }
                                } catch (e) {
                                  //print(" API Call Exception: $e");
                                }
                              } else {
                                //print("Form validation failed");
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 11),
                        Expanded(
                          child: CustomElevatedButton(
                            width: double.infinity,
                            // Expanded will handle the width
                            height: 50,
                            // Adjust as needed
                            text: AppLocalizations.of(context)!.cancelbtn,
                            backgroundColor: Colors.red,
                            // Customize color if needed
                            textColor: Colors.white,
                            borderRadius: 11.0,
                            onPressed: () {
                              Navigator.pop(
                                context,
                              ); // Cancel and return to Previous Page
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text("Loading..."),
              ],
            ),
          ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  Widget _buildRoleSpinner() {
    return DropdownButtonFormField<int>(
      initialValue: spinnerItemsRoles.isNotEmpty ? selectedRoleId : 0,
      // Prevents error
      items:
          spinnerItemsRoles.map((role) {
            return DropdownMenuItem<int>(
              value: role.roleId, // Stores role ID
              child: Text(role.roleName), // Displays role name
            );
          }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          selectedRoleId = newValue!;

          //print("Selected role ID: ${selectedRoleId}");
        });
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
        labelText: AppLocalizations.of(context)!.select_role,
        labelStyle: TextStyle(color: Colors.black),
      ),
      dropdownColor: Colors.white,
      validator: (value) {
        if (value == null) {
          return 'Please select a role'; // Validation message
        }
        return null; // Return null if validation passes
      },
    );
  }

  Widget _buildLocationSpinner() {
    return DropdownButtonFormField<LocationList>(
      initialValue: selectedLocation,
      isExpanded: true,
      items:
          spinnerItems.map((LocationList location) {
            return DropdownMenuItem<LocationList>(
              value: location, // Store entire object
              child: Text(location.locationName), // Display location name
            );
          }).toList(),

      onChanged: (LocationList? newValue) {
        setState(() {
          selectedLocationItem = newValue?.locationId.toString();
          //print("Selected Location ID: ${newValue?.locationId}");// Ensure this is set correctly
        });
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
        labelText: AppLocalizations.of(context)!.select_location,
        labelStyle: TextStyle(color: Colors.black),
      ),
      dropdownColor: Colors.white,
      validator: (value) {
        if (value == null) {
          return 'Please select a Location'; // Validation message
        }
        return null; // Return null if validation passes
      },
    );
  }

  Widget buildVendorList() {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _userList.length, // Use the actual number of users
          itemBuilder: (context, index) {
            final user = _userList[index]; // Get the user at the current index

            return Card(
              color: Colors.white,
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.green,
                      ),
                    ),

                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            user.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    subtitle: Row(
                      children: [
                        Text(
                          user.joindate,
                          //   "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}", // Time
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (expandedItems[user.userid] ?? false)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildInfoRow('Email', user.useremail),
                          // Use user's email
                          SizedBox(height: 8),
                          _buildInfoRow('Mobile Number', user.usermobile),
                          // Use user's mobile number
                          SizedBox(height: 8),
                          _buildInfoRow(
                            'Vendor SapID',
                            user.vendorid == "0"
                                ? "HH32"
                                : user.vendorid.toString(),
                          ),
                          // Use user's vendorSapId
                          SizedBox(height: 16),
                          CustomElevatedButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
                            onPressed: () {
                              int userId = user.userid;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => VendorHomePage(
                                        uid: userId,
                                        uname: widget.uname,
                                        role: widget.role,
                                        locationid: widget.locationid,
                                        uprofileid: widget.uprofileid,

                                      ),
                                ),
                              );
                            },
                            // text: 'Open Profile',
                            text: AppLocalizations.of(context)!.open_profile,
                            backgroundColor: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          (expandedItems[user.userid] ?? false)
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        // Use user.id or index
                        onPressed: () {
                          setState(() {
                            expandedItems[user.userid] =
                                !(expandedItems[user.userid] ??
                                    false); // Toggle the expansion state for this user
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildQATesterList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _userList.length, // Use the actual number of users
          itemBuilder: (context, index) {
            final user = _userList[index]; // Get the user at the current index

            return Card(
              color: Colors.white,
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.green,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            user.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,

                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          user.joindate,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (expandedItems[user.userid] ??
                      false) // Use user.id or index
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildInfoRow('Email', user.useremail),
                          // Use user's email
                          SizedBox(height: 8),
                          _buildInfoRow('Mobile Number', user.usermobile),
                          // Use user's mobile number
                          SizedBox(height: 8),
                          _buildInfoRow(
                            'Vendor SapID',
                            user.vendorid == "0"
                                ? "HH32"
                                : user.vendorid.toString(),
                          ),
                          // Use user's vendorSapId
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          (expandedItems[user.userid] ?? false)
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        // Use user.id or index
                        onPressed: () {
                          setState(() {
                            expandedItems[user.userid] =
                                !(expandedItems[user.userid] ??
                                    false); // Toggle the expansion state for this user
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildMOList() {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _userList.length, // Use the actual number of users
          itemBuilder: (context, index) {
            final user = _userList[index]; // Get the user at the current index

            return Card(
              color: Colors.white,
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.green,
                      ),
                    ),

                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            user.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    subtitle: Row(
                      children: [
                        Text(
                          user.joindate,
                          //   "${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}", // Time
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (expandedItems[user.userid] ?? false)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildInfoRow('Email', user.useremail),
                          // Use user's email
                          SizedBox(height: 8),
                          _buildInfoRow('Mobile Number', user.usermobile),
                          // Use user's mobile number
                          SizedBox(height: 8),
                          _buildInfoRow(
                            'Vendor SapID',
                            user.vendorid == "0"
                                ? "HH32"
                                : user.vendorid.toString(),
                          ),
                          // Use user's vendorSapId
                          SizedBox(height: 16),
                          CustomElevatedButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MOHomePage(
                                        sitename: widget.sitename,
                                        locationid: widget.locationid!,
                                        userid: user.userid,
                                        uprofileid: widget.uprofileid,
                                        role: widget.role,
                                        uname: widget.uname,
                                      ),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.open_profile,
                            //text: 'Open Profile',
                            backgroundColor: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          (expandedItems[user.userid] ?? false)
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        // Use user.id or index
                        onPressed: () {
                          setState(() {
                            expandedItems[user.userid] =
                                !(expandedItems[user.userid] ??
                                    false); // Toggle the expansion state for this user
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Widget _buildInputField({
  //   required TextEditingController controller,
  //   required String label,
  //   required String hint,
  //    IconData? icon,
  //   required bool isPassword,
  //   String? Function(String?)? validator,
  // }) {
  //   return TextField(
  //     controller: controller,
  //     obscureText: isPassword ? _isObscured : false,
  //     style: GoogleFonts.poppins(
  //       fontSize: 15,
  //       color: Colors.black87,
  //     ),
  //
  //     decoration: InputDecoration(
  //       filled: true, // Enable background color
  //       fillColor: Colors.grey[100], // Light grey background color
  //       contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Reduce size
  //       hintText: hint,
  //       hintStyle: TextStyle(color: Colors.grey.
  //       shade600),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide.none, // No border by default
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Colors.green, width: 2), // Green border on focus
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Colors.grey), // Transparent border when enabled
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       label: Text(label,style: TextStyle(color: Colors.black),),
  //       // prefixIcon: Icon(
  //       //   icon,
  //       //   color: Colors.grey[600],
  //       //   size: 22,
  //       // ),
  //       suffixIcon: isPassword
  //           ? IconButton(
  //         icon: Icon(
  //           _isObscured ? Icons.visibility_off : Icons.visibility,
  //           color: Colors.grey[600],
  //           size: 22,
  //         ),
  //         onPressed: () => setState(() => _isObscured = !_isObscured),
  //       )
  //           : null,
  //       // label: Text(
  //       //   'User Name',
  //       //   style: TextStyle(color: Colors.black), // Green label
  //       // ),
  //     ),
  //     validator: validator,
  //   );
  // }
  // Widget _buildInfoRow(String title, String value) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
  //       Text(value),
  //     ],
  //   );
  // }
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,   // ← important
        children: [
          SizedBox(
            width: 110,                                 // fixed width for label
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(                                     // ← this allows wrapping
            child: Text(
              value,
              softWrap: true,                           // allow line breaks
              overflow: TextOverflow.visible,           // or clip / fade — visible is usually best here
              style: const TextStyle(
                height: 1.3,                            // a bit more readable when wrapped
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const CustomElevatedButton({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.borderRadius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
