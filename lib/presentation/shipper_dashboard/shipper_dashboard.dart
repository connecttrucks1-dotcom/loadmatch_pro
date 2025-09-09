import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/active_shipments_card.dart';
import './widgets/emergency_contact_button.dart';
import './widgets/post_load_button.dart';
import './widgets/quick_stats_section.dart';
import './widgets/recent_activity_feed.dart';

class ShipperDashboard extends StatefulWidget {
  const ShipperDashboard({super.key});

  @override
  State<ShipperDashboard> createState() => _ShipperDashboardState();
}

class _ShipperDashboardState extends State<ShipperDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;

  // Mock data for active shipments
  final List<Map<String, dynamic>> _activeShipments = [
    {
      "loadId": "LD001234",
      "status": "In-Transit",
      "origin": "Chicago, IL",
      "destination": "Miami, FL",
      "deliveryDate": "Dec 12, 2024",
      "rate": "\$2,450",
      "progress": 65.0,
      "driverName": "Mike Johnson",
      "driverPhone": "+1-555-0123",
      "cargoType": "Electronics",
      "weight": "15,000 lbs"
    },
    {
      "loadId": "LD001235",
      "status": "Accepted",
      "origin": "Dallas, TX",
      "destination": "Phoenix, AZ",
      "deliveryDate": "Dec 10, 2024",
      "rate": "\$1,850",
      "progress": 0.0,
      "driverName": "Sarah Wilson",
      "driverPhone": "+1-555-0124",
      "cargoType": "Furniture",
      "weight": "12,500 lbs"
    },
    {
      "loadId": "LD001236",
      "status": "Posted",
      "origin": "Seattle, WA",
      "destination": "Portland, OR",
      "deliveryDate": "Dec 15, 2024",
      "rate": "\$950",
      "progress": 0.0,
      "driverName": "",
      "driverPhone": "",
      "cargoType": "Food Products",
      "weight": "8,000 lbs"
    }
  ];

  // Mock data for quick stats
  final Map<String, dynamic> _statsData = {
    "totalLoads": 47,
    "avgDeliveryTime": 3.2,
    "costSavings": "18%"
  };

  // Mock data for recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      "type": "driver_acceptance",
      "title": "Load Accepted",
      "description": "Sarah Wilson accepted load LD001235 to Phoenix",
      "timestamp": "2 hours ago",
      "actionRequired": false
    },
    {
      "type": "delivery_update",
      "title": "Delivery Update",
      "description": "Load LD001234 is 65% complete - currently in Atlanta",
      "timestamp": "4 hours ago",
      "actionRequired": false
    },
    {
      "type": "rating_received",
      "title": "Rating Received",
      "description": "Mike Johnson rated your shipment 5 stars",
      "timestamp": "1 day ago",
      "actionRequired": false
    },
    {
      "type": "payment_processed",
      "title": "Payment Processed",
      "description": "Payment of \$2,100 processed for load LD001230",
      "timestamp": "1 day ago",
      "actionRequired": false
    },
    {
      "type": "message_received",
      "title": "New Message",
      "description": "Driver inquiry about load LD001236 pickup time",
      "timestamp": "2 days ago",
      "actionRequired": true
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'LoadMatch Pro',
        centerTitle: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                onPressed: _showNotifications,
                tooltip: 'Notifications',
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'account_circle',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            onPressed: _showProfile,
            tooltip: 'Profile',
          ),
        ],
        bottom: CustomTabBar.shipperManagement(
          controller: _tabController,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildMyLoadsTab(),
          _buildMessagesTab(),
          _buildProfileTab(),
        ],
      ),
      floatingActionButton: PostLoadButton(
        onPressed: _postNewLoad,
        isFloating: true,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            QuickStatsSection(statsData: _statsData),
            SizedBox(height: 1.h),
            ActiveShipmentsCard(
              activeShipments: _activeShipments,
              onViewAll: () => _tabController.animateTo(1),
            ),
            SizedBox(height: 1.h),
            RecentActivityFeed(
              activities: _recentActivities,
              onViewAll: _showAllActivities,
            ),
            SizedBox(height: 1.h),
            EmergencyContactButton(
              onPressed: _contactEmergencySupport,
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildMyLoadsTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: _activeShipments.isEmpty
          ? _buildEmptyLoadsState()
          : ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: _activeShipments.length,
              itemBuilder: (context, index) {
                final shipment = _activeShipments[index];
                return _buildSlidableLoadCard(shipment, index);
              },
            ),
    );
  }

  Widget _buildSlidableLoadCard(Map<String, dynamic> shipment, int index) {
    return Slidable(
      key: ValueKey(shipment['loadId']),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _editLoad(shipment),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => _cancelLoad(shipment),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.cancel,
            label: 'Cancel',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _viewDriverDetails(shipment),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.person,
            label: 'Driver',
          ),
          SlidableAction(
            onPressed: (context) => _trackLoad(shipment),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.location_on,
            label: 'Track',
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: () => _showLoadContextMenu(shipment),
        child: _buildLoadCard(shipment),
      ),
    );
  }

  Widget _buildLoadCard(Map<String, dynamic> shipment) {
    final status = shipment['status'] as String;
    final statusColor = _getStatusColor(status);

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Load #${shipment['loadId']}',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    '${shipment['origin']} → ${shipment['destination']}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'inventory_2',
                  size: 18,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 2.w),
                Text(
                  '${shipment['cargoType']} • ${shipment['weight']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Date',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      shipment['deliveryDate'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rate',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      shipment['rate'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (shipment['driverName'] != null &&
                (shipment['driverName'] as String).isNotEmpty) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driver: ${shipment['driverName']}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (shipment['driverPhone'] != null &&
                              (shipment['driverPhone'] as String).isNotEmpty)
                            Text(
                              shipment['driverPhone'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _callDriver(shipment['driverPhone'] as String),
                      icon: CustomIconWidget(
                        iconName: 'phone',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (status == 'In-Transit') ...[
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                value: (shipment['progress'] as double) / 100,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
              SizedBox(height: 1.h),
              Text(
                '${shipment['progress']}% Complete',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLoadsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'inventory_2',
              size: 80,
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            SizedBox(height: 4.h),
            Text(
              'No loads posted yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Start by posting your first load to connect with drivers',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            PostLoadButton(
              onPressed: _postNewLoad,
              isFloating: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'message',
              size: 80,
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            SizedBox(height: 4.h),
            Text(
              'Messages',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Communication with drivers will appear here',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    child: CustomIconWidget(
                      iconName: 'business',
                      size: 40,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Acme Logistics Inc.',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Premium Shipper',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          _buildProfileOption('Account Settings', Icons.settings, () {}),
          _buildProfileOption('Payment Methods', Icons.payment, () {}),
          _buildProfileOption('Load History', Icons.history, () {}),
          _buildProfileOption('Help & Support', Icons.help, () {}),
          _buildProfileOption('Terms & Conditions', Icons.description, () {}),
          _buildProfileOption('Sign Out', Icons.logout, () {}),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: _getIconName(icon),
          size: 24,
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
        title: Text(title),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          size: 20,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }

  String _getIconName(IconData icon) {
    switch (icon) {
      case Icons.settings:
        return 'settings';
      case Icons.payment:
        return 'payment';
      case Icons.history:
        return 'history';
      case Icons.help:
        return 'help';
      case Icons.description:
        return 'description';
      case Icons.logout:
        return 'logout';
      default:
        return 'settings';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Posted':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'Accepted':
        return Colors.orange;
      case 'In-Transit':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Delivered':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data refreshed successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Stay on shipper dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/load-details');
        break;
      case 2:
        _tabController.animateTo(1); // My Loads tab
        break;
      case 3:
        // Reports - could navigate to analytics screen
        break;
    }
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Notifications',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: ListTile(
                      leading: CustomIconWidget(
                        iconName: 'notifications',
                        size: 24,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      title: Text('Driver response pending'),
                      subtitle: Text('Load LD001236 has 2 driver inquiries'),
                      trailing: Text('2h ago'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfile() {
    _tabController.animateTo(3);
  }

  void _postNewLoad() {
    Navigator.pushNamed(context, '/load-details');
  }

  void _showAllActivities() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All activities view coming soon')),
    );
  }

  void _contactEmergencySupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Support'),
        content: const Text(
            'Call 24/7 emergency support at:\n+1-800-LOADMATCH\n\nOr use in-app emergency chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chat'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _editLoad(Map<String, dynamic> shipment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit load ${shipment['loadId']}')),
    );
  }

  void _cancelLoad(Map<String, dynamic> shipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Load'),
        content:
            Text('Are you sure you want to cancel load ${shipment['loadId']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Load ${shipment['loadId']} cancelled')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _viewDriverDetails(Map<String, dynamic> shipment) {
    if (shipment['driverName'] == null ||
        (shipment['driverName'] as String).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No driver assigned yet')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                child: CustomIconWidget(
                  iconName: 'person',
                  size: 30,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                shipment['driverName'] as String,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                shipment['driverPhone'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () =>
                        _callDriver(shipment['driverPhone'] as String),
                    icon: CustomIconWidget(
                      iconName: 'phone',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                    label: const Text('Call'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _messageDriver(shipment['driverName'] as String),
                    icon: CustomIconWidget(
                      iconName: 'message',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    label: const Text('Message'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _trackLoad(Map<String, dynamic> shipment) {
    Navigator.pushNamed(context, '/active-delivery-tracking');
  }

  void _showLoadContextMenu(Map<String, dynamic> shipment) {
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
                iconName: 'content_copy',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: const Text('Duplicate Load'),
              onTap: () {
                Navigator.pop(context);
                _duplicateLoad(shipment);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: const Text('Share Tracking'),
              onTap: () {
                Navigator.pop(context);
                _shareTracking(shipment);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: const Text('Contact Driver'),
              onTap: () {
                Navigator.pop(context);
                _viewDriverDetails(shipment);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _callDriver(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phoneNumber...')),
    );
  }

  void _messageDriver(String driverName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat with $driverName')),
    );
  }

  void _duplicateLoad(Map<String, dynamic> shipment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Duplicating load ${shipment['loadId']}')),
    );
  }

  void _shareTracking(Map<String, dynamic> shipment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing tracking for ${shipment['loadId']}')),
    );
  }
}