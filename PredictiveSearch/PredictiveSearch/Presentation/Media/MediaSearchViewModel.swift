//
//  MediaSearchViewModel.swift
//  PredictiveSearch
//
//  Created by m47145 on 17/01/2026.
//

import Foundation

@MainActor
final class MediaSearchViewModel: ObservableObject {
    @Published private(set) var results: [MediaItem] = []
    
    private let repository: MediaRepositoryProtocol
    private var searchTask: Task<Void, Never>?

    init(repository: MediaRepositoryProtocol) {
        self.repository = repository
    }

    func searchTermChanged(to newTerm: String) {
        // Principio de Intención y Cancelación
        // Cada nueva búsqueda debe cancelar la anterior para evitar resultados obsoletos.
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                let items = try await repository.search(for: newTerm)
                // Solo actualiza si la tarea no ha sido cancelada
                if !Task.isCancelled {
                    self.results = items
                }
            } catch is CancellationError {
                // La cancelación es un flujo de control esperado, no un error.
            } catch {
                // Manejo de otros errores (fuera del alcance de este test).
            }
        }
    }
}

