//
//  EventsViewModel.swift
//  Bet3
//
//  Created by mac on 28.10.2022.
//

import Foundation
import Combine

class EventsViewModel {
    
    let eventsTableViewModel: EventsTableViewModel
    
    private let userDefaultsManager: UserDefaultsManager
    
    var hapticsDisabled: Bool {
        return userDefaultsManager.hapticsDisabled
    }
        
    init(userDefaultsManager: UserDefaultsManager, eventModels: [EventModel]) {
        self.userDefaultsManager = userDefaultsManager
        eventsTableViewModel = EventsTableViewModel(models: eventModels)
    }
    
    func saveEvent(_ model: SavedEventModel) {
        userDefaultsManager.savedEvents.append(model)
    }
    
    func betViewModel(eventModel: EventModel, team: Team) -> BetViewModel {
        return BetViewModel(userDefaultsManager: userDefaultsManager,
                            eventModel: eventModel,
                            team: team)
    }
}
