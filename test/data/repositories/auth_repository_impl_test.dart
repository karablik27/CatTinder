import 'package:flutter_test/flutter_test.dart';

import 'package:cattinder/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:cattinder/features/auth/data/models/auth_user_model.dart';
import 'package:cattinder/features/auth/data/repositories/auth_repository_impl.dart';

class InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  AuthUserModel? storedUser;
  bool authorized = false;

  @override
  Future<void> saveUser({
    required String email,
    required String password,
  }) async {
    storedUser = AuthUserModel(
      email: email.trim().toLowerCase(),
      passwordHash: hashForComparison(password),
    );
    authorized = true;
  }

  @override
  Future<AuthUserModel?> readUser() async => storedUser;

  @override
  Future<void> setAuthorized(bool value) async {
    authorized = value;
  }

  @override
  Future<bool> isAuthorized() async => authorized;

  @override
  String hashForComparison(String password) => 'hash:$password';
}

void main() {
  group('AuthRepositoryImpl', () {
    test(
      'signUp saves normalized user and marks session as authorized',
      () async {
        final local = InMemoryAuthLocalDataSource();
        final repository = AuthRepositoryImpl(local);

        await repository.signUp(
          email: '  USER@Mail.COM  ',
          password: 'secret1',
        );

        expect(local.storedUser, isNotNull);
        expect(local.storedUser!.email, 'user@mail.com');
        expect(local.storedUser!.passwordHash, 'hash:secret1');
        expect(await repository.isAuthorized(), isTrue);
      },
    );

    test(
      'login throws on invalid credentials, then authorizes on valid ones',
      () async {
        final local = InMemoryAuthLocalDataSource();
        final repository = AuthRepositoryImpl(local);

        await repository.signUp(email: 'cat@example.com', password: 'secret1');
        await repository.logout();

        await expectLater(
          repository.login(email: 'cat@example.com', password: 'wrong-pass'),
          throwsA(isA<AuthException>()),
        );
        expect(await repository.isAuthorized(), isFalse);

        await repository.login(email: 'cat@example.com', password: 'secret1');
        expect(await repository.isAuthorized(), isTrue);
      },
    );
  });
}
