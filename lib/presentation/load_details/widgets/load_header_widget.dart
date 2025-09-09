import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> loadData;

  const LoadHeaderWidget({
    super.key,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Location',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      loadData['pickupLocation'] as String? ??
                          'Unknown Location',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            height: 1,
            width: double.infinity,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),
          SizedBox(height: 3.h),
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
                  iconName: 'flag',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Location',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      loadData['deliveryLocation'] as String? ??
                          'Unknown Location',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${loadData['distance'] ?? '0'} miles',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 4.h,
                  width: 1,
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer
                      .withValues(alpha: 0.3),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drive Time',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      loadData['driveTime'] as String? ?? '0 hrs',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
