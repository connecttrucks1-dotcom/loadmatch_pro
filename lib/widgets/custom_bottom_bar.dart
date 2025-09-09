import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data structure
class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom navigation bar optimized for logistics applications
/// Provides large touch targets and clear visual feedback for truck-friendly interaction
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when item is tapped
  final ValueChanged<int>? onTap;

  /// Whether to show labels
  final bool showLabels;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  /// Navigation items for driver dashboard flow
  static const List<BottomNavItem> driverNavItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/driver-dashboard',
    ),
    BottomNavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Find Loads',
      route: '/load-search-and-browse',
    ),
    BottomNavItem(
      icon: Icons.local_shipping_outlined,
      activeIcon: Icons.local_shipping,
      label: 'Active',
      route: '/active-delivery-tracking',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/driver-dashboard', // Will show profile section
    ),
  ];

  /// Navigation items for shipper dashboard flow
  static const List<BottomNavItem> shipperNavItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/shipper-dashboard',
    ),
    BottomNavItem(
      icon: Icons.add_box_outlined,
      activeIcon: Icons.add_box,
      label: 'Post Load',
      route: '/load-details',
    ),
    BottomNavItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      label: 'My Loads',
      route: '/shipper-dashboard', // Will show loads section
    ),
    BottomNavItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Reports',
      route: '/shipper-dashboard', // Will show reports section
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Determine which navigation items to show based on current route
    List<BottomNavItem> navItems = _getNavItemsForRoute(currentRoute);

    // Don't show bottom bar on splash screen
    if (currentRoute == '/splash-screen') {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavItem(
                context,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Get navigation items based on current route
  List<BottomNavItem> _getNavItemsForRoute(String? route) {
    switch (route) {
      case '/driver-dashboard':
      case '/load-search-and-browse':
      case '/active-delivery-tracking':
        return driverNavItems;
      case '/shipper-dashboard':
      case '/load-details':
        return shipperNavItems;
      default:
        return driverNavItems; // Default to driver navigation
    }
  }

  /// Build individual navigation item
  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final selectedColor =
        selectedItemColor ?? theme.bottomNavigationBarTheme.selectedItemColor;
    final unselectedColor = unselectedItemColor ??
        theme.bottomNavigationBarTheme.unselectedItemColor;

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with background for selected state
              Container(
                padding: const EdgeInsets.all(8),
                decoration: isSelected
                    ? BoxDecoration(
                        color: selectedColor?.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 24,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),

              // Label
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Handle navigation item tap
  void _handleTap(BuildContext context, int index, String route) {
    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the route if it's different from current
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      // Use pushReplacementNamed to replace current route in bottom nav flow
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

/// Extension to easily create CustomBottomBar for specific user types
extension CustomBottomBarFactory on CustomBottomBar {
  /// Create bottom bar for driver interface
  static CustomBottomBar forDriver({
    required int currentIndex,
    ValueChanged<int>? onTap,
    bool showLabels = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      showLabels: showLabels,
    );
  }

  /// Create bottom bar for shipper interface
  static CustomBottomBar forShipper({
    required int currentIndex,
    ValueChanged<int>? onTap,
    bool showLabels = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      showLabels: showLabels,
    );
  }
}
