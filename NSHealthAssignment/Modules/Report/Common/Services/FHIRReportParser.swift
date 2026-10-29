import FMCore
import Foundation
import ModelsR4

nonisolated struct FHIRReportParser {

    // MARK: - Parsing

    func parse(_ data: Data) throws -> [LabReport] {
        let bundle: ModelsR4.Bundle
        do {
            bundle = try JSONDecoder().decode(ModelsR4.Bundle.self, from: data)
        } catch let error where error is DecodingError
                                || error is FHIRDateParserError
                                || error is FHIRPositiveIntegerError
                                || error is FHIRUnsignedIntegerError {
            throw NetworkError.decoding
        }

        var diagnosticReports: [DiagnosticReport] = []
        var observationsByID: [String: Observation] = [:]

        for entry in bundle.entry ?? [] {
            switch entry.resource {
            case .diagnosticReport(let report)?:
                diagnosticReports.append(report)
            case .observation(let observation)?:
                if let id = observation.id?.stringValue {
                    observationsByID[id] = observation
                }
            default:
                break
            }
        }

        return diagnosticReports
            .map { makeReport(from: $0, observationsByID: observationsByID) }
            .sorted { ($0.effectiveDate ?? .distantPast) > ($1.effectiveDate ?? .distantPast) }
    }

    // MARK: - Mapping

    private func makeReport(from report: DiagnosticReport, observationsByID: [String: Observation]) -> LabReport {
        let results = (report.result ?? []).compactMap { reference -> LabResult? in
            guard let id = reference.reference?.stringValue?.split(separator: "/").last.map(String.init),
                  let observation = observationsByID[id] else { return nil }
            return makeResult(from: observation, id: id)
        }

        var effective: DateTime?
        if case .dateTime(let dateTime)? = report.effective {
            effective = dateTime.value
        }

        return LabReport(
            id: report.id?.stringValue ?? UUID().uuidString,
            name: report.code.text?.stringValue ?? report.code.coding?.first?.display?.stringValue,
            categoryCode: report.category?.first?.coding?.first?.code?.stringValue,
            status: report.status.value?.rawValue,
            performers: (report.performer ?? []).compactMap { $0.display?.stringValue },
            effectiveDate: try? effective?.asNSDate(),
            effectiveTimeZone: effective?.timeZone,
            issuedDate: try? report.issued?.value?.asNSDate(),
            identifier: report.identifier?.first?.value?.stringValue,
            results: results
        )
    }

    private func makeResult(from observation: Observation, id: String) -> LabResult {
        var quantity: Quantity?
        if case .quantity(let value)? = observation.value {
            quantity = value
        }

        let codedName = observation.code.coding?.first?.display?.stringValue
        let name = observation.code.text?.stringValue ?? codedName ?? id
        let value = quantity?.value?.value?.decimal
        let range = observation.referenceRange?.first.map {
            ReferenceRange(
                low: $0.low?.value?.value?.decimal,
                high: $0.high?.value?.value?.decimal,
                text: $0.text?.stringValue
            )
        }
        let interpretation = observation.interpretation?.first?.coding?.first?.code?.stringValue

        return LabResult(
            id: id,
            name: name,
            detail: codedName == name ? nil : codedName,
            code: observation.code.coding?.first?.code?.stringValue,
            value: value,
            unit: quantity?.unit?.stringValue,
            referenceRange: range,
            flag: LabResult.Flag(interpretationCode: interpretation, value: value, range: range)
        )
    }
}

// MARK: - FHIR Helpers

nonisolated private extension FHIRPrimitive where PrimitiveType == FHIRString {
    var stringValue: String? { value?.string }
}
