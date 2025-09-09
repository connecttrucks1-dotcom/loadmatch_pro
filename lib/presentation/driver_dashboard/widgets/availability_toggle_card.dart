import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvailabilityToggleCard extends StatefulWidget {
  final bool isOnline;
  final String currentLocation;
  final VoidCallback onToggle;

  const AvailabilityToggleCard({
    super.key,
    required this.isOnline,
    required this.currentLocation,
    required this.onToggle,
  });

  @override
  State<AvailabilityToggleCard> createState() => _AvailabilityToggleCardState();
}

class _AvailabilityToggleCardState extends State<AvailabilityToggleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: widget.isOnline
                      ? AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: widget.isOnline
                      ? 'radio_button_checked'
                      : 'radio_button_unchecked',
                  color: widget.isOnline
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.outline,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isOnline ? 'You\'re Online' : 'You\'re Offline',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.isOnline
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.isOnline
                          ? 'Ready to receive loads'
                          : 'Not receiving loads',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 1.2,
                child: Switch(
                  value: widget.isOnline,
                  onChanged: (_) => widget.onToggle(),
                  activeColor: AppTheme.lightTheme.colorScheme.tertiary,
                  inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  widget.currentLocation,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          if (widget.isOnline) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'gps_fixed',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'GPS Active - Location updating',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
