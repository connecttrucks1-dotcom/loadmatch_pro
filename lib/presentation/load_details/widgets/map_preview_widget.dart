import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapPreviewWidget extends StatefulWidget {
  final Map<String, dynamic> loadData;

  const MapPreviewWidget({
    super.key,
    required this.loadData,
  });

  @override
  State<MapPreviewWidget> createState() => _MapPreviewWidgetState();
}

class _MapPreviewWidgetState extends State<MapPreviewWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _setupMapData();
  }

  void _setupMapData() {
    final pickupCoords =
        widget.loadData['pickupCoordinates'] as Map<String, dynamic>?;
    final deliveryCoords =
        widget.loadData['deliveryCoordinates'] as Map<String, dynamic>?;

    if (pickupCoords != null && deliveryCoords != null) {
      final pickupLatLng = LatLng(
        pickupCoords['latitude'] as double? ?? 0.0,
        pickupCoords['longitude'] as double? ?? 0.0,
      );
      final deliveryLatLng = LatLng(
        deliveryCoords['latitude'] as double? ?? 0.0,
        deliveryCoords['longitude'] as double? ?? 0.0,
      );

      _markers = {
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLatLng,
          infoWindow: InfoWindow(
            title: 'Pickup Location',
            snippet: widget.loadData['pickupLocation'] as String? ?? '',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: const MarkerId('delivery'),
          position: deliveryLatLng,
          infoWindow: InfoWindow(
            title: 'Delivery Location',
            snippet: widget.loadData['deliveryLocation'] as String? ?? '',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };

      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [pickupLatLng, deliveryLatLng],
          color: AppTheme.lightTheme.colorScheme.primary,
          width: 3,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickupCoords =
        widget.loadData['pickupCoordinates'] as Map<String, dynamic>?;
    final deliveryCoords =
        widget.loadData['deliveryCoordinates'] as Map<String, dynamic>?;

    if (pickupCoords == null || deliveryCoords == null) {
      return const SizedBox.shrink();
    }

    final centerLat = ((pickupCoords['latitude'] as double? ?? 0.0) +
            (deliveryCoords['latitude'] as double? ?? 0.0)) /
        2;
    final centerLng = ((pickupCoords['longitude'] as double? ?? 0.0) +
            (deliveryCoords['longitude'] as double? ?? 0.0)) /
        2;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'map',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Route Preview',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showFullScreenMap(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Full Map',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'open_in_full',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            height: 30.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(centerLat, centerLng),
                  zoom: 8.0,
                ),
                markers: _markers,
                polylines: _polylines,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
              ),
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
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'traffic',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Traffic Status',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Light Traffic',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                              ),
                            ),
                          ],
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
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'local_shipping',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Truck Route',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Optimized',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ],
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

  void _showFullScreenMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenMapView(
          loadData: widget.loadData,
          markers: _markers,
          polylines: _polylines,
        ),
      ),
    );
  }
}

class _FullScreenMapView extends StatefulWidget {
  final Map<String, dynamic> loadData;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const _FullScreenMapView({
    required this.loadData,
    required this.markers,
    required this.polylines,
  });

  @override
  State<_FullScreenMapView> createState() => _FullScreenMapViewState();
}

class _FullScreenMapViewState extends State<_FullScreenMapView> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final pickupCoords =
        widget.loadData['pickupCoordinates'] as Map<String, dynamic>?;
    final deliveryCoords =
        widget.loadData['deliveryCoordinates'] as Map<String, dynamic>?;

    final centerLat = ((pickupCoords?['latitude'] as double? ?? 0.0) +
            (deliveryCoords?['latitude'] as double? ?? 0.0)) /
        2;
    final centerLng = ((pickupCoords?['longitude'] as double? ?? 0.0) +
            (deliveryCoords?['longitude'] as double? ?? 0.0)) /
        2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Map'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'navigation',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening navigation...')),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(centerLat, centerLng),
          zoom: 10.0,
        ),
        markers: widget.markers,
        polylines: widget.polylines,
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}
