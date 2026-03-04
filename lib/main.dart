import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app/app_scope.dart';
import 'app/app_secrets.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/auth/presentation/viewmodels/auth_session_viewmodel.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/onboarding/presentation/viewmodels/onboarding_viewmodel.dart';
import 'features/presentation/screens/breeds_screen.dart';
import 'features/presentation/screens/main_screen.dart';
import 'features/presentation/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    if (kDebugMode) {
      debugPrint('[Firebase] initializeApp success');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('[Firebase] initializeApp failed at startup: $e');
    }
  }

  if (const bool.fromEnvironment('FIREBASE_ANALYTICS_DEBUG')) {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      if (kDebugMode) {
        debugPrint('[Firebase] analytics debug flag enabled');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Firebase] analytics debug flag failed: $e');
      }
    }
  }

  if (kDebugMode) {
    debugPrint('[Secrets] CAT_API_KEY set: ${AppSecrets.hasCatApiKey}');
    debugPrint(
      '[Secrets] OPENROUTER_API_KEY set: ${AppSecrets.hasOpenRouterApiKey}',
    );
    debugPrint(
      '[Secrets] OPENROUTER_API_KEY length: ${AppSecrets.openRouterApiKey.length}',
    );
    debugPrint(
      '[Secrets] APPMETRICA_API_KEY set: ${AppSecrets.hasAppMetricaApiKey}',
    );
    debugPrint(
      '[Secrets] APPMETRICA_API_KEY length: ${AppSecrets.appMetricaApiKey.length}',
    );
  }
  runApp(const AppScope(child: CatTinderApp()));
}

class CatTinderApp extends StatelessWidget {
  const CatTinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatTinder',
      theme: ThemeData(
        fontFamily: 'SF Pro',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.backgroundTop,
          brightness: Brightness.light,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: Colors.white.withValues(alpha: 0.25),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white, size: 28);
            }
            return IconThemeData(color: Colors.white.withValues(alpha: 0.7));
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              color: Colors.white.withValues(
                alpha: states.contains(WidgetState.selected) ? 1 : 0.7,
              ),
              fontWeight: FontWeight.w600,
            );
          }),
        ),
      ),
      home: const AppEntryPoint(),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<OnboardingViewModel, AuthSessionViewModel>(
      builder: (context, onboardingVm, authVm, _) {
        if (!onboardingVm.initialized || !authVm.initialized) {
          return Container(
            decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        if (!onboardingVm.completed) {
          return const OnboardingScreen();
        }

        if (authVm.isAuthenticated) {
          return const MainTabs();
        }

        return const AuthScreen();
      },
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int index = 0;

  final screens = [const MainScreen(), const BreedsScreen()];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: screens[index],
        floatingActionButton: FloatingActionButton.small(
          onPressed: () => context.read<AuthSessionViewModel>().logout(),
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          child: const Icon(Icons.logout, color: Colors.black87),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: NavigationBar(
              height: 65,
              selectedIndex: index,
              elevation: 0,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.pets), label: 'Коты'),
                NavigationDestination(icon: Icon(Icons.list), label: 'Породы'),
              ],
              onDestinationSelected: (i) => setState(() => index = i),
            ),
          ),
        ),
      ),
    );
  }
}
