import Foundation
import Testing
@testable import NSHealthAssignment

struct FHIRReportParserTests {

    @Test func parsesReportDetails() throws {
        let data = try Fixture.data(named: "diagnostic-report-bundle")
        let report = try #require(try FHIRReportParser().parse(data).first)

        #expect(report.name == "Complete Blood Count")
        #expect(report.performers == ["Acme Laboratory, Inc"])
        #expect(report.effectiveDate == ISO8601DateFormatter().date(from: "2011-03-04T08:30:00+11:00"))
        #expect(report.results.count == 17)
    }

    @Test func parsesResultValueUnitAndRange() throws {
        let data = try Fixture.data(named: "diagnostic-report-bundle")
        let report = try #require(try FHIRReportParser().parse(data).first)
        let haemoglobin = try #require(report.results.first)

        #expect(haemoglobin.name == "Haemoglobin")
        #expect(haemoglobin.value == 176)
        #expect(haemoglobin.unit == "g/L")
        #expect(haemoglobin.referenceRange == ReferenceRange(low: 135, high: 180, text: nil))
    }

    @Test func throwsDecodingErrorForMissingRequiredField() {
        let json = #"""
        {"resourceType": "Bundle", "type": "collection", "entry": [{"resource": {
          "resourceType": "DiagnosticReport", "status": "final"
        }}]}
        """#
        #expect(throws: NetworkError.decoding) {
            try FHIRReportParser().parse(Data(json.utf8))
        }
    }
}
