import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:localizations/localizations.dart';

/// Set [withLocalizations] only when the widget under test calls
/// `context.translate(...)`; it loads the JSON asset bundle.
Future<void> pumpApp(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const [],
  Locale locale = const Locale('es'),
  bool withLocalizations = false,
}) async {
  final delegates = <LocalizationsDelegate<dynamic>>[
    if (withLocalizations) ...AppLocalizations.delegates,
    if (!withLocalizations) ...[
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  ];

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: delegates,
        home: Scaffold(body: child),
      ),
    ),
  );
}
