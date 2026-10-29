import SwiftUI

enum AppTab: Hashable {
    case home
    case report
}

struct RootTabView: View {

    // MARK: - Properties

    @State private var selectedTab: AppTab = .home
    @State private var reportPath: [ReportRoute] = []

    // MARK: - View

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("tab.home", systemImage: "house", value: .home) {
                NavigationStack {
                    HomeView(onOpenReport: openReport)
                }
            }

            Tab("tab.report", systemImage: "list.clipboard", value: .report) {
                NavigationStack(path: $reportPath) {
                    ReportListView()
                        .navigationDestination(for: ReportRoute.self) { route in
                            route.destination
                        }
                }
            }
        }
    }

    // MARK: - Navigation

    private func openReport(_ report: LabReport) {
        reportPath = [.report(report)]
        selectedTab = .report
    }
}

// MARK: - Preview

#Preview {
    RootTabView()
        .environment(LabReportsViewModel(service: PreviewReportService()))
}
