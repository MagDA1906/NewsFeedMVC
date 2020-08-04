//
//  UserSettings.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 22.07.2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation

final class UserSettings {
    
    private enum SettingsKeys: String {
        case timeValue
    }
    
    static var timeValue: Float! {
        get {
            return UserDefaults.standard.float(forKey: SettingsKeys.timeValue.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.timeValue.rawValue
            if let value = newValue {
                defaults.set(value, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
