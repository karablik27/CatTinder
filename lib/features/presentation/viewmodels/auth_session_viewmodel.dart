import 'package:flutter/material.dart';

import '../../../app/analytics/analytics_service.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/has_registered_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

class AuthSessionViewModel extends ChangeNotifier {
  final CheckAuthStatusUseCase checkAuthStatus;
  final HasRegisteredUserUseCase hasRegisteredUser;
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final AnalyticsService analyticsService;

  AuthSessionViewModel({
    required this.checkAuthStatus,
    required this.hasRegisteredUser,
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.analyticsService,
  });

  bool initialized = false;
  bool isAuthenticated = false;
  bool isBusy = false;
  bool hasUser = false;
  String? error;

  Future<void> initialize() async {
    hasUser = await hasRegisteredUser();
    isAuthenticated = await checkAuthStatus();
    initialized = true;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    return _runAuthAction(
      () async {
        await loginUseCase(email: email, password: password);
        hasUser = true;
        isAuthenticated = true;
      },
      eventName: 'auth_login',
      email: email,
    );
  }

  Future<bool> signUp({required String email, required String password}) async {
    return _runAuthAction(
      () async {
        await signUpUseCase(email: email, password: password);
        hasUser = true;
        isAuthenticated = true;
      },
      eventName: 'auth_signup',
      email: email,
    );
  }

  Future<void> logout() async {
    isBusy = true;
    error = null;
    notifyListeners();

    await logoutUseCase();
    isAuthenticated = false;
    isBusy = false;
    notifyListeners();
  }

  void clearError() {
    if (error == null) {
      return;
    }
    error = null;
    notifyListeners();
  }

  Future<bool> _runAuthAction(
    Future<void> Function() action, {
    required String eventName,
    required String email,
  }) async {
    isBusy = true;
    error = null;
    notifyListeners();

    try {
      await action();
      await analyticsService.logEvent(
        '${eventName}_success',
        params: {'email_domain': _extractDomain(email)},
      );
      return true;
    } catch (e) {
      error = e.toString();
      await analyticsService.logEvent(
        '${eventName}_error',
        params: {'email_domain': _extractDomain(email), 'reason': e.toString()},
      );
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  String _extractDomain(String email) {
    final trimmed = email.trim();
    final index = trimmed.indexOf('@');
    if (index < 0 || index == trimmed.length - 1) {
      return 'invalid';
    }
    return trimmed.substring(index + 1).toLowerCase();
  }
}
