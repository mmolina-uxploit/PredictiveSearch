# ARCHITECTURE · PredictiveSearch

> Este documento describe las **decisiones arquitectónicas fundamentales** del proyecto **PredictiveSearch**.

---

## Contexto del problema

PredictiveSearch implementa una funcionalidad de búsqueda predictiva que debe manejar:

* múltiples consultas consecutivas,
* concurrencia,
* cancelación de tareas previas,
* actualización determinista de la UI.

Aunque el caso de uso es simple, el sistema está diseñado asumiendo que:

* la UI evolucionará,
* las fuentes de datos pueden cambiar,
* las reglas crecerán,
* la concurrencia será parte central del problema.

---

## Principios arquitectónicos

### 1. Gestión del cambio

La arquitectura asume que el cambio es inevitable.
No intenta evitarlo, sino **limitar su impacto**.

Decisiones centrales:

* proteger el dominio,
* aislar infraestructura,
* definir fronteras explícitas,
* modelar estados de forma clara.

---

### 2. Estabilidad estructural

Los componentes más centrales deben cambiar con menor frecuencia.

Orden de estabilidad:

1. Dominio
2. Presentación (ViewModel)
3. Infraestructura
4. UI

Las dependencias siempre apuntan hacia el código más estable.

---

### 3. Fronteras explícitas

Una frontera solo existe si está codificada.

En PredictiveSearch las fronteras se expresan mediante:

* protocolos en el dominio,
* inversión de dependencias,
* separación entre estado, lógica e infraestructura.

---

## Capas del sistema

### Dominio

El Dominio es el núcleo semántico.

Responsabilidades:

* modelar conceptos de búsqueda,
* definir contratos mediante protocolos,
* representar reglas e invariantes.

El Dominio no conoce:

* SwiftUI,
* networking,
* concurrencia,
* frameworks externos.

---

### Presentación

La capa de presentación coordina la interacción.

Responsabilidades:

* recibir intenciones del usuario,
* coordinar tareas asincrónicas,
* exponer un estado observable.

No contiene reglas de negocio.

---

### Infraestructura

La infraestructura implementa los contratos del dominio.

Características:

* completamente reemplazable,
* responsable de la obtención de datos,
* depende del dominio, nunca al revés.

---

## Estado como contrato

El sistema se organiza alrededor de un principio clave:

> La UI solo reacciona al estado.

* El `ViewModel` expone un `ViewState` determinista.
* SwiftUI proyecta ese estado sin lógica adicional.

Esto elimina estados implícitos y decisiones dispersas.

---

## Flujo de datos

El flujo es estrictamente unidireccional:

1. la vista emite una intención,
2. el ViewModel coordina la acción,
3. el repositorio ejecuta la búsqueda,
4. el estado se actualiza,
5. la UI reacciona.

No hay dependencias circulares.

---

## Concurrencia y cancelación

La arquitectura asume que:

* cada búsqueda es una tarea asincrónica,
* las búsquedas previas deben cancelarse,
* el estado debe permanecer coherente.

La gestión de concurrencia es parte del diseño, no de la UI.

---

## Decisiones reversibles y protegidas

### Reversibles

* implementación del repositorio,
* cliente de red,
* detalles de UI.

### Protegidas

* modelo de dominio,
* contratos,
* flujo de estado.

La arquitectura protege lo costoso de cambiar.

---

## Trade-offs aceptados

* mayor esfuerzo inicial de diseño,
* más abstracciones explícitas,
* estructura más rigurosa.

A cambio de:

* previsibilidad,
* testabilidad,
* menor acoplamiento,
* evolución segura.

---

## Síntesis

La arquitectura de PredictiveSearch no busca ser la más rápida de construir.
Busca ser **razonable de mantener**.

Si la UI cambia, el dominio permanece.
Si la infraestructura cambia, el dominio permanece.

El sistema cumple su objetivo cuando el núcleo se mantiene estable frente al cambio.

