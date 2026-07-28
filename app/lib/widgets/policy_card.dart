import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/policy_model.dart';
import '../utils/app_theme.dart';
import 'luxury_card.dart';

class PolicyCard extends StatelessWidget {
  final PolicyModel policy;
  final VoidCallback onTap;

  const PolicyCard({
    super.key,
    required this.policy,
    required this.onTap,
  });

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'auto':
        return Icons.directions_car_outlined;
      case 'health':
        return Icons.health_and_safety_outlined;
      case 'life':
        return Icons.favorite_border;
      case 'home':
        return Icons.home_outlined;
      case 'travel':
        return Icons.flight_takeoff_outlined;
      default:
        return Icons.policy_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0, locale: 'en_IN');

    return LuxuryCard(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_getIconForType(policy.type), color: AppTheme.primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policy.provider,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.alabasterGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${policy.type.toUpperCase()} • ${policy.policyNumber}',
                  style: const TextStyle(color: AppTheme.dustyDenim, fontSize: 13, letterSpacing: 0.5),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: policy.daysUntilRenewal <= 30
                        ? AppTheme.warningColor.withOpacity(0.1)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Renews in ${policy.daysUntilRenewal} days',
                    style: TextStyle(
                      color: policy.daysUntilRenewal <= 30
                          ? AppTheme.warningColor
                          : AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${currencyFormatter.format(policy.premiumAmount)}/${policy.premiumCadence.substring(0, 1)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.alabasterGrey,
            ),
          ),
        ],
      ),
    );
  }
}
