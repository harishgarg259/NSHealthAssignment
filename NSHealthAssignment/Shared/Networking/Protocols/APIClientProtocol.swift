import Foundation

nonisolated protocol APIClientProtocol: Sendable {
    func data(for endpoint: APIEndpoint) async throws -> Data
}
