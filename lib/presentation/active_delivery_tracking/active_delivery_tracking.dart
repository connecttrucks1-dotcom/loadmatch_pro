import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/delivery_details_sheet.dart';
import './widgets/delivery_map_view.dart';
import './widgets/delivery_progress_indicator.dart';
import './widgets/photo_capture_widget.dart';
import './widgets/status_update_buttons.dart';

class ActiveDeliveryTracking extends StatefulWidget {
  const ActiveDeliveryTracking({super.key});

  @override
  State<ActiveDeliveryTracking> createState() => _ActiveDeliveryTrackingState();
}

class _ActiveDeliveryTrackingState extends State<ActiveDeliveryTracking> {
  int _currentStep = 2; // In Transit
  bool _showStatusButtons = false;
  bool _showPhotoCapture = false;
  bool _showSignatureCapture = false;
  XFile? _capturedImage;

  final List<String> _deliverySteps = [
    'Accepted',
    'Pickup',
    'In-Transit',
    'Delivered',
  ];

  // Mock delivery data
  final Map<String, dynamic> _deliveryData = {
    "loadId": "LD-2024-001234",
    "status": "In Transit",
    "expectedDelivery": "Today, 3:30 PM",
    "shipperCompany": "TechCorp Industries",
    "shipperContact": "Sarah Johnson",
    "shipperPhone": "+1 (555) 987-6543",
    "cargoType": "Electronics & Computer Parts",
    "cargoWeight": "3,200 lbs",
    "cargoDimensions": "10' x 8' x 6'",
    "cargoValue": "\$45,000",
    "instructions":
        "Deliver to loading dock C on the east side of the building. Contact security guard at main entrance for access code. Handle with extreme care - contains sensitive electronic components. Signature required from warehouse manager only.",
    "pickupAddress": "1234 Industrial Blvd, Austin, TX 78701",
    "deliveryAddress": "5678 Commerce Dr, Dallas, TX 75201",
    "estimatedDistance": "195 miles",
    "estimatedTime": "3h 15min",
  };

  // Mock GPS coordinates
  final LatLng _currentLocation = const LatLng(32.7767, -96.7970); // Dallas
  final LatLng _pickupLocation = const LatLng(30.2672, -97.7431); // Austin
  final LatLng _deliveryLocation =
      const LatLng(32.7831, -96.8067); // Dallas delivery

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Active Delivery',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Progress Indicator
              Padding(
                padding: EdgeInsets.all(4.w),
                child: DeliveryProgressIndicator(
                  currentStep: _currentStep,
                  steps: _deliverySteps,
                ),
              ),

              // Map View
              Expanded(
                child: DeliveryMapView(
                  currentLocation: _currentLocation,
                  pickupLocation: _pickupLocation,
                  deliveryLocation: _deliveryLocation,
                  onNavigationTap: _openNavigation,
                ),
              ),
            ],
          ),

          // Delivery Details Sheet
          DeliveryDetailsSheet(
            deliveryData: _deliveryData,
            onContactShipper: _contactShipper,
            onViewInstructions: _viewFullInstructions,
          ),

          // Emergency Support FAB
          Positioned(
            bottom: 20.h,
            right: 4.w,
            child: FloatingActionButton(
              heroTag: "emergency",
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              onPressed: _showEmergencySupport,
              child: CustomIconWidget(
                iconName: 'support_agent',
                color: AppTheme.lightTheme.colorScheme.onError,
                size: 6.w,
              ),
            ),
          ),

          // Status Update Button
          Positioned(
            bottom: 12.h,
            right: 4.w,
            child: FloatingActionButton.extended(
              heroTag: "status_update",
              onPressed: () {
                setState(() {
                  _showStatusButtons = !_showStatusButtons;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              icon: CustomIconWidget(
                iconName: _showStatusButtons ? 'close' : 'update',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                _showStatusButtons ? 'Close' : 'Update Status',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Status Update Buttons Overlay
          if (_showStatusButtons)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showStatusButtons = false;
                          });
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: StatusUpdateButtons(
                        currentStep: _currentStep,
                        onStatusUpdate: _updateDeliveryStatus,
                        onTakePhoto: _showPhotoCaptureSheet,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Photo Capture Sheet
          if (_showPhotoCapture)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: PhotoCaptureWidget(
                  onPhotoTaken: _handlePhotoTaken,
                  onClose: () {
                    setState(() {
                      _showPhotoCapture = false;
                    });
                  },
                ),
              ),
            ),

          // Signature Capture Sheet
          if (_showSignatureCapture) _buildSignatureCaptureSheet(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2, // Active delivery tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/driver-dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(
                  context, '/load-search-and-browse');
              break;
            case 2:
              // Current screen
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/driver-dashboard');
              break;
          }
        },
      ),
    );
  }

  void _updateDeliveryStatus(int newStep) {
    setState(() {
      _currentStep = newStep;
      _showStatusButtons = false;
    });

    // Show signature capture for final delivery
    if (newStep == 4) {
      setState(() {
        _showSignatureCapture = true;
      });
    }

    // Send push notification to shipper (mock)
    _sendStatusUpdateNotification(newStep);
  }

  void _sendStatusUpdateNotification(int step) {
    final statusMessages = {
      1: 'Driver has arrived at pickup location',
      2: 'Cargo has been loaded and secured',
      3: 'Delivery is now in transit',
      4: 'Driver has arrived at delivery location',
      5: 'Delivery has been completed successfully',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Shipper notified: ${statusMessages[step]}',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPhotoCaptureSheet() {
    setState(() {
      _showPhotoCapture = true;
      _showStatusButtons = false;
    });
  }

  void _handlePhotoTaken(XFile photo) {
    setState(() {
      _capturedImage = photo;
      _showPhotoCapture = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Photo captured with GPS coordinates and timestamp',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildSignatureCaptureSheet() {
    final SignatureController _signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: AppTheme.lightTheme.colorScheme.primary,
      exportBackgroundColor: AppTheme.lightTheme.colorScheme.surface,
    );

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Delivery Confirmation',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showSignatureCapture = false;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'Please obtain signature from the authorized recipient to confirm delivery completion.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _signatureController.clear();
                        },
                        child: Text('Clear'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_signatureController.isNotEmpty) {
                            final signature =
                                await _signatureController.toPngBytes();
                            _completeDelivery(signature);
                          }
                        },
                        child: Text('Complete Delivery'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeDelivery(dynamic signature) {
    setState(() {
      _showSignatureCapture = false;
    });

    // Show completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 10.w,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Delivery Completed!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Your delivery has been successfully completed. The shipper has been notified and payment will be processed.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(
                        context, '/driver-dashboard');
                  },
                  child: Text('Continue'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening navigation to delivery location...'),
        action: SnackBarAction(
          label: 'Open Maps',
          onPressed: () {
            // In real implementation, this would open Google Maps or Apple Maps
          },
        ),
      ),
    );
  }

  void _contactShipper() {
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
                'Contact Shipper',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Call ${_deliveryData["shipperContact"]}'),
              subtitle: Text(_deliveryData["shipperPhone"]),
              onTap: () {
                Navigator.pop(context);
                // Implement phone call
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Send Message'),
              subtitle: Text('Send SMS or in-app message'),
              onTap: () {
                Navigator.pop(context);
                // Implement messaging
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _viewFullInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delivery Instructions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              _deliveryData["instructions"],
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencySupport() {
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
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'emergency',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Emergency Support',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text('Emergency Hotline'),
              subtitle: Text('24/7 Emergency Support'),
              onTap: () {
                Navigator.pop(context);
                // Implement emergency call
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_police',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text('Contact Authorities'),
              subtitle: Text('Call 911 for immediate assistance'),
              onTap: () {
                Navigator.pop(context);
                // Implement 911 call
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
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}