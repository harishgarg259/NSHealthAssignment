import Foundation

nonisolated enum ErrorMapper {

    static func map(_ error: any Error) -> NetworkError {
        if let error = error as? NetworkError {
            return error
        }
        switch (error as? URLError)?.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed: return .offline
        case .timedOut: return .timedOut
        default: return .unknown
        }
    }

    static func map(statusCode: Int) -> NetworkError? {
        switch statusCode {
        case 200..<300: nil
        case 404: .notFound
        default: .server(statusCode: statusCode)
        }
    }
}

nonisolated enum NetworkError: Error, Equatable {
    case offline
    case timedOut
    case notFound
    case server(statusCode: Int)
    case decoding
    case unknown
}
