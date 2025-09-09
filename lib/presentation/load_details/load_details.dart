import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/cargo_details_widget.dart';
import './widgets/load_header_widget.dart';
import './widgets/map_preview_widget.dart';
import './widgets/payment_info_widget.dart';
import './widgets/photo_gallery_widget.dart';
import './widgets/shipper_info_widget.dart';
import './widgets/timeline_widget.dart';

class LoadDetails extends StatefulWidget {
  const LoadDetails({super.key});

  @override
  State<LoadDetails> createState() => _LoadDetailsState();
}

class _LoadDetailsState extends State<LoadDetails> {
  late Map<String, dynamic> loadData;

  @override
  void initState() {
    super.initState();
    _initializeLoadData();
  }

  void _initializeLoadData() {
    loadData = {
      "id": "LD-2025-001",
      "pickupLocation":
          "Dallas Distribution Center, 1234 Industrial Blvd, Dallas, TX 75201",
      "deliveryLocation":
          "Phoenix Logistics Hub, 5678 Commerce Dr, Phoenix, AZ 85001",
      "distance": "887",
      "driveTime": "13.5 hrs",
      "totalAmount": "\$2,850",
      "perMileRate": "\$3.21",
      "paymentTerms": "Net 15",
      "weight": "42,500 lbs",
      "dimensions": "48' x 8.5' x 9.5'",
      "cargoType": "Electronics & Consumer Goods",
      "specialRequirements": [
        "Temperature Controlled",
        "Fragile Items",
        "High Value"
      ],
      "pickupWindow": "Jan 10, 2025 - 8:00 AM to 12:00 PM",
      "deliveryDeadline": "Jan 12, 2025 - 6:00 PM",
      "estimatedTransitTime": "2 days, 13.5 hours",
      "pickupCoordinates": {"latitude": 32.7767, "longitude": -96.7970},
      "deliveryCoordinates": {"latitude": 33.4484, "longitude": -112.0740},
      "photos": [
        "https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=800&q=80",
        "https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=800&q=80",
        "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&q=80"
      ],
      "shipper": {
        "companyName": "TechFlow Logistics Inc.",
        "rating": 4.7,
        "totalRatings": 342,
        "location": "Dallas, TX",
        "phone": "(214) 555-0123",
        "totalLoads": 1247,
        "avatar":
            "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&q=80"
      },
      "isExpired": false,
      "expirationTime": "Jan 9, 2025 - 11:59 PM"
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Load Details',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              loadData['id'] as String? ?? '',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              onPressed: _handleShare,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  LoadHeaderWidget(loadData: loadData),
                  SizedBox(height: 3.h),
                  PaymentInfoWidget(loadData: loadData),
                  SizedBox(height: 3.h),
                  CargoDetailsWidget(loadData: loadData),
                  SizedBox(height: 3.h),
                  ShipperInfoWidget(loadData: loadData),
                  SizedBox(height: 3.h),
                  TimelineWidget(loadData: loadData),
                  SizedBox(height: 3.h),
                  PhotoGalleryWidget(loadData: loadData),
                  SizedBox(height: 3.h),
                  MapPreviewWidget(loadData: loadData),
                  SizedBox(height: 10.h), // Extra space for bottom actions
                ],
              ),
            ),
          ),
          ActionButtonsWidget(
            loadData: loadData,
            onAcceptLoad: _handleAcceptLoad,
            onSaveForLater: _handleSaveForLater,
          ),
        ],
      ),
    );
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text('Load details shared successfully'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAcceptLoad() {
    // Navigate to active delivery tracking
    Navigator.pushReplacementNamed(context, '/active-delivery-tracking');
  }

  void _handleSaveForLater() {
    // Handle save for later functionality
    // This could update local storage or send to API
  }
}
