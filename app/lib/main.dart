import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'providers/policy_provider.dart';
import 'utils/app_theme.dart';

import 'models/policy_model.dart';
import 'models/claim_model.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/policy_vault/policy_list_screen.dart';
import 'screens/policy_vault/add_policy_screen.dart';
import 'screens/policy_vault/policy_detail_screen.dart';
import 'screens/claims/claims_assistant_screen.dart';
import 'screens/claims/claim_result_screen.dart';
import 'screens/comparison/comparison_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/family_vault_screen.dart';
import 'screens/profile/export_report_screen.dart';
import 'screens/main_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorVaultKey = GlobalKey<NavigatorState>(debugLabel: 'shellVault');
final GlobalKey<NavigatorState> _shellNavigatorCompareKey = GlobalKey<NavigatorState>(debugLabel: 'shellCompare');
final GlobalKey<NavigatorState> _shellNavigatorClaimsKey = GlobalKey<NavigatorState>(debugLabel: 'shellClaims');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PolicyPalApp());
}

class PolicyPalApp extends StatelessWidget {
  const PolicyPalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => PolicyProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final router = GoRouter(
            navigatorKey: _rootNavigatorKey,
            initialLocation: authProvider.isAuthenticated ? '/home' : '/login',
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/register',
                builder: (context, state) => const RegisterScreen(),
              ),
              // Main Tabs with Persistent Bottom Nav
              StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) {
                  return MainScaffold(navigationShell: navigationShell);
                },
                branches: [
                  StatefulShellBranch(
                    navigatorKey: _shellNavigatorHomeKey,
                    routes: [
                      GoRoute(
                        path: '/home',
                        builder: (context, state) => const HomeScreen(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    navigatorKey: _shellNavigatorVaultKey,
                    routes: [
                      GoRoute(
                        path: '/policies',
                        builder: (context, state) => const PolicyListScreen(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    navigatorKey: _shellNavigatorCompareKey,
                    routes: [
                      GoRoute(
                        path: '/ai-assistant',
                        builder: (context, state) => const ClaimsAssistantScreen(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    navigatorKey: _shellNavigatorClaimsKey,
                    routes: [
                      GoRoute(
                        path: '/profile',
                        builder: (context, state) => const ProfileScreen(),
                      ),
                    ],
                  ),
                ],
              ),
              // Top-level modals/screens that cover the BottomNav
              GoRoute(
                path: '/comparison',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ComparisonScreen(),
              ),
              GoRoute(
                path: '/claims-assistant',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ClaimsAssistantScreen(),
              ),
              GoRoute(
                path: '/add-policy',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const AddPolicyScreen(),
              ),
              GoRoute(
                path: '/policy-detail',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final policy = state.extra as PolicyModel;
                  return PolicyDetailScreen(policy: policy);
                },
              ),
              GoRoute(
                path: '/claim-result',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final claim = state.extra as ClaimModel;
                  return ClaimResultScreen(claim: claim);
                },
              ),
              GoRoute(
                path: '/notifications',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const NotificationsScreen(),
              ),
              GoRoute(
                path: '/profile-detail',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                path: '/family-vault',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const FamilyVaultScreen(),
              ),
              GoRoute(
                path: '/export-report',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ExportReportScreen(),
              ),
            ],
          );

          return MaterialApp.router(
            title: 'PolicyPal',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
