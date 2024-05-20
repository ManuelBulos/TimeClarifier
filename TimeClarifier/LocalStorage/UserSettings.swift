//
//  UserSettings.swift
//  TimeClarifier
//
//  Created by Main on 17/05/24.
//

import SwiftUI

public protocol UserSettingsProtocol {
    var localTimeZoneAbbreviation: String { get set }
}

public class UserSettings: UserSettingsProtocol {
    @UserDefault(key: "localTimeZoneAbbreviation", defaultValue: TimeZone.current.abbreviation()!)
    public var localTimeZoneAbbreviation: String
}
