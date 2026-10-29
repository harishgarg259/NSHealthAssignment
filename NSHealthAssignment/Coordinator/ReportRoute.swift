import SwiftUI

enum ReportRoute: Hashable {
    case report(LabReport)
    case result(ResultRow, report: LabReport)

    // MARK: - Destination

    @ViewBuilder
    var destination: some View {
        switch self {
        case .report(let report):
            ReportDetailView(report: report)
        case .result(let row, let report):
            ResultDetailView(row: row, report: report)
        }
    }
}
