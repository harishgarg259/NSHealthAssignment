import Foundation
import Testing
@testable import NSHealthAssignment

@MainActor
struct LabReportsViewModelTests {

    @Test func loadsReports() async {
        let viewModel = LabReportsViewModel(service: StubReportService(result: .success([.sample])))
        await viewModel.load()
        #expect(viewModel.state == .loaded([.sample]))
        #expect(viewModel.latestReport == .sample)
    }

    @Test func showsErrorWhenLoadingFails() async {
        let viewModel = LabReportsViewModel(service: StubReportService(result: .failure(URLError(.notConnectedToInternet))))
        await viewModel.load()
        #expect(viewModel.state == .failed(.offline))
    }
}

// MARK: - Test Doubles

private struct StubReportService: ReportServiceProtocol {
    let result: Result<[LabReport], Error>

    func fetchReports() async throws -> [LabReport] {
        try result.get()
    }
}

private extension LabReport {
    static let sample = LabReport(
        id: "1",
        name: "CBC",
        categoryCode: nil,
        status: "final",
        performers: [],
        effectiveDate: nil,
        effectiveTimeZone: nil,
        issuedDate: nil,
        identifier: nil,
        results: []
    )
}
