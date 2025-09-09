import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActiveDeliveryBanner extends StatelessWidget {
  final Map<String, dynamic> activeDelivery;
  final VoidCallback onUpdateStatus;
  final VoidCallback onViewDetails;

  const ActiveDeliveryBanner({
    super.key,
    required this.activeDelivery,
    required this.onUpdateStatus,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final pickupLocation = activeDelivery['pickupLocation'] as String? ?? '';
    final deliveryLocation =
        activeDelivery['deliveryLocation'] as String? ?? '';
    final status = activeDelivery['status'] as String? ?? 'In Transit';
    final progress = activeDelivery['progress'] as double? ?? 0.5;
    final estimatedTime = activeDelivery['estimatedTime'] as String? ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onViewDetails,
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'local_shipping',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Delivery',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            status,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildLocationInfo(
                        'From',
                        pickupLocation,
                        'trip_origin',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      child: CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: _buildLocationInfo(
                        'To',
                        deliveryLocation,
                        'place',
                      ),
                    ),
                  ],
                ),
                if (estimatedTime.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'ETA: $estimatedTime',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewDetails,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          side:
                              const BorderSide(color: Colors.white, width: 1.5),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'View Details',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onUpdateStatus,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          backgroundColor: Colors.white,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                        ),
                        child: Text(
                          'Update Status',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String label, String location, String iconName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: Colors.white.withValues(alpha: 0.9),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          location,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
