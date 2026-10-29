import Foundation

// MARK: - Sample Report

extension LabReport {
    nonisolated static let preview = LabReport(
        id: "101",
        name: "Complete Blood Count",
        categoryCode: "HM",
        status: "final",
        performers: ["Acme Laboratory, Inc"],
        effectiveDate: Date(timeIntervalSince1970: 1_299_187_800),
        effectiveTimeZone: TimeZone(secondsFromGMT: 11 * 3600),
        issuedDate: Date(timeIntervalSince1970: 1_299_199_533),
        identifier: "5234342",
        results: [
            LabResult(
                id: "r1", name: "Haemoglobin", detail: "Hemoglobin [Mass/volume] in Blood", code: nil,
                value: 176, unit: "g/L",
                referenceRange: ReferenceRange(low: 135, high: 180, text: nil), flag: .normal
            ),
            LabResult(
                id: "r3", name: "Haematocrit", detail: "Hematocrit [Volume Fraction] of Blood by Automated count", code: nil,
                value: 55, unit: "%",
                referenceRange: ReferenceRange(low: 38, high: 52, text: nil), flag: .high
            ),
            LabResult(
                id: "r9", name: "Neutrophils", detail: "Neutrophils [#/volume] in Blood by Automated count", code: nil,
                value: 0.9, unit: "x10*9/L",
                referenceRange: ReferenceRange(low: 2, high: 7.5, text: nil), flag: .criticalLow
            ),
            LabResult(
                id: "r8", name: "Neutrophils", detail: "Neutrophils/Leukocytes in Blood by Automated count", code: nil,
                value: 20, unit: "%", referenceRange: nil, flag: .unknown
            )
        ]
    )
}

// MARK: - Preview Service

nonisolated struct PreviewReportService: ReportServiceProtocol {
    func fetchReports() async throws -> [LabReport] {
        [.preview]
    }
}
