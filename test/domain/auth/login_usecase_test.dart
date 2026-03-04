import 'package:flutter_test/flutter_test.dart';

import 'package:cattinder/features/domain/repositories/auth_repository.dart';
import 'package:cattinder/features/domain/usecases/login_usecase.dart';

class SpyAuthRepository implements AuthRepository {
  String? lastLoginEmail;
  String? lastLoginPassword;

  @override
  Future<void> login({required String email, required String password}) async {
    lastLoginEmail = email;
    lastLoginPassword = password;
  }

  @override
  Future<bool> hasRegisteredUser() async => false;

  @override
  Future<bool> isAuthorized() async => false;

  @override
  Future<void> logout() async {}

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {}
}

void main() {
  test('LoginUseCase delegates credentials to repository', () async {
    final repository = SpyAuthRepository();
    final useCase = LoginUseCase(repository);

    await useCase(email: 'user@cat.com', password: 'secret1');

    expect(repository.lastLoginEmail, 'user@cat.com');
    expect(repository.lastLoginPassword, 'secret1');
  });
}
