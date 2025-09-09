import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryMapView extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng pickupLocation;
  final LatLng deliveryLocation;
  final VoidCallback? onNavigationTap;

  const DeliveryMapView({
    super.key,
    required this.currentLocation,
    required this.pickupLocation,
    required this.deliveryLocation,
    this.onNavigationTap,
  });

  @override
  State<DeliveryMapView> createState() => _DeliveryMapViewState();
}

class _DeliveryMapViewState extends State<DeliveryMapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('current_location'),
        position: widget.currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Current position',
        ),
      ),
      Marker(
        markerId: const MarkerId('pickup_location'),
        position: widget.pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(
          title: 'Pickup Location',
          snippet: 'Cargo pickup point',
        ),
      ),
      Marker(
        markerId: const MarkerId('delivery_location'),
        position: widget.deliveryLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(
          title: 'Delivery Location',
          snippet: 'Final destination',
        ),
      ),
    };

    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [
          widget.currentLocation,
          widget.pickupLocation,
          widget.deliveryLocation,
        ],
        color: AppTheme.lightTheme.colorScheme.primary,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitMarkersInView();
  }

  void _fitMarkersInView() {
    if (_mapController != null) {
      final bounds = _calculateBounds([
        widget.currentLocation,
        widget.pickupLocation,
        widget.deliveryLocation,
      ]);

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: widget.currentLocation,
            zoom: 12.0,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          trafficEnabled: true,
        ),
        Positioned(
          top: 2.h,
          right: 4.w,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: "navigation",
                mini: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                onPressed: widget.onNavigationTap,
                child: CustomIconWidget(
                  iconName: 'navigation',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
              ),
              SizedBox(height: 1.h),
              FloatingActionButton(
                heroTag: "my_location",
                mini: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                onPressed: () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(widget.currentLocation, 15.0),
                  );
                },
                child: CustomIconWidget(
                  iconName: 'my_location',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
              SizedBox(height: 1.h),
              FloatingActionButton(
                heroTag: "fit_bounds",
                mini: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                onPressed: _fitMarkersInView,
                child: CustomIconWidget(
                  iconName: 'zoom_out_map',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
