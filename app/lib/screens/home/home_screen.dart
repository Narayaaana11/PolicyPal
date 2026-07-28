import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../providers/policy_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/policy_card.dart';
import '../../widgets/luxury_card.dart';
import '../../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = Provider.of<PolicyProvider>(context, listen: false);
        provider.fetchPolicies();
        provider.fetchUpcomingPayments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final policyProvider = Provider.of<PolicyProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Row(
                children: [
                  const Icon(Icons.shield, color: AppTheme.alabasterGrey, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'PolicyPal',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.premiumGradient,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push('/notifications'),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => context.push('/profile'),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${authProvider.user?.name ?? "User"} 👋',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Here is your insurance policy portfolio summary.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 32),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryMetricCard(
                          title: 'Active Policies',
                          value: '${policyProvider.activePoliciesCount}',
                          icon: Icons.folder_special_outlined,
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryMetricCard(
                          title: 'Next Renewal',
                          value: '${policyProvider.nearestRenewalDays} Days',
                          icon: Icons.access_time_outlined,
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Indian Specific Section 80D & ABHA Health Card
                  Builder(
                    builder: (context) {
                      final healthPremium = policyProvider.policies
                          .where((p) => p.type.toLowerCase() == 'health')
                          .fold(0.0, (sum, p) => sum + p.premiumAmount);
                      final eligibleText = healthPremium > 0 
                          ? '₹${healthPremium.toStringAsFixed(0)} Eligible • 80D Tax Deduction' 
                          : 'Add a Health Policy to track 80D savings';
                          
                      return LuxuryCard(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified_outlined, color: AppTheme.successColor, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Section 80D Tax Saved',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('AY 2026-27', style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    eligibleText,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.dustyDenim),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.dustyDenim),
                          ],
                        ),
                      ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.05);
                    }
                  ),
                  
                  const SizedBox(height: 32),
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.add_circle_outline,
                        label: 'Add Policy',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/add-policy');
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.compare_arrows_outlined,
                        label: 'Compare',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/comparison');
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.support_agent_outlined,
                        label: 'AI Claims',
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/claims-assistant');
                        },
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                  
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Vault',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => context.push('/policies'),
                        child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 16),
                  
                  if (policyProvider.isLoading)
                    const ShimmerLoading(height: 120)
                  else if (policyProvider.policies.isEmpty)
                    LuxuryCard(
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.note_add_outlined, size: 48, color: AppTheme.dustyDenim),
                            const SizedBox(height: 16),
                            const Text('No policies stored yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            const Text(
                              'Add your auto, health, or life policies to track coverage.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...policyProvider.policies.take(3).map(
                          (policy) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: PolicyCard(
                              policy: policy,
                              onTap: () => context.push('/policy-detail', extra: policy),
                            ),
                          ),
                        ),
                  
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Claims Preview',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => context.push('/ai-assistant'),
                        child: const Text('New Claim', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ).animate().fadeIn(delay: 750.ms),
                  const SizedBox(height: 12),
                  if (policyProvider.claims.isEmpty)
                    LuxuryCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.history_outlined, color: AppTheme.primaryColor, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('No recent claim incidents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.alabasterGrey)),
                                Text('AI Claims Assistant pre-checks will appear here', style: TextStyle(fontSize: 11, color: AppTheme.dustyDenim)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 800.ms)
                  else
                    ...policyProvider.claims.take(2).map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: LuxuryCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Icon(Icons.assignment_turned_in_outlined, color: AppTheme.successColor, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey, fontSize: 13)),
                                        Text('Status: ${c.status.toUpperCase()} • Grounded Assessment Available', style: const TextStyle(fontSize: 11, color: AppTheme.dustyDenim)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).toList(),

                  const SizedBox(height: 100), // padding for floating nav bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return LuxuryCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.alabasterGrey, size: 32),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 14, color: AppTheme.dustyDenim)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: AppTheme.primaryColor, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}
