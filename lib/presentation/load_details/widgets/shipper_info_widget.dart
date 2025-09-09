import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShipperInfoWidget extends StatelessWidget {
  final Map<String, dynamic> loadData;

  const ShipperInfoWidget({
    super.key,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final shipperData = loadData['shipper'] as Map<String, dynamic>? ?? {};
    final companyName =
        shipperData['companyName'] as String? ?? 'Unknown Company';
    final rating = shipperData['rating'] as double? ?? 0.0;
    final totalRatings = shipperData['totalRatings'] as int? ?? 0;
    final avatarUrl = shipperData['avatar'] as String?;

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
                  iconName: 'business',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Shipper Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: avatarUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: avatarUrl,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: 'business',
                          color: AppTheme
                              .lightTheme.colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return CustomIconWidget(
                            iconName:
                                index < rating.floor() ? 'star' : 'star_border',
                            color: index < rating.floor()
                                ? Colors.amber
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          );
                        }),
                        SizedBox(width: 2.w),
                        Text(
                          '${rating.toStringAsFixed(1)} ($totalRatings)',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _showShipperProfile(context, shipperData);
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'View Profile',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShipperProfile(
      BuildContext context, Map<String, dynamic> shipperData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Shipper Profile',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'business',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      title: Text('Company Name'),
                      subtitle: Text(
                          shipperData['companyName'] as String? ?? 'Unknown'),
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      title: Text('Location'),
                      subtitle: Text(shipperData['location'] as String? ??
                          'Not specified'),
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      title: Text('Contact'),
                      subtitle: Text(
                          shipperData['phone'] as String? ?? 'Not available'),
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'history',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      title: Text('Total Loads'),
                      subtitle:
                          Text('${shipperData['totalLoads'] ?? 0} completed'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
