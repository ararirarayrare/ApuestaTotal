//
//  EventsTableViewModel.swift
//  Bet3
//
//  Created by mac on 28.10.2022.
//

import Foundation
import Combine

class EventsTableViewModel {
    
    private let models: [EventModel]
    
    @Published
    private(set) var currentModels: [EventModel]
    
    var numberOfRows: Int {
        return currentModels.count
    }
    
    var isEmpty: Bool {
        return currentModels.isEmpty
    }
    
    init(models: [EventModel]) {
        self.models = models
        self.currentModels = models
    }
    
    func model(forRow row: Int) -> EventModel {
        return currentModels[row]
    }
    
    func filterModels(by searchText: String) {
        currentModels = models.filter { $0.homeTeam.hasPrefix(searchText) || $0.awayTeam.hasPrefix(searchText) }
    }
    
    func removeAt(index: Int) {
        currentModels.remove(at: index)
    }
    
    func removeAll() {
        currentModels.removeAll()
    }
}
