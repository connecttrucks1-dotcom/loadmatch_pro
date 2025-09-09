import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimelineWidget extends StatelessWidget {
  final Map<String, dynamic> loadData;

  const TimelineWidget({
    super.key,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final pickupWindow = loadData['pickupWindow'] as String? ?? 'TBD';
    final deliveryDeadline = loadData['deliveryDeadline'] as String? ?? 'TBD';
    final estimatedTransitTime =
        loadData['estimatedTransitTime'] as String? ?? 'TBD';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Timeline',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildTimelineItem(
            context,
            'Pickup Window',
            pickupWindow,
            'access_time',
            AppTheme.lightTheme.colorScheme.primary,
            isFirst: true,
          ),
          _buildTimelineConnector(context),
          _buildTimelineItem(
            context,
            'Estimated Transit',
            estimatedTransitTime,
            'local_shipping',
            AppTheme.lightTheme.colorScheme.secondary,
          ),
          _buildTimelineConnector(context),
          _buildTimelineItem(
            context,
            'Delivery Deadline',
            deliveryDeadline,
            'flag',
            AppTheme.lightTheme.colorScheme.tertiary,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String time,
    String iconName,
    Color iconColor, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: iconColor,
              width: 2,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: iconColor,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  time,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.w, top: 1.h, bottom: 1.h),
      child: Container(
        width: 2,
        height: 3.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}
