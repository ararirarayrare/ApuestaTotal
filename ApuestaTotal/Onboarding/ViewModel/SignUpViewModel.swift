//
//  SignUpViewModel.swift
//  Bet3
//
//  Created by mac on 31.10.2022.
//

import Foundation

class SignUpViewModel {
    
    private let userDefaultsManager: UserDefaultsManager
    
    var hapticsDisabled: Bool {
        return userDefaultsManager.hapticsDisabled
    }
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func saveUser(_ userModel: UserModel) {
        userDefaultsManager.userModel = userModel
    }
}
