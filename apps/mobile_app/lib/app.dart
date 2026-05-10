import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:sf_skeleton_app/navigation/app_router.dart';

class SFSkeletonApp extends ConsumerWidget {
  const SFSkeletonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'SaveFamily',
      debugShowCheckedModeBanner: false,
      theme: materialThemeFor(ref.watch(themePortProvider)),
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
