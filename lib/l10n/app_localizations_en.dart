// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Restaurant App';

  @override
  String get menu => 'Menu';

  @override
  String get cart => 'My cart';

  @override
  String get myCart => 'My cart';

  @override
  String get orders => 'My orders';

  @override
  String get myOrders => 'My orders';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full name';

  @override
  String get order => 'Order';

  @override
  String get total => 'Total';

  @override
  String get accept => 'Accept';

  @override
  String get refuse => 'Refuse';

  @override
  String get noOrders => 'No orders';

  @override
  String get cartEmpty => 'Empty cart';

  @override
  String get noAccount => 'No account? Register';

  @override
  String get added => 'added!';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get confirmOrder => 'Confirm order';

  @override
  String get confirmOrderQuestion => 'Do you want to confirm your order?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get orderSent => 'Order sent!';

  @override
  String get restaurantProcessing => 'The restaurant will process your order.';

  @override
  String get viewMyOrders => 'View my orders';

  @override
  String get orderError => 'Order error. Please try again!';

  @override
  String get sendingInProgress => 'Sending...';

  @override
  String get orderNumber => 'Order #';

  @override
  String get addToCart => 'Add';

  @override
  String get logout => 'Logout';

  @override
  String get locationSent => 'Location sent';

  @override
  String get locationNotAvailable => 'GPS not available';

  @override
  String get payOnDelivery => 'Pay on delivery';

  @override
  String get gpsSent => 'GPS will be sent';

  @override
  String get accountCreated => 'Account created! Please login.';

  @override
  String get addDish => 'Add a dish';

  @override
  String get editDish => 'Edit dish';

  @override
  String get tapToChooseImage => 'Tap to choose an image';

  @override
  String get dishName => 'Dish name';

  @override
  String get description => 'Description';

  @override
  String get priceDA => 'Price (DA)';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get menuManagement => 'Menu management';

  @override
  String get noDishesAddSome => 'No dishes — add some!';

  @override
  String get deleteQuestion => 'Delete?';

  @override
  String deleteConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get orderDetails => 'Order Details #';

  @override
  String get deliveryInformation => 'Delivery information';

  @override
  String get positionNotAvailable => 'Position not available';

  @override
  String get orderedItems => 'Ordered items';

  @override
  String get noItems => 'No items';

  @override
  String get unknownDish => 'Unknown dish';

  @override
  String get quantity => 'Quantity:';

  @override
  String get history => 'History';

  @override
  String get pendingOrders => 'Pending orders';

  @override
  String get all => 'All';

  @override
  String get accepted => 'Accepted';

  @override
  String get refused => 'Refused';

  @override
  String get noOrdersInHistory => 'No orders';

  @override
  String get noPendingOrders => 'No pending orders';

  @override
  String get acceptedStatus => 'Accepted';

  @override
  String get refusedStatus => 'Refused';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get unknown => 'Unknown';

  @override
  String get gpsAvailable => 'GPS available';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalRevenue => 'Total revenue';

  @override
  String get totalOrders => 'Total orders';

  @override
  String get dashboardRestaurant => 'Restaurant Dashboard';

  @override
  String get welcome => 'Welcome!';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get pending => 'Pending';

  @override
  String get acceptedOrders => 'Accepted orders';

  @override
  String get orderHistory => 'Order history';

  @override
  String get acceptedAndRefused => 'Accepted and refused';

  @override
  String get manageMenu => 'Manage menu';

  @override
  String get addEditDeleteDishes => 'Add, edit, delete dishes';

  @override
  String get revenueAndOrders => 'Revenue and orders';

  @override
  String newOrders(String count) {
    return '$count new order(s)';
  }

  @override
  String get noDishAvailable => 'No dishes available';

  @override
  String get gpsLocationWillBeSent => 'GPS location will be sent';

  @override
  String get paymentOnDelivery => 'Payment on delivery';
}
