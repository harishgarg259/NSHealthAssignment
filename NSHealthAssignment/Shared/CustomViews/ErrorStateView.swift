import SwiftUI

struct ErrorStateView: View {

    // MARK: - Properties

    let error: NetworkError
    let retry: () -> Void

    // MARK: - View

    var body: some View {
        ContentUnavailableView {
            Label("error.title", systemImage: symbolName)
        } description: {
            Text(message)
        } actions: {
            Button("error.retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
    }

    // MARK: - Helpers

    private var message: LocalizedStringKey {
        switch error {
        case .offline: "error.offline"
        case .timedOut: "error.timedOut"
        case .notFound: "error.notFound"
        case .decoding: "error.unreadable"
        case .server, .unknown: "error.server"
        }
    }

    private var symbolName: String {
        switch error {
        case .offline: "wifi.slash"
        case .timedOut: "clock.arrow.circlepath"
        default: "exclamationmark.triangle"
        }
    }
}
