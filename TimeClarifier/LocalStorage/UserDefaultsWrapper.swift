//
//  UserDefaultsWrapper.swift
//  TimeClarifier
//
//  Created by Main on 17/05/24.
//

import SwiftUI

@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    public let defaultValue: T

    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
