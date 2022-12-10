//
//  MainCollectionViewModel.swift
//  Bet3
//
//  Created by mac on 25.10.2022.
//

import Foundation
import Combine

class MainCollectionViewModel {
    
    private let models: [MainCollectionViewCellModel]
    
    @Published
    private(set) var currentModels: [MainCollectionViewCellModel]
    
    var numberOfRows: Int {
        return currentModels.count
    }
    
    init(models: [MainCollectionViewCellModel]) {
        self.models = models
        self.currentModels = models
    }
    
    func modelForCell(at index: Int) -> MainCollectionViewCellModel {
        return currentModels[index]
    }
    
    func filterModels(by searchText: String) {
        currentModels = models.filter { $0.sportTitle.hasPrefix(searchText) }
    }
}
