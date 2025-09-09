import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> initialFilters;

  const SearchFilterWidget({
    super.key,
    required this.onFiltersChanged,
    this.initialFilters = const {},
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  late Map<String, dynamic> _filters;
  double _distanceRadius = 50.0;
  RangeValues _paymentRange = const RangeValues(500, 5000);
  List<String> _selectedCargoTypes = [];
  String _selectedTimeframe = 'any';

  final List<String> _cargoTypes = [
    'General Freight',
    'Refrigerated',
    'Flatbed',
    'Dry Van',
    'Tanker',
    'Auto Transport',
    'Heavy Haul',
    'Hazmat',
  ];

  final List<Map<String, String>> _timeframes = [
    {'value': 'any', 'label': 'Any Time'},
    {'value': 'today', 'label': 'Today'},
    {'value': 'tomorrow', 'label': 'Tomorrow'},
    {'value': 'week', 'label': 'This Week'},
    {'value': 'month', 'label': 'This Month'},
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.initialFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    _distanceRadius = (_filters['distanceRadius'] as double?) ?? 50.0;
    _paymentRange = RangeValues(
      (_filters['minPayment'] as double?) ?? 500.0,
      (_filters['maxPayment'] as double?) ?? 5000.0,
    );
    _selectedCargoTypes = List<String>.from(_filters['cargoTypes'] ?? []);
    _selectedTimeframe = _filters['timeframe'] as String? ?? 'any';
  }

  void _updateFilters() {
    _filters = {
      'distanceRadius': _distanceRadius,
      'minPayment': _paymentRange.start,
      'maxPayment': _paymentRange.end,
      'cargoTypes': _selectedCargoTypes,
      'timeframe': _selectedTimeframe,
    };
    widget.onFiltersChanged(_filters);
  }

  void _clearAllFilters() {
    setState(() {
      _distanceRadius = 50.0;
      _paymentRange = const RangeValues(500, 5000);
      _selectedCargoTypes.clear();
      _selectedTimeframe = 'any';
    });
    _updateFilters();
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_distanceRadius != 50.0) count++;
    if (_paymentRange.start != 500.0 || _paymentRange.end != 5000.0) count++;
    if (_selectedCargoTypes.isNotEmpty) count++;
    if (_selectedTimeframe != 'any') count++;
    return count;
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDistanceSection(theme),
                  SizedBox(height: 3.h),
                  _buildPaymentSection(theme),
                  SizedBox(height: 3.h),
                  _buildCargoTypeSection(theme),
                  SizedBox(height: 3.h),
                  _buildTimeframeSection(theme),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildFooter(theme),
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
            'Filter Loads',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              if (_getActiveFilterCount() > 0) ...[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_getActiveFilterCount()} active',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
              ],
              TextButton(
                onPressed: _clearAllFilters,
                child: Text(
                  'Clear All',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Distance Radius',
      'location_on',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_distanceRadius.round()} miles from your location',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _distanceRadius,
              min: 10,
              max: 500,
              divisions: 49,
              onChanged: (value) {
                setState(() {
                  _distanceRadius = value;
                });
              },
              onChangeEnd: (value) => _updateFilters(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('10 mi', style: theme.textTheme.bodySmall),
              Text('500 mi', style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Payment Range',
      'attach_money',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$${_paymentRange.start.round()} - \$${_paymentRange.end.round()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          RangeSlider(
            values: _paymentRange,
            min: 100,
            max: 10000,
            divisions: 99,
            onChanged: (values) {
              setState(() {
                _paymentRange = values;
              });
            },
            onChangeEnd: (values) => _updateFilters(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$100', style: theme.textTheme.bodySmall),
              Text('\$10,000', style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCargoTypeSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Cargo Type',
      'inventory_2',
      Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _cargoTypes.map((type) {
          final isSelected = _selectedCargoTypes.contains(type);
          return FilterChip(
            label: Text(type),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedCargoTypes.add(type);
                } else {
                  _selectedCargoTypes.remove(type);
                }
              });
              _updateFilters();
            },
            backgroundColor: theme.colorScheme.surface,
            selectedColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            side: BorderSide(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeframeSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Delivery Timeframe',
      'schedule',
      Column(
        children: _timeframes.map((timeframe) {
          final isSelected = _selectedTimeframe == timeframe['value'];
          return RadioListTile<String>(
            title: Text(
              timeframe['label']!,
              style: theme.textTheme.bodyMedium,
            ),
            value: timeframe['value']!,
            groupValue: _selectedTimeframe,
            onChanged: (value) {
              setState(() {
                _selectedTimeframe = value!;
              });
              _updateFilters();
            },
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    String iconName,
    Widget content,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          content,
        ],
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  _updateFilters();
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
