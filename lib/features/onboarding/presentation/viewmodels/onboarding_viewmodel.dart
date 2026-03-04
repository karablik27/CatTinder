import 'package:flutter/material.dart';

import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../../domain/usecases/get_onboarding_status_usecase.dart';

class OnboardingViewModel extends ChangeNotifier {
  final GetOnboardingStatusUseCase getOnboardingStatus;
  final CompleteOnboardingUseCase completeOnboarding;

  OnboardingViewModel({
    required this.getOnboardingStatus,
    required this.completeOnboarding,
  });

  bool initialized = false;
  bool completed = false;
  bool busy = false;

  Future<void> initialize() async {
    completed = await getOnboardingStatus();
    initialized = true;
    notifyListeners();
  }

  Future<void> finish() async {
    busy = true;
    notifyListeners();

    await completeOnboarding();
    completed = true;
    busy = false;
    notifyListeners();
  }
}
