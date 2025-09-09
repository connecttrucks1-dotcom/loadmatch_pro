import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const DeliveryProgressIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
            'Delivery Progress',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: List.generate(steps.length, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isLast = index == steps.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted || isCurrent
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                            ),
                            child: isCompleted
                                ? CustomIconWidget(
                                    iconName: 'check',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 4.w,
                                  )
                                : isCurrent
                                    ? Container(
                                        margin: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                        ),
                                      )
                                    : null,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            steps[index],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isCompleted || isCurrent
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight:
                                  isCurrent ? FontWeight.w600 : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
