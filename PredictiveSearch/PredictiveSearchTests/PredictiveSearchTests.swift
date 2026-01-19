//
//  PredictiveSearchTests.swift
//  PredictiveSearchTests
//
//  Created by m47145 on 16/01/2026.
//

import XCTest
@testable import PredictiveSearch

// MARK: - Mocks y Fakes (Herramientas de Aislamiento para TDD)

/// Un `Actor` que registra las intenciones de búsqueda y su estado de cancelación.
/// Funciona como un sensor para validar el comportamiento de cancelación cooperativa.
actor MockSearchRepository: MediaRepositoryProtocol {
    
    private var searchIntents: [String: Bool] = [:]
    private let searchDelay: Duration
    
    init(searchDelay: Duration = .milliseconds(100)) {
        self.searchDelay = searchDelay
    }

    func search(for term: String) async throws -> [MediaItem] {
        // Registra la intención de búsqueda
        searchIntents[term] = false
        
        do {
            try await Task.sleep(for: searchDelay)
        } catch {
            // Si el `Task.sleep` es cancelado, marca la intención como cancelada
            searchIntents[term] = true
            throw CancellationError()
        }
        
        // Si la tarea no fue cancelada, retorna un resultado de ejemplo.
        return [MediaItem(id: 1, title: "Result for \(term)", artist: "Artist", artworkURL: URL(string: "https://example.com")!, kind: "song")]
    }
    
    /// Método de espionaje para verificar el estado de una intención de búsqueda.
    func wasCancelled(for term: String) -> Bool {
        return searchIntents[term] ?? false
    }
}

final class PredictiveSearchTests: XCTestCase {

    var mockRepository: MockSearchRepository!
    var viewModel: MediaSearchViewModel!

    @MainActor override func setUp() {
        super.setUp()
        // Given: Un repositorio mock con un retardo para simular la red.
        mockRepository = MockSearchRepository(searchDelay: .milliseconds(20))
        viewModel = MediaSearchViewModel(repository: mockRepository)
    }

    // TDD - FASE RED
    // Este test DEBE fallar inicialmente.
    // Valida que una nueva búsqueda (Intención B) cancela la búsqueda anterior (Intención A).
    func test_SearchIntent_WhenNewSearchIsTriggered_PreviousSearchIsCooperativelyCancelled() async {
        
        // When: Se inician dos búsquedas consecutivas sin espera.
        await viewModel.searchTermChanged(to: "Intención A")
        await viewModel.searchTermChanged(to: "Intención B")
        
        // Se espera un tiempo suficiente para que la segunda búsqueda finalice.
        try? await Task.sleep(for: .milliseconds(50))
        
        // Then: La primera búsqueda ("Intención A") debe haber sido cancelada.
        // La lógica de cancelación aún no está implementada correctamente en el ViewModel, por lo que este assert fallará, cumpliendo la fase RED de TDD.
        let wasFirstSearchCancelled = await mockRepository.wasCancelled(for: "Intención A")
        
        XCTAssertTrue(wasFirstSearchCancelled, "El ViewModel no canceló la tarea de búsqueda anterior, violando la Teoría 05.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
