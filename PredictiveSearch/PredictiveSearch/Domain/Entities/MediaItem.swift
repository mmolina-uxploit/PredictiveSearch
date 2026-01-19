import Foundation

// Contrato de Datos
// El tipo es Sendable para garantizar su seguridad en contextos de concurrencia 
public struct MediaItem: Identifiable, Equatable, Sendable, Decodable {
    public let id: Int
    public let title: String
    public let artist: String
    public let artworkURL: URL
    public let kind: String

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case title = "trackName"
        case artist = "artistName"
        case artworkURL = "artworkUrl100"
        case kind
    }
}
