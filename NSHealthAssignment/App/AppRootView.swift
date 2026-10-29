import SwiftUI

struct AppRootView: View {

    // MARK: - Properties

    @State private var showsSplash = true

    // MARK: - View

    var body: some View {
        if showsSplash {
            SplashView()
                .task {
                    try? await Task.sleep(for: .seconds(1))
                    showsSplash = false
                }
        } else {
            RootTabView()
        }
    }
}

// MARK: - Preview

#Preview {
    AppRootView()
        .environment(LabReportsViewModel(service: PreviewReportService()))
}
