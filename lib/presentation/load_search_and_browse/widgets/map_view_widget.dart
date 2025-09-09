import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> loads;
  final Function(Map<String, dynamic>) onLoadSelected;
  final LatLng? currentLocation;

  const MapViewWidget({
    super.key,
    required this.loads,
    required this.onLoadSelected,
    this.currentLocation,
  });

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedLoad;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  @override
  void didUpdateWidget(MapViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loads != widget.loads) {
      _createMarkers();
    }
  }

  void _createMarkers() {
    setState(() {
      _isLoading = true;
      _markers.clear();
    });

    final Set<Marker> markers = {};

    // Add current location marker
    if (widget.currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: widget.currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current driver position',
          ),
        ),
      );
    }

    // Add load markers
    for (int i = 0; i < widget.loads.length; i++) {
      final load = widget.loads[i];
      final pickupCoords = load['pickupCoordinates'] as Map<String, dynamic>?;
      final deliveryCoords =
          load['deliveryCoordinates'] as Map<String, dynamic>?;

      if (pickupCoords != null) {
        markers.add(
          Marker(
            markerId: MarkerId('pickup_${load['id']}'),
            position: LatLng(
              pickupCoords['lat'] as double,
              pickupCoords['lng'] as double,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: 'Pickup: ${load['pickupLocation']}',
              snippet: '${load['payment']} • ${load['cargoType']}',
            ),
            onTap: () => _onMarkerTapped(load),
          ),
        );
      }

      if (deliveryCoords != null) {
        markers.add(
          Marker(
            markerId: MarkerId('delivery_${load['id']}'),
            position: LatLng(
              deliveryCoords['lat'] as double,
              deliveryCoords['lng'] as double,
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: 'Delivery: ${load['deliveryLocation']}',
              snippet: '${load['payment']} • ${load['cargoType']}',
            ),
            onTap: () => _onMarkerTapped(load),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      _isLoading = false;
    });
  }

  void _onMarkerTapped(Map<String, dynamic> load) {
    setState(() {
      _selectedLoad = load;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitMarkersInView();
  }

  void _fitMarkersInView() {
    if (_markers.isEmpty || _mapController == null) return;

    final bounds = _calculateBounds();
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0),
    );
  }

  LatLngBounds _calculateBounds() {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (final marker in _markers) {
      final position = marker.position;
      minLat = minLat > position.latitude ? position.latitude : minLat;
      maxLat = maxLat < position.latitude ? position.latitude : maxLat;
      minLng = minLng > position.longitude ? position.longitude : minLng;
      maxLng = maxLng < position.longitude ? position.longitude : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: widget.currentLocation ??
                const LatLng(39.8283, -98.5795), // Center of US
            zoom: 6.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onTap: (_) {
            setState(() {
              _selectedLoad = null;
            });
          },
        ),

        // Loading indicator
        if (_isLoading)
          Container(
            color: theme.colorScheme.surface.withValues(alpha: 0.8),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),

        // Custom controls
        Positioned(
          top: 2.h,
          right: 4.w,
          child: Column(
            children: [
              _buildMapButton(
                theme,
                'my_location',
                'My Location',
                _goToCurrentLocation,
              ),
              SizedBox(height: 1.h),
              _buildMapButton(
                theme,
                'zoom_out_map',
                'Fit All',
                _fitMarkersInView,
              ),
            ],
          ),
        ),

        // Load preview card
        if (_selectedLoad != null)
          Positioned(
            bottom: 2.h,
            left: 4.w,
            right: 4.w,
            child: _buildLoadPreviewCard(theme, _selectedLoad!),
          ),

        // Legend
        Positioned(
          top: 2.h,
          left: 4.w,
          child: _buildLegend(theme),
        ),
      ],
    );
  }

  Widget _buildMapButton(
    ThemeData theme,
    String iconName,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Legend',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          _buildLegendItem(theme, Colors.blue, 'Your Location'),
          _buildLegendItem(theme, Colors.green, 'Pickup Points'),
          _buildLegendItem(theme, Colors.red, 'Delivery Points'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, Color color, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadPreviewCard(ThemeData theme, Map<String, dynamic> load) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  load['payment'] as String? ?? '\$0',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedLoad = null;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '${load['pickupLocation']} → ${load['deliveryLocation']}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'inventory_2',
                color: theme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                load['cargoType'] as String? ?? 'General Freight',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 3.w),
              CustomIconWidget(
                iconName: 'straighten',
                color: theme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${load['distance']} miles',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onLoadSelected(load),
              child: Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  void _goToCurrentLocation() {
    if (widget.currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(widget.currentLocation!, 12.0),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
