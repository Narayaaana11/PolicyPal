import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class DisclaimerBanner extends StatelessWidget {
  final String? customText;

  const DisclaimerBanner({super.key, this.customText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppTheme.warningColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              customText ?? AppConstants.claimsDisclaimer,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF92400E),
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
