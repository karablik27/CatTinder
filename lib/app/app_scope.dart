import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'app_secrets.dart';
import 'analytics/analytics_service.dart';
import '../features/data/datasources/auth_local_data_source.dart';
import '../features/data/datasources/secure_auth_local_data_source.dart';
import '../features/data/repositories/auth_repository_impl.dart';
import '../features/domain/repositories/auth_repository.dart';
import '../features/domain/usecases/check_auth_status_usecase.dart';
import '../features/domain/usecases/has_registered_user_usecase.dart';
import '../features/domain/usecases/login_usecase.dart';
import '../features/domain/usecases/logout_usecase.dart';
import '../features/domain/usecases/signup_usecase.dart';
import '../features/presentation/viewmodels/auth_session_viewmodel.dart';
import '../features/data/datasources/cat_api_remote_data_source.dart';
import '../features/data/datasources/cat_name_remote_data_source.dart';
import '../features/data/repositories/cat_name_repository_impl.dart';
import '../features/data/repositories/cat_repository_impl.dart';
import '../features/domain/repositories/cat_name_repository.dart';
import '../features/domain/repositories/cat_repository.dart';
import '../features/domain/usecases/get_breeds_usecase.dart';
import '../features/domain/usecases/get_random_cat_with_generated_name_usecase.dart';
import '../features/data/datasources/onboarding_local_data_source.dart';
import '../features/data/repositories/onboarding_repository_impl.dart';
import '../features/domain/repositories/onboarding_repository.dart';
import '../features/domain/usecases/complete_onboarding_usecase.dart';
import '../features/domain/usecases/get_onboarding_status_usecase.dart';
import '../features/presentation/viewmodels/onboarding_viewmodel.dart';

class AppScope extends StatelessWidget {
  final Widget child;

  const AppScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AnalyticsService>(
          create: (_) {
            if (kDebugMode) {
              debugPrint(
                '[Analytics] AppMetrica key set: ${AppSecrets.hasAppMetricaApiKey}',
              );
            }
            return CompositeAnalyticsService([
              AppMetricaAnalyticsService(),
              FirebaseAnalyticsService(),
            ]);
          },
        ),
        Provider(create: (_) => const FlutterSecureStorage()),
        Provider<AuthLocalDataSource>(
          create: (context) =>
              SecureAuthLocalDataSource(context.read<FlutterSecureStorage>()),
        ),
        Provider<AuthRepository>(
          create: (context) =>
              AuthRepositoryImpl(context.read<AuthLocalDataSource>()),
        ),
        Provider(
          create: (context) =>
              CheckAuthStatusUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) =>
              HasRegisteredUserUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) => SignUpUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) => LogoutUseCase(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthSessionViewModel(
            checkAuthStatus: context.read<CheckAuthStatusUseCase>(),
            hasRegisteredUser: context.read<HasRegisteredUserUseCase>(),
            loginUseCase: context.read<LoginUseCase>(),
            signUpUseCase: context.read<SignUpUseCase>(),
            logoutUseCase: context.read<LogoutUseCase>(),
            analyticsService: context.read<AnalyticsService>(),
          )..initialize(),
        ),
        Provider(
          create: (context) =>
              OnboardingLocalDataSource(context.read<FlutterSecureStorage>()),
        ),
        Provider<OnboardingRepository>(
          create: (context) => OnboardingRepositoryImpl(
            context.read<OnboardingLocalDataSource>(),
          ),
        ),
        Provider(
          create: (context) =>
              GetOnboardingStatusUseCase(context.read<OnboardingRepository>()),
        ),
        Provider(
          create: (context) =>
              CompleteOnboardingUseCase(context.read<OnboardingRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => OnboardingViewModel(
            getOnboardingStatus: context.read<GetOnboardingStatusUseCase>(),
            completeOnboarding: context.read<CompleteOnboardingUseCase>(),
          )..initialize(),
        ),
        Provider(create: (_) => CatApiRemoteDataSource()),
        Provider(create: (_) => CatNameRemoteDataSource()),
        Provider<CatRepository>(
          create: (context) =>
              CatRepositoryImpl(context.read<CatApiRemoteDataSource>()),
        ),
        Provider<CatNameRepository>(
          create: (context) =>
              CatNameRepositoryImpl(context.read<CatNameRemoteDataSource>()),
        ),
        Provider(
          create: (context) => GetRandomCatWithGeneratedNameUseCase(
            catRepository: context.read<CatRepository>(),
            catNameRepository: context.read<CatNameRepository>(),
          ),
        ),
        Provider(
          create: (context) => GetBreedsUseCase(context.read<CatRepository>()),
        ),
      ],
      child: child,
    );
  }
}
