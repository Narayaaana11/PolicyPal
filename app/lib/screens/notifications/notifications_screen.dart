import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/api_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/luxury_card.dart';
import '../../widgets/shimmer_loading.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;
  List<dynamic> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _notifications = [
        {
          'title': 'Auto Policy Renewing Soon',
          'message': 'Your Geico Auto policy (AUTO-998877) will auto-renew in 18 days. Premium: \$1200.',
          'type': 'warning'
        },
        {
          'title': 'Claim Status Update',
          'message': 'Good news! Your claim CL-8894 for roof damage has been approved and payout is scheduled.',
          'type': 'success'
        },
        {
          'title': 'New Document Available',
          'message': 'Your updated health insurance card for 2026 is now available in your policy vault.',
          'type': 'info'
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Notifications & Reminders'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.premiumGradient,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: _isLoading
                ? SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(4, (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ShimmerLoading(height: 100),
                      )),
                    ),
                  )
                : _notifications.isEmpty
                    ? SliverToBoxAdapter(
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 100),
                              Icon(Icons.notifications_active_outlined, size: 64, color: AppTheme.dustyDenim),
                              SizedBox(height: 16),
                              Text('No notifications or renewal warnings right now.', style: TextStyle(color: AppTheme.dustyDenim)),
                            ],
                          ),
                        ).animate().fadeIn(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final notif = _notifications[index];
                            final isWarning = notif['type'] == 'warning';
                            final isSuccess = notif['type'] == 'success';

                            IconData iconData = Icons.info_outline;
                            Color iconColor = AppTheme.primaryColor;
                            Color bgColor = AppTheme.primaryColor.withOpacity(0.1);

                            if (isWarning) {
                              iconData = Icons.warning_amber_rounded;
                              iconColor = AppTheme.warningColor;
                              bgColor = AppTheme.warningColor.withOpacity(0.1);
                            } else if (isSuccess) {
                              iconData = Icons.check_circle_outline;
                              iconColor = AppTheme.secondaryColor;
                              bgColor = AppTheme.secondaryColor.withOpacity(0.1);
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: LuxuryCard(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(iconData, color: iconColor, size: 24),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notif['title'] ?? 'Notice',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.alabasterGrey),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            notif['message'] ?? '',
                                            style: const TextStyle(fontSize: 13, color: AppTheme.dustyDenim, height: 1.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.1);
                          },
                          childCount: _notifications.length,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
