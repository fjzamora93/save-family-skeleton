import 'package:flutter/material.dart';

import 'theme_port.dart';

ThemeData materialThemeFor(ThemePort port) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: port.colorFor(ThemeCode.buttonPrimary),
    ),
    cardTheme: CardThemeData(
      color: port.colorFor(ThemeCode.cardSurface),
      shadowColor: port.colorFor(ThemeCode.cardShadow),
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
  );
}
