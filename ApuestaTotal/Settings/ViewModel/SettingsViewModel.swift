//
//  ProfileViewModel.swift
//  Bet3
//
//  Created by mac on 26.10.2022.
//

import Foundation

class SettingsViewModel {
    
    private let userDefaultsManager: UserDefaultsManager
    
    private(set) var loggedInViewModel: LoggedInViewModel?
    private(set) var signUpViewModel: SignUpViewModel?
    
    var isLogged: Bool {
        return (userDefaultsManager.userModel != nil)
    }
    
    var username: String? {
        guard let userModel = userDefaultsManager.userModel else {
            return nil
        }
        return userModel.firstName
    }
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getLoggedInViewModel() -> LoggedInViewModel {
        let loggedInViewModel = LoggedInViewModel(userDefaultsManager: self.userDefaultsManager)
        self.loggedInViewModel = loggedInViewModel
        
        return loggedInViewModel
    }
    
    func getSignUpViewModel() -> SignUpViewModel {
        let signUpViewModel = SignUpViewModel(userDefaultsManager: self.userDefaultsManager)
        self.signUpViewModel = signUpViewModel
        
        return signUpViewModel
    }
}
