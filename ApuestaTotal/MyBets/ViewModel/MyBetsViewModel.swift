//
//  MyBetsViewModel.swift
//  Bet3
//
//  Created by mac on 01.11.2022.
//

import Foundation

class MyBetsViewModel {
    
    private let userDefaultsManager: UserDefaultsManager

    let betsTableViewModel: EventsTableViewModel
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
        
        let savedEvents = userDefaultsManager.savedEvents
        self.betsTableViewModel = EventsTableViewModel(models: savedEvents)
    }
    
    func removeBet(_ savedEventModel: SavedEventModel) {
        userDefaultsManager.savedEvents.removeAll(where: { $0 == savedEventModel })
    }
    
    func removeAllBets() {
        userDefaultsManager.savedEvents.removeAll()
    }
    
}
