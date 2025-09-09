import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CargoDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> loadData;

  const CargoDetailsWidget({
    super.key,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final weight = loadData['weight'] as String? ?? '0 lbs';
    final dimensions = loadData['dimensions'] as String? ?? 'N/A';
    final cargoType = loadData['cargoType'] as String? ?? 'General Freight';
    final specialRequirements =
        (loadData['specialRequirements'] as List?)?.cast<String>() ?? [];

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
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'inventory_2',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Cargo Details',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  'Weight',
                  weight,
                  'scale',
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildDetailItem(
                  context,
                  'Dimensions',
                  dimensions,
                  'straighten',
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildDetailItem(
            context,
            'Cargo Type',
            cargoType,
            'category',
            AppTheme.lightTheme.colorScheme.secondary,
            isFullWidth: true,
          ),
          if (specialRequirements.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.errorContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Special Requirements',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: specialRequirements
                        .map((requirement) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                requirement,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color iconColor, {
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: iconColor,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: isFullWidth ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
