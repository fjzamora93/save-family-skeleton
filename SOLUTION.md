# Decisiones tomadas

## Validación de formularios

Para la validación de formularios se ha dividido por un lado lo que es el 'estado' propio del formulario (para ello se ha creado el directorio presentation/state), y por otro lado el controlador que va a hacer la llamada al validator. De esta manera queda desacoplado y tenemos opción a hacer crecer el formulario con nuevos campos cuando sea necesario

## Casos de uso

Aunque en esta prueba todas las validaciones que se han hecho son semánticas (que tenga ciertos caracteres o cierto valor límite, por ejemplo), se han añadido validaciones propias de la lógica de negocio. Para ello, se ha creado una capa intermedia llamada 'UseCase' que es la que se ocuparía de la lógica de negocio más compleja.

## Excepciones del domain

Al igual que puede haber excepciones del backend, se están contemplando excepciones de la capa de Domain. En este caso, y por simplificidad, se propagan de la misma manera que los errores que vienen del backend. Aunque idealmente deberían manejarse de una forma distinta (no es lo mismo un fallo de la Api que uno donde simplemente no se cumplen las reglas de negocio y se puede informar al usuario inmediatamente de lo que sucede).


## Llamadas a base de datos

Para mantener el código limpio, se están haciendo llamadas recurrentes al backend y se están invalidando constantemente los controladores. Esto, en un caso real, tiene un coste económico que debe ser evaluado, pues cuando se trabaja con miles de registros simultáneamente, hacer una invalidación es una operación demasiado costosa.


## Estilo

Si quisiéramos empezar a dar estilo a los distintos widgets de la app, sería necesario comenzar a separar responsabilidades dentro del design_system. Ahora mismo, el material_theme se le ha metido una nueva responsabilidad que es la de decidir 'qué aspecto tiene el card', pero próximamente se agregarían el resto de widgets de Flutter... finalmente crecería demasiado y sería un problema. 

Tan pronto fuese posible, sería conveniente separar el ThemeData en piezas.

Para las tipografías, esquema de colores, etc... sería necesario hacer algo equivalente.


## Arquitectura monorepo

Se ha respetado que módulo Home actúe como un agregador: no contiene la lógica de los demás features, pero sí compone sus datos para construir su propio modelo de dominio. En concreto, trae información de otros módulos como savings_goals utilizando únicamente sus APIs públicas, nunca accediendo a su src interno. Con esos datos (por ejemplo List<SavingsGoal>), home construye entidades propias como ChildSummary o HomeData, que son las que usan la UI del módulo. 

De esta forma, home depende de otros módulos a nivel de contrato, no de implementación, y centraliza la composición de datos sin romper el aislamiento entre features.