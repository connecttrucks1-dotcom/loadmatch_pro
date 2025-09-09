import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/load_card_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_filter_widget.dart';
import './widgets/sort_options_widget.dart';

class LoadSearchAndBrowse extends StatefulWidget {
  const LoadSearchAndBrowse({super.key});

  @override
  State<LoadSearchAndBrowse> createState() => _LoadSearchAndBrowseState();
}

class _LoadSearchAndBrowseState extends State<LoadSearchAndBrowse>
    with TickerProviderStateMixin {
  bool _isMapView = false;
  bool _isLoading = false;
  String _searchQuery = '';
  String _sortBy = 'distance';
  bool _isAscending = true;
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _allLoads = [];
  List<Map<String, dynamic>> _filteredLoads = [];
  final LatLng _currentLocation = const LatLng(41.8781, -87.6298); // Chicago

  late AnimationController _viewToggleController;
  late Animation<double> _viewToggleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadMockData();
    _applyFiltersAndSort();
  }

  @override
  void dispose() {
    _viewToggleController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _viewToggleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _viewToggleAnimation = CurvedAnimation(
      parent: _viewToggleController,
      curve: Curves.easeInOut,
    );
  }

  void _loadMockData() {
    _allLoads = [
      {
        "id": 1,
        "payment": "\$2,850",
        "distance": "45",
        "status": "Available",
        "pickupLocation": "Chicago, IL - Warehouse District",
        "deliveryLocation": "Milwaukee, WI - Industrial Park",
        "pickupDate": "Dec 10, 2024 - 8:00 AM",
        "deliveryDate": "Dec 10, 2024 - 6:00 PM",
        "cargoType": "General Freight",
        "weight": "24,500 lbs",
        "totalDistance": "94 mi",
        "shipper": "Midwest Logistics Co.",
        "rating": 5,
        "reviewCount": 127,
        "isSaved": false,
        "pickupCoordinates": {"lat": 41.8781, "lng": -87.6298},
        "deliveryCoordinates": {"lat": 43.0389, "lng": -87.9065},
        "postedDate": "2024-12-09T14:30:00Z",
      },
      {
        "id": 2,
        "payment": "\$3,200",
        "distance": "78",
        "status": "Urgent",
        "pickupLocation": "Detroit, MI - Ford Plant",
        "deliveryLocation": "Indianapolis, IN - Distribution Center",
        "pickupDate": "Dec 9, 2024 - 6:00 AM",
        "deliveryDate": "Dec 9, 2024 - 8:00 PM",
        "cargoType": "Auto Parts",
        "weight": "32,000 lbs",
        "totalDistance": "290 mi",
        "shipper": "AutoFreight Solutions",
        "rating": 4,
        "reviewCount": 89,
        "isSaved": true,
        "pickupCoordinates": {"lat": 42.3314, "lng": -83.0458},
        "deliveryCoordinates": {"lat": 39.7684, "lng": -86.1581},
        "postedDate": "2024-12-09T10:15:00Z",
      },
      {
        "id": 3,
        "payment": "\$1,950",
        "distance": "32",
        "status": "Available",
        "pickupLocation": "Gary, IN - Steel Mill",
        "deliveryLocation": "Rockford, IL - Manufacturing Hub",
        "pickupDate": "Dec 11, 2024 - 10:00 AM",
        "deliveryDate": "Dec 11, 2024 - 4:00 PM",
        "cargoType": "Steel Products",
        "weight": "28,750 lbs",
        "totalDistance": "156 mi",
        "shipper": "Great Lakes Steel",
        "rating": 4,
        "reviewCount": 203,
        "isSaved": false,
        "pickupCoordinates": {"lat": 41.5934, "lng": -87.3464},
        "deliveryCoordinates": {"lat": 42.2711, "lng": -89.0940},
        "postedDate": "2024-12-09T16:45:00Z",
      },
      {
        "id": 4,
        "payment": "\$4,100",
        "distance": "125",
        "status": "Available",
        "pickupLocation": "St. Louis, MO - Gateway Distribution",
        "deliveryLocation": "Nashville, TN - Music City Logistics",
        "pickupDate": "Dec 12, 2024 - 7:00 AM",
        "deliveryDate": "Dec 12, 2024 - 9:00 PM",
        "cargoType": "Refrigerated",
        "weight": "26,800 lbs",
        "totalDistance": "305 mi",
        "shipper": "ColdChain Express",
        "rating": 5,
        "reviewCount": 156,
        "isSaved": false,
        "pickupCoordinates": {"lat": 38.6270, "lng": -90.1994},
        "deliveryCoordinates": {"lat": 36.1627, "lng": -86.7816},
        "postedDate": "2024-12-09T12:20:00Z",
      },
      {
        "id": 5,
        "payment": "\$2,650",
        "distance": "67",
        "status": "Pending",
        "pickupLocation": "Madison, WI - University Area",
        "deliveryLocation": "Cedar Rapids, IA - Industrial Zone",
        "pickupDate": "Dec 13, 2024 - 9:00 AM",
        "deliveryDate": "Dec 13, 2024 - 5:00 PM",
        "cargoType": "Electronics",
        "weight": "18,200 lbs",
        "totalDistance": "245 mi",
        "shipper": "TechMove Logistics",
        "rating": 4,
        "reviewCount": 74,
        "isSaved": true,
        "pickupCoordinates": {"lat": 43.0731, "lng": -89.4012},
        "deliveryCoordinates": {"lat": 41.9778, "lng": -91.6656},
        "postedDate": "2024-12-09T08:30:00Z",
      },
    ];
  }

  void _applyFiltersAndSort() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      List<Map<String, dynamic>> filtered = List.from(_allLoads);

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        filtered = filtered.where((load) {
          final pickup = (load['pickupLocation'] as String).toLowerCase();
          final delivery = (load['deliveryLocation'] as String).toLowerCase();
          final query = _searchQuery.toLowerCase();
          return pickup.contains(query) || delivery.contains(query);
        }).toList();
      }

      // Apply distance filter
      if (_activeFilters['distanceRadius'] != null) {
        final maxDistance = _activeFilters['distanceRadius'] as double;
        filtered = filtered.where((load) {
          final distance = double.tryParse(load['distance'] as String) ?? 0;
          return distance <= maxDistance;
        }).toList();
      }

      // Apply payment filter
      if (_activeFilters['minPayment'] != null &&
          _activeFilters['maxPayment'] != null) {
        final minPayment = _activeFilters['minPayment'] as double;
        final maxPayment = _activeFilters['maxPayment'] as double;
        filtered = filtered.where((load) {
          final paymentStr =
              (load['payment'] as String).replaceAll(RegExp(r'[^\d.]'), '');
          final payment = double.tryParse(paymentStr) ?? 0;
          return payment >= minPayment && payment <= maxPayment;
        }).toList();
      }

      // Apply cargo type filter
      if (_activeFilters['cargoTypes'] != null) {
        final selectedTypes = _activeFilters['cargoTypes'] as List<String>;
        if (selectedTypes.isNotEmpty) {
          filtered = filtered.where((load) {
            return selectedTypes.contains(load['cargoType']);
          }).toList();
        }
      }

      // Apply sorting
      filtered.sort((a, b) {
        int comparison = 0;

        switch (_sortBy) {
          case 'distance':
            final distanceA = double.tryParse(a['distance'] as String) ?? 0;
            final distanceB = double.tryParse(b['distance'] as String) ?? 0;
            comparison = distanceA.compareTo(distanceB);
            break;
          case 'payment':
            final paymentA = double.tryParse((a['payment'] as String)
                    .replaceAll(RegExp(r'[^\d.]'), '')) ??
                0;
            final paymentB = double.tryParse((b['payment'] as String)
                    .replaceAll(RegExp(r'[^\d.]'), '')) ??
                0;
            comparison = paymentA.compareTo(paymentB);
            break;
          case 'rating':
            comparison = (a['rating'] as int).compareTo(b['rating'] as int);
            break;
          default:
            comparison = 0;
        }

        return _isAscending ? comparison : -comparison;
      });

      setState(() {
        _filteredLoads = filtered;
        _isLoading = false;
      });
    });
  }

  void _toggleView() {
    setState(() {
      _isMapView = !_isMapView;
    });

    if (_isMapView) {
      _viewToggleController.forward();
    } else {
      _viewToggleController.reverse();
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: SearchFilterWidget(
          initialFilters: _activeFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _activeFilters = filters;
            });
            _applyFiltersAndSort();
          },
        ),
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsWidget(
        currentSortBy: _sortBy,
        isAscending: _isAscending,
        onSortChanged: (sortBy, ascending) {
          setState(() {
            _sortBy = sortBy;
            _isAscending = ascending;
          });
          _applyFiltersAndSort();
        },
      ),
    );
  }

  void _onLoadSelected(Map<String, dynamic> load) {
    Navigator.pushNamed(context, '/load-details');
  }

  void _onLoadSaved(Map<String, dynamic> load) {
    setState(() {
      load['isSaved'] = !(load['isSaved'] as bool? ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          load['isSaved'] == true
              ? 'Load saved successfully'
              : 'Load removed from saved',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_activeFilters['distanceRadius'] != null &&
        _activeFilters['distanceRadius'] != 50.0) count++;
    if (_activeFilters['minPayment'] != null &&
        (_activeFilters['minPayment'] != 500.0 ||
            _activeFilters['maxPayment'] != 5000.0)) count++;
    if (_activeFilters['cargoTypes'] != null &&
        (_activeFilters['cargoTypes'] as List).isNotEmpty) count++;
    if (_activeFilters['timeframe'] != null &&
        _activeFilters['timeframe'] != 'any') count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Find Loads',
        actions: [
          IconButton(
            onPressed: _showSortBottomSheet,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Sort Options',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            initialQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _applyFiltersAndSort();
            },
            onSearchSubmitted: (query) {
              setState(() {
                _searchQuery = query;
              });
              _applyFiltersAndSort();
            },
            onFilterTap: _showFilterBottomSheet,
            activeFilterCount: _getActiveFilterCount(),
          ),

          // View Toggle
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_isMapView) _toggleView();
                    },
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(8)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: !_isMapView
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'list',
                            color: !_isMapView
                                ? Colors.white
                                : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'List View',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: !_isMapView
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!_isMapView) _toggleView();
                    },
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(8)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: _isMapView
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'map',
                            color: _isMapView
                                ? Colors.white
                                : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Map View',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _isMapView
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredLoads.length} loads found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (_isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 1.h),

          // Content Area
          Expanded(
            child: AnimatedBuilder(
              animation: _viewToggleAnimation,
              builder: (context, child) {
                return _isMapView ? _buildMapView() : _buildListView();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1, // Find Loads tab
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }

  Widget _buildListView() {
    if (_filteredLoads.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        _applyFiltersAndSort();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 2.h),
        itemCount: _filteredLoads.length,
        itemBuilder: (context, index) {
          final load = _filteredLoads[index];
          return Slidable(
            key: Key(load['id'].toString()),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _onLoadSaved(load),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  icon: load['isSaved'] == true
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  label: load['isSaved'] == true ? 'Saved' : 'Save',
                ),
                SlidableAction(
                  onPressed: (_) => _onLoadSelected(load),
                  backgroundColor: AppTheme.successLight,
                  foregroundColor: Colors.white,
                  icon: Icons.visibility,
                  label: 'View',
                ),
              ],
            ),
            child: LoadCardWidget(
              loadData: load,
              onTap: () => _onLoadSelected(load),
              onSave: () => _onLoadSaved(load),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapView() {
    return MapViewWidget(
      loads: _filteredLoads,
      currentLocation: _currentLocation,
      onLoadSelected: _onLoadSelected,
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No loads found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search criteria or expanding your search radius to find more loads.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _activeFilters.clear();
                });
                _applyFiltersAndSort();
              },
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Clear Filters'),
            ),
            SizedBox(height: 2.h),
            OutlinedButton.icon(
              onPressed: _showFilterBottomSheet,
              icon: CustomIconWidget(
                iconName: 'tune',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              label: const Text('Expand Search Radius'),
            ),
          ],
        ),
      ),
    );
  }
}