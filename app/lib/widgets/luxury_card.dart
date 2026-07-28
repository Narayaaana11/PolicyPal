import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_theme.dart';

class LuxuryCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool hasGlow;

  const LuxuryCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.hasGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: hasGlow ? AppTheme.softGlow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: AppTheme.primaryColor.withOpacity(0.1),
          highlightColor: AppTheme.primaryColor.withOpacity(0.05),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.premiumGradient,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.duskBlue.withOpacity(0.3), width: 1),
            ),
            child: child,
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutQuad);
  }
}
