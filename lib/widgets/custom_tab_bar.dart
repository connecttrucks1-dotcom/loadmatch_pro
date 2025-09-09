import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item data structure
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final String? badge;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.badge,
  });
}

/// Custom tab bar widget optimized for logistics applications
/// Provides clear visual hierarchy and touch-friendly interaction
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab items
  final List<TabItem> tabs;

  /// Tab controller
  final TabController? controller;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom label color for selected tab
  final Color? labelColor;

  /// Custom label color for unselected tab
  final Color? unselectedLabelColor;

  /// Custom background color
  final Color? backgroundColor;

  /// Indicator weight/thickness
  final double indicatorWeight;

  /// Whether to show icons
  final bool showIcons;

  /// Tab alignment when not scrollable
  final TabAlignment tabAlignment;

  /// Custom padding for tabs
  final EdgeInsetsGeometry? labelPadding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.indicatorWeight = 3.0,
    this.showIcons = true,
    this.tabAlignment = TabAlignment.fill,
    this.labelPadding,
  });

  /// Factory constructor for load status tabs (common in logistics)
  factory CustomTabBar.loadStatus({
    TabController? controller,
    Color? indicatorColor,
  }) {
    return CustomTabBar(
      controller: controller,
      indicatorColor: indicatorColor,
      tabs: const [
        TabItem(
          label: 'Available',
          icon: Icons.inventory_2_outlined,
        ),
        TabItem(
          label: 'In Transit',
          icon: Icons.local_shipping_outlined,
          badge: '3',
        ),
        TabItem(
          label: 'Delivered',
          icon: Icons.check_circle_outline,
        ),
      ],
    );
  }

  /// Factory constructor for driver activity tabs
  factory CustomTabBar.driverActivity({
    TabController? controller,
    Color? indicatorColor,
  }) {
    return CustomTabBar(
      controller: controller,
      indicatorColor: indicatorColor,
      tabs: const [
        TabItem(
          label: 'Active',
          icon: Icons.directions_car_outlined,
        ),
        TabItem(
          label: 'History',
          icon: Icons.history,
        ),
        TabItem(
          label: 'Earnings',
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
    );
  }

  /// Factory constructor for shipper management tabs
  factory CustomTabBar.shipperManagement({
    TabController? controller,
    Color? indicatorColor,
  }) {
    return CustomTabBar(
      controller: controller,
      indicatorColor: indicatorColor,
      isScrollable: true,
      tabs: const [
        TabItem(
          label: 'Posted',
          icon: Icons.post_add_outlined,
          badge: '5',
        ),
        TabItem(
          label: 'Matched',
          icon: Icons.handshake_outlined,
          badge: '2',
        ),
        TabItem(
          label: 'In Progress',
          icon: Icons.local_shipping_outlined,
          badge: '3',
        ),
        TabItem(
          label: 'Completed',
          icon: Icons.done_all,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha(51),
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => _buildTab(context, tab)).toList(),
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: indicatorWeight,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: labelColor ?? theme.colorScheme.primary,
        unselectedLabelColor:
            unselectedLabelColor ?? theme.colorScheme.onSurfaceVariant,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        labelPadding:
            labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        splashFactory: InkRipple.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return theme.colorScheme.primary.withAlpha(26);
          }
          return null;
        }),
      ),
    );
  }

  /// Build individual tab with icon, label, and optional badge
  Widget _buildTab(BuildContext context, TabItem tabItem) {
    final theme = Theme.of(context);

    return Tab(
      height: 48,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (showIcons &&
                (tabItem.icon != null || tabItem.customIcon != null)) ...[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  tabItem.customIcon ??
                      Icon(
                        tabItem.icon,
                        size: 20,
                      ),
                  // Badge
                  if (tabItem.badge != null)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          tabItem.badge!,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onError,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],

            // Label
            Flexible(
              child: Text(
                tabItem.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // Badge for text-only tabs
            if (!showIcons && tabItem.badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tabItem.badge!,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onError,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

/// Custom tab bar view wrapper for consistent styling
class CustomTabBarView extends StatelessWidget {
  /// List of tab content widgets
  final List<Widget> children;

  /// Tab controller
  final TabController? controller;

  /// Physics for the page view
  final ScrollPhysics? physics;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics ?? const ClampingScrollPhysics(),
      children: children
          .map(
            (child) => Container(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          )
          .toList(),
    );
  }
}
