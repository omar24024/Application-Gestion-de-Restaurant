import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant App'**
  String get appTitle;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'My cart'**
  String get cart;

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My cart'**
  String get myCart;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get orders;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get myOrders;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

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

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @refuse.
  ///
  /// In en, this message translates to:
  /// **'Refuse'**
  String get refuse;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noOrders;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty cart'**
  String get cartEmpty;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? Register'**
  String get noAccount;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'added!'**
  String get added;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get confirmOrder;

  /// No description provided for @confirmOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to confirm your order?'**
  String get confirmOrderQuestion;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @orderSent.
  ///
  /// In en, this message translates to:
  /// **'Order sent!'**
  String get orderSent;

  /// No description provided for @restaurantProcessing.
  ///
  /// In en, this message translates to:
  /// **'The restaurant will process your order.'**
  String get restaurantProcessing;

  /// No description provided for @viewMyOrders.
  ///
  /// In en, this message translates to:
  /// **'View my orders'**
  String get viewMyOrders;

  /// No description provided for @orderError.
  ///
  /// In en, this message translates to:
  /// **'Order error. Please try again!'**
  String get orderError;

  /// No description provided for @sendingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sendingInProgress;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get orderNumber;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addToCart;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @locationSent.
  ///
  /// In en, this message translates to:
  /// **'Location sent'**
  String get locationSent;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'GPS not available'**
  String get locationNotAvailable;

  /// No description provided for @payOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Pay on delivery'**
  String get payOnDelivery;

  /// No description provided for @gpsSent.
  ///
  /// In en, this message translates to:
  /// **'GPS will be sent'**
  String get gpsSent;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please login.'**
  String get accountCreated;

  /// No description provided for @addDish.
  ///
  /// In en, this message translates to:
  /// **'Add a dish'**
  String get addDish;

  /// No description provided for @editDish.
  ///
  /// In en, this message translates to:
  /// **'Edit dish'**
  String get editDish;

  /// No description provided for @tapToChooseImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose an image'**
  String get tapToChooseImage;

  /// No description provided for @dishName.
  ///
  /// In en, this message translates to:
  /// **'Dish name'**
  String get dishName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @priceDA.
  ///
  /// In en, this message translates to:
  /// **'Price (DA)'**
  String get priceDA;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @menuManagement.
  ///
  /// In en, this message translates to:
  /// **'Menu management'**
  String get menuManagement;

  /// No description provided for @noDishesAddSome.
  ///
  /// In en, this message translates to:
  /// **'No dishes — add some!'**
  String get noDishesAddSome;

  /// No description provided for @deleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteQuestion;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details #'**
  String get orderDetails;

  /// No description provided for @deliveryInformation.
  ///
  /// In en, this message translates to:
  /// **'Delivery information'**
  String get deliveryInformation;

  /// No description provided for @positionNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Position not available'**
  String get positionNotAvailable;

  /// No description provided for @orderedItems.
  ///
  /// In en, this message translates to:
  /// **'Ordered items'**
  String get orderedItems;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItems;

  /// No description provided for @unknownDish.
  ///
  /// In en, this message translates to:
  /// **'Unknown dish'**
  String get unknownDish;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity:'**
  String get quantity;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @pendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending orders'**
  String get pendingOrders;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @refused.
  ///
  /// In en, this message translates to:
  /// **'Refused'**
  String get refused;

  /// No description provided for @noOrdersInHistory.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noOrdersInHistory;

  /// No description provided for @noPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'No pending orders'**
  String get noPendingOrders;

  /// No description provided for @acceptedStatus.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedStatus;

  /// No description provided for @refusedStatus.
  ///
  /// In en, this message translates to:
  /// **'Refused'**
  String get refusedStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @gpsAvailable.
  ///
  /// In en, this message translates to:
  /// **'GPS available'**
  String get gpsAvailable;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get totalRevenue;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total orders'**
  String get totalOrders;

  /// No description provided for @dashboardRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Dashboard'**
  String get dashboardRestaurant;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @acceptedOrders.
  ///
  /// In en, this message translates to:
  /// **'Accepted orders'**
  String get acceptedOrders;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get orderHistory;

  /// No description provided for @acceptedAndRefused.
  ///
  /// In en, this message translates to:
  /// **'Accepted and refused'**
  String get acceptedAndRefused;

  /// No description provided for @manageMenu.
  ///
  /// In en, this message translates to:
  /// **'Manage menu'**
  String get manageMenu;

  /// No description provided for @addEditDeleteDishes.
  ///
  /// In en, this message translates to:
  /// **'Add, edit, delete dishes'**
  String get addEditDeleteDishes;

  /// No description provided for @revenueAndOrders.
  ///
  /// In en, this message translates to:
  /// **'Revenue and orders'**
  String get revenueAndOrders;

  /// No description provided for @newOrders.
  ///
  /// In en, this message translates to:
  /// **'{count} new order(s)'**
  String newOrders(String count);

  /// No description provided for @noDishAvailable.
  ///
  /// In en, this message translates to:
  /// **'No dishes available'**
  String get noDishAvailable;

  /// No description provided for @gpsLocationWillBeSent.
  ///
  /// In en, this message translates to:
  /// **'GPS location will be sent'**
  String get gpsLocationWillBeSent;

  /// No description provided for @paymentOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Payment on delivery'**
  String get paymentOnDelivery;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
