import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/active_delivery_tracking/active_delivery_tracking.dart';
import '../presentation/driver_dashboard/driver_dashboard.dart';
import '../presentation/load_search_and_browse/load_search_and_browse.dart';
import '../presentation/shipper_dashboard/shipper_dashboard.dart';
import '../presentation/load_details/load_details.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String activeDeliveryTracking = '/active-delivery-tracking';
  static const String driverDashboard = '/driver-dashboard';
  static const String loadSearchAndBrowse = '/load-search-and-browse';
  static const String shipperDashboard = '/shipper-dashboard';
  static const String loadDetails = '/load-details';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    activeDeliveryTracking: (context) => const ActiveDeliveryTracking(),
    driverDashboard: (context) => const DriverDashboard(),
    loadSearchAndBrowse: (context) => const LoadSearchAndBrowse(),
    shipperDashboard: (context) => const ShipperDashboard(),
    loadDetails: (context) => const LoadDetails(),
    // TODO: Add your other routes here
  };
}
