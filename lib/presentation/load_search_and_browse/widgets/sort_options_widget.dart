import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SortOptionsWidget extends StatelessWidget {
  final String currentSortBy;
  final bool isAscending;
  final Function(String, bool) onSortChanged;

  const SortOptionsWidget({
    super.key,
    required this.currentSortBy,
    required this.isAscending,
    required this.onSortChanged,
  });

  static const List<Map<String, dynamic>> _sortOptions = [
    {
      'value': 'distance',
      'label': 'Distance',
      'icon': 'near_me',
      'description': 'Closest loads first',
    },
    {
      'value': 'payment',
      'label': 'Payment',
      'icon': 'attach_money',
      'description': 'Highest paying loads first',
    },
    {
      'value': 'pickup_date',
      'label': 'Pickup Date',
      'icon': 'schedule',
      'description': 'Earliest pickup dates first',
    },
    {
      'value': 'delivery_date',
      'label': 'Delivery Date',
      'icon': 'event',
      'description': 'Earliest delivery dates first',
    },
    {
      'value': 'posted_date',
      'label': 'Posted Date',
      'icon': 'access_time',
      'description': 'Most recently posted first',
    },
    {
      'value': 'rating',
      'label': 'Shipper Rating',
      'icon': 'star',
      'description': 'Highest rated shippers first',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(theme),
          _buildHeader(theme),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  ..._sortOptions.map((option) => _buildSortOption(
                        theme,
                        option['value'] as String,
                        option['label'] as String,
                        option['icon'] as String,
                        option['description'] as String,
                      )),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sort Loads',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Done',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    ThemeData theme,
    String value,
    String label,
    String iconName,
    String description,
  ) {
    final isSelected = currentSortBy == value;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Builder(
        builder: (context) => InkWell(
          onTap: () {
            if (isSelected) {
              // Toggle sort order if same option is selected
              onSortChanged(value, !isAscending);
            } else {
              // Select new option with default order
              final defaultAscending = _getDefaultSortOrder(value);
              onSortChanged(value, defaultAscending);
            }
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            label,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName:
                                  isAscending ? 'arrow_upward' : 'arrow_downward',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _getDefaultSortOrder(String sortBy) {
    switch (sortBy) {
      case 'distance':
        return true; // Closest first
      case 'payment':
        return false; // Highest first
      case 'pickup_date':
      case 'delivery_date':
        return true; // Earliest first
      case 'posted_date':
        return false; // Most recent first
      case 'rating':
        return false; // Highest first
      default:
        return true;
    }
  }
}