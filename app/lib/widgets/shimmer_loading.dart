import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_theme.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.prussianBlue,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(
      duration: 1500.ms,
      color: AppTheme.dustyDenim.withOpacity(0.2),
      angle: 1.0,
    );
  }
}
