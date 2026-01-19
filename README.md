# PredictiveSearch

`PredictiveSearch` es una aplicación iOS escrita en Swift cuyo propósito es servir como **caso de estudio arquitectónico** sobre concurrencia, cancelación determinista y diseño de fronteras explícitas en escenarios de búsqueda en tiempo real.

La funcionalidad es deliberadamente simple: permitir que el usuario escriba un término y obtener resultados predictivos desde la API de iTunes.

El objetivo del proyecto **no es la UI ni la API concreta**, sino demostrar cómo construir una feature que pueda evolucionar sin degradar su diseño interno.

---

## Qué demuestra este proyecto

* Modelado de una funcionalidad reactiva de búsqueda como problema de dominio y no solo de UI.
* Gestión explícita de concurrencia utilizando `async/await`.
* Cancelación determinista de tareas para evitar condiciones de carrera.
* Separación clara entre:

  * reglas de negocio,
  * orquestación de casos de uso,
  * infraestructura de red,
  * presentación en SwiftUI.
* Uso de protocolos como contratos para aislar dependencias.
* Arquitectura testeable y reemplazable.
* Integración de SwiftUI sin acoplarla al núcleo del sistema.

---

## Arquitectura

El proyecto adopta un enfoque inspirado en **Clean Architecture / Hexagonal Architecture**, organizado alrededor de un núcleo lógico estable y capas bien delimitadas.

### Capas del sistema

* **Domain**
  Define:

  * entidades como `MediaItem`,
  * modelos puros del problema,
  * contratos que expresan qué necesita el sistema para funcionar.

  No conoce frameworks, UI ni detalles de red.

* **Application**
  Orquesta la interacción entre el usuario y el dominio.
  Gestiona concurrencia y cancelación.
  Define qué ocurre cuando el usuario escribe, no cómo se obtiene la información.

* **Infrastructure**
  Implementa los contratos del dominio.
  `MediaRepository` encapsula el acceso a la API de iTunes y transforma respuestas externas en modelos del sistema.

* **UI**
  Capa SwiftUI mínima y declarativa.
  Observa estado, envía intenciones y renderiza resultados.
  No contiene reglas de negocio ni lógica de red.

El criterio fundamental no es quién llama a quién, sino **quién depende de quién**.
Las capas externas dependen de las internas, nunca al revés.

---

## Concurrencia y Cancelación

Uno de los focos centrales del proyecto es el manejo correcto de concurrencia:

* Cada nueva búsqueda genera una tarea asincrónica.
* Las búsquedas anteriores se cancelan explícitamente.
* Solo se muestran resultados de la consulta más reciente.
* Se evitan condiciones de carrera entre respuestas lentas y rápidas.

Este patrón es esencial en aplicaciones modernas con interacción en tiempo real.

---

## Tecnologías Utilizadas

* **Lenguaje:** Swift 5
* **Framework UI:** SwiftUI
* **Concurrencia:** `async/await`, `Task`, cancelación cooperativa
* **Networking:** URLSession
* **Patrones:** Clean Architecture, MVVM, Inyección de Dependencias

---

## Documentación

Las decisiones arquitectónicas y de diseño están explicadas en detalle en:

* **Docs/ARCHITECTURE.md**
  Describe la estructura del sistema, los límites entre capas y los trade-offs adoptados.

* **Docs/TDD-AND-STATE-DRIVEN-DESIGN.md**
  Profundiza en cómo el diseño orientado a estados y pruebas guía la construcción de la feature.

---

## Cómo ejecutar el proyecto

1. Clonar el repositorio.
2. Abrir `PredictiveSearch.xcodeproj` en Xcode.
3. Seleccionar un simulador o dispositivo físico.
4. Ejecutar con Cmd+R.

---

## Nota final

Este proyecto prioriza la claridad conceptual sobre la inmediatez.

Introduce una estructura deliberada para demostrar que incluso una funcionalidad tan cotidiana como una búsqueda puede diseñarse de forma:

* robusta,
* predecible,
* desacoplada,
* preparada para el cambio.

La arquitectura no hace desaparecer la complejidad.
La ubica en lugares correctos.

Ese es el verdadero propósito de PredictiveSearch.

