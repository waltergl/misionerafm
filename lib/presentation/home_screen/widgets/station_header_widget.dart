import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class StationHeaderWidget extends StatefulWidget {
  const StationHeaderWidget({super.key});

  @override
  State<StationHeaderWidget> createState() => _StationHeaderWidgetState();
}

class _StationHeaderWidgetState extends State<StationHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Column(
      children: [
        // Logo container with glow
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(
                      0.3 * _pulseAnimation.value,
                    ),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                  BoxShadow(
                    color: AppTheme.gold.withOpacity(
                      0.15 * _pulseAnimation.value,
                    ),
                    blurRadius: 60,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Container(
            width: isTablet ? 52.w : 70.w,
            height: isTablet ? 52.w : 70.w,
            constraints: const BoxConstraints(maxWidth: 280, maxHeight: 280),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.glassBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(102),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/WhatsApp_Image_2026-05-05_at_11.09.00_AM-1779299476977.jpeg',
                fit: BoxFit.cover,
                semanticLabel:
                    'Logo de Misionera FM 94.9 — radio cristiana con diseño azul, rojo y dorado',
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.primary, AppTheme.primaryLight],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'FM',
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: isTablet ? 14.sp : 18.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                          ),
                          Text(
                            '94.9',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 10.sp : 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Station name
        Text(
          'MISIONERA FM',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: isTablet ? 13.sp : 16.sp,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
            letterSpacing: 4,
          ),
        ),

        SizedBox(height: 0.6.h),

        // Frequency badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.accent, AppTheme.primary],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withAlpha(77),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '94.9 MHz',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Radio Cristiana',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.gold.withAlpha(217),
            letterSpacing: 1.5,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
