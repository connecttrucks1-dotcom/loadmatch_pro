import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadCardWidget extends StatelessWidget {
  final Map<String, dynamic> loadData;
  final VoidCallback? onTap;
  final VoidCallback? onSave;

  const LoadCardWidget({
    super.key,
    required this.loadData,
    this.onTap,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              SizedBox(height: 2.h),
              _buildLocationInfo(theme),
              SizedBox(height: 2.h),
              _buildCargoDetails(theme),
              SizedBox(height: 2.h),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loadData['payment'] as String? ?? '\$0',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${loadData['distance'] as String? ?? '0'} miles away',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getStatusColor(
                        loadData['status'] as String? ?? 'available')
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                loadData['status'] as String? ?? 'Available',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(
                      loadData['status'] as String? ?? 'available'),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            InkWell(
              onTap: onSave,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(2.w),
                child: CustomIconWidget(
                  iconName: loadData['isSaved'] == true
                      ? 'bookmark'
                      : 'bookmark_border',
                  color: loadData['isSaved'] == true
                      ? AppTheme.lightTheme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationInfo(ThemeData theme) {
    return Column(
      children: [
        _buildLocationRow(
          theme,
          'radio_button_checked',
          'Pickup',
          loadData['pickupLocation'] as String? ?? 'Unknown Location',
          loadData['pickupDate'] as String? ?? 'TBD',
        ),
        SizedBox(height: 1.h),
        Container(
          margin: EdgeInsets.only(left: 6.w),
          child: CustomPaint(
            painter: DottedLinePainter(color: theme.colorScheme.outline),
            size: Size(1, 3.h),
          ),
        ),
        SizedBox(height: 1.h),
        _buildLocationRow(
          theme,
          'location_on',
          'Delivery',
          loadData['deliveryLocation'] as String? ?? 'Unknown Location',
          loadData['deliveryDate'] as String? ?? 'TBD',
        ),
      ],
    );
  }

  Widget _buildLocationRow(
    ThemeData theme,
    String iconName,
    String label,
    String location,
    String date,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                location,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCargoDetails(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDetailItem(
              theme,
              'inventory_2',
              'Cargo Type',
              loadData['cargoType'] as String? ?? 'General Freight',
            ),
          ),
          Container(
            width: 1,
            height: 4.h,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildDetailItem(
              theme,
              'scale',
              'Weight',
              loadData['weight'] as String? ?? '0 lbs',
            ),
          ),
          Container(
            width: 1,
            height: 4.h,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildDetailItem(
              theme,
              'straighten',
              'Distance',
              loadData['totalDistance'] as String? ?? '0 mi',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    ThemeData theme,
    String iconName,
    String label,
    String value,
  ) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onSurfaceVariant,
          size: 18,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posted by ${loadData['shipper'] as String? ?? 'Unknown Shipper'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return CustomIconWidget(
                      iconName: index < (loadData['rating'] as int? ?? 0)
                          ? 'star'
                          : 'star_border',
                      color: index < (loadData['rating'] as int? ?? 0)
                          ? Colors.amber
                          : theme.colorScheme.onSurfaceVariant,
                      size: 12,
                    );
                  }),
                  SizedBox(width: 1.w),
                  Text(
                    '(${loadData['reviewCount'] as int? ?? 0})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'View Details',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return AppTheme.errorLight;
      case 'available':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      default:
        return AppTheme.secondaryLight;
    }
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
