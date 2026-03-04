import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cattinder/app/analytics/analytics_service.dart';
import 'package:cattinder/features/domain/repositories/auth_repository.dart';
import 'package:cattinder/features/domain/usecases/check_auth_status_usecase.dart';
import 'package:cattinder/features/domain/usecases/has_registered_user_usecase.dart';
import 'package:cattinder/features/domain/usecases/login_usecase.dart';
import 'package:cattinder/features/domain/usecases/logout_usecase.dart';
import 'package:cattinder/features/domain/usecases/signup_usecase.dart';
import 'package:cattinder/features/presentation/screens/auth_screen.dart';
import 'package:cattinder/features/presentation/viewmodels/auth_session_viewmodel.dart';

class InMemoryAuthRepository implements AuthRepository {
  String? email;
  String? password;
  bool authorized = false;

  @override
  Future<void> login({required String email, required String password}) async {
    if (this.email == null || this.password == null) {
      throw Exception('Сначала зарегистрируйтесь.');
    }
    if (this.email != email.trim().toLowerCase() || this.password != password) {
      throw Exception('Неверный email или пароль.');
    }
    authorized = true;
  }

  @override
  Future<void> logout() async {
    authorized = false;
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    if (this.email != null) {
      throw Exception('Пользователь уже зарегистрирован. Выполните вход.');
    }
    this.email = email.trim().toLowerCase();
    this.password = password;
    authorized = true;
  }

  @override
  Future<bool> hasRegisteredUser() async => email != null;

  @override
  Future<bool> isAuthorized() async => authorized;
}

class NoopAnalytics implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {}
}

Widget _build(AuthSessionViewModel vm) {
  return MaterialApp(
    home: ChangeNotifierProvider<AuthSessionViewModel>.value(
      value: vm,
      child: const AuthScreen(),
    ),
  );
}

AuthSessionViewModel _createViewModel(AuthRepository repository) {
  return AuthSessionViewModel(
    checkAuthStatus: CheckAuthStatusUseCase(repository),
    hasRegisteredUser: HasRegisteredUserUseCase(repository),
    loginUseCase: LoginUseCase(repository),
    signUpUseCase: SignUpUseCase(repository),
    logoutUseCase: LogoutUseCase(repository),
    analyticsService: NoopAnalytics(),
  );
}

void main() {
  group('AuthScreen', () {
    testWidgets('shows validation errors for invalid login input', (
      tester,
    ) async {
      final repository = InMemoryAuthRepository();
      final vm = _createViewModel(repository);

      await tester.pumpWidget(_build(vm));

      await tester.enterText(find.byKey(const Key('login_email_field')), 'bad');
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123',
      );
      await tester.tap(find.text('Войти'));
      await tester.pumpAndSettle();

      expect(find.text('Некорректный email'), findsOneWidget);
      expect(find.text('Минимум 6 символов'), findsOneWidget);
      expect(vm.isAuthenticated, isFalse);
    });

    testWidgets('successful sign up updates auth state', (tester) async {
      final repository = InMemoryAuthRepository();
      final vm = _createViewModel(repository);

      await tester.pumpWidget(_build(vm));

      await tester.tap(find.text('Регистрация'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('signup_email_field')),
        'new@cat.com',
      );
      await tester.enterText(
        find.byKey(const Key('signup_password_field')),
        'secret1',
      );
      await tester.enterText(
        find.byKey(const Key('signup_confirm_field')),
        'secret1',
      );

      await tester.tap(find.text('Зарегистрироваться'));
      await tester.pumpAndSettle();

      expect(vm.isAuthenticated, isTrue);
      expect(vm.hasUser, isTrue);
      expect(await repository.isAuthorized(), isTrue);
    });
  });
}
