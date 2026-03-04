import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  Future<void> call({required String email, required String password}) {
    return repository.signUp(email: email, password: password);
  }
}
