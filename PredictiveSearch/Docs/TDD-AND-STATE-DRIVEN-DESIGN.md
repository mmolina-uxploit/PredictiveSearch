# Desarrollo Guiado por Tests (TDD) en `PredictiveSearch`

> Este documento explica cómo el **Desarrollo Guiado por Pruebas (TDD)** funciona como **herramienta de diseño** en un sistema gobernado por estado y concurrencia.  
> Los tests no se usan aquí solo para verificar comportamiento, sino como **especificaciones ejecutables de decisiones de diseño**.

---

## Rol del test en la arquitectura

En `PredictiveSearch`, los tests cumplen un propósito de **documentación viva**:

- Definen un **contrato observable mínimo**: estado inicial, evento ejecutado y estado resultante esperado.  
- Delimitan transiciones válidas dentro del modelo de estado del `ViewModel`.  
- Evitan depender de detalles de implementación, efectos colaterales o frameworks externos.  

Cada test es, en esencia, un **caso de estudio ejecutable** que asegura que las decisiones arquitectónicas se mantengan coherentes.

---

## Ejemplo conceptual: búsqueda predictiva

Supongamos la clase `PredictiveSearchViewModel`:

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
Un test que describe el flujo esperado:

func testSearchDebounceAndCancellation() async {
    let repository = MockSearchRepository()
    let vm = PredictiveSearchViewModel(repository: repository)

    await vm.search(query: "Rick")
    await vm.search(query: "Morty") // cancela la búsqueda anterior

    XCTAssertEqual(vm.state, .loading("Morty"))
}
```
Qué demuestra este test:

Cancelación explícita de tareas viejas

Estado determinista de la UI (ViewState)

Comportamiento predecible sin lógica defensiva adicional en SwiftUI

El test no valida la UI ni la red real; valida el contrato de transición de estado.

Conexión con Clean Architecture

Los tests operan solo sobre el dominio y el ViewModel, sin depender de NetworkClient ni SwiftUI.

La lógica de presentación y la infraestructura se prueban mediante dobles controlados (mocks o fakes).

Cada transición de estado se convierte en una especificación ejecutable, que guía el diseño del dominio y del ViewModel.

Beneficios de TDD en PredictiveSearch

Diseño guiado por intención: cada test define cómo debería comportarse el sistema, no solo cómo funciona.

Prevención de bugs complejos: cancelaciones, debounce y concurrencia se gestionan antes de llegar a la UI.

Documentación viva: los tests explican decisiones de arquitectura de manera ejecutable.

Refactors seguros: el contrato de estado está siempre validado, incluso si cambian implementaciones internas.

Alcance

Actualmente, los tests cubren principalmente:

Flujo inicial de búsqueda y debounce

Cancelación de búsquedas anteriores

Transiciones de estado en PredictiveSearchViewModel

No es una estrategia de testing completa de UI, pero sí un guía de diseño confiable para futuras expansiones.

Síntesis

En PredictiveSearch, TDD no es un lujo ni un check de QA: es parte integral del diseño.
Cada test representa una decisión de arquitectura y una garantía de que el flujo de estado y concurrencia se mantiene predecible, seguro y razonable.
