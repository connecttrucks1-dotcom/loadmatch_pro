import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusUpdateButtons extends StatelessWidget {
  final int currentStep;
  final Function(int) onStatusUpdate;
  final VoidCallback? onTakePhoto;

  const StatusUpdateButtons({
    super.key,
    required this.currentStep,
    required this.onStatusUpdate,
    this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Status',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildStatusButtons(context),
          SizedBox(height: 2.h),
          _buildPhotoButton(context),
        ],
      ),
    );
  }

  Widget _buildStatusButtons(BuildContext context) {
    final statusButtons = [
      {
        'step': 1,
        'title': 'Arrived at Pickup',
        'icon': 'location_on',
        'enabled': currentStep == 0
      },
      {
        'step': 2,
        'title': 'Cargo Loaded',
        'icon': 'inventory_2',
        'enabled': currentStep == 1
      },
      {
        'step': 3,
        'title': 'In Transit',
        'icon': 'local_shipping',
        'enabled': currentStep == 2
      },
      {
        'step': 4,
        'title': 'Arrived at Delivery',
        'icon': 'place',
        'enabled': currentStep == 3
      },
      {
        'step': 5,
        'title': 'Delivered',
        'icon': 'check_circle',
        'enabled': currentStep == 4
      },
    ];

    return Column(
      children: statusButtons.map((button) {
        final isEnabled = button['enabled'] as bool;
        final step = button['step'] as int;

        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isEnabled
                  ? () => _showConfirmationDialog(
                      context, step, button['title'] as String)
                  : null,
              icon: CustomIconWidget(
                iconName: button['icon'] as String,
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              label: Text(button['title'] as String),
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                foregroundColor: isEnabled
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhotoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTakePhoto,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
        label: Text('Take Photo'),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          side: BorderSide(
            color: AppTheme.lightTheme.colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, int step, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm Status Update',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to update the status to:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'This will notify the shipper and update the delivery tracking.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onStatusUpdate(step);
                _showSuccessSnackBar(context, title);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Status updated to: $title',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
