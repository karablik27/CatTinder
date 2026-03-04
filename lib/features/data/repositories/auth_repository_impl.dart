import '../datasources/auth_local_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl(this.localDataSource);

  @override
  Future<void> signUp({required String email, required String password}) async {
    final hasUser = await hasRegisteredUser();
    if (hasUser) {
      throw AuthException('Пользователь уже зарегистрирован. Выполните вход.');
    }

    await localDataSource.saveUser(email: email, password: password);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final user = await localDataSource.readUser();
    if (user == null) {
      throw AuthException('Сначала зарегистрируйтесь.');
    }

    final normalizedEmail = email.trim().toLowerCase();
    final hash = localDataSource.hashForComparison(password);

    if (user.email != normalizedEmail || user.passwordHash != hash) {
      throw AuthException('Неверный email или пароль.');
    }

    await localDataSource.setAuthorized(true);
  }

  @override
  Future<void> logout() async {
    await localDataSource.setAuthorized(false);
  }

  @override
  Future<bool> isAuthorized() {
    return localDataSource.isAuthorized();
  }

  @override
  Future<bool> hasRegisteredUser() async {
    final user = await localDataSource.readUser();
    return user != null;
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
