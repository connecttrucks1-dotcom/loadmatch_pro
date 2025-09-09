import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/active_delivery_banner.dart';
import './widgets/availability_toggle_card.dart';
import './widgets/earnings_summary_card.dart';
import './widgets/nearby_load_card.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool _isOnline = true;
  bool _isRefreshing = false;
  int _currentBottomNavIndex = 0;

  // Mock data for driver dashboard
  final Map<String, dynamic> _driverData = {
    "currentLocation": "Downtown Chicago, IL",
    "todayEarnings": 245.50,
    "weeklyEarnings": 1850.75,
    "completedDeliveries": 12,
  };

  final Map<String, dynamic> _activeDelivery = {
    "pickupLocation": "Walmart Distribution Center, Chicago, IL",
    "deliveryLocation": "Target Store, Milwaukee, WI",
    "status": "In Transit",
    "progress": 0.65,
    "estimatedTime": "2:30 PM",
  };

  final List<Map<String, dynamic>> _nearbyLoads = [
    {
      "id": 1,
      "pickupLocation": "Amazon Fulfillment Center, Joliet, IL",
      "deliveryLocation": "Best Buy Distribution, Madison, WI",
      "distance": 145.2,
      "payment": 850.0,
      "cargoType": "Electronics",
      "weight": "15,000 lbs",
      "urgency": "Standard",
      "postedTime": "2 hours ago",
    },
    {
      "id": 2,
      "pickupLocation": "Home Depot Warehouse, Aurora, IL",
      "deliveryLocation": "Menards Store, Green Bay, WI",
      "distance": 198.5,
      "payment": 1200.0,
      "cargoType": "Building Materials",
      "weight": "22,500 lbs",
      "urgency": "Urgent",
      "postedTime": "45 minutes ago",
    },
    {
      "id": 3,
      "pickupLocation": "Costco Distribution, Schaumburg, IL",
      "deliveryLocation": "Sam's Club, Rockford, IL",
      "distance": 87.3,
      "payment": 650.0,
      "cargoType": "General Merchandise",
      "weight": "18,750 lbs",
      "urgency": "High",
      "postedTime": "1 hour ago",
    },
    {
      "id": 4,
      "pickupLocation": "FedEx Ground Hub, Bedford Park, IL",
      "deliveryLocation": "UPS Facility, Kenosha, WI",
      "distance": 112.8,
      "payment": 750.0,
      "cargoType": "Packages",
      "weight": "12,000 lbs",
      "urgency": "Standard",
      "postedTime": "3 hours ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'LoadMatch Pro',
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // Status indicators
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  children: [
                    _buildStatusIndicator(
                        'GPS', true, AppTheme.lightTheme.colorScheme.tertiary),
                    SizedBox(width: 3.w),
                    _buildStatusIndicator('Network', true,
                        AppTheme.lightTheme.colorScheme.tertiary),
                    const Spacer(),
                    Text(
                      'Last updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Availability toggle card
            SliverToBoxAdapter(
              child: AvailabilityToggleCard(
                isOnline: _isOnline,
                currentLocation: _driverData['currentLocation'] as String,
                onToggle: _toggleAvailability,
              ),
            ),

            // Active delivery banner (if applicable)
            if (_isOnline && _activeDelivery.isNotEmpty)
              SliverToBoxAdapter(
                child: ActiveDeliveryBanner(
                  activeDelivery: _activeDelivery,
                  onUpdateStatus: _updateDeliveryStatus,
                  onViewDetails: () => _navigateToActiveDelivery(),
                ),
              ),

            // Earnings summary card
            SliverToBoxAdapter(
              child: EarningsSummaryCard(
                todayEarnings: _driverData['todayEarnings'] as double,
                weeklyEarnings: _driverData['weeklyEarnings'] as double,
                completedDeliveries: _driverData['completedDeliveries'] as int,
              ),
            ),

            // Nearby loads section header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Text(
                      'Nearby Loads',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/load-search-and-browse'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View All',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Nearby loads list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final load = _nearbyLoads[index];
                  return NearbyLoadCard(
                    loadData: load,
                    onViewDetails: () => _viewLoadDetails(load),
                    onQuickAccept: () => _quickAcceptLoad(load),
                    onSaveForLater: () => _saveLoadForLater(load),
                    onShare: () => _shareLoad(load),
                    onReport: () => _reportLoad(load),
                  );
                },
                childCount: _nearbyLoads.length,
              ),
            ),

            // Bottom padding
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      floatingActionButton: _isOnline
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamed(context, '/load-search-and-browse'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'search',
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                'Find Loads',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isActive, Color activeColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor
                : AppTheme.lightTheme.colorScheme.outline,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isActive
                ? activeColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard updated'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleAvailability() {
    HapticFeedback.selectionClick();
    setState(() => _isOnline = !_isOnline);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline
            ? 'You are now online and receiving loads'
            : 'You are now offline'),
        backgroundColor: _isOnline
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _updateDeliveryStatus() {
    Navigator.pushNamed(context, '/active-delivery-tracking');
  }

  void _navigateToActiveDelivery() {
    Navigator.pushNamed(context, '/active-delivery-tracking');
  }

  void _viewLoadDetails(Map<String, dynamic> load) {
    Navigator.pushNamed(context, '/load-details', arguments: load);
  }

  void _quickAcceptLoad(Map<String, dynamic> load) {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Load'),
        content: Text(
            'Are you sure you want to accept this ${load['cargoType']} load for \$${(load['payment'] as double).toStringAsFixed(0)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmLoadAcceptance(load);
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _confirmLoadAcceptance(Map<String, dynamic> load) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Load accepted! Check your active deliveries.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View',
          onPressed: () =>
              Navigator.pushNamed(context, '/active-delivery-tracking'),
        ),
      ),
    );
  }

  void _saveLoadForLater(Map<String, dynamic> load) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${load['cargoType']} load saved for later'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareLoad(Map<String, dynamic> load) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Load details shared'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportLoad(Map<String, dynamic> load) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content:
            const Text('What issue would you like to report with this load?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Issue reported. Thank you for your feedback.'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/load-search-and-browse');
        break;
      case 2:
        Navigator.pushNamed(context, '/active-delivery-tracking');
        break;
      case 3:
        // Show profile section (could be implemented as a drawer or separate screen)
        _showProfileOptions();
        break;
    }
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Profile Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_shipping',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Vehicle Information'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Delivery History'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}