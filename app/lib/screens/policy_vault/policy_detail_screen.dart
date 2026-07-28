import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/policy_model.dart';
import '../../utils/app_theme.dart';
import '../../widgets/disclaimer_banner.dart';
import '../../widgets/luxury_card.dart';
import '../../widgets/explain_clause_modal.dart';

class PolicyDetailScreen extends StatelessWidget {
  final PolicyModel policy;

  const PolicyDetailScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: AppTheme.alabasterGrey),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
              title: Text(
                '${policy.provider}\n${policy.type.toUpperCase()}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                maxLines: 2,
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.premiumGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      bottom: -40,
                      child: Icon(
                        _getIconForType(policy.type),
                        size: 160,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              policy.status.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Premium',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                          Text(
                            '${currencyFormatter.format(policy.premiumAmount)} / ${policy.premiumCadence.substring(0, 1)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                  const SizedBox(height: 24),

                  LuxuryCard(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildDetailRow('Policy Number', policy.policyNumber),
                        const Divider(color: AppTheme.duskBlue, height: 24),
                        _buildDetailRow('Provider', policy.provider),
                        const Divider(color: AppTheme.duskBlue, height: 24),
                        _buildDetailRow(
                          'Effective Dates',
                          '${DateFormat('MMM d, yyyy').format(policy.startDate)} - ${DateFormat('MMM d, yyyy').format(policy.endDate)}',
                        ),
                        if (policy.nominee.isNotEmpty) ...[
                          const Divider(color: AppTheme.duskBlue, height: 24),
                          _buildDetailRow('Nominee', policy.nominee),
                        ],
                      ],
                    ),
                  ).animate().slideY(begin: 0.1).fadeIn(delay: 300.ms),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Plain-English Coverage Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.auto_awesome, size: 16, color: AppTheme.primaryColor),
                        label: const Text('Explain Clause', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        onPressed: () => ExplainClauseModal.show(context, clause: policy.coverageSummary),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      policy.coverageSummary.isNotEmpty
                          ? policy.coverageSummary
                          : 'Standard active coverage protection with no noted restrictions.',
                      style: const TextStyle(fontSize: 15, color: AppTheme.alabasterGrey, height: 1.6),
                    ),
                  ).animate().slideY(begin: 0.1).fadeIn(delay: 500.ms),
                  const SizedBox(height: 32),

                  if (policy.exclusions.isNotEmpty) ...[
                    Text(
                      'Policy Exclusions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 12),
                    LuxuryCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: policy.exclusions.map(
                          (exclusion) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.remove_circle_outline, color: AppTheme.dangerColor, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(exclusion, style: const TextStyle(fontSize: 14, color: AppTheme.alabasterGrey, height: 1.4)),
                                ),
                              ],
                            ),
                          ),
                        ).toList(),
                      ),
                    ).animate().slideY(begin: 0.1).fadeIn(delay: 700.ms),
                    const SizedBox(height: 32),
                  ],

                  const DisclaimerBanner().animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.dustyDenim)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
      ],
    );
  }
}
