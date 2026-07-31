import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_nav_bar.dart';
import '../widgets/document_scanner_modal.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _showQuickActionsMenu(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.prussianBlue,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            border: Border.all(color: AppTheme.duskBlue.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.inkBlack.withValues(alpha: 0.8),
                blurRadius: 30,
                offset: const Offset(0, -10),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dustyDenim.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.add_circle, color: AppTheme.primaryColor, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.alabasterGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Instant access to insurance management tools.',
                style: TextStyle(fontSize: 13, color: AppTheme.dustyDenim),
              ),
              const SizedBox(height: 24),
              _buildActionTile(
                ctx,
                icon: Icons.add_moderator_outlined,
                title: 'Add Policy',
                subtitle: 'Manually register policy details into vault',
                color: AppTheme.primaryColor,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/add-policy');
                },
              ),
              const SizedBox(height: 12),
              _buildActionTile(
                ctx,
                icon: Icons.document_scanner_outlined,
                title: 'Scan Policy (OCR)',
                subtitle: 'Upload photo/PDF to extract text & save',
                color: AppTheme.secondaryColor,
                onTap: () {
                  Navigator.pop(ctx);
                  DocumentScannerModal.show(context);
                },
              ),
              const SizedBox(height: 12),
              _buildActionTile(
                ctx,
                icon: Icons.compare_arrows_outlined,
                title: 'Compare Policies',
                subtitle: 'Benchmark your plan against market rates',
                color: AppTheme.goldenOrange,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/comparison');
                },
              ),
              const SizedBox(height: 12),
              _buildActionTile(
                ctx,
                icon: Icons.warning_amber_outlined,
                title: 'Report Incident (AI Claim)',
                subtitle: 'Start guided claim pre-check assistant',
                color: AppTheme.warningColor,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/claims-assistant');
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.inkBlack.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.duskBlue.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.alabasterGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: AppTheme.dustyDenim),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.dustyDenim),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          navigationShell,
          if (!isKeyboardOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GlassNavBar(
                selectedIndex: navigationShell.currentIndex,
                onItemSelected: _goBranch,
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: isKeyboardOpen ? null : Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 84,
          right: 12,
        ),
        child: FloatingActionButton.extended(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.inkBlack,
          elevation: 6,
          onPressed: () => _showQuickActionsMenu(context),
          icon: const Icon(Icons.add, size: 24),
          label: const Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
