import '../models/auth_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser({required String email, required String password});
  Future<AuthUserModel?> readUser();
  Future<void> setAuthorized(bool value);
  Future<bool> isAuthorized();
  String hashForComparison(String password);
}
