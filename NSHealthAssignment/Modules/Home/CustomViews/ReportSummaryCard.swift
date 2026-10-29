import SwiftUI

struct ReportSummaryCard: View {

    // MARK: - Properties

    let report: LabReport
    let onOpenReport: () -> Void

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                Text(report.displayName)
                    .font(.title3.bold())
                if let date = report.formattedDate {
                    Text(date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let performer = report.performers.first {
                    Text(performer)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            HStack {
                StatView(value: report.results.count, title: "home.stat.tests", color: .primary)
                StatView(value: report.outOfRangeResults.count, title: "home.stat.outOfRange", color: Theme.Colors.high)
                StatView(value: report.normalResults.count, title: "home.stat.normal", color: Theme.Colors.normal)
            }

            Button(action: onOpenReport) {
                Text("home.openReport")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .cardStyle()
    }
}

// MARK: - StatView

private struct StatView: View {
    let value: Int
    let title: LocalizedStringKey
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value, format: .number)
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}


// MARK: - Preview

#Preview {
    ReportSummaryCard(report: .preview, onOpenReport: {})
        .padding()
        .background(Theme.Colors.screenBackground)
}
