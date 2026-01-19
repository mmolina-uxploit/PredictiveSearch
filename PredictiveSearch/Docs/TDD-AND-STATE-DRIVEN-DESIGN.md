# Desarrollo Guiado por Tests (TDD) en PredictiveSearch

> Este documento explica cómo el **Desarrollo Guiado por Pruebas (TDD)** funciona como una **herramienta de diseño** en un sistema gobernado por estado y concurrencia.
> Los tests no se usan únicamente para verificar comportamiento, sino como **especificaciones ejecutables de decisiones arquitectónicas**.

---

## Rol del test en la arquitectura

En PredictiveSearch, los tests cumplen un propósito de **documentación viva**:

* definen un **contrato observable mínimo**: estado inicial, evento ejecutado y estado resultante esperado,
* delimitan transiciones válidas dentro del modelo de estado del ViewModel,
* evitan depender de detalles de implementación, efectos colaterales o frameworks externos.

Cada test es, en esencia, un **caso de estudio ejecutable** que asegura que las decisiones arquitectónicas se mantengan coherentes.

---

## Ejemplo conceptual alineado al proyecto

Supongamos la clase central del sistema:

```swift
@MainActor
final class PredictiveSearchViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    private var searchTask: Task<Void, Never>?

    func search(query: String) {
        searchTask?.cancel()
        state = .loading(query)

        searchTask = Task {
            do {
                let results = try await repository.search(query: query)
                state = .loaded(results)
            } catch is CancellationError {
                // la tarea fue cancelada, el estado no cambia
            } catch {
                state = .error(error)
            }
        }
    }
}
```

Un test coherente con PredictiveSearch:

```swift
func testSearchDebounceAndCancellation() async {
    let repository = MockSearchRepository()
    let vm = PredictiveSearchViewModel(repository: repository)

    await vm.search(query: "Intención A")
    await vm.search(query: "Intención B") // cancela la búsqueda anterior

    XCTAssertEqual(vm.state, .loading("Intención B"))
}
```

---

## Qué demuestra este test

El test anterior establece de forma explícita:

* cancelación automática de tareas previas,
* estado determinista de la UI mediante ViewState,
* comportamiento predecible sin lógica defensiva adicional en SwiftUI.

El test no valida la UI ni la red real.
Valida el **contrato de transición de estado** definido por el proyecto.

---

## Conexión con Clean Architecture

Los tests operan únicamente sobre el dominio y el ViewModel:

* no dependen de NetworkClient,
* no dependen de SwiftUI,
* no requieren infraestructura real.

La lógica de presentación y la infraestructura se prueban mediante dobles controlados, como mocks o fakes.

Cada transición de estado se convierte así en una **especificación ejecutable**, que guía el diseño del dominio y del ViewModel.

---

## Beneficios de TDD en PredictiveSearch

El enfoque aporta ventajas concretas:

* **diseño guiado por intención**: cada test define cómo debe comportarse el sistema,
* **prevención de bugs complejos**: cancelaciones y concurrencia se resuelven antes de llegar a la UI,
* **documentación viva**: los tests explican decisiones de arquitectura de forma ejecutable,
* **refactors seguros**: el contrato de estado permanece validado ante cambios internos.

---

## Alcance actual

Actualmente, los tests cubren principalmente:

* flujo inicial de búsqueda y debounce,
* cancelación de búsquedas anteriores,
* transiciones de estado en PredictiveSearchViewModel.

No se trata de una estrategia completa de testing de UI, sino de un **núcleo de diseño confiable** para futuras expansiones.

---

## Síntesis

En PredictiveSearch, TDD no es un accesorio ni una validación tardía.
Es una parte integral del diseño.

Cada test representa una decisión arquitectónica y una garantía de que el flujo de estado y concurrencia se mantiene:

* predecible,
* seguro,
* razonable de evolucionar.
