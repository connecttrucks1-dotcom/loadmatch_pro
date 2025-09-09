import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget optimized for logistics applications
/// Provides consistent navigation and branding across the application
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true when there's a previous route)
  final bool showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to show elevation shadow
  final bool showElevation;

  /// Custom background color (uses theme color if not provided)
  final Color? backgroundColor;

  /// Custom text color (uses theme color if not provided)
  final Color? foregroundColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget (like TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.showElevation = true,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
          letterSpacing: -0.02,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: showElevation ? 2.0 : 0.0,
      shadowColor: theme.appBarTheme.shadowColor,
      surfaceTintColor: theme.appBarTheme.surfaceTintColor,
      leading: leading ??
          (canPop && showBackButton ? _buildBackButton(context) : null),
      actions: actions ?? _buildDefaultActions(context),
      bottom: bottom,
      toolbarHeight: 56.0,
      leadingWidth: 56.0,
    );
  }

  /// Builds the back button with proper navigation
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Back',
      padding: const EdgeInsets.all(16),
    );
  }

  /// Builds default actions based on current route
  List<Widget>? _buildDefaultActions(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case '/driver-dashboard':
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 24),
            onPressed: () => _showNotifications(context),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 24),
            onPressed: () => _showProfile(context),
            tooltip: 'Profile',
          ),
        ];

      case '/shipper-dashboard':
        return [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 24),
            onPressed: () => Navigator.pushNamed(context, '/load-details'),
            tooltip: 'Post Load',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 24),
            onPressed: () => _showNotifications(context),
            tooltip: 'Notifications',
          ),
        ];

      case '/load-search-and-browse':
        return [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 24),
            onPressed: () => _showFilters(context),
            tooltip: 'Filters',
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, size: 24),
            onPressed: () => _showMapView(context),
            tooltip: 'Map View',
          ),
        ];

      case '/load-details':
        return [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 24),
            onPressed: () => _shareLoad(context),
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, size: 24),
            onPressed: () => _bookmarkLoad(context),
            tooltip: 'Bookmark',
          ),
        ];

      case '/active-delivery-tracking':
        return [
          IconButton(
            icon: const Icon(Icons.call, size: 24),
            onPressed: () => _callSupport(context),
            tooltip: 'Call Support',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: () => _showMoreOptions(context),
            tooltip: 'More Options',
          ),
        ];

      default:
        return null;
    }
  }

  /// Show notifications bottom sheet
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Notifications',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('No new notifications'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show profile options
  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('App Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Show filters for load search
  void _showFilters(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filters coming soon')),
    );
  }

  /// Show map view
  void _showMapView(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map view coming soon')),
    );
  }

  /// Share load functionality
  void _shareLoad(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Load shared successfully')),
    );
  }

  /// Bookmark load functionality
  void _bookmarkLoad(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Load bookmarked')),
    );
  }

  /// Call support functionality
  void _callSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling support...')),
    );
  }

  /// Show more options
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Report Issue'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.note_add_outlined),
              title: const Text('Add Note'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        56.0 + (bottom?.preferredSize.height ?? 0.0),
      );
}
