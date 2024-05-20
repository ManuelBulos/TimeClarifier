//
//  ContentViewState.swift
//  TimeClarifier
//
//  Created by Main on 17/05/24.
//

import SwiftUI

public class ContentViewState: ObservableObject {
    @Published public var inputTime: String = ""
    @Published public var inputLocalTimeZoneAbbreviation: String

    @Published public var localTime: String = ""
    @Published public var allTimeZonesAndTimes: [String: String] = [:]

    public init(localTimeZoneAbbreviation: String) {
        self.inputLocalTimeZoneAbbreviation = localTimeZoneAbbreviation
    }
}
