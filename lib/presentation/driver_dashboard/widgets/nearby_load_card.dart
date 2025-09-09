import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NearbyLoadCard extends StatelessWidget {
  final Map<String, dynamic> loadData;
  final VoidCallback onViewDetails;
  final VoidCallback onQuickAccept;
  final VoidCallback? onSaveForLater;
  final VoidCallback? onShare;
  final VoidCallback? onReport;

  const NearbyLoadCard({
    super.key,
    required this.loadData,
    required this.onViewDetails,
    required this.onQuickAccept,
    this.onSaveForLater,
    this.onShare,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final pickupLocation = loadData['pickupLocation'] as String? ?? '';
    final deliveryLocation = loadData['deliveryLocation'] as String? ?? '';
    final distance = loadData['distance'] as double? ?? 0.0;
    final payment = loadData['payment'] as double? ?? 0.0;
    final cargoType = loadData['cargoType'] as String? ?? '';
    final weight = loadData['weight'] as String? ?? '';
    final urgency = loadData['urgency'] as String? ?? 'Standard';
    final postedTime = loadData['postedTime'] as String? ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                        color: _getUrgencyColor(urgency).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'local_shipping',
                        color: _getUrgencyColor(urgency),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                cargoType,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              if (urgency != 'Standard')
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: _getUrgencyColor(urgency),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    urgency.toUpperCase(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            weight,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${payment.toStringAsFixed(0)}',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${distance.toStringAsFixed(0)} mi',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                _buildLocationRow(
                  'trip_origin',
                  'Pickup',
                  pickupLocation,
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(height: 2.h),
                _buildLocationRow(
                  'place',
                  'Delivery',
                  deliveryLocation,
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Posted $postedTime',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onLongPress: () => _showContextMenu(context),
                      child: CustomIconWidget(
                        iconName: 'more_vert',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewDetails,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          side: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onQuickAccept,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                        child: Text(
                          'Quick Accept',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white,
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

  Widget _buildLocationRow(
      String iconName, String label, String location, Color color) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                location,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'urgent':
        return AppTheme.lightTheme.colorScheme.error;
      case 'high':
        return const Color(0xFFD97706);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _showContextMenu(BuildContext context) {
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
            if (onSaveForLater != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'bookmark_border',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: const Text('Save for Later'),
                onTap: () {
                  Navigator.pop(context);
                  onSaveForLater?.call();
                },
              ),
            if (onShare != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  onShare?.call();
                },
              ),
            if (onReport != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'report',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: const Text('Report Issue'),
                onTap: () {
                  Navigator.pop(context);
                  onReport?.call();
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
