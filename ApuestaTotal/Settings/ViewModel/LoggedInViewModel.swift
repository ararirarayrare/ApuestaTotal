//
//  LoggedInViewModel.swift
//  Bet3
//
//  Created by mac on 27.10.2022.
//

import Foundation

class LoggedInViewModel {
    
    var notificationsDisabled: Bool {
        get {
            return userDefaultsManager.notificationsDisabled
        }
        
        set {
            userDefaultsManager.notificationsDisabled = newValue
        }
    }
    
    var hapticsDisabled: Bool {
        get {
            return userDefaultsManager.hapticsDisabled
        }
        
        set {
            userDefaultsManager.hapticsDisabled = newValue
        }
    }
    
    var privacyPolicyURL: URL? {
        let urlString = "https://docs.google.com/document/d/1FwfjikJO3YBspjzsbkNH8eh-RQY183O1bpsPEa20QwI/edit?usp=sharing"
        return URL(string: urlString)
    }
    
    var appstoreURL: URL? {
        let urlString = "https://apps.apple.com/ua/app/Hollywood-Sports-Tracker!/id6444186900"
        return URL(string: urlString)
    }
    
    private let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func deleteAccount() {
        userDefaultsManager.savedEvents.removeAll()
        userDefaultsManager.userModel = nil
    }
}
