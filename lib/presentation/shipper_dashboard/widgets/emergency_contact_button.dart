import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyContactButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        color: AppTheme.lightTheme.colorScheme.errorContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'emergency',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Support',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '24/7 support for critical shipments',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'phone',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
