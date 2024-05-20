//
//  TimeZoneServiceTests.swift
//  TimeClarifierTests
//
//  Created by Main on 17/05/24.
//

import XCTest
@testable import TimeClarifier

final class TimeZoneServiceTests: XCTestCase {

    var timeZoneService: TimeZoneService!

    override func setUp() {
        super.setUp()
        timeZoneService = TimeZoneService()
    }

    override func tearDown() {
        timeZoneService = nil
        super.tearDown()
    }

    func testFetchUniqueAvailableTimeZoneAbbreviations() {
        let abbreviations = timeZoneService.fetchUniqueAvailableTimeZoneAbbreviations()
        XCTAssertFalse(abbreviations.isEmpty, "Abbreviations should not be empty")
    }

    func testStandardizeTimeZone() {
        XCTAssertEqual(timeZoneService.standardizeTimeZone(in: "2PM CT"), "2PM CST")
        XCTAssertEqual(timeZoneService.standardizeTimeZone(in: "14 PT"), "14 PST")
        XCTAssertEqual(timeZoneService.standardizeTimeZone(in: "3 AM MT"), "3 AM MST")
    }

    func testParseDate() {
        XCTAssertNotNil(timeZoneService.parseDate(from: "2PM CST"))
        XCTAssertNotNil(timeZoneService.parseDate(from: "2:30PM CST"))
        XCTAssertNotNil(timeZoneService.parseDate(from: "2:30 PM CST"))
        XCTAssertNotNil(timeZoneService.parseDate(from: "2 PM CST"))
        XCTAssertNotNil(timeZoneService.parseDate(from: "14 CST"))
        XCTAssertNotNil(timeZoneService.parseDate(from: "14:30 CST"))
        XCTAssertNil(timeZoneService.parseDate(from: "Invalid date"))
    }

    func testParseTimeZoneAbbreviation() {
        XCTAssertEqual(timeZoneService.parseTimeZoneAbbreviation("CST"), TimeZone(abbreviation: "CST"))
        XCTAssertEqual(timeZoneService.parseTimeZoneAbbreviation("PST"), TimeZone(abbreviation: "PST"))
        XCTAssertNil(timeZoneService.parseTimeZoneAbbreviation("INVALID"))
    }

    func testFormatDateForTimeZone() {
        let date = Date(timeIntervalSince1970: 0)
        let timeZone = TimeZone(abbreviation: "CST")!
        let formattedDate = timeZoneService.formatDateForTimeZone(date, timeZone: timeZone)
        XCTAssertEqual(formattedDate, "6:00 PM")
    }

    func testFormatDateForAllTimeZones() {
        let date = Date(timeIntervalSince1970: 0)
        let formattedDates = timeZoneService.formatDateForAllTimeZones(date)
        XCTAssertEqual(formattedDates["CST"], "6:00 PM")
        XCTAssertEqual(formattedDates["PST"], "4:00 PM")
        XCTAssertEqual(formattedDates["GMT"], "12:00 AM")
    }

    func testAllTimeZones() {
        let allTimeZones = timeZoneService.allTimeZones
        XCTAssertFalse(allTimeZones.isEmpty, "AllTimeZones should not be empty")
    }

    func testCommonTimeZones() {
        let commonTimeZones = timeZoneService.commonTimeZones
        XCTAssertEqual(commonTimeZones, ["EST", "CST", "CDT", "MST", "PST", "GMT", "CET", "IST", "JST"])
    }

    func testSupportedDateFormatsForInput() {
        let supportedDateFormatsForInput = timeZoneService.supportedDateFormatsForInput
        XCTAssertEqual(supportedDateFormatsForInput, [
            "ha z",
            "h:mma z",
            "h:mm a z",
            "h a z",
            "H z",
            "H:mm z"
        ])
    }
}
