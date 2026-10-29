import SwiftUI

struct ReportDetailView: View {

    // MARK: - Properties

    let report: LabReport

    // MARK: - View

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                ReportHeaderCard(report: report)

                ResultSectionView(title: "report.section.bloodCount", rows: report.bloodCountRows, report: report)
                ResultSectionView(title: "report.section.differential", rows: report.differentialRows, report: report)
            }
            .padding()
        }
        .background(Theme.Colors.screenBackground)
        .navigationTitle(report.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ReportDetailView(report: .preview)
    }
}
