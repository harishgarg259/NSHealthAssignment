import SwiftUI

struct ResultSectionView: View {

    // MARK: - Properties

    let title: LocalizedStringKey
    let rows: [ResultRow]
    let report: LabReport

    // MARK: - View

    var body: some View {
        if !rows.isEmpty {
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text(title)
                    .font(.title3.bold())

                VStack(spacing: 0) {
                    ForEach(rows) { row in
                        NavigationLink(value: ReportRoute.result(row, report: report)) {
                            ResultRowView(row: row)
                        }
                        .buttonStyle(.plain)

                        if row.id != rows.last?.id {
                            Divider()
                        }
                    }
                }
                .cardStyle()
            }
        }
    }
}

// MARK: - ResultRowView

private struct ResultRowView: View {
    let row: ResultRow

    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                Text(row.result.name)
                    .font(.headline)
                Text("report.rangeLine \(row.result.formattedRange)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: Theme.Spacing.xSmall) {
                Text(row.result.formattedResult)
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                if let percentage = row.percentage {
                    Text(percentage.formattedResult)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                FlagBadge(flag: row.result.flag)
            }

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, Theme.Spacing.small)
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ResultSectionView(title: "report.section.bloodCount", rows: LabReport.preview.resultRows, report: .preview)
            .padding()
    }
}
