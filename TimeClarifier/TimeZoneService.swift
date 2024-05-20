//
//  TimeZoneService.swift
//  TimeClarifier
//
//  Created by Main on 17/05/24.
//

import Foundation

public struct TimeZoneService {

    public lazy var allTimeZones: [TimeZone] = {
        return fetchUniqueAvailableTimeZoneAbbreviations().compactMap({ TimeZone(abbreviation: $0) })
    }()

    public let commonTimeZones = ["EST", "CST", "CDT", "MST", "PST", "GMT", "CET", "IST", "JST"]

    public let supportedDateFormatsForInput = [
        "ha z",        // "2PM CST"
        "h:mma z",     // "2:30PM CST"
        "h:mm a z",    // "2:30 PM CST"
        "h a z",       // "2 PM CST"
        "H z",         // "14 CST"
        "H:mm z",      // "14:30 CST"

    ]

    private let timeZoneAbbreviationsMap = ["CT": "CST", "PT": "PST", "MT": "MST", "ET": "EST"]

    public func fetchUniqueAvailableTimeZoneAbbreviations() -> [String] {
        var abbreviations = Set<String>()
        for identifier in TimeZone.knownTimeZoneIdentifiers {
            if let abbreviation = TimeZone(identifier: identifier)?.abbreviation() {
                abbreviations.insert(abbreviation)
            }
        }
        return Array(abbreviations).sorted(by: { $0 < $1 })
    }

    public func standardizeTimeZone(in input: String) -> String {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        return timeZoneAbbreviationsMap.reduce(trimmedInput) { result, mapEntry in
            result.replacingOccurrences(of: " \(mapEntry.key)", with: " \(mapEntry.value)")
        }
    }

    public func parseDate(from input: String) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        let standarizedInput = standardizeTimeZone(in: input)
        for format in supportedDateFormatsForInput {
            inputFormatter.dateFormat = format
            if let date = inputFormatter.date(from: standarizedInput) {
                return date
            }
        }
        return nil
    }

    public func parseTimeZoneAbbreviation(_ abbreviation: String) -> TimeZone? {
        return TimeZone(abbreviation: abbreviation)
    }

    public func formatDateForTimeZone(_ date: Date, timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }

    public func formatDateForAllTimeZones(_ date: Date) -> [String: String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        var convertedTimes: [String: String] = [:]
        for abbreviation in commonTimeZones {
            if let timeZone = TimeZone(abbreviation: abbreviation) {
                dateFormatter.timeZone = timeZone
                let formattedDate = dateFormatter.string(from: date)
                convertedTimes[abbreviation] = formattedDate
            }
        }
        return convertedTimes
    }
}
