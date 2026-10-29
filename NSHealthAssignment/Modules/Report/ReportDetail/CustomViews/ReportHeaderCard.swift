import SwiftUI

struct ReportHeaderCard: View {

    // MARK: - Properties

    let report: LabReport

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack(spacing: Theme.Spacing.small) {
                if let category = report.categoryTitle {
                    Tag(title: category, color: Theme.Colors.accent)
                }
                if let status = report.statusTitle {
                    Tag(title: status, color: .secondary)
                }
            }

            Text(report.displayName)
                .font(.title2.bold())

            Divider()

            InfoRow(title: "report.performer", value: report.performers.joined(separator: ", "))
            InfoRow(title: "report.collected", value: report.formattedDateTime)
            InfoRow(title: "report.issued", value: report.formattedIssuedDateTime)
            InfoRow(title: "report.number", value: report.identifier)
        }
        .cardStyle()
    }
}

// MARK: - InfoRow

private struct InfoRow: View {
    let title: LocalizedStringKey
    let value: String?

    var body: some View {
        if let value, !value.isEmpty {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
                    .multilineTextAlignment(.trailing)
            }
            .font(.subheadline)
            .accessibilityElement(children: .combine)
        }
    }
}

// MARK: - Tag

private struct Tag: View {
    let title: LocalizedStringKey
    let color: Color

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, Theme.Spacing.small)
            .padding(.vertical, Theme.Spacing.xSmall)
            .background(color.opacity(0.12), in: .capsule)
    }
}

// MARK: - Preview

#Preview {
    ReportHeaderCard(report: .preview)
        .padding()
        .background(Theme.Colors.screenBackground)
}
