import Foundation

nonisolated enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

nonisolated enum APIEndpoint {
    case diagnosticReports

    static let baseURL = URL(string: "https://build.fhir.org")!

    var path: String {
        switch self {
        case .diagnosticReports: "diagnosticreport-example.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .diagnosticReports: .get
        }
    }

    var url: URL {
        Self.baseURL.appending(path: path)
    }
}
