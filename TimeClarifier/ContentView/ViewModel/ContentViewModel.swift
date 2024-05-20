import SwiftUI
import Combine

public class ContentViewModel: ObservableObject {

    @Published public var state: ContentViewState

    private let timeZoneService: TimeZoneService
    private var userSettings: UserSettingsProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(userSettings: UserSettingsProtocol) {
        self.state = ContentViewState(localTimeZoneAbbreviation: userSettings.localTimeZoneAbbreviation)
        self.userSettings = userSettings
        self.timeZoneService = TimeZoneService()
        self.setupObservers()
    }

    private func setupObservers() {
        state.$inputTime
            .combineLatest(state.$inputLocalTimeZoneAbbreviation)
            .receive(on: RunLoop.main)
            .sink { [weak self] inputTime, inputLocalTimeZoneAbbreviation in
                guard let self = self else { return }
                self.handleInputTimeChange(inputTime, inputLocalTimeZoneAbbreviation: inputLocalTimeZoneAbbreviation)
            }
            .store(in: &cancellables)

        state.$inputLocalTimeZoneAbbreviation
            .combineLatest(state.$inputTime)
            .receive(on: RunLoop.main)
            .sink { [weak self] inputLocalTimeZoneAbbreviation, inputTime in
                guard let self = self else { return }
                self.handleInputLocalTimeZoneAbbreviationChange(inputLocalTimeZoneAbbreviation, inputTime: inputTime)
            }
            .store(in: &cancellables)
    }

    public func handleInputTimeChange(_ inputTime: String, inputLocalTimeZoneAbbreviation: String) {
        updateLocalTime(inputTime: inputTime, inputLocalTimeZoneAbbreviation: inputLocalTimeZoneAbbreviation)
        updateAllTimeZonesAndTimes(inputTime: inputTime)
    }

    public func handleInputLocalTimeZoneAbbreviationChange(_ inputLocalTimeZoneAbbreviation: String, inputTime: String) {
        updateUserSettings(inputLocalTimeZoneAbbreviation: inputLocalTimeZoneAbbreviation)
        updateLocalTime(inputTime: inputTime, inputLocalTimeZoneAbbreviation: inputLocalTimeZoneAbbreviation)
    }

    public func updateLocalTime(inputTime: String, inputLocalTimeZoneAbbreviation: String) {
        guard let date = timeZoneService.parseDate(from: inputTime), let inputLocalTimeZone = TimeZone(abbreviation: inputLocalTimeZoneAbbreviation) else {
            state.localTime = ""
            return
        }

        state.localTime = timeZoneService.formatDateForTimeZone(date, timeZone: inputLocalTimeZone)
    }

    public func updateAllTimeZonesAndTimes(inputTime: String) {
        guard let date = timeZoneService.parseDate(from: inputTime) else {
            state.allTimeZonesAndTimes = [:]
            return
        }

        state.allTimeZonesAndTimes = timeZoneService.formatDateForAllTimeZones(date)
    }

    public func updateUserSettings(inputLocalTimeZoneAbbreviation: String) {
        userSettings.localTimeZoneAbbreviation = inputLocalTimeZoneAbbreviation
    }
}
