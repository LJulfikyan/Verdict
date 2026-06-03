import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/create_case/bindings/create_case_binding.dart';
import '../../features/create_case/pages/category_step_page.dart';
import '../../features/create_case/pages/description_step_page.dart';
import '../../features/create_case/pages/question_step_page.dart';
import '../../features/create_case/pages/relationship_step_page.dart';
import '../../features/create_case/pages/success_page.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/pages/case_detail_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/notifications/bindings/notifications_binding.dart';
import '../../features/notifications/pages/inbox_page.dart';
import '../../features/onboarding/bindings/onboarding_binding.dart';
import '../../features/onboarding/pages/onboarding_page.dart';
import '../../features/onboarding/pages/splash_page.dart';
import '../../features/premium/bindings/premium_binding.dart';
import '../../features/premium/pages/premium_page.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/pages/edit_profile_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/profile/pages/saved_cases_page.dart';
import '../../features/settings/bindings/settings_binding.dart';
import '../../features/settings/pages/settings_page.dart';
import '../services/app_state_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_shell.dart';
import 'auth_guard.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter()
    : _authService = Get.find<AuthService>(),
      _appStateService = Get.find<AppStateService>() {
    _guard = AuthGuard(
      authService: _authService,
      appStateService: _appStateService,
    );
    _refreshNotifier = _RouterRefreshNotifier(
      listenables: [_authService, _appStateService],
    );
  }

  final AuthService _authService;
  final AppStateService _appStateService;
  late final AuthGuard _guard;
  late final _RouterRefreshNotifier _refreshNotifier;

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _refreshNotifier,
    redirect: (_, state) => _guard.redirect(state),
    routes: [
      GoRoute(
        path: RouteNames.root,
        name: RouteNames.root,
        redirect: (_, state) => RouteNames.splash,
      ),
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => _buildPage(
          state: state,
          binding: OnboardingBinding(),
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => _buildPage(
          state: state,
          binding: OnboardingBinding(),
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => _buildPage(
          state: state,
          binding: AuthBinding(),
          child: const LoginPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: RouteNames.home,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: HomeBinding(),
                  child: const HomePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'case/:caseId',
                    name: RouteNames.caseDetail,
                    pageBuilder: (context, state) => _buildPage(
                      state: state,
                      binding: HomeBinding(),
                      child: CaseDetailPage(
                        caseId: state.pathParameters['caseId'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.create,
                name: RouteNames.create,
                redirect: (_, state) => RouteNames.createRelationship,
              ),
              GoRoute(
                path: RouteNames.createRelationship,
                name: RouteNames.createRelationship,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: CreateCaseBinding(),
                  child: const RelationshipStepPage(),
                ),
              ),
              GoRoute(
                path: RouteNames.createCategory,
                name: RouteNames.createCategory,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: CreateCaseBinding(),
                  child: const CategoryStepPage(),
                ),
              ),
              GoRoute(
                path: RouteNames.createDescription,
                name: RouteNames.createDescription,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: CreateCaseBinding(),
                  child: const DescriptionStepPage(),
                ),
              ),
              GoRoute(
                path: RouteNames.createQuestion,
                name: RouteNames.createQuestion,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: CreateCaseBinding(),
                  child: const QuestionStepPage(),
                ),
              ),
              GoRoute(
                path: RouteNames.createSuccess,
                name: RouteNames.createSuccess,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: CreateCaseBinding(),
                  child: const SuccessPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.inbox,
                name: RouteNames.inbox,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: NotificationsBinding(),
                  child: const InboxPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: RouteNames.profile,
                pageBuilder: (context, state) => _buildPage(
                  state: state,
                  binding: ProfileBinding(),
                  child: const ProfilePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.profileEdit,
                    pageBuilder: (context, state) => _buildPage(
                      state: state,
                      binding: ProfileBinding(),
                      child: const EditProfilePage(),
                    ),
                  ),
                  GoRoute(
                    path: 'saved',
                    name: RouteNames.profileSaved,
                    pageBuilder: (context, state) => _buildPage(
                      state: state,
                      binding: ProfileBinding(),
                      child: const SavedCasesPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        pageBuilder: (context, state) => _buildPage(
          state: state,
          binding: SettingsBinding(),
          child: const SettingsPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.premium,
        name: RouteNames.premium,
        pageBuilder: (context, state) => _buildPage(
          state: state,
          binding: PremiumBinding(),
          child: const PremiumPage(),
        ),
      ),
    ],
  );

  Page<void> _buildPage({
    required GoRouterState state,
    required Bindings binding,
    required Widget child,
  }) {
    binding.dependencies();
    return NoTransitionPage<void>(key: state.pageKey, child: child);
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier({required List<Listenable> listenables})
    : _listenables = listenables {
    for (final listenable in _listenables) {
      listenable.addListener(notifyListeners);
    }
  }

  final List<Listenable> _listenables;

  @override
  void dispose() {
    for (final listenable in _listenables) {
      listenable.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
