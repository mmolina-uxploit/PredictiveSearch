import Foundation

// Contrato que define la frontera entre el Dominio y la Infraestructura
// El método es 'async throws' para operar en un entorno de concurrencia
public protocol MediaRepositoryProtocol {
    /// Busca items de media basados en un término de búsqueda.
    /// - Throws: Si la búsqueda falla. La implementación debe gestionar la cancelación.
    func search(for term: String) async throws -> [MediaItem]
}
