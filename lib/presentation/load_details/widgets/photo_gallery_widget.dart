import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoGalleryWidget extends StatelessWidget {
  final Map<String, dynamic> loadData;

  const PhotoGalleryWidget({
    super.key,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final photos = (loadData['photos'] as List?)?.cast<String>() ?? [];

    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

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
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Cargo Photos',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${photos.length} ${photos.length == 1 ? 'photo' : 'photos'}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 25.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(context, photos, index),
                  child: Container(
                    width: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          CustomImageWidget(
                            imageUrl: photos[index],
                            width: 35.w,
                            height: 25.h,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 2.w,
                            right: 2.w,
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: CustomIconWidget(
                                iconName: 'zoom_in',
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, List<String> photos, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImageViewer(
          photos: photos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const _FullScreenImageViewer({
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1} of ${widget.photos.length}',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: CustomImageWidget(
                imageUrl: widget.photos[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: widget.photos.length > 1
          ? Container(
              color: Colors.black,
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.photos.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
