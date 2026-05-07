# SaveFamily Skeleton — Flutter Skeleton

Mini-monorepo Flutter para una prueba técnica. Antes de empezar a codear, leé `test.md` (en este mismo directorio) que tiene la consigna completa.

## Stack

- Dart `^3.9.2` / Flutter
- Melos `6.3.3` (workspace)
- Riverpod 3 con codegen (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`)
- Freezed 3 + `json_serializable`
- GoRouter 17 (`StatefulShellRoute.indexedStack`)
- GetIt para servicios de infraestructura
- `intl` y delegate propio para localización (en/es)
- `mocktail` para tests

## Setup

```bash
dart pub global activate melos 6.3.3
melos bootstrap

# Generate iOS / Android platform folders for the app (only first time)
cd apps/mobile_app
flutter create --platforms=ios,android --org com.example.savefamily .
cd ../..

melos gen
flutter run -t apps/mobile_app/lib/main_development.dart \
  --dart-define-from-file=apps/mobile_app/config/development.json
```

`melos gen` corre `build_runner` en los packages que lo necesitan (Freezed + Riverpod codegen). Si tocás cualquier `*_controller.dart` con `@riverpod`, model con `@freezed`, o serialización, volvé a correrlo (o `melos watch` en otra terminal).

## Estructura

```
save-family-skeleton/
├── apps/
│   └── mobile_app/                         # Entry point + router + DI bootstrap
│       ├── lib/
│       │   ├── main_development.dart
│       │   ├── app.dart                    # Root MaterialApp.router
│       │   ├── core/init_app.dart          # Orden de inicialización
│       │   └── navigation/app_router.dart  # GoRouter con StatefulShellRoute (2 tabs)
│       └── config/development.json
├── modules/
│   ├── home/                               # Módulo de referencia (mirá este antes de empezar)
│   ├── activity/                           # Placeholder mínimo
│   └── savings_goals/                      # VACÍO — acá va tu trabajo
└── packages/
    ├── design_system/                      # ThemePort + widgets básicos
    ├── localizations/                      # Delegate + I18n constants + en/es
    ├── navigation/                         # NavigationContract + AppRoutes
    └── sf_shared/                          # ApiException + FailureType + showErrorOn + test helpers
```

## Cómo agregar tu feature

`modules/home/` es la **referencia viva** del patrón. Antes de tocar nada, abrílo entero y entendé:

- Cómo se exponen los builders (`features/home/home_builder.dart`) y cómo toman el `NavigationContract` desde GetIt.
- Cómo se estructura un `@riverpod class HomeController extends _$HomeController` que devuelve `FutureOr<HomeData>` y maneja errores con `AsyncValue.guard`.
- Cómo el screen consume el controller con `state.when(loading:, error:, data:)` y muestra errores con `ref.listen + showErrorOn(context)`.
- Cómo el módulo declara sus dependencias en `pubspec.yaml` (incluyendo `riverpod_generator` y `sf_shared`).
- Cómo se testea el controller en `test/home_controller_test.dart` con `makeContainer(...)`.

Después abrí `apps/mobile_app/lib/navigation/app_router.dart` para ver cómo ese módulo se conecta al `StatefulShellRoute`.

Cuando estés listo, replicá ese patrón en `modules/savings_goals/`.

## Comandos útiles

```bash
melos analyze              # flutter analyze en todos los packages
melos test                 # flutter test en los packages con test/
melos gen                  # build_runner build (Freezed + Riverpod codegen)
melos watch                # build_runner watch
melos clean                # limpia .dart_tool/ + build/
```
