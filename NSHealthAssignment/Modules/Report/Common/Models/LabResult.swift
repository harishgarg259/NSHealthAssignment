import Foundation

nonisolated struct LabResult: Identifiable, Hashable, Sendable {

    // MARK: - Properties

    let id: String
    let name: String
    let detail: String?
    let code: String?
    let value: Decimal?
    let unit: String?
    let referenceRange: ReferenceRange?
    let flag: Flag

    // MARK: - Flag

    enum Flag: String, Hashable, Sendable {
        case normal = "N"
        case low = "L"
        case high = "H"
        case criticalLow = "LL"
        case criticalHigh = "HH"
        case unknown

        init(interpretationCode: String?, value: Decimal?, range: ReferenceRange?) {
            if let code = interpretationCode?.uppercased(), let flag = Flag(rawValue: code) {
                self = flag
            } else if let value, let low = range?.low, value < low {
                self = .low
            } else if let value, let high = range?.high, value > high {
                self = .high
            } else if value != nil, range?.low != nil || range?.high != nil {
                self = .normal
            } else {
                self = .unknown
            }
        }

        var isOutOfRange: Bool {
            self != .normal && self != .unknown
        }
    }
}

// MARK: - ReferenceRange

nonisolated struct ReferenceRange: Hashable, Sendable {
    let low: Decimal?
    let high: Decimal?
    let text: String?
}
