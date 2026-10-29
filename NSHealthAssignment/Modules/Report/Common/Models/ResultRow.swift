import Foundation

nonisolated struct ResultRow: Identifiable, Hashable, Sendable {
    let result: LabResult
    let percentage: LabResult?
    var id: String { result.id }
}

nonisolated extension LabReport {

    // MARK: - Grouping

    var resultRows: [ResultRow] {
        var rows: [ResultRow] = []
        var pairedIDs: Set<String> = []

        for result in results where !pairedIDs.contains(result.id) {
            let partner = results.first {
                $0.id != result.id && $0.name == result.name && !pairedIDs.contains($0.id)
            }

            if let partner, (result.unit == "%") != (partner.unit == "%") {
                let (absolute, percentage) = result.unit == "%" ? (partner, result) : (result, partner)
                rows.append(ResultRow(result: absolute, percentage: percentage))
                pairedIDs.insert(partner.id)
            } else {
                rows.append(ResultRow(result: result, percentage: nil))
            }
        }
        return rows
    }

    var bloodCountRows: [ResultRow] {
        resultRows.filter { $0.percentage == nil }
    }

    var differentialRows: [ResultRow] {
        resultRows.filter { $0.percentage != nil }
    }

    // MARK: - Counts

    var normalResults: [LabResult] {
        results.filter { $0.flag == .normal }
    }
}
