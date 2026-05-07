# Prueba Técnica · Flutter

¡Hola! Gracias por tomarte el tiempo para esta prueba. Está diseñada para que puedas demostrar cómo trabajás con Flutter en un contexto **muy parecido al que vas a encontrar en el equipo**: un monorepo Melos con Riverpod 3 (codegen), Freezed, GoRouter, GetIt y un patrón de capas estricto.

**Tiempo estimado**: 6 a 8 horas. No queremos que dediques más. Si llegás al límite y algo queda incompleto, **documentá qué harías a continuación** — eso vale igual o más que una solución pulida pero sin criterio.

## 1. Setup

Ver `README.md` en la raíz del repo para los comandos de bootstrap. Verificá que la app levanta y muestra el shell de 2 tabs (Home / Activity) con dos pantallas placeholder.

> **Sin backend real**: no hay servidor que levantar. Tu propio **datasource** devuelve datos fake (lista hardcodeada en memoria, `Future.delayed` para simular latencia, y `throw` de las excepciones que correspondan). Lo que evaluamos no es que hables con un backend, sino **cómo estructurás las capas** para que el día que se cambie el datasource fake por uno real con HTTP, **nada por encima tenga que cambiar**.

## 2. Lo que tienes que construir

### Feature: **Savings Goals** (objetivos de ahorro de un niño)

Cada niño tiene una billetera y puede definir metas de ahorro (ej: "Bici nueva — €120"). La feature vive dentro del módulo `modules/savings_goals/` (que entregamos vacío).

### 2.1 Operaciones que tiene que soportar el datasource

Tu `SavingsGoalsRemoteDatasource` (interfaz + impl) tiene que exponer y mockear estas operaciones. La impl devuelve datos en memoria con `Future.delayed(Duration(milliseconds: 600))` para simular red.

| Operación | Comportamiento que tu impl debe simular |
|---|---|
| `fetchGoals(childId)` | Devuelve lista hardcodeada. Si `childId == 'child-error'` → `throw ApiException(message: 'Network error', isNetworkError: true)`. |
| `createGoal(childId, request)` | Agrega a la lista en memoria. Si el `name` ya existe → `throw ApiException(message: 'Goal name already exists', statusCode: 409)`. Ese mensaje tiene que llegar tal cual al usuario. |
| `updateProgress(goalId, amount)` | Actualiza `currentAmount`. Una vez de cada 5 intentos lanzá un `ApiException` con `isNetworkError: true` (para que demuestres tu manejo de error). El contador de intentos vive en la impl, **no** en una `Random` global — tiene que ser determinístico para que sea testeable. |
| `deleteGoal(goalId)` | Elimina del estado en memoria. Siempre OK. |

`ApiException` está definida en `packages/sf_shared/`. Es la misma forma que usaríamos contra un backend real (status code + message + isNetworkError).

Seedeá 2 niños (`child-1`, `child-2`) con 3 goals cada uno. El estado vive en memoria del proceso (se pierde con hot restart — está bien).

> Estructurá las capas **como si el datasource hablara con HTTP de verdad**. El día 1 en el equipo, lo único que cambia es swappear esa impl por una que use Dio + el cliente HTTP real — todo lo de arriba (repository, controller, screen, tests) tiene que seguir funcionando sin tocarse.

### 2.2 Modificar la pantalla Home (trabajo sobre código existente)

La pantalla Home actual es un placeholder con un contador. Reemplazala para que muestre **2 cards de niños** (`child-1` y `child-2`) con la siguiente info por card:

- Nombre del niño (puede ser hardcodeado: "Lucía", "Mateo").
- Resumen de sus metas: cantidad de metas y progreso total (ej: "3 metas · €45 / €300").
- Al tocar una card → navega a `/children/{childId}/savings-goals` (la lista de la feature).

Esto implica:
- Modificar el `HomeController` (que obtenga los datos del datasource de savings_goals).
- Modificar el screen para reemplazar el contador por las cards, usando widgets del `design_system`.
- Resolver la **dependencia entre módulos**: Home necesita datos de savings_goals. Pensá cómo exponés eso sin acoplar los módulos directamente — la convención del repo es exponer providers compartidos en un package común (mirá `packages/sf_shared/lib/src/...` para ver cómo funciona el resto). No hay una respuesta única correcta — lo que evaluamos es tu criterio.

### 2.3 Pantallas a implementar

#### A. **Lista de objetivos** — `/children/:childId/savings-goals`

- Muestra la lista de goals de ese niño.
- Cada item: nombre, monto objetivo, monto actual, % de progreso (barra), botón "eliminar".
- Estados visibles vía `AsyncValue.when(...)`: **loading**, **error** (con retry), **success** (incluyendo empty con CTA).
- Pull-to-refresh.
- FAB "Crear nuevo objetivo" → navega a la pantalla B.

#### B. **Crear objetivo** — `/children/:childId/savings-goals/new`

- Formulario con: `name` (3–40 chars), `targetAmount` (decimal > 0, máx €10.000), `description` (opcional, máx 200 chars).
- Validación inline en tiempo real (botón submit deshabilitado si inválido).
- La validación pura (sin dependencias de Riverpod) vive en una clase utilitaria (`SavingsGoalFormValidator` con métodos `static`) que retorna keys de I18n — testeable en aislamiento.
- Al enviar: en éxito vuelve a la lista y muestra un snackbar; en error de **conflicto** (`statusCode == 409`) mostrá el mensaje exacto del backend (`error.message`), no uno genérico. Otros errores se muestran con el dialog estándar vía `state.showErrorOn(context)`.

#### C. **Detalle / actualizar progreso** — `/children/:childId/savings-goals/:goalId`

- Muestra info de la meta + un input para añadir un aporte (monto positivo).
- Al confirmar, llama a `updateProgress` con el nuevo total.
- Si el aporte completa la meta (`>= targetAmount`), muestra un diálogo de "¡Meta alcanzada!" **una sola vez**, no en cada rebuild del widget. Pista: `ref.listen` sobre el `AsyncValue` del controller, no en `build()`.

### 2.4 Requisitos transversales (NO opcionales)

1. **Estructura de feature** según el patrón del proyecto. Mirá `modules/home/` antes de empezar — es la referencia. Estructura esperada:
   ```
   savings_goals/
   ├── lib/savings_goals.dart                                # public exports
   └── lib/src/
       ├── features/
       │   ├── list/
       │   │   ├── savings_goals_list_builder.dart
       │   │   ├── presentation/
       │   │   │   ├── savings_goals_list_screen.dart
       │   │   │   └── providers/
       │   │   │       └── savings_goals_list_controller.dart
       │   │   └── domain/
       │   │       └── entities/                             # entities específicas de la feature (si las hay)
       │   ├── create/
       │   │   ├── create_savings_goal_builder.dart
       │   │   ├── presentation/
       │   │   │   ├── create_savings_goal_screen.dart
       │   │   │   └── providers/
       │   │   │       ├── create_savings_goal_controller.dart
       │   │   │       └── create_savings_goal_form_state_provider.dart
       │   │   └── domain/
       │   │       └── savings_goal_form_validator.dart      # static helpers, sin Riverpod
       │   └── detail/...
       └── core/
           ├── data/
           │   ├── datasource/                               # interfaz + impl en memoria
           │   ├── models/                                   # DTOs Freezed + json_serializable + .toDto() / .toEntity() extensions
           │   └── repositories/                             # impls
           ├── domain/
           │   ├── entities/                                 # Freezed entities (NO usar los DTOs en la UI)
           │   └── repositories/                             # interfaces
           └── providers/                                    # Provider<T> manuales para datasource y repository
   ```
2. **Riverpod 3 con codegen** (`@riverpod`, `riverpod_annotation`, `riverpod_generator`). Los controllers extienden `_$Controller` y exponen estado como `AsyncValue<T>` (`FutureOr<T> build()` + `state = await AsyncValue.guard(() async { ... })`). Para parametrizar por `childId`/`goalId`, usar argumentos en `build`. Para estado UI auxiliar (form, validation error, toggles), preferí providers chicos separados (`@riverpod class XxxFormState extends _$XxxFormState`).
3. **Freezed** para todos los DTOs, entities y data classes. Generado con `melos gen`.
4. **GoRouter**: agregar las 3 rutas anidadas dentro del shell de Home. Los builders son clases `const` con `buildPage(context, state)` que toman el `NavigationContract` desde `GetIt.I<NavigationContract>()` y se lo pasan al screen. Mirá `home_builder.dart` como referencia.
5. **Capa de datos**: el `Repository` de dominio consume la interfaz `SavingsGoalsRemoteDatasource` (no la impl directamente). La impl en memoria se inyecta vía un `Provider` de Riverpod, y queda trivialmente reemplazable por una versión real con HTTP. El repository envuelve cada llamada con `try { ... } on ApiException catch (_) { rethrow; }` (o un `safeCall` que rethrowee como `ApiException`). El día que sea HTTP real, el repo agrega `on DioException catch (e) { throw mapDioError(e, ...) }` y el resto no cambia.
6. **Errores en la UI**: la convención es `ref.listen(controllerProvider, (_, n) => n.showErrorOn(context))`. La extension `showErrorOn` (en `sf_shared`) usa `FailureType.fromException` para mostrar el dialog correcto (connection / technical / validation / notFound / rateLimit / conflict / notAuthorized). El `conflict` (409) renderiza el `ApiException.message` literal — usalo para el caso de nombre duplicado. Para inline errors de validación de form, un `@riverpod` chico tipo `xxxLocalErrorProvider` que expone `String?` con la key de I18n.
7. **Localización**: todas las strings visibles van por `context.translate(I18n.x)`. Agregá las keys nuevas en `packages/localizations/assets/l10n/{en,es}.json` y en `i18n.dart`.
8. **Theming**: colores, radios y tipografía vía el `design_system` (no hardcodear). Si necesitás un widget que no existe, agregalo al package — no inline en una pantalla.
9. **Sin comentarios** en el código que entregues. **Sin business logic dentro de widgets**. **Sin `setState`** — todo el estado mutable de UI vive en providers; la única excepción aceptable es `TextEditingController` con su `dispose()` en un `ConsumerStatefulWidget`.

### 2.5 Tests (mínimo aceptable)

Escribí tests para **al menos** estas tres cosas, usando `mocktail` y el helper `makeContainer(overrides: [...])` de `sf_shared/testing.dart`:

1. **Repository / mapeo de errores** — dado un datasource fake controlado en el test (no la impl en memoria de la app), validar que el conflicto de nombre se propaga como `ApiException(statusCode: 409)` y que el happy path devuelve los datos esperados.
2. **Controller de la lista** — transición `AsyncLoading → AsyncData` y `AsyncLoading → AsyncError` + acción `refresh`. Asertar directamente sobre el AsyncValue (`expect(state, isA<AsyncData<List<X>>>())`).
3. **Validación del formulario de creación** — casos válido/inválido sobre la clase pura (sin Riverpod).

Patrón de referencia (similar a `modules/home/test/home_controller_test.dart`):

```dart
final container = makeContainer(overrides: [
  savingsGoalsRepositoryProvider.overrideWithValue(repo),
]);
addTearDown(container.dispose);
await container.read(controllerProvider.notifier).submit(...);
final state = container.read(controllerProvider);
expect(state, isA<AsyncData<void>>());
```

No esperamos coverage total, esperamos **tests que demuestren cómo testeás**.

### 2.6 Bonus (opcional, máx 1h — y sólo si llegás)

Elegí **uno** y lo discutimos en la defensa:

- **A) Persistir filtro**: agregá un toggle "ocultar metas completadas" en la lista, persistido en `SharedPreferences`, leído al rebuild del provider sin race conditions.
- **B) Optimistic update**: en `deleteGoal`, sacá el item de la lista antes de que la operación termine. Si falla, restauralo y mostrá un snackbar.
- **C) `family` en lugar de argumentos crudos**: refactorizá los controllers parametrizados (`childId`, `goalId`) usando `@Riverpod(keepAlive: false)` con argumentos en `build` y discutí los tradeoffs vs. pasar el id por constructor.

## 3. Entregables

1. PR (o repo) con tu solución.
2. Un `SOLUTION.md` corto (máx 1 página) con:
   - Cómo correrlo (si cambiaste algo del setup).
   - Qué dejaste afuera y por qué.
   - Qué harías diferente con más tiempo.
   - Si hiciste el bonus, cuál y por qué elegiste ese.

## 4. Nota final

Valoramos el diseño, las buenas prácticas, la arquitectura limpia y el código limpio.

El skeleton viene armado con Riverpod 3 (codegen), Freezed, GoRouter y GetIt, y la consigna pide usarlos. Pero si considerás que hay una mejor forma de resolver algo — ya sea otro manejo de estado (bloc/cubit), otra estructura de capas, otro approach de navegación, o lo que sea — **tenés libertad de hacerlo**. Lo único que pedimos es que lo justifiques en tu `SOLUTION.md` y estés preparado para defenderlo en el review. Vamos a hacer todas las preguntas necesarias para entender tu razonamiento.

Lo que nos importa no es que sigas instrucciones al pie de la letra, sino que demuestres criterio técnico.
