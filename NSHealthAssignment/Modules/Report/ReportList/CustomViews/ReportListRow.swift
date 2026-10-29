import SwiftUI

struct ReportListRow: View {

    // MARK: - Properties

    let report: LabReport

    // MARK: - View

    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                HStack(spacing: Theme.Spacing.xSmall) {
                    if let category = report.categoryTitle {
                        Text(category)
                    }
                    if let status = report.statusTitle {
                        Text(verbatim: "·")
                        Text(status)
                    }
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.Colors.accent)

                Text(report.displayName)
                    .font(.headline)

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

                outOfRangeSummary
                    .font(.caption.weight(.semibold))
                    .padding(.top, Theme.Spacing.xSmall)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .cardStyle()
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var outOfRangeSummary: some View {
        let count = report.outOfRangeResults.count
        if count == 0 {
            Label("reports.allNormal", systemImage: "checkmark.circle.fill")
                .foregroundStyle(Theme.Colors.normal)
        } else {
            Label("reports.outOfRange \(count)", systemImage: "exclamationmark.circle.fill")
                .foregroundStyle(Theme.Colors.high)
        }
    }
}

// MARK: - Preview

#Preview {
    ReportListRow(report: .preview)
        .padding()
        .background(Theme.Colors.screenBackground)
}
