import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  const CompleteOnboardingUseCase(this.repository);

  Future<void> call() {
    return repository.complete();
  }
}
