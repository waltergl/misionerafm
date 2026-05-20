import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';

class SocialLinksWidget extends StatelessWidget {
  const SocialLinksWidget({super.key});

  static final List<_SocialLink> _links = [
    _SocialLink(
      label: 'Facebook',
      icon: Icons.facebook_rounded,
      url: 'https://www.facebook.com/radiomisionerafm',
      color: const Color(0xFF1877F2),
      glowColor: const Color(0xFF1877F2),
    ),
    _SocialLink(
      label: 'TikTok',
      icon: Icons.music_note_rounded,
      url: 'https://www.tiktok.com/@misionerafm94.9',
      color: const Color(0xFF010101),
      glowColor: const Color(0xFF69C9D0),
      borderColor: const Color(0xFF69C9D0),
    ),
    _SocialLink(
      label: 'WhatsApp',
      icon: Icons.chat_rounded,
      url: 'https://wa.me/31876238',
      color: const Color(0xFF25D366),
      glowColor: const Color(0xFF25D366),
    ),
  ];

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No se pudo abrir el enlace',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 9.sp,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppTheme.surfaceElevated,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir enlace'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Column(
      children: [
        Text(
          'SÍGUENOS EN',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.textMuted,
            letterSpacing: 3,
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _links.map((link) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 3.w : 4.w),
              child: _SocialButton(
                link: link,
                onTap: () => _launchUrl(context, link.url),
                isTablet: isTablet,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final _SocialLink link;
  final VoidCallback onTap;
  final bool isTablet;

  const _SocialButton({
    required this.link,
    required this.onTap,
    required this.isTablet,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.isTablet ? 14.w : 17.w;
    final double clampedSize = size.clamp(58.0, 76.0);

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        _controller.forward();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        _controller.reverse();
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
        setState(() => _isPressed = false);
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: clampedSize,
              height: clampedSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.link.color.withAlpha(38),
                border: Border.all(
                  color: (widget.link.borderColor ?? widget.link.glowColor)
                      .withOpacity(_isPressed ? 0.9 : 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.link.glowColor.withOpacity(
                      _isPressed ? 0.5 : 0.2,
                    ),
                    blurRadius: _isPressed ? 20 : 12,
                    spreadRadius: _isPressed ? 3 : 1,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.link.icon,
                  color: _isPressed
                      ? widget.link.glowColor
                      : widget.link.glowColor.withAlpha(217),
                  size: clampedSize * 0.42,
                ),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              widget.link.label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLink {
  final String label;
  final IconData icon;
  final String url;
  final Color color;
  final Color glowColor;
  final Color? borderColor;

  const _SocialLink({
    required this.label,
    required this.icon,
    required this.url,
    required this.color,
    required this.glowColor,
    this.borderColor,
  });
}
