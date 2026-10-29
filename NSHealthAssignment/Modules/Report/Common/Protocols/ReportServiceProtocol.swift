import Foundation

nonisolated protocol ReportServiceProtocol: Sendable {
    func fetchReports() async throws -> [LabReport]
}
