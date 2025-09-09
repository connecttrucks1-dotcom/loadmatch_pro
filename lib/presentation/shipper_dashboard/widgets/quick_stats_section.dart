import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsSection extends StatelessWidget {
  final Map<String, dynamic> statsData;

  const QuickStatsSection({
    super.key,
    required this.statsData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Loads',
              '${statsData['totalLoads']}',
              'this month',
              Icons.inventory_2_outlined,
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _buildStatCard(
              'Avg Delivery',
              '${statsData['avgDeliveryTime']}',
              'days',
              Icons.schedule_outlined,
              Colors.orange,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _buildStatCard(
              'Cost Savings',
              '${statsData['costSavings']}',
              'vs last month',
              Icons.trending_up_outlined,
              AppTheme.lightTheme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconWidget(
                  iconName: _getIconName(icon),
                  size: 20,
                  color: color,
                ),
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: _getIconName(icon),
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData icon) {
    switch (icon) {
      case Icons.inventory_2_outlined:
        return 'inventory_2';
      case Icons.schedule_outlined:
        return 'schedule';
      case Icons.trending_up_outlined:
        return 'trending_up';
      default:
        return 'analytics';
    }
  }
}
