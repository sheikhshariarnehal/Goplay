import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants.dart';
import 'core/router.dart';




import 'package:flutter/foundation.dart' show kIsWeb;
import 'utils/web_helper.dart';
import 'widgets/update_handler.dart';
import 'widgets/app_broadcast_wrapper.dart';
import 'providers/app_providers.dart';

// Global future that SplashScreen waits on before navigating.
// Completes when all heavy init is done.
late final Future<void> appInitFuture;

void main() async {
  // Ensure binding is ready synchronously — very fast, no I/O.
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent uncaught Dart runtime exceptions from terminating the app process
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global FlutterError caught: ${details.exceptionAsString()}');
  };

  // Cap the image cache to avoid unbounded decoded-image GC pressure.
  // 200 images max; 80 MB total — covers a full search result page with headroom.
  PaintingBinding.instance.imageCache.maximumSize = 200;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 80 * 1024 * 1024;

  // System UI — synchronous, no cost.
  try {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  } catch (e) {
    debugPrint('Failed to set SystemUIOverlayStyle: $e');
  }

  // Fast init: Initialize Hive and open settingsBox BEFORE runApp.
  // This guarantees dynamic theme colors & UI config load instantly from disk on cold start.
  try {
    await Hive.initFlutter();
    await _openSafeBox(AppConstants.settingsBox);
  } catch (e) {
    debugPrint('Fast Hive settings init error: $e');
  }

  // Kick off remaining heavy async init (channels, categories, Supabase) concurrently
  appInitFuture = _initializeApp();

  runApp(const ProviderScope(child: GoPlayApp()));
}

/// Performs all heavy initialization in the background.
/// SplashScreen races this future against a minimum display timer.
Future<void> _initializeApp() async {
  try {
    // Hive + Supabase can run concurrently.
    await Future.wait([
      _initHive(),
      _initSupabase(),
    ]);
  } catch (e, stack) {
    debugPrint('Background init error (non-fatal): $e\n$stack');
  }
}

Future<void> _initHive() async {
  final boxesToOpen = [
    AppConstants.channelsBox,
    AppConstants.eventsBox,
    AppConstants.categoriesBox,
    AppConstants.watchHistoryBox,
    AppConstants.favoritesBox,
    AppConstants.announcementsBox,
    AppConstants.heroBannersBox,
  ];

  for (final boxName in boxesToOpen) {
    await _openSafeBox(boxName);
  }

  // Clear stale channels & categories cache once to ensure 100% clean sync from Supabase DB
  try {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    const String migrationKey = 'supabase_live_channels_v2_purged';
    if (settingsBox.get(migrationKey) != true) {
      if (Hive.isBoxOpen(AppConstants.channelsBox)) {
        await Hive.box(AppConstants.channelsBox).clear();
      }
      if (Hive.isBoxOpen(AppConstants.categoriesBox)) {
        await Hive.box(AppConstants.categoriesBox).clear();
      }
      await settingsBox.put(migrationKey, true);
      debugPrint('Hive: Purged stale channels & categories caches for live Supabase migration.');
    }
  } catch (e) {
    debugPrint('Hive cache auto-purge error (non-fatal): $e');
  }
}

Future<void> _openSafeBox(String boxName) async {
  try {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  } catch (e) {
    debugPrint('Failed to open Hive box "$boxName": $e. Attempting clean recreate.');
    try {
      await Hive.deleteBoxFromDisk(boxName);
      await Hive.openBox(boxName);
    } catch (e2) {
      debugPrint('Critical: Could not recreate box "$boxName": $e2');
    }
  }
}

Future<void> _initSupabase() async {
  try {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase.initialize non-fatal error: $e');
  }
}

class GoPlayApp extends ConsumerWidget {
  const GoPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        removeLoadingSplash();
      });
    }
    final dynamicTheme = ref.watch(appThemeProvider);

    return AppBroadcastWrapper(
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: dynamicTheme,
        darkTheme: dynamicTheme,
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
        builder: (context, child) {
          // Bound the system font scale. Unclamped accessibility scaling
          // overflowed fixed-height layouts such as the channel grid cards.
          return MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.0,
            maxScaleFactor: 1.3,
            child: UpdateHandler(child: child!),
          );
        },
      ),
    );
  }
}
