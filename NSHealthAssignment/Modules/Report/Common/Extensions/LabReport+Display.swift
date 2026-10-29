import SwiftUI

// MARK: - LabReport

extension LabReport {
    var displayName: String {
        name ?? String(localized: "report.unnamed")
    }

    var formattedDateTime: String? {
        effectiveDate?.formatted(dateStyle(time: .standard))
    }

    var formattedDate: String? {
        effectiveDate?.formatted(dateStyle(time: .omitted))
    }

    var formattedIssuedDateTime: String? {
        issuedDate?.formatted(dateStyle(time: .standard))
    }

    var categoryTitle: LocalizedStringKey? {
        switch categoryCode {
        case "HM": "report.category.hematology"
        case let code?: LocalizedStringKey(code)
        case nil: nil
        }
    }

    var statusTitle: LocalizedStringKey? {
        switch status {
        case "final": "report.status.final"
        case let status?: LocalizedStringKey(status.capitalized)
        case nil: nil
        }
    }

    private func dateStyle(time: Date.FormatStyle.TimeStyle) -> Date.FormatStyle {
        Date.FormatStyle(date: .long, time: time, timeZone: effectiveTimeZone ?? .current)
    }
}

// MARK: - LabResult

extension LabResult {
    var formattedResult: String {
        guard let value else { return "—" }
        return withUnit(value)
    }

    var formattedRange: String {
        guard let referenceRange else {
            return String(localized: "report.range.none")
        }
        switch (referenceRange.low, referenceRange.high) {
        case let (low?, high?):
            return "\(withUnit(low)) – \(withUnit(high))"
        case let (nil, high?):
            return String(localized: "report.range.upTo \(withUnit(high))")
        case let (low?, nil):
            return String(localized: "report.range.from \(withUnit(low))")
        case (nil, nil):
            return referenceRange.text ?? String(localized: "report.range.none")
        }
    }

    private func withUnit(_ number: Decimal) -> String {
        guard let unit else { return number.formatted() }
        return "\(number.formatted()) \(unit)"
    }
}

// MARK: - LabResult.Flag

extension LabResult.Flag {
    var title: LocalizedStringKey? {
        switch self {
        case .normal: "flag.normal"
        case .low: "flag.low"
        case .high: "flag.high"
        case .criticalLow: "flag.criticalLow"
        case .criticalHigh: "flag.criticalHigh"
        case .unknown: nil
        }
    }

    var color: Color {
        switch self {
        case .normal: Theme.Colors.normal
        case .low: Theme.Colors.low
        case .high: Theme.Colors.high
        case .criticalLow, .criticalHigh: Theme.Colors.critical
        case .unknown: .secondary
        }
    }

    var symbolName: String {
        switch self {
        case .normal: "checkmark.circle.fill"
        case .low, .criticalLow: "arrow.down.circle.fill"
        case .high, .criticalHigh: "arrow.up.circle.fill"
        case .unknown: "minus.circle"
        }
    }
}
