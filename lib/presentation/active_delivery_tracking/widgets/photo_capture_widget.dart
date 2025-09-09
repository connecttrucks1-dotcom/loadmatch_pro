
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoCaptureWidget extends StatefulWidget {
  final Function(XFile) onPhotoTaken;
  final VoidCallback? onClose;

  const PhotoCaptureWidget({
    super.key,
    required this.onPhotoTaken,
    this.onClose,
  });

  @override
  State<PhotoCaptureWidget> createState() => _PhotoCaptureWidgetState();
}

class _PhotoCaptureWidgetState extends State<PhotoCaptureWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isLoading = true;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        setState(() => _isLoading = false);
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      // Ignore focus mode errors
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        // Ignore flash mode errors on unsupported devices
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onPhotoTaken(photo);
    } catch (e) {
      _showErrorSnackBar('Failed to capture photo');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        widget.onPhotoTaken(image);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image from gallery');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? _buildLoadingView()
                : _isInitialized
                    ? _buildCameraView()
                    : _buildErrorView(),
          ),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Take Photo',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Initializing camera...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: CameraPreview(_cameraController!),
        ),
        Positioned(
          top: 2.h,
          right: 4.w,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Position cargo in frame',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'camera_alt',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Camera not available',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please check camera permissions or try selecting from gallery',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: 'photo_library',
            label: 'Gallery',
            onTap: _pickFromGallery,
          ),
          _buildCaptureButton(),
          _buildControlButton(
            icon: kIsWeb ? 'camera_front' : 'flip_camera_ios',
            label: 'Flip',
            onTap: _isInitialized ? _switchCamera : null,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: onTap != null
                  ? AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  : AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: onTap != null
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: onTap != null
                  ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _isInitialized ? _capturePhoto : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: _isInitialized
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 3,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'camera_alt',
                color: _isInitialized
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 8.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Capture',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: _isInitialized
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    try {
      final currentCamera = _cameraController!.description;
      final newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection != currentCamera.lensDirection,
        orElse: () => _cameras.first,
      );

      await _cameraController!.dispose();

      _cameraController = CameraController(
        newCamera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _showErrorSnackBar('Failed to switch camera');
    }
  }
}
