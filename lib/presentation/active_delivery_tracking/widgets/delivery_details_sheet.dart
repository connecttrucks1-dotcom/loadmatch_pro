import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> deliveryData;
  final VoidCallback? onContactShipper;
  final VoidCallback? onViewInstructions;

  const DeliveryDetailsSheet({
    super.key,
    required this.deliveryData,
    this.onContactShipper,
    this.onViewInstructions,
  });

  @override
  State<DeliveryDetailsSheet> createState() => _DeliveryDetailsSheetState();
}

class _DeliveryDetailsSheetState extends State<DeliveryDetailsSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  children: [
                    _buildHeader(),
                    SizedBox(height: 2.h),
                    _buildShipperInfo(),
                    SizedBox(height: 2.h),
                    _buildCargoInfo(),
                    SizedBox(height: 2.h),
                    _buildDeliveryInstructions(),
                    SizedBox(height: 2.h),
                    _buildActionButtons(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Load #${widget.deliveryData["loadId"]}',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Expected delivery: ${widget.deliveryData["expectedDelivery"]}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.deliveryData["status"] ?? "In Transit",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShipperInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'business',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Shipper Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildInfoRow('Company',
              widget.deliveryData["shipperCompany"] ?? "ABC Logistics"),
          SizedBox(height: 1.h),
          _buildInfoRow(
              'Contact', widget.deliveryData["shipperContact"] ?? "John Smith"),
          SizedBox(height: 1.h),
          _buildInfoRow('Phone',
              widget.deliveryData["shipperPhone"] ?? "+1 (555) 123-4567"),
        ],
      ),
    );
  }

  Widget _buildCargoInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'inventory_2',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Cargo Details',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildInfoRow(
              'Type', widget.deliveryData["cargoType"] ?? "Electronics"),
          SizedBox(height: 1.h),
          _buildInfoRow(
              'Weight', widget.deliveryData["cargoWeight"] ?? "2,500 lbs"),
          SizedBox(height: 1.h),
          _buildInfoRow('Dimensions',
              widget.deliveryData["cargoDimensions"] ?? "8' x 6' x 4'"),
          SizedBox(height: 1.h),
          _buildInfoRow(
              'Value', widget.deliveryData["cargoValue"] ?? "\$25,000"),
        ],
      ),
    );
  }

  Widget _buildDeliveryInstructions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Delivery Instructions',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onViewInstructions,
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            widget.deliveryData["instructions"] ??
                "Please deliver to loading dock B. Contact security guard for access. Handle with care - fragile electronics inside.",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onContactShipper,
            icon: CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            label: Text('Contact Shipper'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showEmergencyOptions(context);
            },
            icon: CustomIconWidget(
              iconName: 'support_agent',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 4.w,
            ),
            label: Text('Support'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 25.w,
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showEmergencyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Emergency Support',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text('Call Emergency Support'),
              subtitle: Text('24/7 Emergency Hotline'),
              onTap: () {
                Navigator.pop(context);
                // Implement emergency call
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Report Issue'),
              subtitle: Text('Report delivery problems'),
              onTap: () {
                Navigator.pop(context);
                // Implement issue reporting
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Chat Support'),
              subtitle: Text('Live chat with support team'),
              onTap: () {
                Navigator.pop(context);
                // Implement chat support
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
