import Foundation
import Testing
@testable import NSHealthAssignment

struct ResultRowTests {

    @Test func pairsPercentageWithAbsoluteCount() throws {
        let data = try Fixture.data(named: "diagnostic-report-bundle")
        let report = try #require(try FHIRReportParser().parse(data).first)

        #expect(report.resultRows.count == 12)

        let neutrophils = try #require(report.differentialRows.first)
        #expect(neutrophils.result.id == "r9")
        #expect(neutrophils.percentage?.id == "r8")
    }
}
