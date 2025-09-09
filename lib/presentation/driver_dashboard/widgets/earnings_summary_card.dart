import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EarningsSummaryCard extends StatelessWidget {
  final double todayEarnings;
  final double weeklyEarnings;
  final int completedDeliveries;

  const EarningsSummaryCard({
    super.key,
    required this.todayEarnings,
    required this.weeklyEarnings,
    required this.completedDeliveries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Earnings Summary',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildEarningItem(
                  'Today',
                  '\$${todayEarnings.toStringAsFixed(2)}',
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildEarningItem(
                  'This Week',
                  '\$${weeklyEarnings.toStringAsFixed(2)}',
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_shipping',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Completed Deliveries',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    completedDeliveries.toString(),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
