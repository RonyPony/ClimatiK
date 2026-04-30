import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/controllers/settings_controller.dart';

class ClimatikApp extends ConsumerWidget {
  const ClimatikApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Climatik',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('es'),
    );
  }
}
