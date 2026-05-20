import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/radio_player_widget.dart';
import './widgets/social_links_widget.dart';
import './widgets/station_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.backgroundDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated background gradient
          const BackgroundGradientWidget(),

          // Main content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 480 : double.infinity,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 0 : 4.w,
                          vertical: 2.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: isTablet ? 3.h : 2.h),

                            // Station header with logo
                            const StationHeaderWidget(),

                            SizedBox(height: isTablet ? 5.h : 4.h),

                            // Radio player
                            const RadioPlayerWidget(),

                            SizedBox(height: isTablet ? 5.h : 4.h),

                            // Social media links
                            const SocialLinksWidget(),

                            SizedBox(height: isTablet ? 3.h : 2.h),

                            // Footer
                            _buildFooter(context),

                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          width: 40.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.glassBorder,
                Colors.transparent,
              ],
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        Text(
          '© 2026 Misionera FM 94.9',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 10.sp,
            color: AppTheme.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Transmitiendo la Palabra de Dios',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 9.5.sp,
            color: AppTheme.gold.withAlpha(153),
            fontStyle: FontStyle.italic,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
