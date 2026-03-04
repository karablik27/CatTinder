import '../repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase {
  final OnboardingRepository repository;

  const GetOnboardingStatusUseCase(this.repository);

  Future<bool> call() {
    return repository.isCompleted();
  }
}
