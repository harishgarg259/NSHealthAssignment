import Foundation

nonisolated struct ReportService: ReportServiceProtocol {

    // MARK: - Properties

    private let client: any APIClientProtocol
    private let parser = FHIRReportParser()

    // MARK: - Init

    init(client: any APIClientProtocol = APIClient()) {
        self.client = client
    }

    // MARK: - ReportServiceProtocol

    func fetchReports() async throws -> [LabReport] {
        let data = try await client.data(for: .diagnosticReports)
        return try await parse(data)
    }

    // MARK: - Parsing

    @concurrent
    private func parse(_ data: Data) async throws -> [LabReport] {
        try parser.parse(data)
    }
}
