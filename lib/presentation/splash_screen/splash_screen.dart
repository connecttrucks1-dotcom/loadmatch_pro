import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _loadingText = 'Initializing LoadMatch Pro...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo scale animation with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization steps with realistic loading messages
      await _performInitializationSteps();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _loadingText = 'Ready to connect drivers and shippers!';
        });

        // Wait for animations to complete before navigation
        await Future.delayed(const Duration(milliseconds: 800));
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _loadingText = 'Connection timeout. Tap to retry.';
        });
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    final steps = [
      {'message': 'Checking authentication status...', 'duration': 600},
      {'message': 'Loading user preferences...', 'duration': 500},
      {'message': 'Fetching available loads...', 'duration': 700},
      {'message': 'Preparing GPS services...', 'duration': 600},
      {'message': 'Connecting to LoadMatch network...', 'duration': 500},
    ];

    for (final step in steps) {
      if (mounted) {
        setState(() {
          _loadingText = step['message'] as String;
        });
        await Future.delayed(Duration(milliseconds: step['duration'] as int));
      }
    }
  }

  void _navigateToNextScreen() {
    // Simulate authentication check and navigation logic
    final isAuthenticated = _checkAuthenticationStatus();
    final userRole = _getUserRole();

    if (isAuthenticated) {
      if (userRole == 'driver') {
        Navigator.pushReplacementNamed(context, '/driver-dashboard');
      } else if (userRole == 'shipper') {
        Navigator.pushReplacementNamed(context, '/shipper-dashboard');
      } else {
        // Default to driver dashboard for demo
        Navigator.pushReplacementNamed(context, '/driver-dashboard');
      }
    } else {
      // For demo purposes, navigate to driver dashboard
      // In real app, this would go to login/onboarding
      Navigator.pushReplacementNamed(context, '/driver-dashboard');
    }
  }

  bool _checkAuthenticationStatus() {
    // Simulate authentication check
    // In real app, this would check stored tokens/preferences
    return false; // For demo, assume not authenticated
  }

  String _getUserRole() {
    // Simulate user role retrieval
    // In real app, this would come from stored user data
    return 'driver'; // Default role for demo
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isInitialized = false;
      _loadingText = 'Retrying connection...';
    });

    // Reset and restart animations
    _logoAnimationController.reset();
    _progressAnimationController.reset();
    _logoAnimationController.forward();
    _progressAnimationController.forward();

    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide status bar on Android, set status bar color on iOS
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.6),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: _hasError ? _retryInitialization : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo section with animation
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Truck logo icon
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4.w),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'local_shipping',
                                      color: Colors.white,
                                      size: 12.w,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 3.h),

                                // App name
                                Text(
                                  'LoadMatch Pro',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: 1.h),

                                // Tagline
                                Text(
                                  'Connecting Drivers & Shippers',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Loading section
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Loading indicator or error state
                      if (_hasError) ...[
                        CustomIconWidget(
                          iconName: 'refresh',
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 8.w,
                        ),
                        SizedBox(height: 2.h),
                      ] else if (!_isInitialized) ...[
                        // Animated progress indicator
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 60.w,
                              height: 0.5.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(0.25.h),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 60.w * _progressAnimation.value,
                                  height: 0.5.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0.25.h),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 3.h),
                      ] else ...[
                        // Success indicator
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 8.w,
                        ),
                        SizedBox(height: 2.h),
                      ],

                      // Loading text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          _loadingText,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Retry instruction for error state
                      if (_hasError) ...[
                        SizedBox(height: 1.h),
                        Text(
                          'Tap anywhere to retry',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),

                // Footer section
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '© 2024 LoadMatch Pro. All rights reserved.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 9.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
