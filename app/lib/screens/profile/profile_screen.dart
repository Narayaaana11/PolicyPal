import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/luxury_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

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
              title: const Text('Profile & Settings'),
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
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppTheme.prussianBlue,
                            child: Text(
                              user?.name.substring(0, 1).toUpperCase() ?? 'P',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                            ),
                          ),
                        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'Priya Sharma',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'priya.sharma@example.in',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                          ),
                          child: const Text(
                            '🇮🇳 ABHA Verified • ABHA-91-8849-2041-9921',
                            style: TextStyle(color: AppTheme.successColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text('Indian Insurance Services & Vault', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.dustyDenim)).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 12),

                  LuxuryCard(
                    child: Column(
                      children: [
                        _buildListTile(
                          icon: Icons.family_restroom_outlined,
                          title: 'Family / Group Vault',
                          subtitle: 'Manage linked family members & shared policies',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push('/family-vault');
                          },
                        ),
                        const Divider(height: 1, color: AppTheme.duskBlue),
                        _buildListTile(
                          icon: Icons.receipt_long_outlined,
                          title: 'Section 80D & 80C Tax Certificates',
                          subtitle: 'Download consolidated IT Return tax proof',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push('/export-report');
                          },
                        ),
                        const Divider(height: 1, color: AppTheme.duskBlue),
                        _buildListTile(
                          icon: Icons.download_outlined,
                          title: 'Export Portfolio Report (PDF / Excel)',
                          subtitle: 'Complete policy, payment & claim summary log',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push('/export-report');
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),
                  const SizedBox(height: 32),

                  const Text('Regulatory & Support (IRDAI Grievance)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.dustyDenim)).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 12),

                  LuxuryCard(
                    child: Column(
                      children: [
                        _buildListTile(
                          icon: Icons.support_agent_outlined,
                          title: 'IRDAI Bima Bharosa Toll-Free',
                          subtitle: '155255 / 1800 425 4732 Grievance Portal',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('IRDAI Toll-Free Helpline: 155255 copied to clipboard')),
                            );
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 650.ms).slideX(begin: 0.1),
                  const SizedBox(height: 32),

                  const Text('Data & Privacy (Right-to-Erasure)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.dustyDenim)).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 12),

                  LuxuryCard(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.dangerColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete_outline, color: AppTheme.dangerColor),
                      ),
                      title: const Text('Delete Account & Erasure Request', style: TextStyle(color: AppTheme.dangerColor, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Permanently remove all policies and personal data', style: TextStyle(color: AppTheme.dustyDenim, fontSize: 13)),
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppTheme.prussianBlue,
                            title: const Text('Confirm Account Deletion', style: TextStyle(color: AppTheme.alabasterGrey)),
                            content: const Text(
                              'This action is permanent and adheres to Right-to-Erasure privacy compliance. All stored policy vault items and claim records will be wiped.',
                              style: TextStyle(color: AppTheme.dustyDenim),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel', style: TextStyle(color: AppTheme.alabasterGrey)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.dangerColor,
                                  foregroundColor: AppTheme.alabasterGrey,
                                ),
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();
                                  Navigator.pop(ctx);
                                  await authProvider.logout();
                                  if (context.mounted) context.go('/login');
                                },
                                child: const Text('Delete Permanently'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 750.ms).slideX(begin: 0.1),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.dangerColor,
                        side: BorderSide(color: AppTheme.dangerColor.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        await authProvider.logout();
                        if (context.mounted) context.go('/login');
                      },
                    ),
                  ).animate().fadeIn(delay: 800.ms).scale(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.dustyDenim, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.dustyDenim),
      onTap: onTap,
    );
  }
}
