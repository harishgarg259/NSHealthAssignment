import Foundation

nonisolated struct LabReport: Identifiable, Hashable, Sendable {

    // MARK: - Properties

    let id: String
    let name: String?
    let categoryCode: String?
    let status: String?
    let performers: [String]
    let effectiveDate: Date?
    let effectiveTimeZone: TimeZone?
    let issuedDate: Date?
    let identifier: String?
    let results: [LabResult]

    // MARK: - Derived Values

    var outOfRangeResults: [LabResult] {
        results.filter { $0.flag.isOutOfRange }
    }
}
