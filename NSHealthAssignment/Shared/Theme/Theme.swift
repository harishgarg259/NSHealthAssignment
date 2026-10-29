import SwiftUI

enum Theme {

    // MARK: - Colors

    enum Colors {
        static let accent = Color(.accent)
        static let screenBackground = Color(.screenBackground)
        static let cardBackground = Color(.cardBackground)
        static let normal = Color(.statusNormal)
        static let low = Color(.statusLow)
        static let high = Color(.statusHigh)
        static let critical = Color(.statusCritical)
        static let splashBackground = Color(.splashBackground)
    }

    // MARK: - Spacing

    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
    }
}

// MARK: - Card Style

extension View {
    func cardStyle() -> some View {
        padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.Colors.cardBackground, in: .rect(cornerRadius: 16))
    }
}
