//
//  UserDefaultsManager.swift
//  Bet3
//
//  Created by mac on 26.10.2022.
//

import Foundation

class UserDefaultsManager {
    
    struct Keys {
        static let userModel = "userModel"
        static let notifications = "notifications"
        static let haptics = "haptics"
        static let savedEvents = "savedEvents"
    }
    
    var userModel: UserModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.userModel) else {
                return nil
            }
            let userModel = try? JSONDecoder().decode(UserModel.self, from: data)
            return userModel
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: Keys.userModel)
        }
    }
    
    var hapticsDisabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.haptics)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.haptics)
        }
    }
    
    var notificationsDisabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.notifications)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.notifications)
        }
    }
    
    var savedEvents: [SavedEventModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.savedEvents),
                  let events = try? JSONDecoder().decode([SavedEventModel].self, from: data) else {
                return []
            }
            
            return events
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: Keys.savedEvents)
        }
    }
}
