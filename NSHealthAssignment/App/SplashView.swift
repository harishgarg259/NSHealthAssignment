import SwiftUI

struct SplashView: View {

    // MARK: - View

    var body: some View {
        ZStack {
            Theme.Colors.splashBackground
                .ignoresSafeArea()

            Image(.splashLogo)
                .resizable()
                .frame(width: 120, height: 120)
                .accessibilityLabel(Text(verbatim: "NSHealth"))
        }
    }
}

// MARK: - Preview

#Preview {
    SplashView()
}
