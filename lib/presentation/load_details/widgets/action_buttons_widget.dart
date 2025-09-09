import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatefulWidget {
  final Map<String, dynamic> loadData;
  final VoidCallback? onAcceptLoad;
  final VoidCallback? onSaveForLater;

  const ActionButtonsWidget({
    super.key,
    required this.loadData,
    this.onAcceptLoad,
    this.onSaveForLater,
  });

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget> {
  bool _isAccepting = false;
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final isExpired = widget.loadData['isExpired'] as bool? ?? false;
    final expirationTime = widget.loadData['expirationTime'] as String?;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isExpired) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'This load has expired and is no longer available',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ] else if (expirationTime != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Expires: $expirationTime',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme
                            .lightTheme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onLongPress: isExpired
                        ? null
                        : () => _showAcceptConfirmation(context),
                    child: ElevatedButton(
                      onPressed: isExpired ? null : _handleAcceptLoad,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isExpired
                            ? AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest
                            : AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor: isExpired
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isExpired ? 0 : 2,
                      ),
                      child: _isAccepting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName:
                                      isExpired ? 'block' : 'check_circle',
                                  color: isExpired
                                      ? AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                      : AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  isExpired ? 'Expired' : 'Accept Load',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isExpired
                                        ? AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                        : AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleSaveForLater,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      side: BorderSide(
                        color: _isSaved
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: _isSaved
                          ? AppTheme.lightTheme.colorScheme.tertiaryContainer
                              .withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: _isSaved ? 'bookmark' : 'bookmark_border',
                          color: _isSaved
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _isSaved ? 'Saved' : 'Save',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: _isSaved
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isExpired) ...[
              SizedBox(height: 2.h),
              Text(
                'Long press "Accept Load" for confirmation dialog',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleAcceptLoad() async {
    if (_isAccepting) return;

    setState(() {
      _isAccepting = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAccepting = false;
      });

      widget.onAcceptLoad?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Load accepted successfully!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          action: SnackBarAction(
            label: 'View',
            textColor: AppTheme.lightTheme.colorScheme.onTertiary,
            onPressed: () {
              Navigator.pushNamed(context, '/active-delivery-tracking');
            },
          ),
        ),
      );
    }
  }

  void _handleSaveForLater() {
    setState(() {
      _isSaved = !_isSaved;
    });

    HapticFeedback.lightImpact();

    widget.onSaveForLater?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isSaved ? 'Load saved for later' : 'Load removed from saved'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAcceptConfirmation(BuildContext context) {
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Accept Load',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Load Summary:',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildSummaryRow('Route',
                  '${widget.loadData['pickupLocation']} → ${widget.loadData['deliveryLocation']}'),
              _buildSummaryRow(
                  'Distance', '${widget.loadData['distance']} miles'),
              _buildSummaryRow('Payment',
                  widget.loadData['totalAmount'] as String? ?? '\$0'),
              _buildSummaryRow('Pickup',
                  widget.loadData['pickupWindow'] as String? ?? 'TBD'),
              SizedBox(height: 2.h),
              Text(
                'Are you sure you want to accept this load?',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleAcceptLoad();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Accept Load',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
