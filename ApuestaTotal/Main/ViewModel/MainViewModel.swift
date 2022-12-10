//
//  MainViewModel.swift
//  Bet3
//
//  Created by mac on 25.10.2022.
//

import Foundation
import Combine

class MainViewModel {
    
    private let sportsList = [
        "Cricket",
        "Basketball",
        "Baseball",
        "ESports",
        "Ice Hockey",
        "Soccer"
    ]
    
    @Published
    private(set) var mainCollectionViewModel: MainCollectionViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData() {
        var models = [MainCollectionViewCellModel]()

        let dispatchGroup = DispatchGroup()
//        let queue = DispatchQueue(label: "schedules-queue")

        for sport in sportsList {

            dispatchGroup.enter()
            networkManager.requestScheduledEvents(sport: sport)
                .compactMap { $0 }
                .sink { result in
                    guard result == .finished else {
                        
                        self.mainCollectionViewModel = MainCollectionViewModel(models: self.mockModels())
                        
                        
                        return
                    }
                } receiveValue: { jsonArray in
                    
                    let eventModels = jsonArray.compactMap { EventModel(scheduleJSON: $0) }
                    let model = MainCollectionViewCellModel(sportTitle: sport,
                                                            hasEvents: jsonArray.count > 0,
                                                            eventModels: eventModels)
                    
                    models.append(model)
                    dispatchGroup.leave()
                }
                .store(in: &cancellables)

        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.mainCollectionViewModel = MainCollectionViewModel(models: models)
        }
    }
    
    
    func mockModels() -> [MainCollectionViewCellModel] {
        return sportsList.compactMap { sportTitle -> MainCollectionViewCellModel in
            
            let eventModels = [EventModel](
                repeating: EventModel(event: "Event",
                                      sport: "Sport",
                                      league: "League",
                                      homeTeam: "Home",
                                      awayTeam: "Away",
                                      homeScore: "\(Int.random(in: 80...150))",
                                      awayScore: "\(Int.random(in: 80...150))",
                                      eventTime: "11:00",
                                      homeOdd: "\(Int.random(in: 1...3))",
                                      awayOdd: "\(Int.random(in: 1...3))"),
                
                count: Int.random(in: 8...15)
            )
            
            
            
            return MainCollectionViewCellModel(sportTitle: sportTitle,
                                               hasEvents: .random(),
                                               eventModels: eventModels)
        }
    }
    
}
