import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActiveShipmentsCard extends StatelessWidget {
  final List<Map<String, dynamic>> activeShipments;
  final VoidCallback? onViewAll;

  const ActiveShipmentsCard({
    super.key,
    required this.activeShipments,
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
                  'Active Shipments',
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
            activeShipments.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: activeShipments
                        .take(3)
                        .map((shipment) => _buildShipmentItem(shipment))
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
            iconName: 'local_shipping',
            size: 48,
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          SizedBox(height: 2.h),
          Text(
            'No active shipments',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Post your first load to get started',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentItem(Map<String, dynamic> shipment) {
    final status = shipment['status'] as String;
    final statusColor = _getStatusColor(status);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Load #${shipment['loadId']}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                size: 16,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  '${shipment['origin']} → ${shipment['destination']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    shipment['deliveryDate'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                shipment['rate'] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (status == 'In-Transit') ...[
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: (shipment['progress'] as double) / 100,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
            SizedBox(height: 0.5.h),
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
    );
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
}
