import Foundation
import OSLog

nonisolated struct APIClient: APIClientProtocol {

    // MARK: - Properties

    private static let cache = URLCache(memoryCapacity: 5_000_000, diskCapacity: 20_000_000)

    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCache = cache
        return URLSession(configuration: configuration)
    }()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "NSHealth", category: "Network")

    // MARK: - APIClientProtocol

    func data(for endpoint: APIEndpoint) async throws -> Data {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/fhir+json", forHTTPHeaderField: "Accept")
        logger.info("Request: \(endpoint.method.rawValue, privacy: .public) \(endpoint.url, privacy: .public)")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await Self.session.data(for: request)
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch {
            let mapped = ErrorMapper.map(error)
            if endpoint.method == .get, mapped == .offline || mapped == .timedOut,
               let cached = Self.cache.cachedResponse(for: request) {
                logger.info("Request failed, using cached response")
                return cached.data
            }
            logger.error("Request failed: \(error.localizedDescription, privacy: .public)")
            throw mapped
        }

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        logger.info("Response: \(http.statusCode, privacy: .public), \(data.count, privacy: .public) bytes")
        #if DEBUG
        logger.debug("Response body: \(String(decoding: data.prefix(500), as: UTF8.self), privacy: .private)")
        #endif

        if let error = ErrorMapper.map(statusCode: http.statusCode) {
            throw error
        }
        return data
    }
}
