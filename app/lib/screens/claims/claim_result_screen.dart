import 'package:flutter/material.dart';
import '../../models/claim_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_theme.dart';
import '../../widgets/disclaimer_banner.dart';
import '../../widgets/luxury_card.dart';

class ClaimResultScreen extends StatelessWidget {
  final ClaimModel claim;

  const ClaimResultScreen({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    final assessment = claim.aiAssessment;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: AppTheme.alabasterGrey),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
              title: const Text('AI Guidance Results'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.premiumGradient,
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
                  DisclaimerBanner(customText: assessment.disclaimer).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),

                  Text(
                    'Grounded Policy Analysis',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: 8),
                  Text(
                    assessment.confidenceNote,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 32),

                  _buildSectionHeader('Relevant Policy Clauses', Icons.gavel_outlined).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 12),
                  ...assessment.relevantClauses.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LuxuryCard(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, color: AppTheme.primaryColor, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(fontSize: 14, color: AppTheme.alabasterGrey, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 500 + (entry.key * 100))).slideX(begin: 0.1),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Required Document Checklist', Icons.checklist_outlined).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: assessment.checklist
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_box_outlined, color: AppTheme.secondaryColor, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(item, style: const TextStyle(fontSize: 14, color: AppTheme.alabasterGrey)),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ).animate().fadeIn(delay: 900.ms).slideX(begin: 0.1),
                  const SizedBox(height: 32),

                  _buildSectionHeader('Possible Exclusions & Watchouts', Icons.warning_amber_outlined).animate().fadeIn(delay: 1000.ms),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: assessment.possibleExclusions
                          .map(
                            (ex) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline, color: AppTheme.warningColor, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(ex, style: const TextStyle(fontSize: 14, color: AppTheme.dustyDenim)),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ).animate().fadeIn(delay: 1100.ms).slideX(begin: 0.1),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey),
        ),
      ],
    );
  }
}
