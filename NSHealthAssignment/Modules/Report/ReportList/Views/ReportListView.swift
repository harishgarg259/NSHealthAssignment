import SwiftUI

struct ReportListView: View {

    // MARK: - Properties

    @Environment(LabReportsViewModel.self) private var viewModel

    // MARK: - View

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.Colors.screenBackground)
            .navigationTitle("reports.title")
            .task {
                await viewModel.loadIfNeeded()
            }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("common.loading")
        case .failed(let error):
            ErrorStateView(error: error) {
                Task { await viewModel.load() }
            }
        case .loaded(let reports) where reports.isEmpty:
            ContentUnavailableView("reports.empty", systemImage: "doc.text.magnifyingglass")
        case .loaded(let reports):
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.medium) {
                    ForEach(reports) { report in
                        NavigationLink(value: ReportRoute.report(report)) {
                            ReportListRow(report: report)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .refreshable {
                await viewModel.load()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ReportListView()
            .navigationDestination(for: ReportRoute.self) { $0.destination }
    }
    .environment(LabReportsViewModel(service: PreviewReportService()))
}
