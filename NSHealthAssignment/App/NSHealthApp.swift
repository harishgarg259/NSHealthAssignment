import SwiftUI

@main
struct NSHealthApp: App {

    // MARK: - Properties

    @State private var reportsViewModel = LabReportsViewModel(service: ReportService())

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(reportsViewModel)
        }
    }
}
