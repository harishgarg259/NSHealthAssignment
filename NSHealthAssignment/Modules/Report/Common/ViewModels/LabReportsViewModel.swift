import Foundation
import Observation

@Observable
final class LabReportsViewModel {

    // MARK: - Types

    enum State: Equatable {
        case idle
        case loading
        case loaded([LabReport])
        case failed(NetworkError)
    }

    // MARK: - Properties

    private(set) var state: State = .idle

    private let service: any ReportServiceProtocol

    // MARK: - Init

    init(service: any ReportServiceProtocol) {
        self.service = service
    }

    // MARK: - Derived State

    var reports: [LabReport] {
        if case .loaded(let reports) = state { reports } else { [] }
    }

    var latestReport: LabReport? {
        reports.first
    }

    // MARK: - Loading

    func loadIfNeeded() async {
        guard state == .idle else { return }
        await load()
    }

    func load() async {
        if case .loaded = state {} else {
            state = .loading
        }

        do {
            state = .loaded(try await service.fetchReports())
        } catch is CancellationError {
            resetIfStillLoading()
        } catch {
            state = .failed(ErrorMapper.map(error))
        }
    }

    // MARK: - Private Helpers

    private func resetIfStillLoading() {
        if state == .loading {
            state = .idle
        }
    }
}

