import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String? initialQuery;
  final Function(String) onSearchChanged;
  final Function(String) onSearchSubmitted;
  final VoidCallback? onFilterTap;
  final int activeFilterCount;
  final bool showVoiceSearch;

  const SearchBarWidget({
    super.key,
    this.initialQuery,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    this.onFilterTap,
    this.activeFilterCount = 0,
    this.showVoiceSearch = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  final List<String> _recentSearches = [
    'Chicago, IL',
    'Dallas, TX',
    'Los Angeles, CA',
    'Atlanta, GA',
    'Phoenix, AZ',
  ];

  final List<String> _popularLocations = [
    'New York, NY',
    'Miami, FL',
    'Seattle, WA',
    'Denver, CO',
    'Nashville, TN',
    'Houston, TX',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _updateSuggestions(_controller.text);
      setState(() {
        _showSuggestions = true;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [..._recentSearches, ..._popularLocations];
      });
      return;
    }

    final filteredSuggestions = [
      ..._recentSearches,
      ..._popularLocations,
    ]
        .where(
            (location) => location.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _suggestions = filteredSuggestions;
    });
  }

  void _onSearchTextChanged(String value) {
    _updateSuggestions(value);
    widget.onSearchChanged(value);
  }

  void _onSuggestionSelected(String suggestion) {
    _controller.text = suggestion;
    _focusNode.unfocus();
    widget.onSearchSubmitted(suggestion);
  }

  void _onVoiceSearch() {
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onSearchTextChanged,
                  onSubmitted: widget.onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Search by city, state, or route...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_controller.text.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              _controller.clear();
                              widget.onSearchChanged('');
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        if (widget.showVoiceSearch)
                          IconButton(
                            onPressed: _onVoiceSearch,
                            icon: CustomIconWidget(
                              iconName: 'mic',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              InkWell(
                onTap: widget.onFilterTap,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomIconWidget(
                        iconName: 'tune',
                        color: widget.activeFilterCount > 0
                            ? AppTheme.lightTheme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      if (widget.activeFilterCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.errorLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              widget.activeFilterCount.toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Suggestions dropdown
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_controller.text.isEmpty) ...[
                  _buildSuggestionSection(
                    theme,
                    'Recent Searches',
                    'history',
                    _recentSearches,
                  ),
                  _buildSuggestionSection(
                    theme,
                    'Popular Locations',
                    'trending_up',
                    _popularLocations,
                  ),
                ] else ...[
                  _buildSuggestionSection(
                    theme,
                    'Suggestions',
                    'location_on',
                    _suggestions.take(6).toList(),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSuggestionSection(
    ThemeData theme,
    String title,
    String iconName,
    List<String> suggestions,
  ) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: theme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...suggestions.map((suggestion) => InkWell(
              onTap: () => _onSuggestionSelected(suggestion),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                child: Row(
                  children: [
                    SizedBox(width: 6.w), // Align with section title
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'north_west',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ],
                ),
              ),
            )),
        if (suggestions != _suggestions.take(6).toList()) SizedBox(height: 1.h),
      ],
    );
  }
}
