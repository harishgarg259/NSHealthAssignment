import SwiftUI

struct ResultDetailView: View {

    // MARK: - Properties

    let row: ResultRow
    let report: LabReport

    private var result: LabResult { row.result }

    // MARK: - View

    var body: some View {
        List {
            Section {
                HStack(alignment: .firstTextBaseline) {
                    Text(result.formattedResult)
                        .font(.largeTitle.bold())
                        .monospacedDigit()
                    Spacer()
                    FlagBadge(flag: result.flag)
                }
            }

            Section {
                LabeledContent("observation.result", value: result.formattedResult)
                if let percentage = row.percentage {
                    LabeledContent("detail.percentage", value: percentage.formattedResult)
                }
                LabeledContent("observation.normalRange", value: result.formattedRange)
            }

            Section("detail.aboutTest") {
                LabeledContent("detail.testName", value: result.detail ?? result.name)
                if let code = result.code {
                    LabeledContent("detail.loinc", value: code)
                }
                LabeledContent("report.performer", value: report.performers.joined(separator: ", "))
                if let date = report.formattedDateTime {
                    LabeledContent("report.collected", value: date)
                }
            }
        }
        .navigationTitle(result.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ResultDetailView(row: LabReport.preview.resultRows[0], report: .preview)
    }
}
