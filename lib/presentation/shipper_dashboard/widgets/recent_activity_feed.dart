import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityFeed extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final VoidCallback? onViewAll;

  const RecentActivityFeed({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                Text(
                  'Recent Activity',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            activities.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: activities
                        .take(5)
                        .map((activity) => _buildActivityItem(activity))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'notifications',
            size: 48,
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          SizedBox(height: 2.h),
          Text(
            'No recent activity',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final activityType = activity['type'] as String;
    final iconData = _getActivityIcon(activityType);
    final iconColor = _getActivityColor(activityType);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconData,
                size: 20,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['timestamp'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          if (activity['actionRequired'] == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Action Required',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getActivityIcon(String type) {
    switch (type) {
      case 'driver_acceptance':
        return 'person_add';
      case 'delivery_update':
        return 'local_shipping';
      case 'rating_received':
        return 'star';
      case 'payment_processed':
        return 'payment';
      case 'load_posted':
        return 'add_box';
      case 'message_received':
        return 'message';
      default:
        return 'notifications';
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'driver_acceptance':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'delivery_update':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'rating_received':
        return Colors.amber;
      case 'payment_processed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'load_posted':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'message_received':
        return Colors.orange;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
