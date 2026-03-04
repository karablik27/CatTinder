import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_local_data_source.dart';
import '../models/auth_user_model.dart';

class SecureAuthLocalDataSource implements AuthLocalDataSource {
  static const _emailKey = 'auth.email';
  static const _passwordHashKey = 'auth.password_hash';
  static const _authorizedKey = 'auth.authorized';

  final FlutterSecureStorage secureStorage;

  const SecureAuthLocalDataSource(this.secureStorage);

  @override
  Future<void> saveUser({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final hash = _hashPassword(password);

    await secureStorage.write(key: _emailKey, value: normalizedEmail);
    await secureStorage.write(key: _passwordHashKey, value: hash);
    await secureStorage.write(key: _authorizedKey, value: 'true');
  }

  @override
  Future<AuthUserModel?> readUser() async {
    final email = await secureStorage.read(key: _emailKey);
    final passwordHash = await secureStorage.read(key: _passwordHashKey);

    if (email == null || passwordHash == null) {
      return null;
    }

    return AuthUserModel(email: email, passwordHash: passwordHash);
  }

  @override
  Future<void> setAuthorized(bool value) async {
    await secureStorage.write(
      key: _authorizedKey,
      value: value ? 'true' : 'false',
    );
  }

  @override
  Future<bool> isAuthorized() async {
    final value = await secureStorage.read(key: _authorizedKey);
    return value == 'true';
  }

  String _hashPassword(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  @override
  String hashForComparison(String password) {
    return _hashPassword(password);
  }
}
