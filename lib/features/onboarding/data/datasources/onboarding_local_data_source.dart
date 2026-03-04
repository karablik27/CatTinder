import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingLocalDataSource {
  static const _completedKey = 'onboarding.completed';

  final FlutterSecureStorage secureStorage;

  const OnboardingLocalDataSource(this.secureStorage);

  Future<bool> isCompleted() async {
    final value = await secureStorage.read(key: _completedKey);
    return value == 'true';
  }

  Future<void> complete() async {
    await secureStorage.write(key: _completedKey, value: 'true');
  }
}
