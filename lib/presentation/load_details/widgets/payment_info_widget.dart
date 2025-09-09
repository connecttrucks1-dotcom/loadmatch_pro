import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentInfoWidget extends StatelessWidget {
  final Map<String, dynamic> loadData;

  const PaymentInfoWidget({
    super.key,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = loadData['totalAmount'] as String? ?? '\$0';
    final perMileRate = loadData['perMileRate'] as String? ?? '\$0.00';
    final paymentTerms = loadData['paymentTerms'] as String? ?? 'Net 30';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
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
                  iconName: 'attach_money',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Payment Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Total Payment',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  totalAmount,
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'speed',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Per Mile',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        perMileRate,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Payment Terms',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        paymentTerms,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
