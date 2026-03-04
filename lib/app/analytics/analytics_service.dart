import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import '../app_secrets.dart';

abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? params});
}

class AppMetricaAnalyticsService implements AnalyticsService {
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized || AppSecrets.appMetricaApiKey.isEmpty) {
      return;
    }

    try {
      await AppMetrica.activate(AppMetricaConfig(AppSecrets.appMetricaApiKey));
      _initialized = true;
      if (kDebugMode) {
        debugPrint('[Analytics][AppMetrica] initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Analytics][AppMetrica] init failed: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    if (AppSecrets.appMetricaApiKey.isEmpty) {
      if (kDebugMode) {
        debugPrint(
          '[Analytics][AppMetrica] skipped "$name": empty API key '
          '(length=${AppSecrets.appMetricaApiKey.length})',
        );
      }
      return;
    }

    await _ensureInitialized();

    final attributes = <String, Object>{};
    if (params != null) {
      for (final entry in params.entries) {
        final value = entry.value;
        if (value != null) {
          attributes[entry.key] = value;
        }
      }
    }

    await AppMetrica.reportEventWithMap(
      name,
      attributes.isEmpty ? null : attributes,
    );
    if (kDebugMode) {
      debugPrint(
        '[Analytics][AppMetrica] event sent: $name, params=${attributes.keys.toList()}',
      );
    }
  }
}

class NoopAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {}
}

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalytics? _analytics;
  bool _attemptedInit = false;

  Future<void> _ensureInitialized() async {
    if (_attemptedInit) {
      return;
    }
    _attemptedInit = true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _analytics = FirebaseAnalytics.instance;
      if (kDebugMode) {
        debugPrint('[Analytics][Firebase] initialized');
      }
    } catch (e, st) {
      _analytics = null;
      if (kDebugMode) {
        debugPrint('[Analytics][Firebase] init failed: $e');
        debugPrint(st.toString());
      }
    }
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    await _ensureInitialized();
    if (_analytics == null) {
      if (kDebugMode) {
        debugPrint('[Analytics][Firebase] skipped "$name": analytics unavailable');
      }
      return;
    }

    final payload = <String, Object>{};
    if (params != null) {
      for (final entry in params.entries) {
        final value = entry.value;
        if (value != null) {
          payload[entry.key] = value;
        }
      }
    }

    await _analytics!.logEvent(
      name: name,
      parameters: payload.isEmpty ? null : payload,
    );
    if (kDebugMode) {
      debugPrint(
        '[Analytics][Firebase] event sent: $name, params=${payload.keys.toList()}',
      );
    }
  }
}

class CompositeAnalyticsService implements AnalyticsService {
  final List<AnalyticsService> services;

  const CompositeAnalyticsService(this.services);

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    for (final service in services) {
      try {
        await service.logEvent(name, params: params);
      } catch (e, st) {
        // Analytics errors must not affect product flows.
        if (kDebugMode) {
          debugPrint('[Analytics][Composite] service failed: $e');
          debugPrint(st.toString());
        }
      }
    }
  }
}
