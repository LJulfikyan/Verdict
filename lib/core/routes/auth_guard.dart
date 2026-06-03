import 'package:go_router/go_router.dart';

import '../services/app_state_service.dart';
import '../services/auth_service.dart';
import 'route_names.dart';

class AuthGuard {
  AuthGuard({
    required AuthService authService,
    required AppStateService appStateService,
  }) : _authService = authService,
       _appStateService = appStateService;

  final AuthService _authService;
  final AppStateService _appStateService;

  String? redirect(GoRouterState state) {
    final location = state.matchedLocation;
    final isPublic = _isPublicRoute(location);

    if (!_appStateService.isReady && location != RouteNames.splash) {
      return RouteNames.splash;
    }

    if (!_appStateService.onboardingCompleted &&
        location != RouteNames.onboarding &&
        location != RouteNames.splash) {
      return RouteNames.onboarding;
    }

    if (location == RouteNames.root) {
      if (!_appStateService.onboardingCompleted) {
        return RouteNames.onboarding;
      }
      return _authService.isAuthenticated ? RouteNames.home : RouteNames.login;
    }

    if (!isPublic && !_authService.isAuthenticated) {
      return RouteNames.login;
    }

    if (_authService.isAuthenticated &&
        (location == RouteNames.login || location == RouteNames.onboarding)) {
      return RouteNames.home;
    }

    return null;
  }

  bool _isPublicRoute(String location) {
    return location == RouteNames.root ||
        location == RouteNames.splash ||
        location == RouteNames.onboarding ||
        location == RouteNames.login;
  }
}
