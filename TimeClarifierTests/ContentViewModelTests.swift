import XCTest
import Combine
@testable import TimeClarifier

class ContentViewModelTests: XCTestCase {

    var contentViewModel: ContentViewModel!
    fileprivate var mockUserSettings: MockUserSettings!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUserSettings = MockUserSettings()
        contentViewModel = ContentViewModel(userSettings: mockUserSettings)
        cancellables = []
    }

    override func tearDown() {
        contentViewModel = nil
        mockUserSettings = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(contentViewModel.state.inputTime, "")
        XCTAssertEqual(contentViewModel.state.inputLocalTimeZoneAbbreviation, "CST")
        XCTAssertEqual(contentViewModel.state.localTime, "")
        XCTAssertTrue(contentViewModel.state.allTimeZonesAndTimes.isEmpty)
    }

    func testUpdateStateWithValidInput() {
        contentViewModel.updateLocalTime(inputTime: "2PM CST", inputLocalTimeZoneAbbreviation: "CST")
        contentViewModel.updateAllTimeZonesAndTimes(inputTime: "2PM CST")

        XCTAssertEqual(contentViewModel.state.localTime, "2:00 PM")
        XCTAssertFalse(contentViewModel.state.allTimeZonesAndTimes.isEmpty)
        XCTAssertEqual(contentViewModel.state.allTimeZonesAndTimes["CST"], "2:00 PM")
    }

    func testUpdateStateWithInvalidInput() {
        contentViewModel.updateLocalTime(inputTime: "Invalid Time", inputLocalTimeZoneAbbreviation: "CST")
        contentViewModel.updateAllTimeZonesAndTimes(inputTime: "Invalid Time")

        XCTAssertEqual(contentViewModel.state.localTime, "")
        XCTAssertTrue(contentViewModel.state.allTimeZonesAndTimes.isEmpty)
    }

    func testUpdateUserSettings() {
        contentViewModel.updateUserSettings(inputLocalTimeZoneAbbreviation: "PST")
        XCTAssertEqual(mockUserSettings.localTimeZoneAbbreviation, "PST")
    }

    func testUpdateLocalTimeWithDifferentTimeZones() {
        contentViewModel.updateLocalTime(inputTime: "2PM CST", inputLocalTimeZoneAbbreviation: "CST")
        XCTAssertEqual(contentViewModel.state.localTime, "2:00 PM")

        contentViewModel.updateLocalTime(inputTime: "2PM PST", inputLocalTimeZoneAbbreviation: "PST")
        XCTAssertEqual(contentViewModel.state.localTime, "2:00 PM")
    }

    func testUpdateAllTimeZonesAndTimesWithEdgeCaseTimes() {
        contentViewModel.updateAllTimeZonesAndTimes(inputTime: "12AM CST")
        XCTAssertEqual(contentViewModel.state.allTimeZonesAndTimes["CST"], "12:00 AM")

        contentViewModel.updateAllTimeZonesAndTimes(inputTime: "12PM CST")
        XCTAssertEqual(contentViewModel.state.allTimeZonesAndTimes["CST"], "12:00 PM")
    }

    func testHandleInputLocalTimeZoneAbbreviationChange() {
        contentViewModel.handleInputLocalTimeZoneAbbreviationChange("PST", inputTime: "2PM CST")
        XCTAssertEqual(contentViewModel.state.localTime, "12:00 PM")
        XCTAssertEqual(mockUserSettings.localTimeZoneAbbreviation, "PST")
    }

    func testInputLocalTimeZoneAbbreviationObserverUpdatesState() {
        let expectation = XCTestExpectation(description: "State should be updated when inputLocalTimeZoneAbbreviation changes")

        contentViewModel.state.inputTime = "2PM CST"

        contentViewModel.state.$localTime
            .dropFirst()  // Skip the initial value
            .sink { localTime in
                if localTime == "2:00 PM" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        contentViewModel.state.inputLocalTimeZoneAbbreviation = "CST"

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(contentViewModel.state.localTime, "2:00 PM")
        XCTAssertFalse(contentViewModel.state.allTimeZonesAndTimes.isEmpty)
        XCTAssertEqual(contentViewModel.state.allTimeZonesAndTimes["CST"], "2:00 PM")
    }

    func testInputTimeObserverUpdatesState() {
        let expectation = XCTestExpectation(description: "State should be updated when inputTime changes")

        contentViewModel.state.$localTime
            .dropFirst()  // Skip the initial value
            .sink { localTime in
                if localTime == "2:00 PM" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        contentViewModel.state.inputTime = "2PM CST"

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(contentViewModel.state.localTime, "2:00 PM")
        XCTAssertFalse(contentViewModel.state.allTimeZonesAndTimes.isEmpty)
        XCTAssertEqual(contentViewModel.state.allTimeZonesAndTimes["CST"], "2:00 PM")
    }
}

fileprivate class MockUserSettings: UserSettingsProtocol {
    var localTimeZoneAbbreviation: String = "CST"
}
