//
//  BetViewModel.swift
//  Bet3
//
//  Created by mac on 31.10.2022.
//

import Foundation

class BetViewModel {
    
    private let userDefaultsManager: UserDefaultsManager
    
    let eventModel: EventModel
    let team: Team
    
    var odd: String? {
        return team == .home ? eventModel.homeOdd : eventModel.awayOdd
    }
    
    var hapticsDisabled: Bool {
        return userDefaultsManager.hapticsDisabled
    }
    
    init(userDefaultsManager: UserDefaultsManager, eventModel: EventModel, team: Team) {
        self.userDefaultsManager = userDefaultsManager
        self.eventModel = eventModel
        self.team = team
    }
    
    func saveBet(amount: Double) {
        let savedEventModel = SavedEventModel(event: eventModel,
                                              betAmount: amount,
                                              team: team)
        userDefaultsManager.savedEvents.append(savedEventModel)
    }
    
}
