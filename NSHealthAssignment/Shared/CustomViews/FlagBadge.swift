import SwiftUI

struct FlagBadge: View {

    // MARK: - Properties

    let flag: LabResult.Flag

    // MARK: - View

    var body: some View {
        if let title = flag.title {
            Label(title, systemImage: flag.symbolName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(flag.color)
        }
    }
}
