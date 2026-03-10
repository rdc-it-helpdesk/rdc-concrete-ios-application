import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Your Dashboard'**
  String get title;

  /// No description provided for @user_management.
  ///
  /// In en, this message translates to:
  /// **'User  Management'**
  String get user_management;

  /// No description provided for @weighbridge_status.
  ///
  /// In en, this message translates to:
  /// **'Weighbridge Status'**
  String get weighbridge_status;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @current_location.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get current_location;

  /// No description provided for @fetch_po.
  ///
  /// In en, this message translates to:
  /// **'Fetch PO'**
  String get fetch_po;

  /// No description provided for @spares_and_expense.
  ///
  /// In en, this message translates to:
  /// **'Spares and Expense'**
  String get spares_and_expense;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @your_Dashboard.
  ///
  /// In en, this message translates to:
  /// **'Your Dashboard'**
  String get your_Dashboard;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @open_profile.
  ///
  /// In en, this message translates to:
  /// **'Open Profile'**
  String get open_profile;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get username;

  /// No description provided for @addnewuser.
  ///
  /// In en, this message translates to:
  /// **'Add New User'**
  String get addnewuser;

  /// No description provided for @mobilenumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobilenumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmpass.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmpass;

  /// No description provided for @submitbtn.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitbtn;

  /// No description provided for @cancelbtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelbtn;

  /// No description provided for @select_role.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get select_role;

  /// No description provided for @vendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get vendors;

  /// No description provided for @qa_tester.
  ///
  /// In en, this message translates to:
  /// **'QA Tester'**
  String get qa_tester;

  /// No description provided for @material_officer.
  ///
  /// In en, this message translates to:
  /// **'Material Officer'**
  String get material_officer;

  /// No description provided for @chalan_number_1.
  ///
  /// In en, this message translates to:
  /// **'Chalan Number 1'**
  String get chalan_number_1;

  /// No description provided for @chalan_number_2.
  ///
  /// In en, this message translates to:
  /// **'Chalan Number 2'**
  String get chalan_number_2;

  /// No description provided for @site_Name.
  ///
  /// In en, this message translates to:
  /// **'Site Name'**
  String get site_Name;

  /// No description provided for @vehicle_Number.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get vehicle_Number;

  /// No description provided for @driver_Name.
  ///
  /// In en, this message translates to:
  /// **'Driver Name'**
  String get driver_Name;

  /// No description provided for @net_Weight.
  ///
  /// In en, this message translates to:
  /// **'Net Weight'**
  String get net_Weight;

  /// No description provided for @chalan_Weight_1.
  ///
  /// In en, this message translates to:
  /// **'Chalan Weight 1'**
  String get chalan_Weight_1;

  /// No description provided for @chalan_Weight_2.
  ///
  /// In en, this message translates to:
  /// **'Material Officer'**
  String get chalan_Weight_2;

  /// No description provided for @royalty_Pass.
  ///
  /// In en, this message translates to:
  /// **'Royalty Pass'**
  String get royalty_Pass;

  /// No description provided for @last_Action.
  ///
  /// In en, this message translates to:
  /// **'Last Action'**
  String get last_Action;

  /// No description provided for @moisture.
  ///
  /// In en, this message translates to:
  /// **'Moisture %'**
  String get moisture;

  /// No description provided for @mrn_No.
  ///
  /// In en, this message translates to:
  /// **'MRN No'**
  String get mrn_No;

  /// No description provided for @search_PO_Numbar.
  ///
  /// In en, this message translates to:
  /// **'Search PO Numbar...'**
  String get search_PO_Numbar;

  /// No description provided for @new_Vendor_Available_to_Map.
  ///
  /// In en, this message translates to:
  /// **'New Vendor Available to Map'**
  String get new_Vendor_Available_to_Map;

  /// No description provided for @pO_Number.
  ///
  /// In en, this message translates to:
  /// **'PO Number'**
  String get pO_Number;

  /// No description provided for @uOM.
  ///
  /// In en, this message translates to:
  /// **'UOM'**
  String get uOM;

  /// No description provided for @line_ID.
  ///
  /// In en, this message translates to:
  /// **'Line ID'**
  String get line_ID;

  /// No description provided for @ship_To.
  ///
  /// In en, this message translates to:
  /// **'Ship To'**
  String get ship_To;

  /// No description provided for @bill_to.
  ///
  /// In en, this message translates to:
  /// **'Bill to'**
  String get bill_to;

  /// No description provided for @created_By.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get created_By;

  /// No description provided for @need_By.
  ///
  /// In en, this message translates to:
  /// **'Need By'**
  String get need_By;

  /// No description provided for @mapped.
  ///
  /// In en, this message translates to:
  /// **'Mapped'**
  String get mapped;

  /// No description provided for @mobile_Number.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile_Number;

  /// No description provided for @vendor_Name.
  ///
  /// In en, this message translates to:
  /// **'Vendor Name'**
  String get vendor_Name;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @pO_Details.
  ///
  /// In en, this message translates to:
  /// **'PO Details'**
  String get pO_Details;

  /// No description provided for @pO_Generate_Date.
  ///
  /// In en, this message translates to:
  /// **'PO Generate Date'**
  String get pO_Generate_Date;

  /// No description provided for @issue_Quality.
  ///
  /// In en, this message translates to:
  /// **'Issue Quality'**
  String get issue_Quality;

  /// No description provided for @available_Quality.
  ///
  /// In en, this message translates to:
  /// **'Available Quality'**
  String get available_Quality;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @line_ID_No.
  ///
  /// In en, this message translates to:
  /// **'Line ID No'**
  String get line_ID_No;

  /// No description provided for @created_by.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get created_by;

  /// No description provided for @on_Road_Orders.
  ///
  /// In en, this message translates to:
  /// **'On Road Orders'**
  String get on_Road_Orders;

  /// No description provided for @complete_Orders.
  ///
  /// In en, this message translates to:
  /// **'Complete Orders'**
  String get complete_Orders;

  /// No description provided for @rejected_Orders.
  ///
  /// In en, this message translates to:
  /// **'Rejected Orders'**
  String get rejected_Orders;

  /// No description provided for @order_Status.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get order_Status;

  /// No description provided for @transaction_Summary.
  ///
  /// In en, this message translates to:
  /// **'Transaction Summary'**
  String get transaction_Summary;

  /// No description provided for @update_location.
  ///
  /// In en, this message translates to:
  /// **'Update Location'**
  String get update_location;

  /// No description provided for @active_Now.
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get active_Now;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @location_Details.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get location_Details;

  /// No description provided for @current_Reading.
  ///
  /// In en, this message translates to:
  /// **'Current Reading'**
  String get current_Reading;

  /// No description provided for @po_Insert_Form.
  ///
  /// In en, this message translates to:
  /// **'PO Insert Form'**
  String get po_Insert_Form;

  /// No description provided for @vehicle_Details.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicle_Details;

  /// No description provided for @driver_Details.
  ///
  /// In en, this message translates to:
  /// **'Driver Details'**
  String get driver_Details;

  /// No description provided for @invoice_No.
  ///
  /// In en, this message translates to:
  /// **'Invoice No'**
  String get invoice_No;

  /// No description provided for @challan_No.
  ///
  /// In en, this message translates to:
  /// **'Challan No'**
  String get challan_No;

  /// No description provided for @weight_In_Kg.
  ///
  /// In en, this message translates to:
  /// **'Weight in KG'**
  String get weight_In_Kg;

  /// No description provided for @click_Here.
  ///
  /// In en, this message translates to:
  /// **'Click here'**
  String get click_Here;

  /// No description provided for @is_With_Invoice.
  ///
  /// In en, this message translates to:
  /// **'Is With Invoice'**
  String get is_With_Invoice;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @choose_File.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get choose_File;

  /// No description provided for @do_you_have_second_challan_with_same_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Do you have second challan with same vehicle?'**
  String get do_you_have_second_challan_with_same_vehicle;

  /// No description provided for @additional_Details_List.
  ///
  /// In en, this message translates to:
  /// **'Additional Details list'**
  String get additional_Details_List;

  /// No description provided for @additional_Weight_In_Kg.
  ///
  /// In en, this message translates to:
  /// **'Additional Weight in KG'**
  String get additional_Weight_In_Kg;

  /// No description provided for @selected_File.
  ///
  /// In en, this message translates to:
  /// **'Selected File'**
  String get selected_File;

  /// No description provided for @add_New_Driver.
  ///
  /// In en, this message translates to:
  /// **'Add New Driver'**
  String get add_New_Driver;

  /// No description provided for @enter_Driver_Name.
  ///
  /// In en, this message translates to:
  /// **'Enter Driver Name'**
  String get enter_Driver_Name;

  /// No description provided for @enter_Mobile_No.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile No'**
  String get enter_Mobile_No;

  /// No description provided for @savebtn.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get savebtn;

  /// No description provided for @map_to_vendor_Profile.
  ///
  /// In en, this message translates to:
  /// **'Map to Vendor Profile'**
  String get map_to_vendor_Profile;

  /// No description provided for @vendor_Email.
  ///
  /// In en, this message translates to:
  /// **'Vendor Email'**
  String get vendor_Email;

  /// No description provided for @vendor_Mobile.
  ///
  /// In en, this message translates to:
  /// **'Vendor Mobile'**
  String get vendor_Mobile;

  /// No description provided for @select_Vendor_id.
  ///
  /// In en, this message translates to:
  /// **'Select Vendor ID'**
  String get select_Vendor_id;

  /// No description provided for @select_Vendor.
  ///
  /// In en, this message translates to:
  /// **'Select Vendor'**
  String get select_Vendor;

  /// No description provided for @n_a.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get n_a;

  /// No description provided for @camera_Not_Working.
  ///
  /// In en, this message translates to:
  /// **'Camera not working'**
  String get camera_Not_Working;

  /// No description provided for @please_try_again.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get please_try_again;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @qa_mo.
  ///
  /// In en, this message translates to:
  /// **'QA/MO'**
  String get qa_mo;

  /// No description provided for @map_Fastag.
  ///
  /// In en, this message translates to:
  /// **'Map Fastag'**
  String get map_Fastag;

  /// No description provided for @truck_Is_Ok.
  ///
  /// In en, this message translates to:
  /// **'Truck is Ok'**
  String get truck_Is_Ok;

  /// No description provided for @truck_Is_Not_Ok.
  ///
  /// In en, this message translates to:
  /// **'Truck is not Ok'**
  String get truck_Is_Not_Ok;

  /// No description provided for @dont_reach_the_plant.
  ///
  /// In en, this message translates to:
  /// **'Don\'t reach the Plant !!!'**
  String get dont_reach_the_plant;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @fastag_Is_Not_Tapped.
  ///
  /// In en, this message translates to:
  /// **'Fastag is Not Tapped!'**
  String get fastag_Is_Not_Tapped;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @view_Invoice.
  ///
  /// In en, this message translates to:
  /// **'View Invoice'**
  String get view_Invoice;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @driver_Contact.
  ///
  /// In en, this message translates to:
  /// **'Driver Contact'**
  String get driver_Contact;

  /// No description provided for @creation_Time.
  ///
  /// In en, this message translates to:
  /// **'Creation Time'**
  String get creation_Time;

  /// No description provided for @vendor_Details.
  ///
  /// In en, this message translates to:
  /// **'Vendor Details'**
  String get vendor_Details;

  /// No description provided for @vendor_Contact.
  ///
  /// In en, this message translates to:
  /// **'Vendor Contact'**
  String get vendor_Contact;

  /// No description provided for @rfid_Information.
  ///
  /// In en, this message translates to:
  /// **'RFID Information'**
  String get rfid_Information;

  /// No description provided for @rfid_1.
  ///
  /// In en, this message translates to:
  /// **'RFID 1'**
  String get rfid_1;

  /// No description provided for @rfid_2.
  ///
  /// In en, this message translates to:
  /// **'RFID 2'**
  String get rfid_2;

  /// No description provided for @accept_Driver.
  ///
  /// In en, this message translates to:
  /// **'Accept Driver'**
  String get accept_Driver;

  /// No description provided for @reach_Rdc_Plant.
  ///
  /// In en, this message translates to:
  /// **'Reach RDC Plant?'**
  String get reach_Rdc_Plant;

  /// No description provided for @driver_is_allowed_to_enter_in_plant.
  ///
  /// In en, this message translates to:
  /// **'Driver Is Allowed to Enter In Plant'**
  String get driver_is_allowed_to_enter_in_plant;

  /// No description provided for @gross_Weight.
  ///
  /// In en, this message translates to:
  /// **'Gross Weight'**
  String get gross_Weight;

  /// No description provided for @fastag_is_Not_Mapped.
  ///
  /// In en, this message translates to:
  /// **'Fastag is Not Mapped!'**
  String get fastag_is_Not_Mapped;

  /// No description provided for @order_Information.
  ///
  /// In en, this message translates to:
  /// **'Order Information'**
  String get order_Information;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @otp_has_been_sent.
  ///
  /// In en, this message translates to:
  /// **'OTP has been Sent'**
  String get otp_has_been_sent;

  /// No description provided for @capture_Weight.
  ///
  /// In en, this message translates to:
  /// **'Capture weight'**
  String get capture_Weight;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning!'**
  String get warning;

  /// No description provided for @do_you_want_to_reject_this_record.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reject this record?'**
  String get do_you_want_to_reject_this_record;

  /// No description provided for @enter_Vehicle_Number.
  ///
  /// In en, this message translates to:
  /// **'Enter Vehicle Number'**
  String get enter_Vehicle_Number;

  /// No description provided for @enter_Fastag_No.
  ///
  /// In en, this message translates to:
  /// **'Enter FASTAG No.'**
  String get enter_Fastag_No;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @map_TM.
  ///
  /// In en, this message translates to:
  /// **'Map tm'**
  String get map_TM;

  /// No description provided for @select_Rfid_Type.
  ///
  /// In en, this message translates to:
  /// **'Select RFID Type: '**
  String get select_Rfid_Type;

  /// No description provided for @rfid.
  ///
  /// In en, this message translates to:
  /// **'RFID'**
  String get rfid;

  /// No description provided for @fastag_No.
  ///
  /// In en, this message translates to:
  /// **'FASTAG NO.'**
  String get fastag_No;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
