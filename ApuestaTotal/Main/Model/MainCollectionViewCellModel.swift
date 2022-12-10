//
//  MainCollectionViewCellModel.swift
//  Bet3
//
//  Created by mac on 28.10.2022.
//

import UIKit

struct MainCollectionViewCellModel {
    
    let sportTitle: String
    
    var image: UIImage? {
        return UIImage(named: sportTitle.replacingOccurrences(of: " ", with: "-").lowercased() + "-logo")
    }
    
    let hasEvents: Bool
    
    let eventModels: [EventModel]
    
}
