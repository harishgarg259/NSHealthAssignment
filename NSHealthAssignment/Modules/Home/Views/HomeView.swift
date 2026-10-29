import SwiftUI

struct HomeView: View {

    // MARK: - Properties

    @Environment(LabReportsViewModel.self) private var viewModel

    var onOpenReport: (LabReport) -> Void = { _ in }

    // MARK: - View

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                latestReportSection
            }
            .padding()
        }
        .background(Theme.Colors.screenBackground)
        .navigationTitle("home.title")
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    // MARK: - Sections

    private var latestReportSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            SectionHeader(title: "home.latestReport")

            switch viewModel.state {
            case .idle, .loading:
                ProgressView("common.loading")
                    .frame(maxWidth: .infinity)
                    .cardStyle()
            case .failed:
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("error.title")
                        .font(.headline)
                    Button("error.retry") {
                        Task { await viewModel.load() }
                    }
                }
                .cardStyle()
            case .loaded:
                if let report = viewModel.latestReport {
                    ReportSummaryCard(report: report) {
                        onOpenReport(report)
                    }
                } else {
                    Text("reports.empty")
                        .foregroundStyle(.secondary)
                        .cardStyle()
                }
            }
        }
    }
}

// MARK: - SectionHeader

private struct SectionHeader: View {
    let title: LocalizedStringKey

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(LabReportsViewModel(service: PreviewReportService()))
}
