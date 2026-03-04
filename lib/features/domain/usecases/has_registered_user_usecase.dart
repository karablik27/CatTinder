import '../repositories/auth_repository.dart';

class HasRegisteredUserUseCase {
  final AuthRepository repository;

  const HasRegisteredUserUseCase(this.repository);

  Future<bool> call() {
    return repository.hasRegisteredUser();
  }
}
