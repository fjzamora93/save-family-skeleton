
# Generar los freeze

Para ir generando los freeze... tienes que meterte en el modulo y ejecutar este comando

dart run build_runner build --delete-conflicting-outputs && flutter analyze

# EJecutar el proyecto

Se ejectua desde apps/mobile_app... desde ahí arrancas el proyecto, no desde cualuiqer parte




# Paso 1: Definición del Dominio y Modelos (Freezed) COMPLETADO

Lo primero es definir qué es un "Savings Goal" en tu código. Debes ir a modules/savings_goals/ y crear las Entities (clases de dominio para la UI) y los Models (clases DTO para la capa de datos) usando Freezed. Es crucial incluir los métodos fromJson y las extensiones de mapeo (.toEntity()) para transformar los datos que vienen del "backend" fake a objetos que la interfaz pueda entender sin acoplarse al formato de red.


# Paso 2: Implementación del Datasource y Repositorio COMPLETADO

Debes construir la infraestructura de datos siguiendo el patrón de la consigna. Crea una interfaz para el SavingsGoalsRemoteDatasource y su implementación "fake" en memoria que simule latencia con Future.delayed y maneje el contador de errores solicitado. Luego, implementa el Repository, que será el encargado de llamar al datasource y capturar las excepciones (ApiException), asegurando que la lógica de negocio esté protegida y sea fácilmente intercambiable por una implementación real en el futuro.


# Paso 3: Configuración de Providers y Dependencias COMPLETADO

Con las clases de datos listas, toca usar Riverpod para que el resto de la app pueda acceder a ellas. Crea los providers manuales para el repositorio y el datasource en la carpeta core/providers del módulo. Al usar Riverpod 3 con codegen, esto permitirá que tus controladores inyecten estas dependencias automáticamente, facilitando también la sustitución de estas por mocks durante los tests unitarios.


# Paso 4: Actualización del Módulo Home

Antes de crear tus pantallas nuevas, debes modificar el módulo home existente para que sirva de puente. Modifica su HomeController para que consuma el repositorio de savings_goals que acabas de crear y obtenga el resumen de los dos niños (child-1 y child-2). Aquí demostrarás tu criterio para resolver dependencias entre módulos, exponiendo la información necesaria (como el progreso total y número de metas) para pintar las cards requeridas en la pantalla principal.


# Paso 5: Registro de Rutas en GoRouter

El último paso de esta fase de preparación es "darle una dirección" a tus futuras pantallas en el AppRouter. Ve a apps/mobile_app y registra las nuevas rutas (lista, creación y detalle) dentro del StatefulShellRoute. Deberás crear los Builders correspondientes en tu módulo de metas (siguiendo el ejemplo de HomeBuilder) para que la navegación sea desacoplada y el router sepa exactamente cómo construir cada pantalla inyectando el NavigationContract.




# Paso 6: Pantalla de Lista de Objetivos (Feature List)
Implementa la interfaz en presentation/ usando AsyncValue.when para manejar estados de carga, éxito y error con reintento. Incluye el componente de barra de progreso por meta, la funcionalidad de eliminar y el gesto pull-to-refresh según el requisito 2.3.A.


# Paso 7: Pantalla y Lógica de Creación (Feature Create)
Desarrolla el formulario con validaciones inline mediante la clase estática SavingsGoalFormValidator y un provider de estado dedicado. Al enviar, gestiona el error de conflicto (409) mostrando el mensaje literal del backend y usa un snackbar para confirmar el éxito.


# Paso 8: Pantalla de Detalle y Aportes (Feature Detail)
Crea la vista para actualizar el progreso de ahorro con un input para montos positivos. Utiliza ref.listen sobre el controlador para disparar el diálogo de "¡Meta alcanzada!" una única vez cuando el aporte complete el objetivo, evitando repeticiones innecesarias.

# Paso 9: Internacionalización y Sistema de Diseño (Transversal)
Traslada todas las cadenas de texto a los archivos .json en packages/localizations para su uso mediante context.translate. Asegura que todos los widgets utilicen exclusivamente los tokens de color y tipografía definidos en el design_system del proyecto.

# Paso 10: Suite de Tests Unitarios (Requisito 2.5)
Escribe los tests mínimos con mocktail para validar el mapeo de errores del Repositorio, las transiciones de estado del Controlador de lista y la lógica del Validador. Verifica que el happy path y los casos de error (ApiException) se comporten según lo esperado.

# Paso 11: Documentación y Entrega (Entregables)
Redacta el archivo SOLUTION.md detallando las decisiones de diseño, la gestión de dependencias entre módulos y cualquier bonus realizado. Asegúrate de limpiar comentarios innecesarios y lógica de negocio dentro de los widgets antes de realizar el PR final.